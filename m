Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3624C3CA462
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhGORc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGORc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20B3F613D7;
        Thu, 15 Jul 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626370205;
        bh=Flw15wMFOWTWZ7Do+OUNzQu22+yegu+u/76/RBpVfhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZguZuy3lQQkuS/6Fq0dHl9+jEgMhtzK+EGvgr4YT9CSs3WYP/OoMIdSSGHODf6p+t
         HeBszqG2XAb8MEF3f0St0AYHrWQUBH4HzIf7/sh0ZWkSSbRE9ixEMPiQHacB+3amFX
         UmaoIBTDzMFPiyclEYX7n9c6fAJnjFb/jfddlvnR1t9SRnxs2uPmaXXtwxbL8Pee6M
         mnQe4+0ic4Rvcnyc7A9TX8OtdckjrhqPCb4WdfH+LFqKScKCXAI9Lh/cYSzV0O5rSN
         ilxbEc3ID6nGETkQ2qnXO0H+HdyFqyrBGWkmEXmqkuDNlY76gCTFoyfFCE2yqbiSR9
         XsgYylndwlybA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0AF73609CF;
        Thu, 15 Jul 2021 17:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: remove unnecessary local variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637020504.11955.9930812995357254562.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:30:05 +0000
References: <20210715142643.2648-1-rocco.yue@mediatek.com>
In-Reply-To: <20210715142643.2648-1-rocco.yue@mediatek.com>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Jul 2021 22:26:43 +0800 you wrote:
> The local variable "struct net *net" in the two functions of
> inet6_rtm_getaddr() and inet6_dump_addr() are actually useless,
> so remove them.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  net/ipv6/addrconf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] ipv6: remove unnecessary local variable
    https://git.kernel.org/netdev/net-next/c/87117baf4f92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


