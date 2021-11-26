Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9845E727
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344573AbhKZFZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345114AbhKZFXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 00:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 01D2A61028;
        Fri, 26 Nov 2021 05:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637904009;
        bh=oNuKc1eaqNCQrknJUPSY1Bk9ecPSzGmfU5+XZ5PFYqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J1pJxH3qLbZlVF3OvZ1DC6dMo22WGCEocB+F5QErDwK94R25zEd3fJSxHL+JL+6LO
         a2zG1u6YvbXBs72lHnfwenaLoEimjb4Bqf8iobfkAqoYM6ExlHC9+OEnGDqDyQ6fX6
         Pp53AGyLyT+HfJsKz1BCwb+cnN9D+veg/6xBSilSb6qHdV3Mlrm6NZ3Q5GVglFjt3/
         fB6ZzbrNOLtEAtjenlNlJ6mbzwnNtCBxlKTGIJGfshrsxWnJ68LadEyRdnoZ0GqJ/j
         0z+VjeZzUka1/PD9CywlkFd5w2xoQJwETuozG6UIYPOo2zeV/U4Dm2xiQM4Hc3G0xX
         DFRm8k3u4CTjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7DF560A4E;
        Fri, 26 Nov 2021 05:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: small csum optimizations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163790400894.20433.4793668125549772716.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 05:20:08 +0000
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
In-Reply-To: <20211124202446.2917972-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 12:24:44 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After recent x86 csum_partial() optimizations, we can more easily
> see in kernel profiles costs of add/adc operations that could
> be avoided, by feeding a non zero third argument to csum_partial()
> 
> Eric Dumazet (2):
>   gro: optimize skb_gro_postpull_rcsum()
>   net: optimize skb_postpull_rcsum()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] gro: optimize skb_gro_postpull_rcsum()
    https://git.kernel.org/netdev/net-next/c/0bd28476f636
  - [net-next,2/2] net: optimize skb_postpull_rcsum()
    https://git.kernel.org/netdev/net-next/c/29c3002644bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


