Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24322F9048
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 04:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbhAQDAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 22:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbhAQDAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 22:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 49AF022581;
        Sun, 17 Jan 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610852408;
        bh=eyDvhmo5YNCmB4X9bOVQazk3Lst0lac5Jb6cLVM9Epg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WbBrC8ddwwnmQU2piziLs8FgY2Y+/jjEjlhx8DxYfSH8TVgdJpSrArqXvGgCwHtnM
         Pjku8a9hcAyaPXRJSAgpNkKxoN5FxfaNoABb1GFS3uL/NCCQXHck2WRfLkgAaWmWpQ
         Brcbdz7e7Q+LtJ+fje8SrrOzWDMwvsrfcEn8p8Z/spJ9UpVNnFTGNR/USFAOdvwJpZ
         D81WqLQI79TnXOK9P/igjfseHr6Ri2m+GkwqsLoGnL97Z0X1U9opbU85dJmUUrgyiE
         ABYyDOFDu5U9oZ4bWVbAUNGPueJ/Aue1G4t8npelyZfcnwpJphtTYdGulpMxfwMHq7
         uiJ053vMTV38Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3EB0360658;
        Sun, 17 Jan 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: enable interrupt based Tx completions for T5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161085240825.1548.7391581604999735732.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Jan 2021 03:00:08 +0000
References: <20210115102059.6846-1-rajur@chelsio.com>
In-Reply-To: <20210115102059.6846-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 15:50:59 +0530 you wrote:
> Enable interrupt based Tx completions to improve latency for T5.
> The consumer index (CIDX) will now come via interrupts so that Tx
> SKBs can be freed up sooner in Rx path. Also, enforce CIDX flush
> threshold override (CIDXFTHRESHO) to improve latency for slow
> traffic. This ensures that the interrupt is generated immediately
> whenever hardware catches up with driver (i.e. CIDX == PIDX is
> reached), which is often the case for slow traffic.
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: enable interrupt based Tx completions for T5
    https://git.kernel.org/netdev/net-next/c/b660bccbc345

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


