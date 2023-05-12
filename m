Return-Path: <netdev+bounces-1998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A5F6FFE58
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5074281810
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29667FD;
	Fri, 12 May 2023 01:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9E7F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E40FBC4339B;
	Fri, 12 May 2023 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683854419;
	bh=T3PLvaLVMEPHLPGBT/83ZUniy67yBRIT67BhY+08ahI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nHAPrBTK3O6egHn0XCW3uo9VH3Pl7INshfjU1SdvlNQSjeHZRxNYSTwPPYj5xCbvB
	 BOhwk+h11qvOLkU2WwW75tC5BCyGHsWFgnkL7sSOkjU8k6dHGFubITx+SoPpQ+46HO
	 X1y6GHxGcUBetmiSeuvEDmXKTG9U7ItYIonhKAjH2kBtQ16dSVPF2+VA0D8Nriiq6P
	 Ns3OcOFECGRmMrgRfby4Qk+5bof2o56Zx8YmyLmW8icjcWlpUyyN83UZjkEyN2Jd4u
	 LsBclUtoPbn8EzHEbu7iImYOBX1cEQOf70+afeQqY54Rb2ZuwNAjvl9OpzgIJWyoV7
	 knvFqJIuqofOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB0D4E49F61;
	Fri, 12 May 2023 01:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fec: Better handle pm_runtime_get() failing in
 .remove()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168385441982.17474.1383391783432684623.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 01:20:19 +0000
References: <20230510200020.1534610-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230510200020.1534610-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
 linux-imx@nxp.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, fugang.duan@nxp.com, hslester96@gmail.com,
 netdev@vger.kernel.org, kernel@pengutronix.de

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 May 2023 22:00:20 +0200 you wrote:
> In the (unlikely) event that pm_runtime_get() (disguised as
> pm_runtime_resume_and_get()) fails, the remove callback returned an
> error early. The problem with this is that the driver core ignores the
> error value and continues removing the device. This results in a
> resource leak. Worse the devm allocated resources are freed and so if a
> callback of the driver is called later the register mapping is already
> gone which probably results in a crash.
> 
> [...]

Here is the summary with links:
  - [net] net: fec: Better handle pm_runtime_get() failing in .remove()
    https://git.kernel.org/netdev/net/c/f816b9829b19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



