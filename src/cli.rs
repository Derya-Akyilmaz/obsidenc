use clap::{Parser, Subcommand};
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "obsidenc", version)]
#[command(about = "Encrypt/decrypt a directory as a single encrypted tar archive.")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Command,
}

#[derive(Subcommand, Debug)]
pub enum Command {
    Encrypt {
        vault_dir: PathBuf,
        output_file: PathBuf,
        #[arg(long)]
        keyfile: Option<PathBuf>,
        #[arg(long)]
        force: bool,
    },
    Decrypt {
        input_file: PathBuf,
        output_dir: PathBuf,
        #[arg(long)]
        keyfile: Option<PathBuf>,
        #[arg(long)]
        force: bool,
        #[arg(long)]
        /// Overwrite staging files with zeros before deletion (slower but more secure)
        secure_delete: bool,
    },
}

