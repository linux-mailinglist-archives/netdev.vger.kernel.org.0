Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB13AD69B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 04:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhFSCSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 22:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhFSCSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 22:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62BD96100A;
        Sat, 19 Jun 2021 02:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624068996;
        bh=bymX7W94Euwf7xkOT8/KHgZ9A065dthXZlIu3nnQTn0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XQmw4r1XQKwLAhOldDaScvvhvCTy6o/H4uaYGVMqRfZGoGmfWTdnjn/78fh5G1OOj
         jVBNmTO4bAl89wlCwN2TnP0rujoZ3P4LieUgS0iammf0l2VHb54rXbNlXg5qi/+8ra
         ZA/nKRZLFNbSYh6QNz8hEolRh1xLHdGcIpktHx68hyqW1kDEKerY2Cdyxp4fIbflve
         CqnxKP9pyD1z6p7Uah5P59qwtiGJNfkpAXIsHnZ0OklkUk4kmym6jfm6eYaQx+aAD7
         ZK+Ac59I1+ECWsTWO1h8ePjj7r75TNs2BuCUwN542rdsunnO60Uk4Re75cO/9IS9EB
         Q61jZCbEJbMOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D40D608B8;
        Sat, 19 Jun 2021 02:16:36 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.13-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210619012448.3089951-1-kuba@kernel.org>
References: <20210619012448.3089951-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210619012448.3089951-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc7
X-PR-Tracked-Commit-Id: 9cca0c2d70149160407bda9a9446ce0c29b6e6c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9ed13a17e38e0537e24d9b507645002bf8d0201f
Message-Id: <162406899624.20033.17740694842455634451.pr-tracker-bot@kernel.org>
Date:   Sat, 19 Jun 2021 02:16:36 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 18 Jun 2021 18:24:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9ed13a17e38e0537e24d9b507645002bf8d0201f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
