Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C35232719
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgG2VpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbgG2VpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:45:05 -0400
Subject: Re: [GIT PULL] 9p update for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596059104;
        bh=RGxKV2Xu1zD1MH8dO1gS8pqPCLQU9ZwmSd2xHqLoN+s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VQJ/gvKycDWO9M9qk/2BrzD3jYVw8orSP3PDqpWXU/a0UBkDkPt7nrwC8lenvGCeY
         kSRnHs65SSyRBe2sSZMf7ViIp88xYYlQJV5nyPrE9HnpiIUofzT0XXvhVHdMKSQG5L
         y71YRJOS8YFm67g3Ip4Qel20LY+z7m/eFhsunu3k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200729063306.GA19549@nautica>
References: <20200729063306.GA19549@nautica>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200729063306.GA19549@nautica>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.8-2
X-PR-Tracked-Commit-Id: 74d6a5d5662975aed7f25952f62efbb6f6dadd29
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 21391520cbb597823050ac1bc343a0df3222ac90
Message-Id: <159605910487.4880.6597657243870316422.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Jul 2020 21:45:04 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 29 Jul 2020 08:33:06 +0200:

> https://github.com/martinetd/linux tags/9p-for-5.8-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/21391520cbb597823050ac1bc343a0df3222ac90

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
