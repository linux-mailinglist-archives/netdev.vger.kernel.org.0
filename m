Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11564041CD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 01:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244560AbhIHXdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 19:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240406AbhIHXc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 19:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1FF196044F;
        Wed,  8 Sep 2021 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631143910;
        bh=6pLIvXijYgvmsA2FfiSgiW8Oq7w90zN/zDTa2RAcvHg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XEUExD3ZqfCzIbuHRbeGnTt3UE4yUFcvviBDw43C57yzKyO18l8xvsnjDH60P2TWq
         KHKegyQ8jPVI+NQKemGoWbC8SzVXiky7UMh7PiEihRomMiN3zp9dmLRlkgNrA5wDsk
         G/ncrx6LpZw/e00FtnJ2sxX1SD4c+7O4Wqs3J3/FRApaKsD3XEC3m9bGcrCRc6pPV2
         HjG0YSJtxMg7OH2U8Zwzw4OyxWSANYS5ek1Bf4RRkx+2KnTQonzA1aDRMyMIa4p3bZ
         PvBhth7OZHlQrYJnTWrctdaWXflqy+C/d+KVT1IwTB7wLDkgGQSmn40Pkh0mMn8/wu
         j46dZP54/55qA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A0DD60A24;
        Wed,  8 Sep 2021 23:31:50 +0000 (UTC)
Subject: Re: [GIT PULL] 9p update for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YTjFWjkz0nPb+sZe@codewreck.org>
References: <YTjFWjkz0nPb+sZe@codewreck.org>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YTjFWjkz0nPb+sZe@codewreck.org>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.15-rc1
X-PR-Tracked-Commit-Id: 9c4d94dc9a64426d2fa0255097a3a84f6ff2eebe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34c59da47329ac50b9700035e0c3a829e6c3c183
Message-Id: <163114391009.13056.18287984806603504636.pr-tracker-bot@kernel.org>
Date:   Wed, 08 Sep 2021 23:31:50 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 8 Sep 2021 23:14:50 +0900:

> https://github.com/martinetd/linux tags/9p-for-5.15-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34c59da47329ac50b9700035e0c3a829e6c3c183

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
