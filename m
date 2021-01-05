Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF4F2EB47E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbhAEUti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbhAEUth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 65B7422D5A;
        Tue,  5 Jan 2021 20:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609879737;
        bh=+dcJ7Jw0dibkaMEl/5dgBy5eNryFCj8j+fuUlZdkPNU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AgKZz0R8/D0klMYQRocpNMqVrZhE1dB714LuxQ9PvKRubpukSCuwF7bNQr4PJRYwN
         uF7rfUMY6fedLQ2+yzW61lrDBLGLEChyQgQKZd5CEFLKnDemfrDFn+0e7upqcOp2FP
         gSr4zluxDjQ6IxuZ68f72cKY2r7htZRZV942lI1BeRqVKca3Ep0RdUq3enMyG3l9ms
         mLMkk/kdmQ6sthzXWPM3eZ/7J3RGwF7fg3LYxkw7V5W63UrsnpSFT+2P7ISr7MJwLP
         EqJ/Jw8TeXUADh9+2nxjJI0ZCGSNVGXNrA6lbUor3CQs9M2n13whzE0JZ85fnpj5tR
         CI3w8+Mh4vzDw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5FB9A604FC;
        Tue,  5 Jan 2021 20:48:57 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210105003232.3172133-1-kuba@kernel.org>
References: <20210105003232.3172133-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210105003232.3172133-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3
X-PR-Tracked-Commit-Id: a8f33c038f4e50b0f47448cb6c6ca184c4f717ef
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa35e45cd42aa249562c65e440c8d69fb84945d9
Message-Id: <160987973738.24340.2842369940007039675.pr-tracker-bot@kernel.org>
Date:   Tue, 05 Jan 2021 20:48:57 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon,  4 Jan 2021 16:32:32 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa35e45cd42aa249562c65e440c8d69fb84945d9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
