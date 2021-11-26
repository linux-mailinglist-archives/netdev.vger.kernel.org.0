Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56A745F627
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhKZVM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:12:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46948 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhKZVK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 16:10:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDB4CB828FB;
        Fri, 26 Nov 2021 21:07:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C8DA60184;
        Fri, 26 Nov 2021 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637960831;
        bh=LQrmHwWDfECeJoOBW4ERPbA+s0p1dR9xtWBXrvG3taY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=j9wNEcX+a4hrvzaOEESWvsjuBI1Q+nRLozIXry9A/RRMc4xET67SADVbvqp0nA89o
         BjD9pGC0kuJLd5PAnQBPyuJtfp5eVEjv9A+31tS4qYSiFyNmvKVAA4MznbJZ7azm50
         uyYYzfAY2J+RXHyUc52x9y5i46ou6TTap2xLiSOMf7+yaDLVIjLeBKy0tfBPbRD9gf
         z3lslbfFGCc9ff/Idb16Dt+uFgHT8B7++y67iTcbSHueM0lDTLVFMEjYNide1BB71D
         D5BKUXouDKPdISSoi0rXsrv2WnHegt+8a5PAFb1wQmql2bvpYv6z9DhS6Ra61reXRn
         biG546UNsNpnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 16793609BA;
        Fri, 26 Nov 2021 21:07:11 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211126205348.1807629-1-kuba@kernel.org>
References: <20211126205348.1807629-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211126205348.1807629-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc3
X-PR-Tracked-Commit-Id: b3612ccdf2841c64ae7a8dd9e780c91240093fe6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5c17547b778975b3d83a73c8d84e8fb5ecf3ba5
Message-Id: <163796083103.23165.1266886008125183216.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Nov 2021 21:07:11 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 26 Nov 2021 12:53:48 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5c17547b778975b3d83a73c8d84e8fb5ecf3ba5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
