Return-Path: <netdev+bounces-6229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2DA7154AE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1953B281073
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192A84A0C;
	Tue, 30 May 2023 05:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565B41C2B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E92CBC4339C;
	Tue, 30 May 2023 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685422822;
	bh=rVTuwEui2Osf8JwG+HWnkMtEsnaWhkgmCooquZbghQg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V7A8t2oBFtcog5KDgbWOQ4aajEpmJpGoPPIlVRn9xKZAN4vnjPpzW4z8/AQstXVbX
	 gjMX4fwHT3nQyP6d6+XN+K0GNf1DuRMRpBOjRXXSgEPiCuX09LLj3DFTJ8rttRHRL6
	 jKfUqmH5hOKZpIyjGfqtMdASo5V70jDCdYR40ndxDpnst2OMSvqjjT3b+3vr5QuMgE
	 w+DrfQx4emiSo4kFYuSin7cW5RwmNSzkuNm8pyX6gaXyNqv8tzM99WuVPmfPrFAFBJ
	 lJBjEBtB4eMOgfkK/upAhFYDXcDbsRzvjFCnHA+dio+hizF9tn8b9ShoF2me8uZRt8
	 QdG5s1kZLxBiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE57AE52BF8;
	Tue, 30 May 2023 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dpaa2-mac: use correct interface to free
 mdiodev
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542282177.21395.15371967055245325552.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:00:21 +0000
References: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, ioana.ciornei@nxp.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 12:44:43 +0100 you wrote:
> Rather than using put_device(&mdiodev->dev), use the proper interface
> provided to dispose of the mdiodev - that being mdio_device_free().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This change is independent of the series I posted changing the lynx
> PCS - since we're only subsituting an explicit put_device() for the
> right interface in this driver, and this driver is not touched by
> that series.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dpaa2-mac: use correct interface to free mdiodev
    https://git.kernel.org/netdev/net-next/c/404621fab273

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



