Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C72314981E
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 23:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgAYWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 17:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgAYWfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 17:35:04 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579991703;
        bh=PCUMx6bpKFINzFW6ARpgnsyecWMnbIzh3bZ8vJ80Gnc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qX0Z3GHnNz0tDm0jeGINQPEBW8q0UVpbhfRBj0BgYk561SAifVRw3r/3f3cUp5xop
         i9IL0fC/axTdOiooysH5I238T9SEQ5yGXe79XFxPblOdTMoCRcdN3UX5npAbHWtqdN
         8Jo0z5PB7v6F5/Lqv2CAfbuyfJX4BEImHmHE8nAM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200125.224148.1422830886922555363.davem@davemloft.net>
References: <20200125.224148.1422830886922555363.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200125.224148.1422830886922555363.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: fa865ba183d61c1ec8cbcab8573159c3b72b89a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 84809aaf78b5b4c2e6478dc6121a1c8fb439a024
Message-Id: <157999170352.21045.704562636007940215.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Jan 2020 22:35:03 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 25 Jan 2020 22:41:48 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/84809aaf78b5b4c2e6478dc6121a1c8fb439a024

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
