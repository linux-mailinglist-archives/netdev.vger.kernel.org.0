Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577BB41E369
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345555AbhI3VgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344849AbhI3VgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E3A4061A51;
        Thu, 30 Sep 2021 21:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633037676;
        bh=Dtfzg1e6cZ1ruBJZwMDGkMTpSG3SbmghqYzbRSZO9QI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=L+/6nf5f33kt02rOW/W7uf+B/CxR7bXl0evT+TM411wnm6YAAK0Xvk5NdpnVuknh3
         6lr3NK0R2LaOQsOsaDyBPi7lPccHMcJh7LtOWSp0/HVHfbHo1IHcRPZ4tHVj9Qbx2D
         efyUjNqn9nsd0FpM8qiizTwxYLsrbS9k38CngSfh2e9ymYxaluiSLaDIWcGOpaqa4i
         WRvs7f6xjzHwUtkKigoNTNAfqMLWBzv1lEnhvEVt5one3kbfjP0t2WcWh51Lkei7xC
         zsmMYrzekAQjaQKOg8UDEqcMbjrSnabg900Hhn23CrPQvwaRoVpDXh0DCbK0w+2Q1y
         ZhpHNYEj3p3+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC82260A88;
        Thu, 30 Sep 2021 21:34:36 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210930163002.4159171-1-kuba@kernel.org>
References: <20210930163002.4159171-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210930163002.4159171-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc4
X-PR-Tracked-Commit-Id: 35306eb23814444bd4021f8a1c3047d3cb0c8b2b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4de593fb965fc2bd11a0b767e0c65ff43540a6e4
Message-Id: <163303767689.5240.9437874320149352433.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Sep 2021 21:34:36 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        johannes@sipsolutions.net, pablo@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 30 Sep 2021 09:30:02 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4de593fb965fc2bd11a0b767e0c65ff43540a6e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
