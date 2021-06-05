Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BB39C4D4
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 03:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhFEBhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 21:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhFEBhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 21:37:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D24E86138C;
        Sat,  5 Jun 2021 01:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622856956;
        bh=KQKxWLhxTdsXI3HUF1wXr+Y8iuyybKr7rEiEQ5qQk7w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=r2F9Xq8w67g8dBY4vp+mqljwfViCYOGzqnGEIHfr77z0QsrTOnoYKjkLARiDh2bre
         a8skXtWFjY8/ED1aZNiH4fTsPKEIGKT8TLv92uV+KgYsPm+whv5N7YJ8VBj2ynOYmG
         S/3fnGHAmEWrPbRKBhq4wmqjrE1LZUgNLIm9JGOZhDE3ubmWMfL7AaxWn/bvNcYT5B
         9sWpuGALt36/z+5Tw3gnSk1z6PZFLcwRCiXZ+Gf7Yy5aJLtGXCgpBj4KYpi2cc2vOP
         Y4JTZVEfWwXvlQRkVBumDzQauBJOM5EOE+ch3PDIr1e6jIPFqahRf9qLwY+t4KNzFf
         WErYQsv6FCGiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF4FB609B6;
        Sat,  5 Jun 2021 01:35:56 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.13-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210605005650.2542428-1-kuba@kernel.org>
References: <20210605005650.2542428-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210605005650.2542428-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc5
X-PR-Tracked-Commit-Id: 3822d0670c9d4342794d73e0d0e615322b40438e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d32fa5d74b148b1cba262c0c24b9a27a910909b
Message-Id: <162285695672.3539.1697069197541052272.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Jun 2021 01:35:56 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri,  4 Jun 2021 17:56:50 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d32fa5d74b148b1cba262c0c24b9a27a910909b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
