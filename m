Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4126830C699
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhBBQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236479AbhBBQut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6EBEC64F7E;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284607;
        bh=Ytdw3WOGdT9xww9kCNTVv9sQsmMyzoPAqdxksZUNbIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=obTFqui1pgwjAeiVNRoU7WsAIClkhrWe0hxGly4zali+ct84fIm4AQ68Mf8qZlh66
         oi/IdrTNvkhIK3BSGPlpdL14TI5/OT/vnUilapjh5KZI/Bn8KS+1K6L9IFEckKgZ7f
         0Bk/8IBDz6vT8gOs4McLl596B2OoIQ298pxx7PAsb1b5UBHEZZXyn1i+RY3/8zV+j+
         hEfK2eR148pyx8iX+6CcvboHhmGMF+MrE8ax/G8sSezavaCwK+eYEsZK8jBWLUFwqg
         G/JRgY6PGNvwsFIJ72tUUo2bdntQRlWAz4NYvpNyc8ABmnBAbvx+Vz5UD7dVDqkKfn
         kKZlJfkpMeTJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 686C9609CE;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-02-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228460742.23213.1117377482651295585.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 16:50:07 +0000
References: <20210202143505.37610-1-johannes@sipsolutions.net>
In-Reply-To: <20210202143505.37610-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 15:35:04 +0100 you wrote:
> Hi Jakub,
> 
> So, getting late, but we have two more fixes - the staging
> one (acked by Greg) is for a recent regression I had through
> my tree, and the rate tables one is kind of important for
> (some) drivers to get proper rate scaling going.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-02-02
    https://git.kernel.org/netdev/net/c/f418bad6ccfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


