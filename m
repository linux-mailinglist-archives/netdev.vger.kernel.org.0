Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A40488DB4
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbiAJBA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiAJBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085B0C061757;
        Sun,  9 Jan 2022 17:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91979610AB;
        Mon, 10 Jan 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5702EC36B12;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776414;
        bh=A+L8/YncNQtimP1xLvtgWIKkzVDQAjNIx8Z2hnKCAeo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N2oyXKrxIcbwWxqS+yaw0fw2L20wLCD6DZuUZib8cUZybLTWnBYj9srbn4fkqvNej
         9TQ+TxB+IjUj4rExgzYJRGi0I+/rQFacnmwF6xFKmPWSzeuCAN3IfBrsM1lSjILW+f
         DuY4NKJe26NuL56R/0JzgiQxnbAkXKDRsC+G7LGDJ+7WPlwkOIwZpMtRjDAnDhD6n3
         fa0I+yLKB0ifW7dG7nINvzhU1FvXk+nCBD5YXZeXSmzA+fyxEQOZLHTu5LcYVu4Nzm
         xMLzLh92xpVtGoKMSnITo+3m5ox6+jmvSo8+mVlo4FSL5tRTSQpAWufkJ3Vkx50JLf
         mDgLpuaI2Gx1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44CFEF60792;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tcp: tcp_send_challenge_ack delete useless param `skb`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641427.18208.7022414471516014395.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:14 +0000
References: <20220109130824.2776-1-yan2228598786@gmail.com>
In-Reply-To: <20220109130824.2776-1-yan2228598786@gmail.com>
To:     Benjamin Yim <yan2228598786@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 21:08:24 +0800 you wrote:
> After this parameter is passed in, there is no usage, and deleting it will
>  not bring any impact.
> 
> Signed-off-by: Benjamin Yim <yan2228598786@gmail.com>
> ---
>  net/ipv4/tcp_input.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - tcp: tcp_send_challenge_ack delete useless param `skb`
    https://git.kernel.org/netdev/net-next/c/208dd45d8d05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


