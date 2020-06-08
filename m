Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A81F20B5
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 22:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgFHUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 16:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgFHUaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 16:30:23 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591648223;
        bh=aKkHAUwMJdAcjnYPmV/eAoZWvfj4xFrMkgKicaY87As=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ljl2GCNCJsmVH4YW2QInicqFxjtP4XJuvf+wroeyjcdKgzyosTLptcNX/glYDUxqD
         cLEaV/mQpbylmPSO01c0MgBjbsv0lbAtexoyT9CwAYUX3wlHADmr/SsgtxDyMOKXjO
         pKBUj9EmftSY/WEdqmqI5WSagqmd39DdxHNN/iMY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200602.171111.57475611625131165.davem@davemloft.net>
References: <20200602.171111.57475611625131165.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200602.171111.57475611625131165.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 065fcfd49763ec71ae345bb5c5a74f961031e70e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2
Message-Id: <159164822321.23618.12568851381765933923.pr-tracker-bot@kernel.org>
Date:   Mon, 08 Jun 2020 20:30:23 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 02 Jun 2020 17:11:11 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb8e59cc87201af93dfbb6c3dccc8fcad72a09c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
