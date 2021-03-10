Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97193349D8
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCJVaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCJVai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9277464FA9;
        Wed, 10 Mar 2021 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615411837;
        bh=vF94WRkNT5k2/I2ewfk4sckLMR31tx5pHvt/oKkpzsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j/6jfqM7wB7FBwuU1BRIvVSu4iJyWqHKWZzRO2ff8vGskn0zIuf3hfic8wnnC/pIc
         FepR4mEeFce0BOQzGHbp3iaz/RORZ/HZMDhW/wCg3B7t4FR4nXLia/+pquzXaZgpTx
         LgLQRi6ZBLDKWyYBxkGl3VX8AFtLu4yIDwNxFI56Y/pMb3KVhmQBZ++ly9KeMoE7j+
         Q3C9Wk9n4tdvZyk3hT+nUizsjQyg2HifRLxGjdjPmdrhOarTbgNbq8j4jKRxTlzcyn
         BWDpXVfEY0ZeGZGY/Vdsno4CRQKjOt6UnTRy2bMFfFFpom4H6oJU4BDwEikDKImFcn
         lp+6RBbm40nAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81563609BB;
        Wed, 10 Mar 2021 21:30:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] Refactoring/cleanup for NXP ENETC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541183752.19029.31795583817662108.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:30:37 +0000
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 14:03:39 +0200 you wrote:
> This series performs the following:
> - makes the API for Control Buffer Descriptor Rings in enetc_cbdr.c a
>   bit more tightly knit.
> - moves more logic into enetc_rxbd_next to make the callers simpler
> - moves more logic into enetc_refill_rx_ring to make the callers simpler
> - removes forward declarations
> - simplifies the probe path to unify probing for used and unused PFs.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: enetc: move the CBDR API to enetc_cbdr.c
    https://git.kernel.org/netdev/net-next/c/176769d10f96
  - [net-next,02/12] net: enetc: save the DMA device for enetc_free_cbdr
    https://git.kernel.org/netdev/net-next/c/01121ab73924
  - [net-next,03/12] net: enetc: squash enetc_alloc_cbdr and enetc_setup_cbdr
    https://git.kernel.org/netdev/net-next/c/24be14e3260a
  - [net-next,04/12] net: enetc: save the mode register address inside struct enetc_cbdr
    https://git.kernel.org/netdev/net-next/c/27f9025d4941
  - [net-next,05/12] net: enetc: squash clear_cbdr and free_cbdr into teardown_cbdr
    https://git.kernel.org/netdev/net-next/c/0bfde022b345
  - [net-next,06/12] net: enetc: pass bd_count as an argument to enetc_setup_cbdr
    https://git.kernel.org/netdev/net-next/c/5b4daa7f1256
  - [net-next,07/12] net: enetc: don't initialize unused ports from a separate code path
    https://git.kernel.org/netdev/net-next/c/4b47c0b81ffd
  - [net-next,08/12] net: enetc: simplify callers of enetc_rxbd_next
    https://git.kernel.org/netdev/net-next/c/c027aa9201eb
  - [net-next,09/12] net: enetc: use enum enetc_active_offloads
    https://git.kernel.org/netdev/net-next/c/7f071a450b08
  - [net-next,10/12] net: enetc: remove forward-declarations of enetc_clean_{rx,tx}_ring
    https://git.kernel.org/netdev/net-next/c/8580b3c3d786
  - [net-next,11/12] net: enetc: remove forward declaration for enetc_map_tx_buffs
    https://git.kernel.org/netdev/net-next/c/0486185ee244
  - [net-next,12/12] net: enetc: make enetc_refill_rx_ring update the consumer index
    https://git.kernel.org/netdev/net-next/c/7a5222cb7a56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


