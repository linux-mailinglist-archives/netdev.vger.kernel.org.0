Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81D0355F96
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbhDFXkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245131AbhDFXkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B41C6613C4;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617752409;
        bh=dbFKkZ5gn6qFJI78Zn7ZhdYFqFjyH8VNi5PbJS/lwuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eju4ByvGb+C0MTGtJuZtVOQn7ysd8CxHCNJjxqXdsTHrLJb+NZe/ifDMnFK6aH7JJ
         mqWD1iYT51w//zHUrvz2LDWePVn4PZdXai/0TVkAOFLWP73wuTZ37tewVJQ3Bxe7qS
         Mazjqyu4ydE88UAVMWsA37nWNbTYCPSWpVEFJ6j9BjSb2YgcSbDtqrIa0LNCNh/IKP
         duAeFHO9TXytkYXydSglMZqzPJ04moV2BZe+vvrg2qNKoeqoeyezxtbJjZyOD+cybi
         zvISs8LaGGHhia7/OzPqD3fMIvO8c9ouikhE216tMbsjsd/YFlVsWD/O8dlvx9wZaE
         5KzD4PMgTV1SQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF16E609FF;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pcnet32: Use pci_resource_len to validate PCI resource
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775240971.19905.4302192635272366867.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:40:09 +0000
References: <20210406042922.210327-1-linux@roeck-us.net>
In-Reply-To: <20210406042922.210327-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     pcnet32@frontier.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Apr 2021 21:29:22 -0700 you wrote:
> pci_resource_start() is not a good indicator to determine if a PCI
> resource exists or not, since the resource may start at address 0.
> This is seen when trying to instantiate the driver in qemu for riscv32
> or riscv64.
> 
> pci 0000:00:01.0: reg 0x10: [io  0x0000-0x001f]
> pci 0000:00:01.0: reg 0x14: [mem 0x00000000-0x0000001f]
> ...
> pcnet32: card has no PCI IO resources, aborting
> 
> [...]

Here is the summary with links:
  - pcnet32: Use pci_resource_len to validate PCI resource
    https://git.kernel.org/netdev/net/c/66c3f05ddc53

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


