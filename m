Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC0349D99
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCZAUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhCZAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3CF6761A45;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718010;
        bh=JHrOunMxZ4Eh1XsRghyG5Lf+wrk6L1lkKELMpgMIfT4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mGSNXUygMbyaXNvWeRGB37DctqeItw8MqEktz5lANRzKRjCwOdZZXDqdS3hW8tLzJ
         0lSufeZdomkTkQQKShSbSL0Z1zQkr5RI3HisbuDLRwHHTcS4vDwr7GemIEtQX9kf/t
         1gzETByV7ZP2ohq98w4iL9FjXBqvQBDejjIyJkZWKNXl6Uy2e5Bf14y9SAZV8NokFj
         DjA0cLUxDFdZcyM0afpjSzURH91uCG3isZxqCP0iJxCcq5rXSaablLqzbEGqEbYy4B
         U4+rN132hqUs+czdgLnQS9mh9gEYzlgVSrGyyNMwKrCZyJH97t5PYV6MpIB4ymP9D1
         7WP6fwLUbxndw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3068B60A6A;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 0/5]Fix some typos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671801019.29431.589027901422670357.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:10 +0000
References: <20210325063825.228167-1-luwei32@huawei.com>
In-Reply-To: <20210325063825.228167-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com,
        linux-decnet-user@lists.sourceforge.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 14:38:20 +0800 you wrote:
> Lu Wei (5):
>   net: ceph: Fix a typo in osdmap.c
>   net: core: Fix a typo in dev_addr_lists.c
>   net: decnet: Fix a typo in dn_nsp_in.c
>   net: dsa: Fix a typo in tag_rtl4_a.c
>   net: ipv4: Fix some typos
> 
> [...]

Here is the summary with links:
  - [-next,1/5] net: ceph: Fix a typo in osdmap.c
    https://git.kernel.org/netdev/net-next/c/3f9143f10c3d
  - [-next,2/5] net: core: Fix a typo in dev_addr_lists.c
    https://git.kernel.org/netdev/net-next/c/897b9fae7a8a
  - [-next,3/5] net: decnet: Fix a typo in dn_nsp_in.c
    https://git.kernel.org/netdev/net-next/c/e51443d54b4e
  - [-next,4/5] net: dsa: Fix a typo in tag_rtl4_a.c
    https://git.kernel.org/netdev/net-next/c/952a67f6f6a8
  - [-next,5/5] net: ipv4: Fix some typos
    https://git.kernel.org/netdev/net-next/c/cbd801b3b071

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


