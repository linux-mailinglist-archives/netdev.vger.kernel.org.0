Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0223748E0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhEETvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233570AbhEETvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 15:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46FC0613D8;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620244210;
        bh=byEPMnZSL9V3zIvRks+p5QiXR8TyfwlWf3AN9fEiUy0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fvWsJEfGsIbCRPvZDdGblUZyVqjsKgdFzc6TWnwkRV0mCM+gU596gkxIU1ErCFafE
         HleElMft7Y6YfcyHK1mUI8K84t43ZTJLKJWlQar7bcJN90xLxmn0JUg79UBIF5N41J
         ZR2zOdKXf7G7m+OSvLmHJj8g9Xcsybrx4k3dWedsSXaJ8PPgKt47xzJLlHKbqHeuXV
         s86cOQt2SwfDZ1e+Fan82MnpV2qcoIEpMsuhGW54hP51/zIGiW/np1v1xIfzgaC7yY
         sKW6GxykchHk6pd1jD7WmiraBMGv9nmbU/4KItHbVO7NflrgY/6ltQonIW0cJv4VZ1
         NmgqtJIYkrgYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A56760A0E;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix nla_strcmp to handle more then one trailing null
 character
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162024421023.18947.10503588776097291034.git-patchwork-notify@kernel.org>
Date:   Wed, 05 May 2021 19:50:10 +0000
References: <20210505165831.875497-1-zenczykowski@gmail.com>
In-Reply-To: <20210505165831.875497-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        nuccachen@google.com, xiyou.wangcong@gmail.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, jhs@mojatatu.com, jiri@mellanox.com,
        jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  5 May 2021 09:58:31 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Android userspace has been using TCA_KIND with a char[IFNAMESIZ]
> many-null-terminated buffer containing the string 'bpf'.
> 
> This works on 4.19 and ceases to work on 5.10.
> 
> [...]

Here is the summary with links:
  - net: fix nla_strcmp to handle more then one trailing null character
    https://git.kernel.org/netdev/net/c/2c16db6c92b0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


