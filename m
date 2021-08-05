Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA03E14E6
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhHEMkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240239AbhHEMkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4161461132;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628167206;
        bh=ADpxBt6oVgoGxWYom3C0Sco4vqfS6lH69mv3genZHKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ojuGc8EVftD25TXgKTt+5Cx+3HFgMDuT7h4HbJurYbKMB+rq3ymptG5dCDWpot5oP
         aSPf2omEsh6uJwS6sUD9V9pplZibiEBg6VgSPBmE9o705eV0R8fsbiQrbuEciQqFqp
         NQRJZ6slDt/Ntoh2sBOANJwpESrOKUWM5SmKn4CgWOcP+K5zfddqsFVLja0/QYCxDB
         LaUiMTuxqXvnwSO7oNN0+iofz7PDk5EnPCDth3tyzVd6+GPtXmu+rvpQBDnu5LGMeq
         ZuvlNhBbZZ0vTMJlTS3SAAM78mH/pbrqmY618g3bBvmWHNRo++/UHUzwzxHnktQ0ch
         Zba3o46vQeetA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32C9A60A72;
        Thu,  5 Aug 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnx2x: fix an error code in bnx2x_nic_load()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816720620.10114.11424792100720509562.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:40:06 +0000
References: <20210805103826.GB26417@kili>
In-Reply-To: <20210805103826.GB26417@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, eilong@broadcom.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 5 Aug 2021 13:38:26 +0300 you wrote:
> Set the error code if bnx2x_alloc_fw_stats_mem() fails.  The current
> code returns success.
> 
> Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] bnx2x: fix an error code in bnx2x_nic_load()
    https://git.kernel.org/netdev/net/c/fb653827c758

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


