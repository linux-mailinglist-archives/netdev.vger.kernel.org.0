Return-Path: <netdev+bounces-9203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA9D727EFB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4E52815BF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7B81118C;
	Thu,  8 Jun 2023 11:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F8B11189
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE0B8C4339C;
	Thu,  8 Jun 2023 11:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686224422;
	bh=Xb0c2eFPQSfWbZXxVY/N3wmksxoTmIIHFKUhff2jICE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BBu8USMJ20dP1CD7K2ZnyXZUilBZnlOM+rh7UtLT2Sye0EXfSKnCJiZLxbLwcMtRl
	 G/06g+wIvJTRjYC+zJIuMK08hT1k1oZiBjJVtuFEYlPuMCVAmnHZvHkl4s9tkDxeX5
	 bD+IoHi1F7tJefG6Cat4lmr6H48SF9C1D54JMlTynpitbE9Af5DfBRQU3LYVz0Zin7
	 kaYdiU8PLRudC1M2ImykmcO6iRw9TyYCyOAfMe8RJ2N0JzXOIG5wvL0Pqp2I5XkqSd
	 3qgAhuBlVz6hrYtDkunZA5DtwiAA+UisHyLQTlQWX748zi2MJtD+cDz2r+e2jVM09p
	 fDd3z93uexxZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D015E4D015;
	Thu,  8 Jun 2023 11:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v12 0/8] TXGBE PHYLINK support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168622442263.17370.16554373092861552237.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 11:40:22 +0000
References: <20230606092107.764621-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230606092107.764621-1-jiawenwu@trustnetic.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, andriy.shevchenko@linux.intel.com,
 Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Jun 2023 17:20:59 +0800 you wrote:
> Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link.
> 
> Because our I2C and PCS are based on Synopsys Designware IP-core, extend
> the i2c-designware and pcs-xpcs driver to realize our functions.
> 
> v11 -> v12:
> - split I2C designware patch (2/9) to I2C tree, repost remaining 8
>   patches
> 
> [...]

Here is the summary with links:
  - [net-next,v12,1/8] net: txgbe: Add software nodes to support phylink
    https://git.kernel.org/netdev/net-next/c/c3e382ad6d15
  - [net-next,v12,2/8] net: txgbe: Register fixed rate clock
    https://git.kernel.org/netdev/net-next/c/b63f20485e43
  - [net-next,v12,3/8] net: txgbe: Register I2C platform device
    https://git.kernel.org/netdev/net-next/c/c625e72561f6
  - [net-next,v12,4/8] net: txgbe: Add SFP module identify
    https://git.kernel.org/netdev/net-next/c/04d94236182e
  - [net-next,v12,5/8] net: txgbe: Support GPIO to SFP socket
    https://git.kernel.org/netdev/net-next/c/b83c37315a62
  - [net-next,v12,6/8] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
    https://git.kernel.org/netdev/net-next/c/af8de1e307bf
  - [net-next,v12,7/8] net: txgbe: Implement phylink pcs
    https://git.kernel.org/netdev/net-next/c/854cace61387
  - [net-next,v12,8/8] net: txgbe: Support phylink MAC layer
    https://git.kernel.org/netdev/net-next/c/08f08f9390e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



