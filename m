Return-Path: <netdev+bounces-7368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D868871FE72
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 158A21C20C5F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BE7182A0;
	Fri,  2 Jun 2023 10:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F55687
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78986C4339B;
	Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685700019;
	bh=FKQFA9YyHsqaGBGUWB0EFoK6lSWvks20FcE63BHWbWE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rT/wtFKHIhvvbEFXZfHoyLloY+H8mg+rD7Yg1jnkzgKUMBRP5IDciCWAfw/84HdUn
	 UJq2dZYkzJXyEvd8PlrlJqdY5Z9vbwE7iV9BvZTwLR5kb59gNxELugaYJPhEgeYslT
	 MWDddRgE/EDZsnuTEHu9dV79/55TO8IkiO/BzLUfSZVYXBllU2tyem4bC1aFgyjPhK
	 rC2JwZHLHaIUV8ojJ8QTsK2lQXe51zIj6Srn3fPq1Kgy6D8H5rIpgocFFjrhRTx5D6
	 XW8ZIujqgw9frwLYJmSmCdVKJdpzUUrUNqxWoWRl4UM49ICk8OMCJMgvXDnsz9A+go
	 Obt7OBo0Ot8tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C95EC395E5;
	Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: qca8k: add CONFIG_LEDS_TRIGGERS dependency
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168570001937.17073.11024207858113974677.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 10:00:19 +0000
References: <20230601213111.3182893-1-arnd@kernel.org>
In-Reply-To: <20230601213111.3182893-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 ansuelsmth@gmail.com, arnd@arndb.de, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  1 Jun 2023 23:31:04 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without LED triggers, the driver now fails to build:
> 
> drivers/net/dsa/qca/qca8k-leds.c: In function 'qca8k_parse_port_leds':
> drivers/net/dsa/qca/qca8k-leds.c:403:31: error: 'struct led_classdev' has no member named 'hw_control_is_supported'
>   403 |                 port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
>       |                               ^
> 
> [...]

Here is the summary with links:
  - net: dsa: qca8k: add CONFIG_LEDS_TRIGGERS dependency
    https://git.kernel.org/netdev/net/c/37a826d86ff7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



