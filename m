Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CEA3A2008
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhFIWcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD71061040;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277805;
        bh=lkWP9PANZgEUE9+eUCm7BT/HBVIVFmcVIjo2L3ELd5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vATwzMkcRxGAiRHD0VABjmvDy8FUPXmFe4wQdLfB0QeCPSfzNvfoncuSO3bHzHjkq
         Y+8UQIl3tjc9vVwZUqx9aXlLFajn4ok8uRdHwOgch6m4g8pVf428+VDwwqcrwqu0RR
         Eb3mdSCk/xfX8BDiN63xhGY7duPHErZXLqQ8873JI0tJakexN9CHFX9qAQNUSpu3w3
         ONQ/DTKB8QY30Yg2XbwqFK7Nq2HedpbANGIugfjOPahsqVYnv8PR2QFQKY4zLo43C3
         1CEQ5rWzpGaJzgnupUa8Tm1NyKEvaOTehpv4qN+UKh2p7zPzCuxs8SdLmoH/giTfl7
         HhSTvUGGPMMUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA98E60CD8;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "nvme-tcp-offload: ULP Series"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780575.20375.5665830051923528863.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609104918.10329-1-smalin@marvell.com>
In-Reply-To: <20210609104918.10329-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        geert@linux-m68k.org, hch@lst.de, sagi@grimberg.me,
        kbusch@kernel.org, axboe@fb.com, himanshu.madhani@oracle.com,
        pmladek@suse.com, hare@suse.de, aelior@marvell.com,
        mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 13:49:18 +0300 you wrote:
> This reverts commits:
> - 762411542050dbe27c7c96f13c57f93da5d9b89a
>      nvme: NVME_TCP_OFFLOAD should not default to m
> - 5ff5622ea1f16d535f1be4e478e712ef48fe183b:
>      Merge branch 'NVMeTCP-Offload-ULP'
> 
> As requested on the mailing-list: https://lore.kernel.org/netdev/SJ0PR18MB3882C20793EA35A3E8DAE300CC379@SJ0PR18MB3882.namprd18.prod.outlook.com/
> This patch will revert the nvme-tcp-offload ULP from net-next.
> 
> [...]

Here is the summary with links:
  - Revert "nvme-tcp-offload: ULP Series"
    https://git.kernel.org/netdev/net-next/c/daf6e8c9caa0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


