Return-Path: <netdev+bounces-3701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 866757085AA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D8C61C21105
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634D923D5B;
	Thu, 18 May 2023 16:10:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3449B53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3AA0C433EF;
	Thu, 18 May 2023 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684426245;
	bh=ZYC8hwzk/3eL1RxC4ETQ/LcIZ809nraJIfkOs+pHbnA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HJVpP1/L5ktx3kOsZOLPna1rKQyU0yi0LeWNECcv1Ddw2s6E6agY+2ZIKt04iwWrc
	 s1/QQ2amWMmCWpBTdUHZbHQ8medgQ6afe8DuHdAdwATpOxYWqZEz0qO3Sj+MRJi3Mn
	 TbGiYWspL3rwav0mzq3D81zoj+ctKvJVJz28E4+LEEpmo3mMdDoETl1JNzAhZJePtt
	 6zziCCLkQpjqT3JzYEdhqAp4aY42vI7eZ1jl0Oup+ISD8DgKo7FBZ6fqJBNcOw6D0K
	 xJQgqlbH4FVEONfqfHdOCg8pESL38uE1vr6SyGDoQbH3lnOOhFb20mnXHxXyoNAwuv
	 VfoAOj3tEQRSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3D83C73FE2;
	Thu, 18 May 2023 16:10:45 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230518132554.41223-1-pabeni@redhat.com>
References: <20230518132554.41223-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230518132554.41223-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc3
X-PR-Tracked-Commit-Id: 6e42fae0a15519393d3cc5500dc8d84b8549a337
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f594fe7c90746982569bd4f3489e809104a9176
Message-Id: <168442624579.10219.5887984652112925914.pr-tracker-bot@kernel.org>
Date: Thu, 18 May 2023 16:10:45 +0000
To: Paolo Abeni <pabeni@redhat.com>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 May 2023 15:25:54 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f594fe7c90746982569bd4f3489e809104a9176

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

