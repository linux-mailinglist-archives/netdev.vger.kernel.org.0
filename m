Return-Path: <netdev+bounces-6311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A20715A72
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A4B1C20B59
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776EE1548B;
	Tue, 30 May 2023 09:41:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DAF14264
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9EFAC433D2;
	Tue, 30 May 2023 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685439692;
	bh=2tuj7AtKSDuy0EDA4m4ZyONmVZkVqpCP2lFX0A5XKYY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AcZ938CiuTHDpzzboIF8RW0NlzBK/DEqSJnt6odILEKP+Z4Rp66pLfL4yOCw5Pp9A
	 62leyJwIUQbjBYR9Wxu+ufrXPeIeE27UF4Pik28lnptV4QV/xpbybJwZvtWkle58Dw
	 /HcOGbrJvVL/itTid++rROZCp3EG6HxyYEmBM0dmGcl7qmyPrzBnawJ7hFX5EzzzwL
	 aweUIWgtJYMO256G4VwYch/M2d++r1Vt5Kq4Ijn0Hde/WLwrBTbY9cmHcOEQcEkxMp
	 B/dejAY2JLj4FKzUCIV+FY6neWeZbxUXD60eY468TjlwpJsYwyoMh2lqFUu0DtAks3
	 +dE7fZoDJ14ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE635E52C02;
	Tue, 30 May 2023 09:41:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] Microchip DSA Driver Improvements
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168543969270.28717.11968516011003747192.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 09:41:32 +0000
References: <20230526073445.668430-1-o.rempel@pengutronix.de>
In-Reply-To: <20230526073445.668430-1-o.rempel@pengutronix.de>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: davem@davemloft.net, andrew@lunn.ch, edumazet@google.com,
 f.fainelli@gmail.com, kuba@kernel.org, pabeni@redhat.com, olteanv@gmail.com,
 woojung.huh@microchip.com, arun.ramadoss@microchip.com,
 kernel@pengutronix.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 UNGLinuxDriver@microchip.com, linux@armlinux.org.uk

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 May 2023 09:34:40 +0200 you wrote:
> changes v2:
> - set .max_register = U8_MAX, it should be more readable
> - clarify in the RMW error handling patch, logging behavior
>   expectation.
> 
> I'd like to share a set of patches for the Microchip DSA driver. These
> patches were chosen from a bigger set because they are simpler and
> should be easier to review. The goal is to make the code easier to read,
> get rid of unused code, and handle errors better.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: dsa: microchip: improving error handling for 8-bit register RMW operations
    https://git.kernel.org/netdev/net-next/c/2f0d579956e8
  - [net-next,v2,2/5] net: dsa: microchip: add an enum for regmap widths
    https://git.kernel.org/netdev/net-next/c/b8311f46c6f5
  - [net-next,v2,3/5] net: dsa: microchip: remove ksz_port:on variable
    https://git.kernel.org/netdev/net-next/c/bb4609d27f89
  - [net-next,v2,4/5] net: dsa: microchip: ksz8: Prepare ksz8863_smi for regmap register access validation
    https://git.kernel.org/netdev/net-next/c/ae1ad12e9da4
  - [net-next,v2,5/5] net: dsa: microchip: Add register access control for KSZ8873 chip
    https://git.kernel.org/netdev/net-next/c/d0dec3333040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



