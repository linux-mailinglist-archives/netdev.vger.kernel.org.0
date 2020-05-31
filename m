Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854E81E99C0
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 20:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgEaSFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 14:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgEaSFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 14:05:03 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590948303;
        bh=4CRZa7JGRDtPrxJB3HXKHm8gh7sum89U5LPzt6xgYTM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=OsShzPphWZaWbqrk1NS//SA+ERA2QksqWp1szrKM5Gk4xDf6lGT7gdPWHKZ0MGrfF
         XEakHHun3IGC3B2cdsMRrlzOCrQoFychULXX+ULAakMcqBABKGdoAboWLC/zjidWXT
         681qBpYTe1ZOBWTd0UuJSxHdpzOdpBciTMV258hw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200530.221309.1347376729998812574.davem@davemloft.net>
References: <20200530.221309.1347376729998812574.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200530.221309.1347376729998812574.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: d9a81a225277686eb629938986d97629ea102633
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 19835b1ba6b1f2d3fb5aefffa01ebd626513ff4a
Message-Id: <159094830304.9121.2392773888465749729.pr-tracker-bot@kernel.org>
Date:   Sun, 31 May 2020 18:05:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 30 May 2020 22:13:09 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/19835b1ba6b1f2d3fb5aefffa01ebd626513ff4a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
