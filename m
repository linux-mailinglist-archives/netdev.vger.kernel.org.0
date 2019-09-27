Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F12C0E37
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 01:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfI0XAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 19:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfI0XAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 19:00:25 -0400
Subject: Re: [GIT PULL] 9p updates for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569625225;
        bh=sOmkUwDptShoBIASuX4SCcnaHcEbbpoN1nJZcqTmius=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=mQ7UH8+piZka+ufHrTF665+on+mZzFyvkeIXB5NsYUxwVhCF1+7xgSVMY8YbAk58N
         ohVkaeklk+avIiYnQ/t5VCdKOMityE7hHDbw0LssTa0bXOBisvLAmTMC5FB7j2ceKz
         h1U1Cf9f9061Low6y8uMVts0Ahfh5unpiZBRd94M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190927142725.GA8169@nautica>
References: <20190927142725.GA8169@nautica>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190927142725.GA8169@nautica>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.4
X-PR-Tracked-Commit-Id: aafee43b72863f1f70aeaf1332d049916e8df239
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9977b1a71488742606376c09e19e0074e4403cdf
Message-Id: <156962522511.10299.7199492339418267253.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Sep 2019 23:00:25 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 27 Sep 2019 16:27:26 +0200:

> https://github.com/martinetd/linux tags/9p-for-5.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9977b1a71488742606376c09e19e0074e4403cdf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
