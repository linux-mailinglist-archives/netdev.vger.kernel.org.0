Return-Path: <netdev+bounces-3181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4885F705E81
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05BA5281019
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A547440F;
	Wed, 17 May 2023 04:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8B3FDD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F619C433A8;
	Wed, 17 May 2023 04:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684296024;
	bh=KsKnrJ142v+r6a582CDkkgPBsFRfdsSokSvGe/Okpog=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lWu+nniWPdSPWwmSs7ei7uBXARQ33Nh6YcQU7XWc+Ep6+DC3obREZKBi3cdTOIL9k
	 /IusQ/CSXs+Hb18ZqIFze8O5Xt4YX17Rttmi9L0O+hb2C+nRnY7lT+a904JVOHzdOD
	 rtWA1L0rF/FhBlLD/0gYDW97Lh2ZTDN72MygPy9aKQC6vHsw8vvbLc7QMal7FYuQqX
	 xi+4WYXCybnV6MsReHqeXpdKWy1feMYZ90+JyLN5LZP/TUaBo6dTzzObqPMS/TOmna
	 te41HrVfYiwLsHuOSzxxy4m1izex+iNpdJOKMD3esiWihS0IZXxM2m5s+47eUeins6
	 gnatycz89xpGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C6C1E5421C;
	Wed, 17 May 2023 04:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/7] xfrm: don't check the default policy if the policy allows
 the packet
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168429602430.23839.11062789710575476505.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 04:00:24 +0000
References: <20230516052405.2677554-2-steffen.klassert@secunet.com>
In-Reply-To: <20230516052405.2677554-2-steffen.klassert@secunet.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
 netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Tue, 16 May 2023 07:23:59 +0200 you wrote:
> From: Sabrina Dubroca <sd@queasysnail.net>
> 
> The current code doesn't let a simple "allow" policy counteract a
> default policy blocking all incoming packets:
> 
>     ip x p setdefault in block
>     ip x p a src 192.168.2.1/32 dst 192.168.2.2/32 dir in action allow
> 
> [...]

Here is the summary with links:
  - [1/7] xfrm: don't check the default policy if the policy allows the packet
    https://git.kernel.org/netdev/net/c/430cac487400
  - [2/7] xfrm: release all offloaded policy memory
    https://git.kernel.org/netdev/net/c/94b95dfaa814
  - [3/7] xfrm: Fix leak of dev tracker
    https://git.kernel.org/netdev/net/c/ec8f32ad9a65
  - [4/7] Revert "Fix XFRM-I support for nested ESP tunnels"
    https://git.kernel.org/netdev/net/c/5fc46f94219d
  - [5/7] xfrm: Reject optional tunnel/BEET mode templates in outbound policies
    https://git.kernel.org/netdev/net/c/3d776e31c841
  - [6/7] af_key: Reject optional tunnel/BEET mode templates in outbound policies
    https://git.kernel.org/netdev/net/c/cf3128a7aca5
  - [7/7] xfrm: Check if_id in inbound policy/secpath match
    https://git.kernel.org/netdev/net/c/8680407b6f8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



