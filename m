Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A76730D1FB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhBCDKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhBCDKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 22:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B46F64F6A;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612321812;
        bh=qCxhU4oGeXDcmRe/OcfFGmztsqhLADlvqabHNTAROGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sD5Yvl4tVeGgsVWlBVxu2dYYJDala9rFes/UnjhjSH7jXNXO3qACVUQJ/frEyugYx
         OTEOw9JoB9CIT6v8Qnb4eecHzJMHtKS8UhmAIX2P11YLKnjFy2b0fn2P75AKvwN5Cj
         GmYWWp900g1LVYKbff8T6zz71A11negtN1x/pYjct/3Q1eLMp2yEuAqOWGdyhjFTJw
         db7+7c2oXWH69h+5xnFhRf9tj4/b1dWjcbODvJJhfwVaC1adA3UO4YgQPWev69vLLn
         bqcvb2Lb6t0ic1960TfitBHoXjs9enanyfZv4vLdXdDWb4+SxbeootMq7Lb0NwSreo
         rWeSU2wcUY8OA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 10B10609E3;
        Wed,  3 Feb 2021 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-02-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161232181206.32173.7600413164012224417.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 03:10:12 +0000
References: <20210202144106.38207-1-johannes@sipsolutions.net>
In-Reply-To: <20210202144106.38207-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 15:41:05 +0100 you wrote:
> Hi Jakub,
> 
> And for mac80211-next, I have only locking fixes right now. I'm
> happy that it otherwise seems to be fine though, now no new bugs
> have been reported for a few days.
> 
> I might send some more things your way another day, but wanted
> to get the locking fixes out sooner.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-02-02
    https://git.kernel.org/netdev/net-next/c/0256317a6151

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


