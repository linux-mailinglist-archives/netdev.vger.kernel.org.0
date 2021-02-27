Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328F0326A95
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhB0AAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhB0AAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 19:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B149B64F0D;
        Sat, 27 Feb 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614384007;
        bh=LqF0Y0iKI7pGhuOrPdVuZu49LAteXzzIj30rUY30ekM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F+mXqVedt4XQHBtwcHwFum+z2rkjeGBMXYlLnAg4joGnJJShWS0ltgDdDdyhfEo2r
         CxPico2gcWvr8FGODYoIjxGBiZiOH0NlwdFfLXDMKTon1tEhcs4iTS9gwlF0ozztJ3
         VUxBlrqmG7OMaG6C4fOXJ7yznUO8Ek4pPB7dizeJbrqWygiIvqSzDkuPpacMOqGwA3
         mz9G6VX5YTzQE7X65trMOZEqlqI90ByJUSAiOT+PRKei4aTVdpEI95O2ISo2U5Uyyj
         vvccnT+773biolsa3ZvkT2n9m1Y7BLBKIYJzRHL/L6OEVPOEpZYNl96iLyI14LxzTa
         g3UBCQNYVn70g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A076260A24;
        Sat, 27 Feb 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: Error recovery bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438400765.3533.1698905482061936583.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Feb 2021 00:00:07 +0000
References: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 26 Feb 2021 04:43:08 -0500 you wrote:
> Two error recovery related bug fixes for 2 corner cases.
> 
> Please queue patch #2 for -stable.  Thanks.
> 
> Edwin Peer (1):
>   bnxt_en: reliably allocate IRQ table on reset to avoid crash
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: Fix race between firmware reset and driver remove.
    https://git.kernel.org/netdev/net/c/d20cd745218c
  - [net,2/2] bnxt_en: reliably allocate IRQ table on reset to avoid crash
    https://git.kernel.org/netdev/net/c/20d7d1c5c9b1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


