Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B442193284
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgCYVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbgCYVUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 17:20:07 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585171207;
        bh=LBkJ2QsaM4TEjxklSbnT/FU9k+yUp06V7Hx7cR3EjeI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fjROOQpxHtGvMPX2zLw9x5od9TrATDS2VJ6db1sgweRTsFDa0G7g0sqLDWpyj4sgX
         Zqoo+sLb3w88lb4m+yakKs+hHAdaWUKEHGooienCWQCr5Rw5DYRNUGY5fnLaw3+9MA
         8wuaXOtt2NXQ/NwprWp10aDW449FbOU5Abtz3AcY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200325.132424.1374007175286656428.davem@davemloft.net>
References: <20200325.132424.1374007175286656428.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200325.132424.1374007175286656428.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 2910594fd38d1cb3c32fbf235e6c6228c780ab87
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b649e0bcae71c118c1333e02249a7510ba7f70a
Message-Id: <158517120722.13294.18023221083576299745.pr-tracker-bot@kernel.org>
Date:   Wed, 25 Mar 2020 21:20:07 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 25 Mar 2020 13:24:24 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b649e0bcae71c118c1333e02249a7510ba7f70a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
