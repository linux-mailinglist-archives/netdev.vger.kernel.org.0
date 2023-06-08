Return-Path: <netdev+bounces-9307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1139472864F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A45652816EF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E881519E4D;
	Thu,  8 Jun 2023 17:27:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71A910973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 261B6C433EF;
	Thu,  8 Jun 2023 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686245230;
	bh=92eU1L7Io4Fz9eLviD0H7EH/0UpGO8xeyF6EqIObqUk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZPGL3JfpA3XUf+jdc7l9wQLWw8mmBlIk5yVFr5oX7EDk2r2BUk1MwAWnOcnAu5qug
	 hgX8LdPfQEyDob0/nICzvuyQxA+0kmbubFfNeOtTSTIG0oqfTr1fjldyvzeDIBfuGa
	 53Wp9TdKYcAe2wZeqvyqgocXoFGX99/dvVu8SYM9u6aBLExZyjyqtoq31vaCpAWFKS
	 vTmUJqGbrpRgQ7oTSx6/lUp9Q8Aqc3H7CU2+Hk4Z2sbmvGhiEge3wiqna82EoumbPK
	 +nRBeHC4ioMsPJKASCM1Fa5wFCH6XRxRQhTZtWoTfwk4W/Msi/Qe3LglYaTPkVqC8u
	 LCp5Iw0r1Y3Nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13FB6E29F3C;
	Thu,  8 Jun 2023 17:27:10 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.4-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230608111934.18511-1-pabeni@redhat.com>
References: <20230608111934.18511-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230608111934.18511-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc6
X-PR-Tracked-Commit-Id: 6c0ec7ab5aaff3706657dd4946798aed483b9471
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 25041a4c02c7cf774d8b6ed60586fd64f1cdaa81
Message-Id: <168624523007.6402.17972607771576038972.pr-tracker-bot@kernel.org>
Date: Thu, 08 Jun 2023 17:27:10 +0000
To: Paolo Abeni <pabeni@redhat.com>
Cc: torvalds@linux-foundation.org, kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  8 Jun 2023 13:19:34 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.4-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/25041a4c02c7cf774d8b6ed60586fd64f1cdaa81

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

