Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B60043E74A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhJ1R16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhJ1R14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 13:27:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DFD2610FF;
        Thu, 28 Oct 2021 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635441929;
        bh=g/bzId7RkrOvfk+SrjHBprnep7MTl4j0MevO9JIXV6E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Hc7NIXIszy888yfFJM7APFGcE1Xgh+FZAX/HR2Lf5t9YpdPgoowpZvBfsp43Rdnxb
         hD+QNIjgut0w0GHoEwZdb/3JsCb4kFLZzjDPQ6dBOyJ7c3+uj+Hmvolt+tYSldYAa3
         NVm7ubexdVEfWvZDC3a5l2FrWJVE8Kvf3ptfSMDGi9qI//x1+8AVSTimEjH0k/YPkA
         eD40vYpaxPe0qaqgbKaQtA9Jnit/5SS0WGhblUxsXCB4Ifj3H2uPAf19sb/NQaBn/t
         D+X84vOC45j23McV+ETZnUmQDnGVipw4n/ju230ENxgmCrwSMSzDLAtfMYSt9COzUB
         j7esaCpkvrKpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0705360972;
        Thu, 28 Oct 2021 17:25:29 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211028162912.1660341-1-kuba@kernel.org>
References: <20211028162912.1660341-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211028162912.1660341-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc8
X-PR-Tracked-Commit-Id: 35392da51b1ab7ba0c63de0a553e2a93c2314266
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 411a44c24a561e449b592ff631b7ae321f1eb559
Message-Id: <163544192902.14282.15783866044630928474.pr-tracker-bot@kernel.org>
Date:   Thu, 28 Oct 2021 17:25:29 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net, toke@toke.dk,
        johannes@sipsolutions.net, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 28 Oct 2021 09:29:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/411a44c24a561e449b592ff631b7ae321f1eb559

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
