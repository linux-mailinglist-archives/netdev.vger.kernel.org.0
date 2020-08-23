Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1140B24EF49
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHWSjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgHWSjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 14:39:23 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598207962;
        bh=AAcm6AfS330Gug5Is/2Xp1ttTbFdI7vSdBpDeoXtpFc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=od4Rx16jGqjiOiV/kf9Xza5OATr+cx6g/QMTC6t82SgYpV8JOudBU5PeCz0Az9Fii
         tG7yrVFs0rT5Oe8pYhSJ75Cl3g8/CAGqdDUAzjIfLp7Q0XW683iO0tLm0k8cd7r7r1
         SinpSdOoXnRP3BroRUXO/Vypa4lamv6bNAABXekw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200822.191948.1640751494477385125.davem@davemloft.net>
References: <20200822.191948.1640751494477385125.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200822.191948.1640751494477385125.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: eeaac3634ee0e3f35548be35275efeca888e9b23
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d045ed1ebe1a6115d3fa9930c5371defb31d95a
Message-Id: <159820796230.12134.16025100180403740391.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Aug 2020 18:39:22 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 22 Aug 2020 19:19:48 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d045ed1ebe1a6115d3fa9930c5371defb31d95a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
