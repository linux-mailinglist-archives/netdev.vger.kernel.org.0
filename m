Return-Path: <netdev+bounces-7246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5308071F4EB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B00C2817F3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EABE24138;
	Thu,  1 Jun 2023 21:40:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B624130
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55A12C433D2;
	Thu,  1 Jun 2023 21:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685655640;
	bh=EmFaRNESXp24m392Z9FFvkoAt9Tu3v3zI6uBJPBkC6Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jfsjUMgrZrYffmfnH+gs5nB+jSsZWoDLwz/CmvgSpmxU/rzfT3sAamAXMrQpK3s4x
	 qqG18TydL8PPvMSJ2U5xrHRSpso1p6d3cVAKenrhVJDYmPs5tjNQ8P7TKfVVuQS6vn
	 s2Xvglhj4nQMQFu7JP3PZf8RskhbszOLPct8idQH/cW0MISxiVFwgmARrXDrkMS1UJ
	 mLph9FQd+MU69IGlqe4eHoA4GneK+o7GYU56l9mc1ZmM0C1R7xw6Q+SrO7WL8fzQGM
	 p5A70HLEw5cejh5HRElIJA/6npN+SZpTdaH0FTWXfuTkdUdI/+19Ze7jA+erUk49S6
	 3uphIRA9VbCAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D8E6E52C02;
	Thu,  1 Jun 2023 21:40:40 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for v6.4-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230601180906.238637-1-kuba@kernel.org>
References: <20230601180906.238637-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230601180906.238637-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc5
X-PR-Tracked-Commit-Id: a451b8eb96e521ebabc9c53fefa2bcfad6f80f25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 714069daa5d345483578e2ff77fb6f06f4dcba6a
Message-Id: <168565564024.17545.9325041927544084632.pr-tracker-bot@kernel.org>
Date: Thu, 01 Jun 2023 21:40:40 +0000
To: Jakub Kicinski <kuba@kernel.org>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  1 Jun 2023 11:09:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.4-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/714069daa5d345483578e2ff77fb6f06f4dcba6a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

