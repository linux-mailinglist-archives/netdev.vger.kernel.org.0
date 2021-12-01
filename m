Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929074644D4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhLACXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:23:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhLACXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:23:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72AF8B81C0F;
        Wed,  1 Dec 2021 02:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25E5CC53FC7;
        Wed,  1 Dec 2021 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638325209;
        bh=NsrkI24hix3RptPZuZ71vjwQOEYKri4EMggY7An9M6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sAGx29hvH+xkMzOQWtp5v2Die9qU1BN6CCNeMpEGnBVKREsljq/WZ0X1qijFtwMl9
         zTG1RkrwDTkMZv5tr5/LU6OdQ+oOWGFlRQ3z1OMGQhUnZPxaaXLXYM7nKPCFfvejIX
         I+yCRWwgHQrvcI2oZhTrjjNR7N4wer1okY+b1kNv/AxPbA+A8GsnVf2SOMcl995Kp2
         40+XOO4odY+y41w1tDNldBQdz8elmfPc8IxYvQfAv0pSWP62nzGGzv077FPGpHAXa8
         TjoakFcldckXEMcCBtBqkW+9K/V+uU3X3S+oIlby2cuHmu6UGxVSs3A89DVP7Y6zXF
         7wEWTSICMt4Cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C33B60A38;
        Wed,  1 Dec 2021 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] mctp: remove unnecessary check before calling
 kfree_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163832520904.6106.12847821764543488258.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 02:20:09 +0000
References: <20211130031243.768823-1-yangyingliang@huawei.com>
In-Reply-To: <20211130031243.768823-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jk@codeconstruct.com.au, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 11:12:43 +0800 you wrote:
> The skb will be checked inside kfree_skb(), so remove the
> outside check.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/mctp/af_mctp.c | 3 +--
>  net/mctp/route.c   | 4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [-next] mctp: remove unnecessary check before calling kfree_skb()
    https://git.kernel.org/netdev/net-next/c/5cfe53cfeb1c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


