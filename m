Return-Path: <netdev+bounces-1377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B469C6FDA44
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A5E281369
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C527364;
	Wed, 10 May 2023 09:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D0863E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CED79C4339B;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709222;
	bh=DtHUdsIi9oQqN+9omncA8SoYL5Targ72KId5L2H5vrg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jubCn1c9O3PxIEwtchpL6tLdzwugvAGL2yOQyDUqe5kQ9ApCMPx/y12BV8XdvmNa0
	 4jsrtRZ+fG/A3kjyTBlvWrB1dOhqMg4qricZ0f7w9QK/GSN9XZgO21loO78mNb3a6o
	 5RNPH7Uhy32QXahscEmrhlG0vZPNAYCjbk/bFnwDjv5jsUjJZmKd1TYCN1x+u7SYz5
	 TJ13wjDh5PEYRfst80UYCZpBLPEh6WfQZ60TAhdXLwPnJURjtmOCrnOVgg8gzIlQFC
	 b63dnBpNJ1U4AATA44VMSk9ThPi5MpGbj21pejHjD855qenXg0Tl7fKpP9jFRCupWh
	 7ZchMSjM6Zxrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADC29E270C4;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: lan966x: Add support for ES0 VCAP
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370922269.25656.9465910340269237668.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:00:22 +0000
References: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230509072645.3245949-1-horatiu.vultur@microchip.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
 daniel.machon@microchip.com, UNGLinuxDriver@microchip.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 9 May 2023 09:26:42 +0200 you wrote:
> Provide the Egress Stage 0 (ES0) VCAP (Versatile Content-Aware
> Processor) support for the lan966x platform.
> 
> The ES0 VCAP has only 1 lookup which is accessible with a TC chain
> id 10000000.
> 
> Currently only one action is support which is vlan pop. Also it is
> possible to link the IS1 to ES0 using 'goto chain 10000000'.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: lan966x: Add ES0 VCAP model
    https://git.kernel.org/netdev/net-next/c/011be8726434
  - [net-next,2/3] net: lan966x: Add ES0 VCAP keyset configuration for lan966x
    https://git.kernel.org/netdev/net-next/c/96b6c8a662a3
  - [net-next,3/3] net: lan966x: Add TC support for ES0 VCAP
    https://git.kernel.org/netdev/net-next/c/85f050002ba9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



