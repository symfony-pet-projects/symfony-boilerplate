<?php

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'generate-secret',
    description: 'Creates new APP_SECRET',
)]
class RegenerateAppSecretCommand extends Command
{
    protected function configure(): void
    {}

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $secretToken = bin2hex(random_bytes(14));

        $io->success("New secret token: $secretToken");

        return Command::SUCCESS;
    }
}
