Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A711B833C
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 04:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgDYCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 22:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgDYCaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 22:30:16 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587781816;
        bh=11+U7d/6Bw0ujSyz7hfoOJ9djeOpPa7R/U0m/sgqgSY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=TH4uSCC5CF3MMRJ3oT8iCpanXly09AXMSTI5Mf7QH/t31VknttGe6YY4jngxkHcxI
         rc7t6tmEwuage8eFMp0oqj0TlIpAQEG2W+fot8Qk2GGWgJChJkdnjlLo3BibXmfhs6
         A/P96Aq2Hxvd/r0z3nMR/W0/PPzHy/axAImqB7B0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200424.190216.1867250977580084003.davem@davemloft.net>
References: <20200424.190216.1867250977580084003.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200424.190216.1867250977580084003.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 167ff131cb3dffccab8bb4d65a8d72e7c5ffc398
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ab51cac00ef2859f20a73d33a53f3a8987b65e11
Message-Id: <158778181638.31747.18441893239696391932.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Apr 2020 02:30:16 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 24 Apr 2020 19:02:16 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ab51cac00ef2859f20a73d33a53f3a8987b65e11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
