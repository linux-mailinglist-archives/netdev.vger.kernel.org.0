Return-Path: <netdev+bounces-1828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B866FF3C8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 884B71C2082E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2CB19E7C;
	Thu, 11 May 2023 14:14:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7919E66
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9410BC433D2;
	Thu, 11 May 2023 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683814440;
	bh=iTLtntyrKHslW5mtXuPtDYxS2hfFDvk0H3QzEpmOT84=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rhJTDEFr4Ekg4Ffq3/SwGzPxEajfVCJuMxJLHh6GbmvkcY8r09souB1qmmOsq1PmI
	 kNLz1JbKJyCsp7yCY/VJZQXUuxVkPSPbCHFGOYvq+MGcPcMYJ2acSTqMASjqdxOVDo
	 jFHjKfsTTU/BuwyieP2u0byMKLCHPQ6No3bZx9g7O0NGNEmvVyiEg4QWRije7oSnGz
	 B8BZOTo0MYxEGwAhpcTZ58k411FUqrrtqkmT08VLV6NHVf1qu+cRpJgmu+BDrOfY09
	 5MAPBQwokDAIBwthjID9vs/1J8YxNRNGWPDYV7BSKo8MsRvSWQwggHWj5xyeoJQEbl
	 YTSx1Nvzu915A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81551E450BA;
	Thu, 11 May 2023 14:14:00 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230511104342.18276-1-pabeni@redhat.com>
References: <20230511104342.18276-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230511104342.18276-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc2
X-PR-Tracked-Commit-Id: cceac9267887753f3c9594f1f7b92237cb0f64fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e27831b91a0bc572902eb065b374991c1ef452a
Message-Id: <168381444052.1327.14606144770579574822.pr-tracker-bot@kernel.org>
Date: Thu, 11 May 2023 14:14:00 +0000
To: Paolo Abeni <pabeni@redhat.com>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 May 2023 12:43:42 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e27831b91a0bc572902eb065b374991c1ef452a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

