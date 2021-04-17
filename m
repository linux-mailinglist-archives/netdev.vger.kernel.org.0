Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED364363149
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhDQRCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236698AbhDQRCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B41A7610C7;
        Sat, 17 Apr 2021 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618678928;
        bh=VsXF+WPcT3GnWYIQViGsNqb95iXQ7PnB7fyjW02U3DU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ow47Pp1bp2dbb2aP9cTgWoIBvlyha5GRiJpBuk27+xDvHGg+uA54zm2JAmdSDniYR
         6VWHnHBCUvHJu8t+5PeDb5TlyxPPreOJDh6ZooxJXqj6s20AO42rveGRilVFrJ2oMw
         ZaFJoIM0fper4qpVb24TuRjpylkILL7ZhMPuaYAaoMZFpSGhvsCfhcf1EW30r5KQqC
         1gyFKlfrmWSyPhRfuDLhmq0h3pjMj2zAh3f5yN9UF6M/QFqvZRgwq4GUV2jkWPky50
         0rLY7BKaSIcmvy5omQPjVsjDkKGWVOI/cuFakBAtM7A8ZNNFy3w0jTqfzx+bj/Ortm
         AYq9BK71+9LGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEC2D60A15;
        Sat, 17 Apr 2021 17:02:08 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.12-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210417050703.610514-1-kuba@kernel.org>
References: <20210417050703.610514-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210417050703.610514-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc8
X-PR-Tracked-Commit-Id: f2764bd4f6a8dffaec3e220728385d9756b3c2cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 88a5af943985fb43b4c9472b5abd9c0b9705533d
Message-Id: <161867892870.3103.14627731957843212134.pr-tracker-bot@kernel.org>
Date:   Sat, 17 Apr 2021 17:02:08 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 16 Apr 2021 22:07:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/88a5af943985fb43b4c9472b5abd9c0b9705533d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
