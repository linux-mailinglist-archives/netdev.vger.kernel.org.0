Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD1A35A8BD
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhDIWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234602AbhDIWeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 18:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 293FC610F9;
        Fri,  9 Apr 2021 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618007664;
        bh=dOqU26ROINAW9hEmDvYv+xj4l+JdDUMyfOj5phF6Nbk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cR3ONLgpkE+ESL3qnSmdUukR/4Aw6f6xqi7CvTxXRpnTCiuVGmnopjkEtZ13Idpw0
         sHCKzihp+dy+izciyB6OgT7cXX72cyaJ8GiFfj33Z/Z210OVRRXVDILypzkRzS7zwZ
         i9TcQtVPMI4IB+GzOeayERyk5oY0eBeS1FfPk+hnd4eD8SgJO/8aSbc03gVVolt8bK
         2L7Ju+Zx7Um7kJrbpzZquK0L0viynM0qPlVMU0Y8+0so4GtXa1EWDYDozS1O/nOwfB
         UN8wy0sl+l7SW+w2Zzs7Xh6BAAfoHyAu8R1tD5q9bMPMSDuUIvvXpYbhSfT7YjU4S8
         XvrUBSYZbA8LA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23EFC60A2A;
        Fri,  9 Apr 2021 22:34:24 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.12-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210409214803.1618792-1-kuba@kernel.org>
References: <20210409214803.1618792-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210409214803.1618792-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc7
X-PR-Tracked-Commit-Id: 27f0ad71699de41bae013c367b95a6b319cc46a9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e04e7513b0fa2fe8966a1c83fb473f1667e2810
Message-Id: <161800766414.9164.1744269360898985739.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Apr 2021 22:34:24 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri,  9 Apr 2021 14:48:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e04e7513b0fa2fe8966a1c83fb473f1667e2810

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
