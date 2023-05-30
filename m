Return-Path: <netdev+bounces-6533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB43716D8E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBA3B2812C1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB7E24E93;
	Tue, 30 May 2023 19:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860FE21CD0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 456E2C4339E;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685475020;
	bh=p0Z/3Ub+U6Quo6U4fCre32cm3kZECe98snThW07UUqY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tnGH/Ww3BOaRJh9PONMwYp6mB0PkRPscMJh1Qw3CvohplhT0m2xSOFpX4yPL4ejJx
	 eNbf6r1ioVJQp2Xtb9MKaG8fahaKeylOKaUZvbb9yQwmyJnq1p5L4Ms0UonFjJkLcS
	 Og3iZsIpk/URhou1hGn9bVR2Tit97k7nBC7kXJdcDDlSX2cL5PNeXH/FRaq6XqlfGH
	 H4PG4KA7nupJGRTDnaiNINnyWZ3Yo4JN5BlrqcNuq9iNjqxiHtFUNgWLFeDCKIXDOK
	 DhVrFJJT/OYtxv5ezWvg4gEoV0D8AYi3ZTosu28ZFTvk6HeY/O38f7oLR9TIsSReCp
	 kgsxVqN4UYtlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E1EEE21EC5;
	Tue, 30 May 2023 19:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] iproute_lwtunnel: fix array boundary check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168547502018.11706.2695326990015475559.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 19:30:20 +0000
References: <f20348ddef412b090829a025f92718158450eb6f.1685396319.git.aclaudi@redhat.com>
In-Reply-To: <f20348ddef412b090829a025f92718158450eb6f.1685396319.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 29 May 2023 23:42:16 +0200 you wrote:
> seg6_mode_types is made up of 5 elements, so ARRAY_SIZE(seg6_mode_types)
> evaluates to 5. Thus, when mode = 5, this function returns
> seg6_mode_types[5], resulting in an out-of-bound access.
> 
> Fix this bailing out when mode is equal to or greater than 5.
> 
> Fixes: cf87da417bb4 ("iproute: add support for seg6 l2encap mode")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> 
> [...]

Here is the summary with links:
  - [iproute2] iproute_lwtunnel: fix array boundary check
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=1cf50a1f2723

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



