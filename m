Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F217E2DDB0F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbgLQVvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbgLQVvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 16:51:12 -0500
Subject: Re: [GIT PULL] Networking for 5.11-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608241762;
        bh=LI6trbnfUu7s3ZsogP+zu1G7Tz/8IjZQ+dzYJrJTZLc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=JZnJuu3V/5WjgkHpIeGMb+RMepFWqmcsEw7zvynKikqRXmehVYndsHrc1STh5ZmEf
         59JHNlQQbXUGzbhx4+Ryd0hzApvcp3wchT1o+1wwnU1CqarP8KoIbexoRmkmcWHf3e
         fdGFN6zrw9BET9b9OgcCM7IrgvOxjGulioMtz2n5e308vbeoco6LCaEzqL6oa1BYRq
         RKKZ4cMOD3SWeLB00Lp1SUE9/Z4rCcaQNkHIr+92+jc4nQdfDIhxyccdhhq29QUCKD
         LLEE1qiglOjEyBFDWLT0mNaU+gIU8HoJse6wwjLkNB4O2hj0Qcnx237M/pirhTHUQQ
         GtoC+EDVjnWfg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201217210204.1256850-1-kuba@kernel.org>
References: <20201217210204.1256850-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201217210204.1256850-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc1
X-PR-Tracked-Commit-Id: 44d4775ca51805b376a8db5b34f650434a08e556
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d64c6f96ba86bd8b97ed8d6762a8c8cc1770d214
Message-Id: <160824176246.26275.10068748815417314493.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Dec 2020 21:49:22 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 17 Dec 2020 13:02:04 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d64c6f96ba86bd8b97ed8d6762a8c8cc1770d214

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
