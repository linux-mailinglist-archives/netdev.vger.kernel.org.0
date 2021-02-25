Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06B4325767
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 21:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhBYUPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233604AbhBYUPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 15:15:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B83E264F34;
        Thu, 25 Feb 2021 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614284097;
        bh=fPMivAazjMW28Uh0DrhdSs3hl5qHy6LZK/ULoxO8Yrw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=b8XKcbJBWLCq5MpGfDKxIOH+rJeIbtSFGiKrJiO0a/wHsFK5ht5Jm2m/VwqXYD4ve
         6SD0JNs7KQfFgGPRK64dItPXakrx915ccbWjfRuXWz1soum7Jsepy24Fk6cx1d/ODS
         n7KwEBiZDy/2WCpfWBjwrDh8muniwUZdh+uUedtEzf/BI2hWie9c4o5LF7lDMe7y8s
         VifIcwKRo7WQlHYurNnQf7+Yxucgs3zxA7v7ytTqR61GQt/ZMGGHAYeUuPSkzrHHrm
         gRu90J9BadAb33N2juZOggoMpySVLSbccPfYv0hr+0Z1HCFh3cyAnWccVvy4Lb5eBr
         YmNsCDrd8OqEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B31F160A0E;
        Thu, 25 Feb 2021 20:14:57 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.12-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210225184826.2269264-1-kuba@kernel.org>
References: <20210225184826.2269264-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210225184826.2269264-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc1
X-PR-Tracked-Commit-Id: 6cf739131a15e4177e58a1b4f2bede9d5da78552
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ad3dbab569ac39e88fae31690401895c37368b6
Message-Id: <161428409772.10391.367644792141423844.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Feb 2021 20:14:57 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 25 Feb 2021 10:48:26 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ad3dbab569ac39e88fae31690401895c37368b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
