Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D2F3B0C25
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhFVSDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232867AbhFVSCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2995361289;
        Tue, 22 Jun 2021 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384804;
        bh=r4wPkvRW23ychtkgMSdxA425ofqPXPqLym0wPtBoYeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aTtwe0/ZGrihbdVULO8MMvAUuK9pe1TEMO0XI51MtuVbepQFdRRmbWDmCgPKXhBIy
         RBmVpbyctZ/YnGEWqKt+QNtjx8ykgjZH4wm9a+3W+4RRHWNcqMYyHM0ftiHBD2MdXg
         uwX/uJ1CrklwKLW0qMIm64e0nDYyk5u7J6+QuVKZMWO2/S4mudDg+LFeN2UOR8sJ9m
         0naaCQusWiLqO8Vvzf4IOfd45drLrxNN5ol4okDq8DTtYjQX6n4ZlP7hQ+rinwhVy5
         munFFj85AGPDRIp6c69AjwXzkntXMd3yvAemtqw95qbdUqJvnKouzC9b0igRqK+7K+
         l+BTeJrwguapQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1AA8E60A02;
        Tue, 22 Jun 2021 18:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ti: am65-cpsw-nuss: Fix crash when changing number of TX
 queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438480410.5394.7044056991038755056.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 18:00:04 +0000
References: <20210622143857.21682-1-vigneshr@ti.com>
In-Reply-To: <20210622143857.21682-1-vigneshr@ti.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Jun 2021 20:08:57 +0530 you wrote:
> When changing number of TX queues using ethtool:
> 
> 	# ethtool -L eth0 tx 1
> 	[  135.301047] Unable to handle kernel paging request at virtual address 00000000af5d0000
> 	[...]
> 	[  135.525128] Call trace:
> 	[  135.525142]  dma_release_from_dev_coherent+0x2c/0xb0
> 	[  135.525148]  dma_free_attrs+0x54/0xe0
> 	[  135.525156]  k3_cppi_desc_pool_destroy+0x50/0xa0
> 	[  135.525164]  am65_cpsw_nuss_remove_tx_chns+0x88/0xdc
> 	[  135.525171]  am65_cpsw_set_channels+0x3c/0x70
> 	[...]
> 
> [...]

Here is the summary with links:
  - net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues
    https://git.kernel.org/netdev/net/c/ce8eb4c728ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


