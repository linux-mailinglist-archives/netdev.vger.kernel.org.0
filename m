Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5347A45065C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKOONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhKOONG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:13:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BF9FC63218;
        Mon, 15 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636985408;
        bh=36hUQYfLJLMml8hFNibWqn0xVmvSLdPuzBLRLi3O0/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F762VF+y360U37bS172dS6FTNNxAShJRwQKPkxpOp1/U+bWQY7XPYkc/Tsvxfh5AU
         MTisMvQ5w9fpzNpirodqlU1kHVkEReYCXoHo/vdwLZHsZYAbSR8BRr5PPYTrWAwQGw
         NbvXfUOeb4sk/wrXh5FMnGoBBDvqBDE8tU9MQHH9SW2WoR3ngmLsksMMbL4m3HtPXf
         IObhdsQiI1sPiLW0YCiKcrXNMmR4W9NHFy13VuHwlZDiQHX9wSS2fbt2NG7cPNeIOx
         ESheYtLeG22BFzzjrJiwBsuGgUwkzemp7HGYsMns8KxC9LW8FK5qB3EYLaApdBOQZi
         9dqDZmfDVfbZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8DB860A88;
        Mon, 15 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698540868.13805.17800408021782408762.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:10:08 +0000
References: <YZCBeNdJaWqaH1jG@Zekuns-MBP-16.fios-router.home>
In-Reply-To: <YZCBeNdJaWqaH1jG@Zekuns-MBP-16.fios-router.home>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brendandg@nyu.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 Nov 2021 22:24:40 -0500 you wrote:
> This bug report shows up when running our research tools. The
> reports is SOOB read, but it seems SOOB write is also possible
> a few lines below.
> 
> In details, fw.len and sw.len are inputs coming from io. A len
> over the size of self->rpc triggers SOOB. The patch fixes the
> bugs by adding sanity checks.
> 
> [...]

Here is the summary with links:
  - atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
    https://git.kernel.org/netdev/net/c/b922f622592a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


