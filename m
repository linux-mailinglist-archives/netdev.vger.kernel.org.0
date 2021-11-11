Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2514C44DE4F
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 00:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhKKXMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 18:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhKKXL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 18:11:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AE6F061264;
        Thu, 11 Nov 2021 23:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636672147;
        bh=k/4d/zedAtjocXo2eebd2PP0D9dsQaA5h1E0rIGzQy0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZRDQv5+znlZXd/qcnIJzDJ9c1X3uzW6hzgjRk1uMHOgPY1CmNCte7FvmSi5yAH20n
         gyz00Iwie0fWkpHHY/jLOlLc1AtPGBCRzmov5c6tRWqzbtm+7OaiDDHerpRXeL6fwq
         GQ9xz9/emx0rAoEnlb90G8k3nlhVGiqJUktnaiIrsZXMnxAwFSMXQnpwfb7BpwKKCU
         Z9WKaQ8i0fx4ayVbwzAstoZRKlw9wHGxeMPS7eT9ewLrtRqkhIIUFxB9b1p/k/aubP
         wzHTub3cTJ0sRZj1KbVb9eBAIKRTwJVSZCmmFiulFTjcQ+PeMZfT/Peq0RYkQtfRFl
         gk97BSaW6nn6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9547E608FE;
        Thu, 11 Nov 2021 23:09:07 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211111163301.1930617-1-kuba@kernel.org>
References: <20211111163301.1930617-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211111163301.1930617-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc1
X-PR-Tracked-Commit-Id: d336509cb9d03970911878bb77f0497f64fda061
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f54ca91fe6f25c2028f953ce82f19ca2ea0f07bb
Message-Id: <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
Date:   Thu, 11 Nov 2021 23:09:07 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-can@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 11 Nov 2021 08:33:01 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f54ca91fe6f25c2028f953ce82f19ca2ea0f07bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
