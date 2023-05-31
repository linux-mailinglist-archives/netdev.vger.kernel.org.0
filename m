Return-Path: <netdev+bounces-6736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90847717B5C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BB572812A3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A44C8D4;
	Wed, 31 May 2023 09:10:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DAB1FBA
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56B50C4339B;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685524226;
	bh=/HXE6Lv70q14EtRVGFTc+yxi8ujb9+Ft28H1V80Qm7s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oPnTH7o+o0CmeOFhUFfJzD1ME+nfdJq8O9G6SLQDdQlckMyX7ei9XEljkJx5VKo81
	 WOgpgwTMO19TOSB62ofR0hkONv/Tcarv38i6Bz7E2ZQum90gwIRgkbcrC+VVbGhSev
	 Op1naBJPBV2rIZDJojfGKl52lc17MOT0b6/2etJm2oWhvFkjGrbOBFY89Mq1jJPdpH
	 kYQyHiUdZ6FcE+6Ytv33n3sit9r0QH8H5Hb2Q/+KwwpeTMKtIoyJhsE2OFqjWFcndk
	 Szl8Ucz/Q7SPJHyvRfTUGJe8+9yN44wGOenXcZVOeffuTEvra3HPUPGCX20BL28pqF
	 2YgYyvbUznJAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36783E52BFB;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v4 00/13] leds: introduce new LED hw control APIs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168552422621.12579.18364898651664418572.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 09:10:26 +0000
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: pavel@ucw.cz, lee@kernel.org, corbet@lwn.net, andrew@lunn.ch,
 f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 May 2023 18:32:30 +0200 you wrote:
> Since this series is cross subsystem between LED and netdev,
> a stable branch was created to facilitate merging process.
> 
> This is based on top of branch ib-leds-netdev-v6.5 present here [1]
> and rebased on top of net-next since the LED stable branch got merged.
> 
> This is a continue of [2]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/13] leds: add APIs for LEDs hw control
    https://git.kernel.org/netdev/net-next/c/ed554d3f9451
  - [net-next,v4,02/13] leds: add API to get attached device for LED hw control
    https://git.kernel.org/netdev/net-next/c/052c38eb17e8
  - [net-next,v4,03/13] Documentation: leds: leds-class: Document new Hardware driven LEDs APIs
    https://git.kernel.org/netdev/net-next/c/8aa2fd7b6698
  - [net-next,v4,04/13] leds: trigger: netdev: refactor code setting device name
    https://git.kernel.org/netdev/net-next/c/28a6a2ef18ad
  - [net-next,v4,05/13] leds: trigger: netdev: introduce check for possible hw control
    https://git.kernel.org/netdev/net-next/c/4fd1b6d47a7a
  - [net-next,v4,06/13] leds: trigger: netdev: add basic check for hw control support
    https://git.kernel.org/netdev/net-next/c/6352f25f9fad
  - [net-next,v4,07/13] leds: trigger: netdev: reject interval store for hw_control
    https://git.kernel.org/netdev/net-next/c/c84c80c7388f
  - [net-next,v4,08/13] leds: trigger: netdev: add support for LED hw control
    https://git.kernel.org/netdev/net-next/c/7c145a34ba6e
  - [net-next,v4,09/13] leds: trigger: netdev: validate configured netdev
    https://git.kernel.org/netdev/net-next/c/33ec0b53beff
  - [net-next,v4,10/13] leds: trigger: netdev: init mode if hw control already active
    https://git.kernel.org/netdev/net-next/c/0316cc5629d1
  - [net-next,v4,11/13] leds: trigger: netdev: expose netdev trigger modes in linux include
    https://git.kernel.org/netdev/net-next/c/947acacab5ea
  - [net-next,v4,12/13] net: dsa: qca8k: implement hw_control ops
    https://git.kernel.org/netdev/net-next/c/e0256648c831
  - [net-next,v4,13/13] net: dsa: qca8k: add op to get ports netdev
    https://git.kernel.org/netdev/net-next/c/4f53c27f772e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



