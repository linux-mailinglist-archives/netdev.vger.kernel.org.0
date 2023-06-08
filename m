Return-Path: <netdev+bounces-9131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9AB727672
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5182281537
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CF54C95;
	Thu,  8 Jun 2023 05:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C4546AF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15007C4339C;
	Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686200423;
	bh=7OYbiAHfgxsM/xc4In9XJ0B8lhvu1gQgEezkYH+hh3c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qc8lBFYfF/MBCV7a3K+IYAONYWPYTGi3BOyeFn1BU4KSZPPouYsRF/bRmf9CykRrG
	 nOZnPOrViwdScp/G6hd1TUANid++6VOU2bIF3ydHvoFkF3Pfv4EJbmxYEBGuuhVp5S
	 ctFMopiEJ5WOQogwzl3+wRkj7/TWkUwbjMnhV/JquVzXW2dCEk4SgHuLhO73Q8PVWR
	 Ab1oacOaroNTEd4ZCBiWZulKXszldBs5jACev8/beE59+/v7gnuCRq1WZvsvyxI0nc
	 XI376cZCZqtjADRl9oYyUabwEJZD9aT5v27P2mu+TpHKIBJnNYaMP/M10uhVStoX9+
	 rv1lR3+WNvjow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAA34E4D030;
	Thu,  8 Jun 2023 05:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Fix EEE implementation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168620042295.23382.9481928925357674437.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 05:00:22 +0000
References: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
In-Reply-To: <20230606214348.2408018-1-florian.fainelli@broadcom.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, o.rempel@pengutronix.de, andrew@lunn.ch,
 rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com, opendmb@gmail.com,
 f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Jun 2023 14:43:47 -0700 you wrote:
> We had a number of short comings:
> 
> - EEE must be re-evaluated whenever the state machine detects a link
>   change as wight be switching from a link partner with EEE
>   enabled/disabled
> 
> - tx_lpi_enabled controls whether EEE should be enabled/disabled for the
>   transmit path, which applies to the TBUF block
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Fix EEE implementation
    https://git.kernel.org/netdev/net/c/a9f31047baca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



