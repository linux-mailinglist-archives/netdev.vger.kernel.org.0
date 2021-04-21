Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D1D3674E5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbhDUVun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235385AbhDUVum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 17:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0590561417;
        Wed, 21 Apr 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619041809;
        bh=TxGjyTKTrep4+1c7wtCObCQQM6L94MVzKUi76CBWRns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MKX42D1xjgYKV8WKNwYShkD6H+sEaWWUM5xaHOmzd9FdpgNAyFh8fQCeP/EhQCRNK
         44V4zq8flg5cUR6j8gl/LU3u0e0dVN5CEpgjl8+/PSDVs4XSBk3O128dXdFMyH5tJa
         x6Q60jI4xgc7ZMkN2ppqoV0P5FzsTQHnIDHEzK4Mj5O/lE+ed8ALaSMBK4ufW4RBfY
         +LasmHW/Mp28dik39wOBBU7GeX2qerznZ5V8y4kmLYYz3l7qLiDya5JhLl2X0lrO66
         AjsjwAthIMdyjrMBU4fAYVf2X8uAQgHEMwFsWHZ9iSu1cyLe+OwUvl2v7z/hR4XXwc
         ziJCx738kl1Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECB1160A3C;
        Wed, 21 Apr 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] neighbour: Prevent Race condition in neighbour subsytem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161904180896.24605.8882592667952939239.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 21:50:08 +0000
References: <20210421194212.GA5676@chinagar-linux.qualcomm.com>
In-Reply-To: <20210421194212.GA5676@chinagar-linux.qualcomm.com>
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, chinmay.12cs207@gmail.com,
        sharathv@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Apr 2021 01:12:22 +0530 you wrote:
> Following Race Condition was detected:
> 
> <CPU A, t0>: Executing: __netif_receive_skb() ->__netif_receive_skb_core()
> -> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which
> takes a reference on neighbour entry 'n'.
> Moves further along, arp_process() and calls neigh_update()->
> __neigh_update(). Neighbour entry is unlocked just before a call to
> neigh_update_gc_list.
> 
> [...]

Here is the summary with links:
  - neighbour: Prevent Race condition in neighbour subsytem
    https://git.kernel.org/netdev/net/c/eefb45eef5c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


