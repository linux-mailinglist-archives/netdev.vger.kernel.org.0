Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5A2F8B2D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbhAPEau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbhAPEat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 23:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EB0CD23A75;
        Sat, 16 Jan 2021 04:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610771409;
        bh=zxy10ZzNRp6NoJKDyYWFcyj/tqGU4pIU1p3JOj/Fxss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z1ylZT4XNTui+w9PxPZYMHqYHp6vQNGQAxjYZ5JFxCSLE0s/JVUjHMrfFa03RL7k2
         L3QnQuamJvmbXTgpvIgB+VVeDt/P/TEi6MsgwNXrDqMss/FChq8rKWBJlBIOF+hRam
         2rkDIba5qlbdpEfMBl1sPXq7KgY2V+xsWnC/A/KBZ+77PzK9pt16oBhqav3F+ZEKuX
         n6GWkLQhT2LDaWZTNgVBQyCqVsAmpGs7UdMeTgqY2wDCIZ/+4+k86Lx1vbO2zf+k6r
         Xs54QcbVjY1/2otevGLyD5eQAxPYj+xQ8XHvg7CmVaEx9oSp486Gqwk4D0SRh3wDpA
         71SpUBsIL8zyg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D9E4B60649;
        Sat, 16 Jan 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tcp_cubic: use memset and offsetof init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161077140888.29705.12549950075312268419.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 04:30:08 +0000
References: <1610597696-128610-1-git-send-email-yejune.deng@gmail.com>
In-Reply-To: <1610597696-128610-1-git-send-email-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 14 Jan 2021 12:14:56 +0800 you wrote:
> In bictcp_reset(), use memset and offsetof instead of = 0.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/tcp_cubic.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)

Here is the summary with links:
  - tcp_cubic: use memset and offsetof init
    https://git.kernel.org/netdev/net-next/c/f4d133d86af7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


