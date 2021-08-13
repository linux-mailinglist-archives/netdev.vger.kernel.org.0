Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757193EAEC6
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 04:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhHMC7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 22:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238506AbhHMC7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 22:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 764466104F;
        Fri, 13 Aug 2021 02:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628823567;
        bh=1IRXGyCcsIvGPLVQnv5g03U5IqA4GdNniUiDHAd8Hjs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YBXOdXNAVk1ZSCFRMWhXZydSo2jPkXUZyt+MMA0MJxYQ6lfIkPBCpjgyodD81AL91
         QzE+Y2ntpgTNTqNq/4TWxOm7MhsPHUqRWVgWko9Al2kFtp84xXxwhqsF0muw9qt8/4
         Y6D+FtoLLYE7qOTwtnvyBIAcNcE3Apwrrf4pQtSuRDZuQv3WjXXbJ69PhORA5FOmNn
         8FHuUlvEHmFYx6xZ3Cq2tOrxFv93UB2MLiRLgMOFkhWPRqHp+tvLccAwSf+k2YZCSs
         TjxTLCspAM9qqwyXNTt09+PKrFayK1n2PhFjWGFVss7dT3ez1QLWiqzIrbQbg1dTuS
         q80PSEKAn0Vdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7094B608FA;
        Fri, 13 Aug 2021 02:59:27 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210812192214.397695-1-kuba@kernel.org>
References: <20210812192214.397695-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210812192214.397695-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc6
X-PR-Tracked-Commit-Id: a9a507013a6f98218d1797c8808bd9ba1e79782d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f8e6dfc64f6135d1b6c5215c14cd30b9b60a0008
Message-Id: <162882356745.1107.8677481565467801623.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Aug 2021 02:59:27 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 12 Aug 2021 12:22:14 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f8e6dfc64f6135d1b6c5215c14cd30b9b60a0008

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
