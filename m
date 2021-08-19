Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4093F2206
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhHSVCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhHSVCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 17:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E48560E76;
        Thu, 19 Aug 2021 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629406918;
        bh=49QqhGLQhA2ZhmHBHD3l7+wGJmxDsRilCUW2Tw3L0sc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ULMigV3lllpmZ9s3SUD0R2Sna8ttpIyilImebMSnwMniobzsU6YMXGTgogOPE3AwY
         yoormveSneeM9NuT0npYJ74StVGNLd8C80GqPkoRz6QP4w9HJRWm+ap6MWRk2017IR
         9eoWOuFBuGsZxwRzKNY828i1q7XJNavz704ng0EuRnF61plb2IcEvKqXXwSM/vPNKK
         LWHNn+2V06r/POZN1o6RDWD5k9HugfAYtpgeVFCDEnbt9t2RQMXg5OJyMc+juK75Jq
         7v+1dXIgEuZBazxKtIqaLzcn1PZ0gUOKENkj4HhYV1n+iyUNs/3YoTLcSzmtVNS3W0
         VwHSNVpzoWQow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39D7F60997;
        Thu, 19 Aug 2021 21:01:58 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210819190205.2996753-1-kuba@kernel.org>
References: <20210819190205.2996753-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210819190205.2996753-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc7
X-PR-Tracked-Commit-Id: cd0a719fbd702eb4b455a6ad986483750125588a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f87d64319e6f980c82acfc9b95ed523d053fb7ac
Message-Id: <162940691817.11714.3665593341045192709.pr-tracker-bot@kernel.org>
Date:   Thu, 19 Aug 2021 21:01:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 19 Aug 2021 12:02:05 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f87d64319e6f980c82acfc9b95ed523d053fb7ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
