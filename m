Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECDE43FCA4
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhJ2Mwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhJ2Mwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDF3961181;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511809;
        bh=HDU40Ij+WZ/aZzBQShPVnJIwCcTEw6CtMHgcR5xH1F0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CmqioEtbqOT3mrvOLyFthpjtcc/3nO/7lyY0QQIMz2Uwt1FMB6tX1SP6MlnDzKwUd
         HULMiSrbG957q+1/WvKikj3BF5iEeITAfVFPxkUWt4Q+E99bBYgwbhOMmimpPbaDuT
         Bf+P6Rl5g0GjtonUqBm5n1VR0FJi3ZjbvpKj/cuJAmpErsdiqRC1jyXNzNdGD3zCvr
         UzK1wzAu5k4tHYL8cFezYDrmyTON2SBiTqPNL4xOe8Pti/YdDtyODeG+wLD/MLZq3K
         jfmTYlQYqGbRYUAwvx+cknOixmyNIBSGQNKLH1bweZ40fP6fLATVGTK6omoctKKjvq
         wDqStHaggaCag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E995160A5A;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bareudp: fix duplicate checks of data[]
 expressions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551180895.32606.8903887186480447271.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:50:08 +0000
References: <20211028182453.9713-2-sakiwit@gmail.com>
In-Reply-To: <20211028182453.9713-2-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 12:24:53 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Both !data[IFLA_BAREUDP_PORT] and !data[IFLA_BAREUDP_ETHERTYPE] are
> checked.  We should remove the checks of data[IFLA_BAREUDP_PORT] and
> data[IFLA_BAREUDP_ETHERTYPE] that follow since they are always true.
> 
> Put both statements together in group and balance the space on both
> sides of '=' sign.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bareudp: fix duplicate checks of data[] expressions
    https://git.kernel.org/netdev/net-next/c/5bd663212f2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


