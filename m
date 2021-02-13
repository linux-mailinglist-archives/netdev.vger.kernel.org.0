Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1E631A932
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhBMBBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBMBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 709F964EA1;
        Sat, 13 Feb 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613178009;
        bh=YzFqgwz1H5+PJl8apILpwQXNEkQLHhvONd1iaEkjmbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bXSTHpmdbvcz3rLGV8dPt9sselCKW8GX8kNKIEBOZ7wam3WaN6hejGcQCaCXnMPGT
         mH047GBstnSnuukJdW5WaaQxJ4aP6+KZyxTWzpXggB+3USf9TBd3SAwdZe9oRND8Eu
         DjkCjFeMj53bBzEkqExokmNtbGfXSLEfO4VE53KU1vW2u0kFCI67PWHDmj88wifWQW
         FfKFN9ULHVMlzB2/pNO9SbLZxxpkhXkVl6codOB8Zc+0HZV63Z+8O3yGI+xzQSZXUv
         Kqg0GqZ98Z77ZMSIDT9D1fbJtalYLasuYaPqyYTp+Cd4i2XZPlBGp+V+JgFGP0NehM
         q5QkRQGer6jDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6129E60A35;
        Sat, 13 Feb 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-02-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317800939.11471.6873829341150664652.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:00:09 +0000
References: <20210212135551.49439-1-johannes@sipsolutions.net>
In-Reply-To: <20210212135551.49439-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 14:55:50 +0100 you wrote:
> Hi,
> 
> This is almost certainly a last update for net-next, and
> it's not very big - the biggest chunk here is minstrel
> improvements from Felix, to lower overhead.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-02-12
    https://git.kernel.org/netdev/net-next/c/21cc70c75be0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


