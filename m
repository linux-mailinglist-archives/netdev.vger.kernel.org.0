Return-Path: <netdev+bounces-8234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE7C723358
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA7651C20D5A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9F42770F;
	Mon,  5 Jun 2023 22:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198CF37F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 733F3C433EF;
	Mon,  5 Jun 2023 22:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686005422;
	bh=qMzJbsUxyn7F5AoJSAoGEdgw+NaC+Ioc/FGR+NVtrkY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EUZmJUxX8Su5vqVMf93IK/I1gLIEumS2K8nZeqRcOgSm6w/lBq6+cqJC6J2bV5yTR
	 vkJ6BoAsAqw5ZlGSDBtRLbSGjUGTrDFgshcZWMwHCfOvIvA3UaBG7cmiFj8ZFsuWbF
	 f3ebtmaHLEiPV6TS7nK5X2ml2OlujWW9fmRL2LFH3ZNqQS1wm1mYW3MWfkf46IUdRk
	 lTIiaFlJHwYc4g1A6GtKFZZ7PE/vKhUK+fbZPH4QP3QaW8Sgyfpz36/N8XBaHRLG9H
	 3GV0ioD9V/ZXlEZ3Nr97BnTA8QH7k3mWLDWBxnwQjTMpu9kluX0OF2aj1XrXiSxsys
	 je5bl+HNWErWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58FC0E8723C;
	Mon,  5 Jun 2023 22:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v9 0/4] drm/i915: use ref_tracker library for tracking
 wakerefs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168600542236.23821.5722558079876009232.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 22:50:22 +0000
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
In-Reply-To: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
To: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
 jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
 rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, chris@chris-wilson.co.uk,
 netdev@vger.kernel.org, dvyukov@google.com, andi.shyti@linux.intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 02 Jun 2023 12:21:32 +0200 you wrote:
> Hi Jakub,
> 
> This is reviewed series of ref_tracker patches, ready to merge
> via network tree, rebased on net-next/main.
> i915 patches will be merged later via intel-gfx tree.
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> 
> [...]

Here is the summary with links:
  - [v9,1/4] lib/ref_tracker: add unlocked leak print helper
    https://git.kernel.org/netdev/net-next/c/7a113ff63559
  - [v9,2/4] lib/ref_tracker: improve printing stats
    https://git.kernel.org/netdev/net-next/c/b6d7c0eb2dcb
  - [v9,3/4] lib/ref_tracker: add printing to memory buffer
    https://git.kernel.org/netdev/net-next/c/227c6c832303
  - [v9,4/4] lib/ref_tracker: remove warnings in case of allocation failure
    https://git.kernel.org/netdev/net-next/c/acd8f0e5d727

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



