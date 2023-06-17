Return-Path: <netdev+bounces-11699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E649733F31
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07437281880
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B7A6FAF;
	Sat, 17 Jun 2023 07:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151E963C0
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FC96C433C9;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686987020;
	bh=fYy6nMAJNYburtM9pq9lF+Zobe4EUVhCz0hSdCWHARQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SYK/9LoIGpxdUv8bwkmHa/Bc2WlqIhkNlKN2C4d9Ka1zGZtMunCVPCnitOVKgnr6y
	 ILSoKLScPubpnGcbuGYrkyRve/zQsjrdiFXYeCv3lhh4SMbndEZb6VZHo6c0eAvpqw
	 cmsiJUMhdB/9pUgfVL+OLxt31WT/p9qY2iaKinzPr88GQ62yG/v9o+6PkErD2pgNeE
	 z5wlZ2OEv2mJ34OqD3doEMbee+OK0rFTJpJ8Vr9MfeDQh12TyIhdgtSY40CUptAzD+
	 n2zCSor7sALcdaULRR0/G5lb5MXGY723dMrYAlKSMfSyx6rxs7xlOiZDVfvmoM4p75
	 aaDvTk5Wuwu/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 670D0E21EEA;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] net: mctp: remove redundant RTN_UNICAST check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698702041.21379.18026446028173220224.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:30:20 +0000
References: <20230615152240.1749428-1-linma@zju.edu.cn>
In-Reply-To: <20230615152240.1749428-1-linma@zju.edu.cn>
To: Lin Ma <linma@zju.edu.cn>
Cc: jk@codeconstruct.com.au, matt@codeconstruct.com.au, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 23:22:40 +0800 you wrote:
> Current mctp_newroute() contains two exactly same check against
> rtm->rtm_type
> 
> static int mctp_newroute(...)
> {
> ...
>     if (rtm->rtm_type != RTN_UNICAST) { // (1)
>         NL_SET_ERR_MSG(extack, "rtm_type must be RTN_UNICAST");
>         return -EINVAL;
>     }
> ...
>     if (rtm->rtm_type != RTN_UNICAST) // (2)
>         return -EINVAL;
> ...
> }
> 
> [...]

Here is the summary with links:
  - [v1] net: mctp: remove redundant RTN_UNICAST check
    https://git.kernel.org/netdev/net-next/c/f60ce8a48b97

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



