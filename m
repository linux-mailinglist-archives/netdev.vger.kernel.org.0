Return-Path: <netdev+bounces-536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 706C16F7F9B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 141D3280EB6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E6E6FC9;
	Fri,  5 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FAF538B
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22B04C4339B;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683277821;
	bh=PNffMdZwgheaGnL0jJF7PwCUxWLJ8WRE+P1ANBVttPI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C9D9HUU+9hqJD8QGZ2+UXMgyVYXCIKUDbbVEosPINeBSO/61+GEpfjmxcrOPJG0zD
	 aePSBo+f1eMQmYDnA3+6T9qA1HueAFFlEoTuS6M6BMB9T4bWFqhzUudDtfA2CMS3Dd
	 RcE3aSffj5wh/ZpfHSfxt1fFj9AnovQToPHpfc6IA2lRC3rYP4GnKsfpHXq+AK9NFF
	 1QPMDTLahHZP+uW02JNibM2k1qOMvmSuA5Xw8e926/wkGOgHcgOtTM5myQmIMdfpkg
	 uPsGq4z8pH+ZGZL3de1ZOlAPOn9IJ/0OwUhjOMm0aJecczE0ES52yf9x8Ksj7SQIEK
	 xrh9TDRqzTOXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06C95E5FFC9;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] Fixes for miss to tc action series
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327782102.8511.15878995199791548617.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 09:10:21 +0000
References: <20230504181616.2834983-1-vladbu@nvidia.com>
In-Reply-To: <20230504181616.2834983-1-vladbu@nvidia.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
 netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, marcelo.leitner@gmail.com, paulb@nvidia.com,
 simon.horman@corigine.com, ivecera@redhat.com, pctammela@mojatatu.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 4 May 2023 20:16:13 +0200 you wrote:
> Changes V1 -> V2:
> 
> - Added new patch reverting Ivan's fix for the same issue.
> 
> Vlad Buslov (3):
>   net/sched: flower: fix filter idr initialization
>   Revert "net/sched: flower: Fix wrong handle assignment during filter
>     change"
>   net/sched: flower: fix error handler on replace
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net/sched: flower: fix filter idr initialization
    https://git.kernel.org/netdev/net/c/dd4f6bbfa646
  - [net,v2,2/3] Revert "net/sched: flower: Fix wrong handle assignment during filter change"
    https://git.kernel.org/netdev/net/c/5110f3ff6d3c
  - [net,v2,3/3] net/sched: flower: fix error handler on replace
    https://git.kernel.org/netdev/net/c/fd741f0d9f70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



