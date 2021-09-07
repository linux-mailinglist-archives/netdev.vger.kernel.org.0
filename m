Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB10403032
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347170AbhIGVXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347129AbhIGVXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E43A361102;
        Tue,  7 Sep 2021 21:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049747;
        bh=mpprWvjYhsVojAHrR9gaDmc2KSzr3zkjrtJcsTroQDQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dCQFW4AmbVIZ1waBdE4Mpjz8UqoTEQ6ZLmm0RA2JfteEOWIxXNTsieLoFLXlN4FNq
         Z/wnk2B92/gMiowoMtf83KGJ5PT7qfHhNk8EXtr//gFTCbTPW3ILxnq/Vc7UlbELYb
         dv99qudDqIFkb84GtqOSYb6+i5aQseAXAmHfulMgtQgK7xYRPlY9b6DyVTvKJnOmuP
         5rGbfrsWtrF6n6TFdOLotUH4EEya1PvWp+3hVg5f3Yf+HTZl65iOxolhQ4r4nU8VMS
         KM7pRHq/puFOcUSITjW5nLdC3Cc0eBlCubUWFIlq/iL+/WAUB6h/a/UUPKQKOvEziO
         3xpCyjRBjp2iw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE879609AB;
        Tue,  7 Sep 2021 21:22:27 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210907191640.1569636-1-kuba@kernel.org>
References: <20210907191640.1569636-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210907191640.1569636-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc1
X-PR-Tracked-Commit-Id: 0f77f2defaf682eb7e7ef623168e49c74ae529e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 626bf91a292e2035af5b9d9cce35c5c138dfe06d
Message-Id: <163104974790.25074.5266425509923162400.pr-tracker-bot@kernel.org>
Date:   Tue, 07 Sep 2021 21:22:27 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue,  7 Sep 2021 12:16:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/626bf91a292e2035af5b9d9cce35c5c138dfe06d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
