Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7337C28FC52
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgJPCA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgJPCA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 22:00:29 -0400
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602813629;
        bh=/WsP3NIlr8hDoRCpON2SlJjjOtYsMCOoUdJPLOo2npA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=YbBSxRcSPLonVi70Z9Ln3CkMOev+xXtEW4wSguohA3ryqInvjM7mUfYtsXNB3pu6i
         B4GFa7JMPJ45DvkGQg/+xW3TYEvgpI/8NgBwcafTGPZiDCGBicBJEy/HlR6RQKbRFT
         PKohq3acOnj89mCE1aienSx9KqTL7WVjrmz854oQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.10
X-PR-Tracked-Commit-Id: 105faa8742437c28815b2a3eb8314ebc5fd9288c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9ff9b0d392ea08090cd1780fb196f36dbb586529
Message-Id: <160281362918.14616.833621065053535862.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Oct 2020 02:00:29 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 15 Oct 2020 14:13:02 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9ff9b0d392ea08090cd1780fb196f36dbb586529

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
