Return-Path: <netdev+bounces-6989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4B571926F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:40:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 967771C20E4B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197826FCC;
	Thu,  1 Jun 2023 05:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349A6D1B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FB22C4339C;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685598021;
	bh=9VRWBEJhrWb/3G3bXkrO2WxkPaRrh2Yu36UNolKKbL0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jeD//TAH1mFDt57ZEQr0QyetZEtXKOWAzBU6vDEgcNVL9fOZxR4OPkMS4D2TwQEH5
	 kkAdzhLkYYJWmwTzo3dDoJ8CoGRUcI+peq3giKQ3jO5xmvCw8RcH/twwa+bI9p6nMX
	 +/0eURJYF+jIKnkqdj99ESzvtfeAkiNC3cGtBDjggiZaAHKn+rN1rfoEH+9LusgxH9
	 P+dTnTtXCJGe2YNMx82hhnU1cUu+ldMvEgpDSdT9u8Lg35QzhLTLGMfTbwviyybftV
	 3dRwbkNNamEjbvIs/OtPhz0I29RcGY4Pxx+Y34SYtE6yjsaGDjSmkJmtnM5s6gERjR
	 JVPv8O0xrTllA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20F85C395E5;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/2] Add support for VSC85xx DT RGMII delays
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168559802112.10778.15941032546106214780.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 05:40:21 +0000
References: <20230529122017.10620-1-harini.katakam@amd.com>
In-Reply-To: <20230529122017.10620-1-harini.katakam@amd.com>
To: Harini Katakam <harini.katakam@amd.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 vladimir.oltean@nxp.com, wsa+renesas@sang-engineering.com,
 simon.horman@corigine.com, david.epping@missinglinkelectronics.com,
 mk+kernel@armlinux.org.uk, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
 michal.simek@amd.com, radhey.shyam.pandey@amd.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 May 2023 17:50:15 +0530 you wrote:
> Provide an option to change RGMII delay value via devicetree.
> 
> v5:
> - Rebase after VSC8501 series is merged, to avoid conflicts
> - Rename _internal_delay to use vsc86xx, move declaration and
> simplify format of pointer to above
> - Acquire DT delay values in vsc85xx_update_rgmii_cntl instead of
> vsc85xx_config_init to accommodate all VSC phy versions
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/2] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
    https://git.kernel.org/netdev/net-next/c/31605c01fb24
  - [net-next,v5,2/2] phy: mscc: Add support for RGMII delay configuration
    https://git.kernel.org/netdev/net-next/c/dbb050d2bfc8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



