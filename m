Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34574156853
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 02:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgBIBaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 20:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgBIBaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Feb 2020 20:30:24 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581211824;
        bh=nP3WJUemZwOEGYMM6sFrfB/oEG8Nb2n/yQJFGwJv+us=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=QzvA3G/E9OC66clwdJJPSpTYOsgHGoj9yeJUrbz66/EFtUeCk2Ge0xN3inOdQqY5r
         akSlUJLzjuR+LGengwlQbBiRoJRs80AKiN6ozBsO2ZyTjhnIX0IImz3TlvxUJ8rnsc
         o3/NPje2e1gqf0kTxgc4mJWRqetPb7o72jq64IwI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200208.233612.1712791186124406955.davem@davemloft.net>
References: <20200208.233612.1712791186124406955.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200208.233612.1712791186124406955.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 29ca3b31756fb7cfbfc85f2d82a0475bf38cc1ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 291abfea4746897b821830e0189dc225abd401eb
Message-Id: <158121182430.19605.8913178584004677320.pr-tracker-bot@kernel.org>
Date:   Sun, 09 Feb 2020 01:30:24 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 08 Feb 2020 23:36:12 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/291abfea4746897b821830e0189dc225abd401eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
