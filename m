Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E414335CC
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhJSMWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235551AbhJSMWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8AE761260;
        Tue, 19 Oct 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634646011;
        bh=lTRv0FEqX/DuYAwL2su65hXlRQN/e8Xi+13cohvZLzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EtgNYwMeCMiJSZQmSCvVI3+bnZEGU0NQZYN55YZ2cdabsiK2LrIMbFGFz9Ze+RFGq
         xQHcE5AfQ/09j3KDHpFke4aSTOgpkSAOyVNhA7y+pPv6trlSpc9108jdgg/MrMh4y1
         nq84OS0ENfVzGOeEYZe7oTpVKrJSpgR5cNGvEBYRAA+Y7LzDg+u7DTMVg5rGxDaAka
         uuMqhiooCBGWjIQ5Q5jlYHwFqM4XFiNIPGviFnZ+Re31oL81ZqzfL/pCEJNLnJYY3l
         J9NvQQuMgLdZ3itVXwIgDKGpHH2qtKfGYOgZ5ohnoSyqTRsjNnSsp91s4wUuxqHR95
         bu+244JyE273g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2BE3609D8;
        Tue, 19 Oct 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Remove extra device_lock assert checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464601092.7615.1219827050996715515.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:20:10 +0000
References: <8bbcc624cf574a1f491a674e436dbd0673cb0127.1634629765.git.leonro@nvidia.com>
In-Reply-To: <8bbcc624cf574a1f491a674e436dbd0673cb0127.1634629765.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        amcohen@nvidia.com, jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 10:49:54 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> PCI core code in the pci_call_probe() has a path that doesn't hold
> device_lock. It happens because the ->probe() is called through the
> workqueue mechanism.
> 
>    349 static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>    350                           const struct pci_device_id *id)
>    351 {
>    352
> ....
>    377         if (cpu < nr_cpu_ids)
>    378                 error = work_on_cpu(cpu, local_pci_probe, &ddi);
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Remove extra device_lock assert checks
    https://git.kernel.org/netdev/net-next/c/cb3dc8901ba4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


