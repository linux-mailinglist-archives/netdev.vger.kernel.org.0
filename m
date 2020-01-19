Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9166A141FF7
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 21:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgASUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 15:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgASUUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 15:20:04 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579465203;
        bh=lv9oNq8nD4H5tIBdR7cFtVznUj+BxbwXx8QUI8/WI6s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qg2FyBCCauqx167cz++d9RNv1T0K9lqOXHU8SZopuHvAFOitLJgN08f3cU1Dhqfq2
         dufshal4Zii8wa/iS2N8Kv2aUWgHfXtblhHgHjW9XkcaeEciYNIzYvjKM6NngOUQMI
         JqYRgvg0R4AcTDqusy3ZQkpoWRBFUmgsc/Nw9KuM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200119.163941.2280554179674027217.davem@davemloft.net>
References: <20200119.163941.2280554179674027217.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200119.163941.2280554179674027217.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: b2383ad987a61bdd3a0a4ec3f343fbf0e3d9067b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11a827294755ce3d07e14cfe257b3ec16ab56f34
Message-Id: <157946520376.8493.17503906965460845534.pr-tracker-bot@kernel.org>
Date:   Sun, 19 Jan 2020 20:20:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 19 Jan 2020 16:39:41 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11a827294755ce3d07e14cfe257b3ec16ab56f34

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
