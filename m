Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C3142E690
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhJOCcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231653AbhJOCcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 67937611EE;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265008;
        bh=lSIr6MyD6q/GPpZY1UyRAsdJL5XBCTjf6lA2sgPOLDg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qgohciPcWZmF99Ru1fI2OofUu7k6R1CD3SPkx2pEUdZzlORAx0c1fzUj54c6ZReU4
         e2NDk1yJM+GjlSfcyQ9I+BsXRL191IM4RY+/Cs82/GpX+AngeTQLZmc1cDzqGFzxA1
         th2wA3X2NGZpE6ch8BzEXZvjVeK9v46d1I0nf0u4o+/s11N+N6Yt6AXlUpjULYMXGF
         IqYdZjUo+YS2ZVfevW4M6hxNfuOVf0pmLucNhjUoUZZ9USHCOnpkz+EAss/h1yD4iV
         U9wacO6eN4EZsm9wWUnohoQtLXxydOMTq5SOt6FeaqV/bBwmNCFgxOUci2oiVse9bf
         4f6WflqH3lmGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5FDD660A38;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hv_netvsc: Add comment of netvsc_xdp_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426500838.31820.16091657260521518155.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:30:08 +0000
References: <1634174786-1810351-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1634174786-1810351-1-git-send-email-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 01:26:26 +0000 you wrote:
> Adding comment to avoid the misusing of netvsc_xdp_xmit().
> Otherwise the value of skb->queue_mapping could be 0 and
> then the return value of skb_get_rx_queue() could be MAX_U16
> cause by overflow.
> 
> Fixes: 351e158 ("hv_netvsc: Add XDP support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - hv_netvsc: Add comment of netvsc_xdp_xmit()
    https://git.kernel.org/netdev/net-next/c/78e0a006914b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


