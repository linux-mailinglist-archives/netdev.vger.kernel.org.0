Return-Path: <netdev+bounces-5422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E2F71138C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFFEF1C20F19
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E822108D;
	Thu, 25 May 2023 18:18:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B0101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF6C6C433D2;
	Thu, 25 May 2023 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685038729;
	bh=CefBghubXsTMP+QHnobgN31GVFJ+vHVRcUw1QkKa/wA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lurB00EMRF0MOKR3dbce/oeZHp4EeglOl5p3QUtKM6SvgnsjLlalNM72ivjICduZV
	 qZk93w7ZNc2W0bs/2I4ywvPnn29LU7sxq5Gt1c+O2CveOTBsdnnjVWSItdMLux8fe2
	 sI3iwp9c87VXroPuyplVR3lq6zOWWw20LiPdLIQhu8zBVC9R098z8ZDIFXF1rczSvx
	 eRfEX7QaA3WNuyniUZtL0PNL5CGHW/atTUT8MbQ0YTarsHz30OfafNboPiqtDfruMm
	 IlYr+6i3LAU0/b61Cjkk/paVD4fV48hLf/eoc5WqWWmEhL5bm04INAyJOERFPpAgwk
	 KUo20fOB9MmbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD542C395DF;
	Thu, 25 May 2023 18:18:49 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230525105631.211284-1-pabeni@redhat.com>
References: <20230525105631.211284-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230525105631.211284-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc4
X-PR-Tracked-Commit-Id: ad42a35bdfc6d3c0fc4cb4027d7b2757ce665665
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50fb587e6a56dba74c3c56a7a09c48bff25cc5fa
Message-Id: <168503872970.4421.3204448053989100401.pr-tracker-bot@kernel.org>
Date: Thu, 25 May 2023 18:18:49 +0000
To: Paolo Abeni <pabeni@redhat.com>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 25 May 2023 12:56:31 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50fb587e6a56dba74c3c56a7a09c48bff25cc5fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

