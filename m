Return-Path: <netdev+bounces-7309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D2F71F984
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ADDE2819E2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C864699;
	Fri,  2 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8064F1854
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2A17C4339B;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685682020;
	bh=rUHmOXEYpK/oNBqcnTdtouxfSre1j04IJR96syYNKDw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Vsbzlpgdftk8smVI3yWSPQcDhM00q0Fb6ZUHq53dFVgfRBZfrtlRAQFga4wIJoVFd
	 GeC7zQlHYpS8h6SGynQSJBGdqsb2iHAQuzIUp7dPdAdfgQL2wFZ37BameN0mY9xKQx
	 SvsV7KQYO/qPAITjmG7L2DQq3LeJzN51/OUSpwWviRWlb1AG6ABkiRLHI7KrVf6oxP
	 i/41ZPo/EGc9lN2MZ3z1/knMQA6htsN30dEdUqpMXKMWpNjFZKgXKdWMNn4vb9g9nA
	 CXO1BgH82XuZyHRHRYnz4SbduC6VHUAqOWvEXk5qPVnjhFyLR2C7mo78nJzqBpampD
	 x7KOVAuihf5sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 979BDE29F3F;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] Extend dt-bindings for PSE-PD controllers and update
 prtt1c dts
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568202061.24823.10947582942293943932.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 05:00:20 +0000
References: <20230531102113.3353065-1-o.rempel@pengutronix.de>
In-Reply-To: <20230531102113.3353065-1-o.rempel@pengutronix.de>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 robh+dt@kernel.org, krzk+dt@kernel.org, jerome.pouiller@silabs.com,
 kernel@pengutronix.de, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 12:21:11 +0200 you wrote:
> changes v3:
> - reword commit message for the pse-controller.yaml patch
> - drop podl-pse-regulator.yaml patch
> 
> changes v2:
> - extend ethernet-pse regexp in the PoDL PSE dt-bindings
> 
> [...]

Here is the summary with links:
  - [v3,1/2] dt-bindings: net: pse-pd: Allow -N suffix for ethernet-pse node names
    https://git.kernel.org/netdev/net-next/c/bd415f6c748e
  - [v3,2/2] ARM: dts: stm32: prtt1c: Add PoDL PSE regulator nodes
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



