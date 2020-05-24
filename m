Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C321D1DFC18
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 02:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388205AbgEXAUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 20:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388094AbgEXAUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 20:20:03 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590279603;
        bh=2wbNW0bwyjO+vUh7ssuCFbgTNBBdBTYCdA88Amnu9eo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=u03oMAW/U+PuvdmYsrsKID7adMbsAr2hY6ADPnhYCntKzn+hw37SI449wumznJGx2
         gBpgO+w2L+asfwWJvENf6uoO2Agkq7bIV7uPEIUqYMbWaJIBgJBPJ6mBT63gvttTrv
         DVUGrDq/lx/dccNWrQf3w4Sa2NdH3urYsECKSMzE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200523.170654.66302705884131064.davem@davemloft.net>
References: <20200523.170654.66302705884131064.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200523.170654.66302705884131064.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 539d39ad0c61b35f69565a037d7586deaf6d6166
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: caffb99b6929f41a69edbb5aef3a359bf45f3315
Message-Id: <159027960327.1872.1044358515428595667.pr-tracker-bot@kernel.org>
Date:   Sun, 24 May 2020 00:20:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 23 May 2020 17:06:54 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/caffb99b6929f41a69edbb5aef3a359bf45f3315

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
