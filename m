Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3408F40EB8F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbhIPUUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhIPUUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 16:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EB8661207;
        Thu, 16 Sep 2021 20:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631823561;
        bh=wHcat4Qqsa/b6FdiPVdS5QbYPXHvMNmiO/M1zBZFkA8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iZrxqPjMbvfO5JLwz4nMxWH/7kSc78r/F5J6KCNE3ikQ3wqtMRkcOPCeurRdz5bCW
         YVzy/8WdiBu60GuM0xC3OR6mQlsYL1RseC2s1zQWFdJwMCMlhrkk2b5WJPIUC3LPa/
         gQwIQVwMDA1GVYj8LjrpmtPUDkJkHwrrwLkFSQiKcV5DLCUpwqGciX4CAOFchVBi+x
         GopMzjYX3nRA0xzTDCbE8ktq9GcScUIQKknmBvaKSSlSPicrDIDDzzK7/fTi5TdrSi
         JCims9udlbWFY0HPmJ/lVHJht3eq37m9jWhsrOBh34j6tU+YUP1mFUD194W+NmieoH
         zlfCN/N35LFxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B179609CD;
        Thu, 16 Sep 2021 20:19:21 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210916200345.3840415-1-kuba@kernel.org>
References: <20210916200345.3840415-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210916200345.3840415-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc2
X-PR-Tracked-Commit-Id: ee8a9600b5391f434905c46bec7f77d34505083e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc0c0548c1a2e676d3a928aaed70f2d4d254e395
Message-Id: <163182356111.25666.7350174853488952240.pr-tracker-bot@kernel.org>
Date:   Thu, 16 Sep 2021 20:19:21 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 16 Sep 2021 13:03:45 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc0c0548c1a2e676d3a928aaed70f2d4d254e395

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
