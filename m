Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805FA457B2B
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhKTEdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:33:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236856AbhKTEdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C76F86052B;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637382609;
        bh=tIkohGYzYTVVSUMVrjRMsQvaifSYUJTUbMS/PpDMrkM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=njVuZEhqRlQVTdo734WSXpZneRz4OLmzMqOf9bg3VPYU0wzDuH3IFOuHzwuRIyh9p
         0Vhgo2S5cDbLI3xdxxS0GSAHBD9VgYBOXaO0HPyJjQM1jAaAfo5H62/xLmnV0JCM3Q
         X73U2f8MOGi1I3LZInIPKF6MEjkD0h3j4RqD4KHBN7qqmIK15favLjhPxEE5aJBkcM
         jFmdHKt7DS2lY9TAsjqmNbMjh/mnM019rGGob+GdkqP3HrIg33J93Q/WSKmPKWMFmR
         LaYwPwdu7YJSwJMdu44kGGccQ9pMvGS1sW+eNm6Vmsn5dxCybgk/NdcRa35W8jtc4v
         t3Ppamzjgpuwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B774F60A2F;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: ip6_skb_dst_mtu() cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163738260974.5569.9791359276045280668.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 04:30:09 +0000
References: <20211119022355.2985984-1-eric.dumazet@gmail.com>
In-Reply-To: <20211119022355.2985984-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Nov 2021 18:23:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use const attribute where we can, and cache skb_dst()
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/ip6_route.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [net-next] ipv6: ip6_skb_dst_mtu() cleanups
    https://git.kernel.org/netdev/net-next/c/8d22679dc89a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


