Return-Path: <netdev+bounces-11280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6572C732622
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A2E281609
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24903817;
	Fri, 16 Jun 2023 04:16:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A401812
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 04:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D6BEC433CB;
	Fri, 16 Jun 2023 04:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686889005;
	bh=3YKd3SS9ibMMgdSfLYTMSYXk+EuiUD2alt/LfUjDHGM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UBR/AQJMHzN5nGqEaXj9/GQWlQInqsY/Ggjo0rJHqMbWXBj4PUIqY++EIW2ZoeGpn
	 eVlWweB1rHdwQDC/8N1x3izTsr2hclf85vymk8Nkd7SjexGtzznAkMXURtKDPdIax6
	 2Jbx2X7QHqdk59u5P9AcPEEi6/mBCxzLISNLvljOx7KKH3Pby++LBlv7DURmlt8i9x
	 f0ANQoxbz+9+wPDHqdWf/qIhHigjiY7dyW72FuSBkqjF6TiCT7qhhWr3kpCYs0Kxyq
	 izVTjfq5EaRLxWmafLnY5Sk9duHO0Cdz1t9jLjNk8yHMh+mgmG0NhcLvUZZfn8Fjsp
	 lDgYWefLNT1NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 341A5C3274B;
	Fri, 16 Jun 2023 04:16:45 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for v6.4-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230615225716.1507720-1-kuba@kernel.org>
References: <20230615225716.1507720-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230615225716.1507720-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc7
X-PR-Tracked-Commit-Id: 8f0e3703571fe771d06235870ccbbf4ad41e63e8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40f71e7cd3c6ac04293556ab0504a372393838ff
Message-Id: <168688900521.32380.13001680271505981059.pr-tracker-bot@kernel.org>
Date: Fri, 16 Jun 2023 04:16:45 +0000
To: Jakub Kicinski <kuba@kernel.org>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 15 Jun 2023 15:57:16 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40f71e7cd3c6ac04293556ab0504a372393838ff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

