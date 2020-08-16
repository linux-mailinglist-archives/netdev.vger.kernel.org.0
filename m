Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0320E24555C
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 03:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgHPBzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 21:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgHPBzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 21:55:10 -0400
Subject: Re: [GIT PULL] 9p update for 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597542910;
        bh=N/bkrF+0fXTLqLT/Y//NJuCDndDV9m/xvtSF6AUgh9w=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ShzdSZgCnl4sIbw3X2HQWkZ4z+bg+n7PXRyxUzLlV5SFCXlR2T9ef2WgoIbxODBDf
         eEbQ+3R5cU4vjGjYz97Gggc+3FhMf97MYhdIohN+Kgh1bNGqMAXC5hU1nfKAiPxJl4
         GAHmV81HyWZF3QxpbluUX2Pqqcw7THHHJcdABZkM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200815055219.GA20922@nautica>
References: <20200815055219.GA20922@nautica>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200815055219.GA20922@nautica>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.9-rc1
X-PR-Tracked-Commit-Id: 2ed0b7578170c3bab10cde09d4440897b305e40c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 410520d07f5c66a6c1f3eb7ef2063d9bdd3d440b
Message-Id: <159754291013.18953.882050995366233563.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Aug 2020 01:55:10 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 15 Aug 2020 07:52:19 +0200:

> https://github.com/martinetd/linux tags/9p-for-5.9-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/410520d07f5c66a6c1f3eb7ef2063d9bdd3d440b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
