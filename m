Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1713E0084
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhHDLuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237814AbhHDLuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 07:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18EA561040;
        Wed,  4 Aug 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628077806;
        bh=2aCOp2VlcmQcq7u16DBPOp9C5tWXLPZhOXpDQ6cMnQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auyIgiUdcfkafp7mm4bUhUr9QZALlKyDhyvjJtsJlWVxACg6uM10t4Hq3ziArLaYp
         K58xBZcJFAPGKSLmkweWGIwgH4IfhFpP63XlI7PQad1rl6y4nnLtosIg3GTyxTvw/q
         PpmVfYLengTOWBIed5hWgcAub77jsmHgKazSfyXtI6ScqgFV01tjt92XVbR7LKOmXe
         mLB680kvdfSNh8H5dxro4kamncqbzLcL12DQPjfacNoNX5QDgBtJdM6+UpL6sWbiq4
         movmOkXboap6xxr4QN0lo6A9lMIEeuP5rwomjC48xI2XW7TqDTg3AboSNbNqPzQRd4
         nkt4rI4SeIOMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12C69609E2;
        Wed,  4 Aug 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tc-testing: Add control-plane selftests for sch_mq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807780607.28477.10651060788262890304.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 11:50:06 +0000
References: <20210803221659.9847-1-yepeilin.cs@gmail.com>
In-Reply-To: <20210803221659.9847-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     kuba@kernel.org, shuah@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucasb@mojatatu.com,
        cong.wang@bytedance.com, peilin.ye@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 15:16:59 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Recently we added multi-queue support to netdevsim in commit d4861fc6be58
> ("netdevsim: Add multi-queue support"); add a few control-plane selftests
> for sch_mq using this new feature.
> 
> Use nsPlugin.py to avoid network interface name collisions.
> 
> [...]

Here is the summary with links:
  - [net-next] tc-testing: Add control-plane selftests for sch_mq
    https://git.kernel.org/netdev/net-next/c/625af9f0298b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


