Return-Path: <netdev+bounces-9167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 110F9727B11
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAD3928163D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D312D947D;
	Thu,  8 Jun 2023 09:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8386E3B3FA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE57AC433D2;
	Thu,  8 Jun 2023 09:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686216022;
	bh=mxS9eY88YibbOyZO6D+rodDnTfJ3kGaXPMGUq7EwDUQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bQ3szSHlIrJwp1ffDAysTa3qclWavLoxxS2HX43yTlbmBw6UM1+BHO7Wi8/nMhZab
	 eyLQ2iMC7hLWJl/mQdYw9Ko26CnZiihI6RwqEW4RY1EvaCuBPwjmp1UMSf3+y7reY3
	 Fa8SGriC98Lk4WORcpcApG06LnNxBT3gHOrgCEZCu5c5l7fR9KM31YKsXkDgHAtKJS
	 HW9gqaiheH3EBo5CMQZSHtbpNbayoApxO217/OV99Ow6DbvVuyTK9/cElKiM5Ylwbd
	 pHK+//e66KU9WKPTBzcsJKeY/RajR9qIGkP5JC0oFhQKHJdTspiOU8fCfMtmcLjwYx
	 yYnVhbUzx+JZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D470BE29F3C;
	Thu,  8 Jun 2023 09:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] bnxt_en: Bug fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168621602186.5097.13769030814075608020.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 09:20:21 +0000
References: <20230607075409.228450-1-michael.chan@broadcom.com>
In-Reply-To: <20230607075409.228450-1-michael.chan@broadcom.com>
To: Michael Chan <michael.chan@broadcom.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  7 Jun 2023 00:54:03 -0700 you wrote:
> This patchset has the following fixes for bnxt_en:
> 
> 1. Add missing VNIC ID parameter in the FW message when getting an
> updated RSS configuration from the FW.
> 
> 2. Fix a warning when doing ethtool reset on newer chips.
> 
> [...]

Here is the summary with links:
  - [net,1/6] bnxt_en: Fix bnxt_hwrm_update_rss_hash_cfg()
    https://git.kernel.org/netdev/net/c/095d5dc0c1d9
  - [net,2/6] bnxt_en: Don't issue AP reset during ethtool's reset operation
    https://git.kernel.org/netdev/net/c/1d997801c7cc
  - [net,3/6] bnxt_en: Query default VLAN before VNIC setup on a VF
    https://git.kernel.org/netdev/net/c/1a9e4f501bc6
  - [net,4/6] bnxt_en: Skip firmware fatal error recovery if chip is not accessible
    https://git.kernel.org/netdev/net/c/83474a9b252a
  - [net,5/6] bnxt_en: Prevent kernel panic when receiving unexpected PHC_UPDATE event
    https://git.kernel.org/netdev/net/c/319a7827df97
  - [net,6/6] bnxt_en: Implement .set_port / .unset_port UDP tunnel callbacks
    https://git.kernel.org/netdev/net/c/1eb4ef125913

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



