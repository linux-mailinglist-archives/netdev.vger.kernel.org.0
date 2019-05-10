Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB4195F6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 02:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEJAPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 20:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfEJAPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 20:15:13 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557447312;
        bh=471Q0FZH+6iM02c97pYQxOSDif0KayU1oC74I23Z6Vk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hiEp5GqfrGILKWWhGHhc4WhQ2Rao+r15fuMNZr9cxZKhbQGfxJUdQvUDOPVZlV0X+
         Ab8t46WUwaFKMWx5NbvRFmeqdyLHMmwN50P1hPqpgv3+TqKKDkanQx5WleAdSSMkO/
         TLpinP+Tf9bwhgo0Xx++HDrptlsHCSw0L+10L2JE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190509.165536.716778200205224094.davem@davemloft.net>
References: <20190509.165536.716778200205224094.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190509.165536.716778200205224094.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 6c9f05441477e29783e8391d06c067e4a3b23d47
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 601e6bcc4ef02bda2831d5ac8133947b5edf597b
Message-Id: <155744731267.2452.12854565532718916139.pr-tracker-bot@kernel.org>
Date:   Fri, 10 May 2019 00:15:12 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 09 May 2019 16:55:36 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/601e6bcc4ef02bda2831d5ac8133947b5edf597b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
