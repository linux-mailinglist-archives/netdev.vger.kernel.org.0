Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244E12FC72A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbhATBvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731080AbhATBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 73714224B1;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611107410;
        bh=QvXDt3LEXKwztqUdMgdHJQOZvbdsHauUw1+45qXWZ1c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tg2RriRlmwazptzesO8jNlH4TO7qxJdiyNnlPkkwk9hx79S3iOnnGZAgTCbTCiDxR
         Z9u3D1O0MV5IIDT2ATQN1Aa4EsF9c/YRjuYzM5C7kCUgQeo7Y5s6j87IynJgQUICvE
         wH/tCldNGH3k3ix9uLzhJ6SsPHC7Olvt7D3LRGF0UUSCjB0WgHOCCeRN18ATVMgAC3
         9TeQ1GJaDTQV/m98TIG7HPCm3XvIjNhWR7xGF+LKNWKqnYyC4jvUG0gLqXzd+T6dSn
         TXMxxC3LD7Ss2Y8Pka0FQycTKQRCQf6PHaLcALKDLlPJZSiwb2UuN/NnL56PGCCgsR
         wF/hOl0/w5wRA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 68FEF60591;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] taprio: boolean values to a bool variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110741042.23772.15208009210857088847.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 01:50:10 +0000
References: <1610958662-71166-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610958662-71166-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 18 Jan 2021 16:31:02 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./net/sched/sch_taprio.c:393:3-16: WARNING: Assignment of 0/1 to bool
> variable.
> 
> ./net/sched/sch_taprio.c:375:2-15: WARNING: Assignment of 0/1 to bool
> variable.
> 
> [...]

Here is the summary with links:
  - taprio: boolean values to a bool variable
    https://git.kernel.org/netdev/net-next/c/0deee7aa23a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


