Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D510D30E9AA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhBDBuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234071AbhBDBur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 20:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E4E664F64;
        Thu,  4 Feb 2021 01:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612403407;
        bh=YtmyLiz70pkJL0gh+9gjQLDp06SxCxtxekyhdBxoo4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WocOz/vMKe3yzgAMPe5Ks2myYbFOLXkLEtN5j7Fn/egALbFpnWBgSfmdMUBYSqLj+
         MNTD5UW0/xnkxMifiZpYH+2XCL9Y+WB0/ZZ0XCqyhCrSbFdvnMxTec52BFmXz4Enb9
         zOL5Yz07H4GnOW9qEe/7YvsUeifz2ua4TBvnS9bTrl7Bjsh3gFYD3NgXcLa5bSIwRY
         eSFRxyFzq6jF+sdDdoNSv0qK1A3PB5p+xE28UdMgrnPDLpYmR2OieSGOzd4RsX5jSa
         s01+BWGGw4fiXGxO/IDEhdMO7BiXPty9yc4yBv/5pC7YVDE9B9BXmIykuWIz4ssV6s
         goHzcfm8aPfKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47255609CE;
        Thu,  4 Feb 2021 01:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] chelsio: cxgb: Use threaded interrupts for deferred work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161240340728.20790.9706547933013653495.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 01:50:07 +0000
References: <20210202170104.1909200-1-bigeasy@linutronix.de>
In-Reply-To: <20210202170104.1909200-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tglx@linutronix.de, a.darwish@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 18:01:02 +0100 you wrote:
> Patch #2 fixes an issue in which del_timer_sync() and tasklet_kill() is
> invoked from the interrupt handler. This is probably a rare error case
> since it disables interrupts / the card in that case.
> Patch #1 converts a worker to use a threaded interrupt which is then
> also used in patch #2 instead adding another worker for this task (and
> flush_work() to synchronise vs rmmod).
> 
> [...]

Here is the summary with links:
  - [1/2] chelsio: cxgb: Replace the workqueue with threaded interrupt
    https://git.kernel.org/netdev/net-next/c/fec7fa0a750c
  - [2/2] chelsio: cxgb: Disable the card on error in threaded interrupt
    https://git.kernel.org/netdev/net-next/c/82154580a7f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


