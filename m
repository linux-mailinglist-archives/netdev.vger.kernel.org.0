Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8E287E14
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgJHVhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgJHVhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 17:37:46 -0400
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602193066;
        bh=r392DO3w/yePYwR9c1w7PXZ33gYcHF1iE0DJ8ctdYQo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Y/i1xSYjRGWMhv3N/A5hPxHgancDPas/TdYUikmXw4YIecZhtSeTT8szb9/6uYO4K
         j2m7EJUi8d0VTbLJyD2g5QI5MkslAB31bW37ESvjLqc+MafRvRbt6LRlRxxL59qku7
         xtv5tJ57bmyj57QyAjrCZoc3LbM/f8bFy56ySw/A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201008132329.7eaa0d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201008132329.7eaa0d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201008132329.7eaa0d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: 28802e7c0c9954218d1830f7507edc9d49b03a00
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6288c1d8024eebb7a1ccdbab80f6e857ac94eeb0
Message-Id: <160219306641.23094.17685367320772018805.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Oct 2020 21:37:46 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 8 Oct 2020 13:23:29 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6288c1d8024eebb7a1ccdbab80f6e857ac94eeb0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
