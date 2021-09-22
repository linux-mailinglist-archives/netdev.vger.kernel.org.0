Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6F414A68
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhIVNVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231868AbhIVNVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 54396611C0;
        Wed, 22 Sep 2021 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632316807;
        bh=e629AuGefhJIdNjI5mU4FtRRKzsoCkMCGvZj9iUO1/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uCTJ6JSLYDlQIH1ID+doV82pPqQ2TIQE9AICXyFKkO1xsCfKxWYZbneTZ83/7Rixb
         DkJlLSsFTDVX8ojjWa08gRjAHp7Ej2Q42dsqWCsTlmh67sc1386kXvQuDJ3sGUdHCi
         Xnuz7T5mxdOLVP7q64d5gdR9UT6MDOdCjBBkgIGXRg0QLFxu1RofORurf+ZJ/SoLxS
         cinA9x1EJzTrOZ1R2TxM/BAm3LYjrgS/Y0FDqV9kwcZFYb5tdko0QSHJZf0Zio72p2
         Alva7PGmjxIAFzTyZG2meD4RddnhmDpwRA8BTbiKaP6duFVeP3m8kLuN9gF7trjZ1h
         T7irIwp/55+TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 401F660A7C;
        Wed, 22 Sep 2021 13:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] devlink: Make devlink_register to be void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163231680725.16453.13582291901349669974.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 13:20:07 +0000
References: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
In-Reply-To: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch, aelior@marvell.com,
        luobin9@huawei.com, claudiu.manoil@nxp.com, coiby.xu@gmail.com,
        dchickles@marvell.com, drivers@pensando.io, fmanlunas@marvell.com,
        f.fainelli@gmail.com, gakula@marvell.com,
        gregkh@linuxfoundation.org, GR-everest-linux-l2@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, hkelam@marvell.com,
        idosch@nvidia.com, linuxwwan@intel.com,
        intel-wired-lan@lists.osuosl.org, ioana.ciornei@nxp.com,
        jerinj@marvell.com, jesse.brandeburg@intel.com, jiri@nvidia.com,
        jonathan.lemon@gmail.com, lcherian@marvell.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        loic.poulain@linaro.org, manishc@marvell.com,
        m.chetan.kumar@intel.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        richardcochran@gmail.com, saeedm@nvidia.com,
        salil.mehta@huawei.com, sburla@marvell.com, ryazanov.s.a@gmail.com,
        snelson@pensando.io, simon.horman@corigine.com,
        sbhatta@marvell.com, sgoutham@marvell.com, tchornyi@marvell.com,
        tariqt@nvidia.com, anthony.l.nguyen@intel.com,
        UNGLinuxDriver@microchip.com, vkochan@marvell.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com,
        yisen.zhuang@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 11:58:03 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> devlink_register() can't fail and always returns success, but all drivers
> are obligated to check returned status anyway. This adds a lot of boilerplate
> code to handle impossible flow.
> 
> Make devlink_register() void and simplify the drivers that use that
> API call.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] devlink: Make devlink_register to be void
    https://git.kernel.org/netdev/net-next/c/db4278c55fa5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


