Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A509D3B8AD3
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 01:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhF3XQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 19:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhF3XQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 19:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B560E613A9;
        Wed, 30 Jun 2021 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625094850;
        bh=OaobmDfYGlODepv0TfEoXUQolmhzH19OwnEyRNaOgyc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OcIPiWagCPF9rqVh77aSVcDmGilk+r0T4Z/G8ANWa/iqPGKFjyB0k5+FW9u3jBb37
         qjceOcbExuXlFhhOSvdDICywYmj4lZJziYKUCTujVqgcBGvfYcU4wjQ9SPFJqnrBV2
         lePf66NYE+yep9rwKpijZUhMauvWrRW9YmeO47uwYHHImtir1l34hjw3gF49OPOfWv
         8qhKiovNeZx+yRcLM3uBWWAJMcvQE8bA1+Y+becVzlIJ8knswmwY7BjcG3ufK+KXeP
         nfslfVDb7G2IBbvZdGMDadlqW4tXbzswwwi35c6Z2ttVt09Q930ZK31ZqnL0GbYMl3
         EMmouxbNo55Xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A24376095D;
        Wed, 30 Jun 2021 23:14:10 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for v5.14
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210630051855.3380189-1-kuba@kernel.org>
References: <20210630051855.3380189-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210630051855.3380189-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.14
X-PR-Tracked-Commit-Id: b6df00789e2831fff7a2c65aa7164b2a4dcbe599
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dbe69e43372212527abf48609aba7fc39a6daa27
Message-Id: <162509485060.23001.15009915450669760468.pr-tracker-bot@kernel.org>
Date:   Wed, 30 Jun 2021 23:14:10 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 29 Jun 2021 22:18:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dbe69e43372212527abf48609aba7fc39a6daa27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
