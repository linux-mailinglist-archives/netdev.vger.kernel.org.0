Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122B6428095
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhJJKwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhJJKwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:52:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E80560F55;
        Sun, 10 Oct 2021 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633863035;
        bh=nDdiWpMj1LSCIN1GhRKIlLlwszMtNWYOOLj8t98unQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YluI2Xt8A+Ke13X/+iEZRIClc6PnEZjF8i2PpvB5h6hSzn5ppJZVrUe62/QWtrtc3
         YT9Cgme+JtKualzYULGAmirozDENamAVKl4rrYW76lPt5kMU8LImjHBsdZqJixLNb2
         0wDtEhhw2HFNwzfQm3GQaLP519uhCod5l4r7ctD4h/toXqh6YrvP4dtLKIa1uIEGcC
         KarmAgHpx0XOngUBF1Rz41cMAyIxIuMRb/uBeQojRl50uGeUO4rPNOdxtixwmJlj4C
         eNUa7E083oNjexBY+mF17EQA8a/IbYST8uzLrS+yBGziPN71wZGZhnQBweNx1t9raP
         zdfiaPjbdX0dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3289C60A88;
        Sun, 10 Oct 2021 10:50:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3] octeontx2-pf: Simplify the receive buffer size
 calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386303520.26784.12387913598003600006.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:50:35 +0000
References: <1633860575-7001-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1633860575-7001-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 10 Oct 2021 15:39:35 +0530 you wrote:
> This patch separates the logic of configuring hardware
> maximum transmit frame size and receive frame size.
> This simplifies the logic to calculate receive buffer
> size and using cqe descriptor of different size.
> Also additional size of skb_shared_info structure is
> allocated for each receive buffer pointer given to
> hardware which is not necessary. Hence change the
> size calculation to remove the size of
> skb_shared_info. Add a check for array out of
> bounds while adding fragments to the network stack.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] octeontx2-pf: Simplify the receive buffer size calculation
    https://git.kernel.org/netdev/net-next/c/0182d0788cd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


