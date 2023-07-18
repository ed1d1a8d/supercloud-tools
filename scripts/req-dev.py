#!/state/partition1/llgrid/pkg/anaconda/anaconda3-2021b/bin/python
import argparse
import dataclasses
import pathlib
import subprocess


@dataclasses.dataclass
class ProgramArgs:
    job_name: str = dataclasses.field(
        default="devbox", metadata={"help": "Name of the job."}
    )

    qos: str = dataclasses.field(
        default="high",
        metadata={
            "help": "Quality of service to request. (Can be normal or high).",
        },
    )

    cpus: int = dataclasses.field(
        default=20,
        metadata={
            "help": " ".join(
                [
                    "Number of cpus to request.",
                    "4GB of RAM is allocated per cpu.",
                ]
            )
        },
    )

    gpus: int = dataclasses.field(
        default=1, metadata={"help": "Number of gpus to request."}
    )

    hours: int = dataclasses.field(
        default=24, metadata={"help": "Number of hours to request."}
    )

    blacklist: str = dataclasses.field(
        default="",
        metadata={"help": "Blacklist of nodes to avoid, comma separated."},
    )

    @classmethod
    def from_cli(cls):
        parser = argparse.ArgumentParser(description="Launches a devbox.")

        for field in dataclasses.fields(cls):
            parser.add_argument(
                f"--{field.name.replace('_', '-')}",
                default=field.default,
                type=field.type,
                help=field.metadata["help"] + f" (default: {field.default})",
            )

        return cls(**vars(parser.parse_args()))


def main(args: ProgramArgs):
    print(
        "Requesting devbox with",
        f"{args.gpus} gpus,",
        f"{args.cpus} cpus,",
        f"for {args.hours} hours...",
    )

    # Get absolute path to mallory
    script_dir = pathlib.Path(__file__).parent.resolve()
    sleep_path = (script_dir / "sleep.sh").absolute()

    # Make log directory
    # mkdir -p $HOME/slurm-logs/dev
    log_dir = (pathlib.Path.home() / "slurm-logs" / "dev").absolute()
    log_dir.mkdir(parents=True, exist_ok=True)

    # Construct sbatch command
    sbatch_args = (
        [
            "sbatch",
            f"--qos={args.qos}",
            f"--job-name={args.job_name}",
            f"--cpus-per-task={args.cpus}",
            f"--time={args.hours}:00:00",
            f"--output={log_dir}/{args.job_name}-%j.out",
            "--wrap",
            f"srun {sleep_path}",
        ]
        + (
            [f"--gres=gpu:volta:{args.gpus}"]
            if args.gpus > 0
            else ["--partition=xeon-p8"]  # Use p8 partition for cpu-only jobs
        )
        + ([f"--exclude={args.blacklist}"] if len(args.blacklist) > 0 else [])
    )

    # Launch job with sbatch
    subprocess.run(sbatch_args, check=True)


if __name__ == "__main__":
    main(ProgramArgs.from_cli())
