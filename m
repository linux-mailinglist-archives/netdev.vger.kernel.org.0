Return-Path: <netdev+bounces-11323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F7717329A6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D387828140F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDBEBA27;
	Fri, 16 Jun 2023 08:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730D63BD;
	Fri, 16 Jun 2023 08:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1420C433C8;
	Fri, 16 Jun 2023 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686903619;
	bh=2Ei3eeYE49SRktfK8kKm5lEBRhqvlRSbRcqm37dzo1I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cRBkElskTs7BxOJ5olZmYoVkpaWvZAfKKAZp6T+tw4iNzEX11MUDdUNMcbBPEVvq1
	 FOt82brsc3l+bn9OAc093NK6lkqrvuEQDe9y93zxELv3H6pyP0kLq/CUnAf7kbyKOs
	 meW05KOIbU9eTPWqSYcxvFlZeyyaMdd53QKOtwhQ13LkaAKkT/pQpTJIm19YLsxxYI
	 O6ey+BxT2hIcpzB8LHaponm7RdFshgqRul8SH9q62hkdwgXyolele/RVZ09DwAN/Vd
	 o3BBc9+JV9aATzOX0h8Dc6nNQQxdSyaaER+MH6FabLt21rXAw3J4lcpFXrA0nxASPG
	 q/mCqjY0gi0pA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFE67E21EE5;
	Fri, 16 Jun 2023 08:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] sfc: do not try to call tc functions when
 CONFIG_SFC_SRIOV=n
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168690361978.13714.16133018806153868167.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 08:20:19 +0000
References: <20230615215243.34942-1-edward.cree@amd.com>
In-Reply-To: <20230615215243.34942-1-edward.cree@amd.com>
To:  <edward.cree@amd.com>
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
 netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
 oe-kbuild-all@lists.linux.dev, simon.horman@corigine.com,
 pieter.jansen-van-vuuren@amd.com, naresh.kamboju@linaro.org, lkp@intel.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 15 Jun 2023 22:52:43 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Functions efx_tc_netdev_event and efx_tc_netevent_event do not exist
>  in that case as object files tc_bindings.o and tc_encap_actions.o
>  are not built, so the calls to them from ef100_netdev_event and
>  ef100_netevent_event cause link errors.
> Wrap the corresponding header files (tc_bindings.h, tc_encap_actions.h)
>  with #if IS_ENABLED(CONFIG_SFC_SRIOV), and add an #else with static
>  inline stubs for these two functions.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] sfc: do not try to call tc functions when CONFIG_SFC_SRIOV=n
    https://git.kernel.org/netdev/net-next/c/c08afcdcf952

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



