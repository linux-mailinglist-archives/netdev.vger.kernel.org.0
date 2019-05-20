Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0901323CC7
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389552AbfETQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389376AbfETQAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 12:00:20 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558368020;
        bh=r1vRugFSCXlLxkpJKTjcWoL9vYTyIlJsjDIoSONWvKI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hA1cUfO2k0UvtE5I0vBd91ZOSKxVA9I6mlT6GHvAZsJLmuiCe1F3rC2HgTPgHEjEh
         8OvbzW+JeV0R3JKCuDUIUQ47NEdkE8Z66k8jRV91KB9zyREi9e9EXS4OijBSSs4u/V
         Wpr8oQpssa26+Ek74tuEDsqrbKOdxHIPdyp4qLbQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190519.232805.495214807000862867.davem@davemloft.net>
References: <20190519.232805.495214807000862867.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190519.232805.495214807000862867.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master
X-PR-Tracked-Commit-Id: 6a0a923dfa1480df41fb486323b8375e387d516f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78e03651849fd3e8aa9ab3288bc1d3726c4c6129
Message-Id: <155836802020.24165.10320170839771850110.pr-tracker-bot@kernel.org>
Date:   Mon, 20 May 2019 16:00:20 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 19 May 2019 23:28:05 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78e03651849fd3e8aa9ab3288bc1d3726c4c6129

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
