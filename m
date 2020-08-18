Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868FB247BDB
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 03:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgHRBfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 21:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgHRBfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 21:35:19 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597714519;
        bh=9PLn/cqodGkiti1DimZNQdTl/V/td8jX8QmhzOw+5S4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nyd1fESVWrdaaUS2wKVTdoOIZ5KPlI2NUzEQXD+t378DoZn8qA6Lh+oj7OYn0xfuK
         70ma9ylnpDNMx3dOEfzSPFiZPCJfExaozMcWTZNRTwRYJXsm0o9JHwublgOnoc7/2x
         ss5eSMiPtbZ+hgiXZigfUaGmsnQif6l2u7RUSLps=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200817.151516.165813635830933647.davem@davemloft.net>
References: <20200817.151516.165813635830933647.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200817.151516.165813635830933647.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: bf2bcd6f1a8822ea45465f86d705951725883ee8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4cf7562190c795f1f95be6ee0d161107d0dc5d49
Message-Id: <159771451950.4714.11357473073400346796.pr-tracker-bot@kernel.org>
Date:   Tue, 18 Aug 2020 01:35:19 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 17 Aug 2020 15:15:16 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4cf7562190c795f1f95be6ee0d161107d0dc5d49

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
