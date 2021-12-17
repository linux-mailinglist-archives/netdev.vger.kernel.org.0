Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851E147810E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhLQADQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLQADP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:03:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2544C061574;
        Thu, 16 Dec 2021 16:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 679DDB82659;
        Fri, 17 Dec 2021 00:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34647C36AE7;
        Fri, 17 Dec 2021 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639699392;
        bh=ex1niKFas7VSiyh1RKfrYhYOZJJisG4ALL8i9Zx9iFw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oeMCOn254oA1UWmS4FnH2zm3nvs6TTDnnpZ035MUtPfbiBCtO0yVw8t0CQN/mzAaf
         KPGrOU1U+SJuKiqNrrdvzGTuYDK4vM5Iz2fVx+xJdkCIvoyapsMgFAEW6I56lZ90Yn
         A9Gr055mNtDbnElkIJ4cFptPdh1q3ExzxcYXHq7bGgbN/EmTAV0BG7KQZ95j8TcLM4
         A0n2e/+YvGV/Z0gTxFk3yiGmHKUxHE4sSdHOqReoTwLg2CmDeqigZMwGVagiz02owV
         4h56UmYAZdc7MC5r0x50wS2Gk1aMTlhtFNZoFTE5culT7QzbAbXlNzJOC4Jb4MStnf
         Mv+ZZYcmiXIPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 111E76095D;
        Fri, 17 Dec 2021 00:03:12 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211216213207.839017-1-kuba@kernel.org>
References: <20211216213207.839017-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211216213207.839017-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc6
X-PR-Tracked-Commit-Id: 0c3e2474605581375d808bb3b9ce0927ed3eef70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 180f3bcfe3622bb78307dcc4fe1f8f4a717ee0ba
Message-Id: <163969939201.17683.5934554932765289984.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Dec 2021 00:03:12 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        johannes@sipsolutions.net, kvalo@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 16 Dec 2021 13:32:07 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/180f3bcfe3622bb78307dcc4fe1f8f4a717ee0ba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
