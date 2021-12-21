Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D827C47BE17
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 11:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhLUKUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 05:20:13 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40262 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhLUKUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 05:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBC19CE1691;
        Tue, 21 Dec 2021 10:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36AEFC36AE7;
        Tue, 21 Dec 2021 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640082010;
        bh=NNMnpxvY27QIGdOV4RXsnf6COxEz9TaAdaSv9uAIafg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=REWLzjMnf0kUNh9zA7vxAUYh0PRYYWf/z7Bn6dgWj8jt5PNf4Y9tdxUh7Lccxn1b0
         IadXfJUDVVbQXgeoyxcs6PHBmzt0sQxrMz2UOHx6B1yxuUgie730Ca8dMR6rUzhPjD
         v3Tl14lgDRM6gKENdRtjHAwv8JsO7KZxLC9pKaRnGuAnRmyfy0ioMxPovWlTVUIaiL
         yeLgKDOhRhlLvIbc1OXE6f9TsH/jTRSUYVm4wQRfF+yI0R/z8VsxW4ujw5dv+ndsRW
         ayuIl8U1UcukI/snaRA0oYPluOHA8AufPxYFTO7ckkISfFyC42XBfxGhL5wrglQVS5
         Gz7SUctCf1oVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0900D60A27;
        Tue, 21 Dec 2021 10:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/sched: use min() macro instead of doing it manually
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164008201003.19926.3019516223695943322.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 10:20:10 +0000
References: <20211221011455.10163-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20211221011455.10163-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Dec 2021 09:14:55 +0800 you wrote:
> Fix following coccicheck warnings:
> ./net/sched/cls_api.c:3333:17-18: WARNING opportunity for min()
> ./net/sched/cls_api.c:3389:17-18: WARNING opportunity for min()
> ./net/sched/cls_api.c:3427:17-18: WARNING opportunity for min()
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] net/sched: use min() macro instead of doing it manually
    https://git.kernel.org/netdev/net-next/c/c48c94b0ab75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


