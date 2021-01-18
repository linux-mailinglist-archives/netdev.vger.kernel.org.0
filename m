Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EA32FAD91
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390680AbhARWvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732477AbhARWut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 17:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 20FBD2222A;
        Mon, 18 Jan 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611010209;
        bh=zuWfpZ4hjw9/aPWqTVav9cTSi55/kKdgu1hpodVrMsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G5046WrjbqMb8EvKA8GAjn1qSUPYhHkLCOjXN0YirZ6Nh4y7Qd5NyT0nOvR2q2dRY
         4moRr3Q2aNElk4wW+rRs/50LHd+7674btcx56qsFdFp+3rBypERMG5xsmhdmbqOuuj
         8sB5lONBGBELEDJsU7ZfFQXtuAKEBUgWj28CeDX9riyky1wZ7Mxb3/MhvStt4auh8+
         CRiCuZdF5P2FIxb+JqcIVvw9v3X04X+qwzUWjqsUvv1MWhP/4RyOY1QMP6fl0tFFRE
         rVvZuTjQp5NGAZaHAlVFYvtYWxRkE3T/gMdovOw4m+/rZAXzB1KkAMILR5gCNv9LEB
         olQZuLaRtORew==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 10F31602DA;
        Mon, 18 Jan 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161101020906.2232.13826999223880000897.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 22:50:09 +0000
References: <20210118204750.7243-1-johannes@sipsolutions.net>
In-Reply-To: <20210118204750.7243-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon, 18 Jan 2021 21:47:49 +0100 you wrote:
> Hi,
> 
> New try, dropped the 160 MHz CSA patch for now that has the sparse
> issue since people are waiting for the kernel-doc fixes.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-01-18.2
    https://git.kernel.org/netdev/net/c/bde2c0af6141

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


