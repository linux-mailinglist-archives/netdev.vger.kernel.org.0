Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5473E2F8A10
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbhAPAuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbhAPAut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 19:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E1DFF2082D;
        Sat, 16 Jan 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610758208;
        bh=qDitnr5lvrAnOAJgmN2YG9MmNhos5/XaXHhI1rzMzwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PxSNVQ/u7t7fz/JtFB1yyYT3ALld4VKwuWx5Ot+M2Moh5alJ6PKzgWXYLpGOO1Eua
         1509sXFN5n8vhsT+htUtfAfWdsPv2kVZTcyD2LROYpXskZ551qTwLcuo3+QowZahI8
         uHhZP2ZaX7feydVo/Zk4A1q9CuhW1N5vEA9FyTYFU6ril0mqClACBpIlpsp9w/9beo
         uRoACJyHN4EJohYFTpdzhkmdparAN4O+zLLchUDkPCpt5Tb7MUfJYhvFnNynb3GPoS
         PhBjDaDgm5uzvx7g52whLzYVoWnCOehLJ14Pglur+ChM/sYFp8BC36m7ELbahstb8u
         PfqwbLnlQas4g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D7C10605AB;
        Sat, 16 Jan 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netxen_nic: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161075820887.2945.292036690452256996.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 00:50:08 +0000
References: <20210113202519.487672-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20210113202519.487672-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 21:25:18 +0100 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'netxen_get_minidump_template()' GFP_KERNEL can
> be used because its only caller, ' netxen_setup_minidump(()' already uses
> it and no lock is acquired in the between.
> 
> [...]

Here is the summary with links:
  - netxen_nic: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/297af515d75f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


