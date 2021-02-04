Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3797930E972
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhBDBav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhBDBar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 20:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A1C864F65;
        Thu,  4 Feb 2021 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612402207;
        bh=SqRkHwnqkxIxl3DIOG6t6hlkMtbpPjlZM0WRwc2xWgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zd3pFqAzVDeKDylj8Z4z7xBV/nOw4vD4fiSx0XLFkM3sGkdraMmRjtIQwIYzPhwIQ
         MMZCeVs8qL/F+c8vrvWQt3f1C/o3IJ87Ba42aYz2CrPIsZioB0jsD0Z7VMj2P1O0u0
         FoxnFjqu8//eaLg2VLJny1ZpDWJHRDvtHrYQUlgIgVbmKCh/u6QeNcnISx8oIq4GHL
         gHIF1LXcdTrPSZa4RCj9m6eULQPnIeHxnAodJjpf4ae/7x+Z5YZUyNP4wfB6GH9WtL
         Co2P58Qr8vkdRISuYNa8sVb016mO3Q8jLzuKe4WLYWbUV7FITrEpuXtu62k83hhKQ9
         ijVdSh1Eiaz+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F087609CE;
        Thu,  4 Feb 2021 01:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mdiobus: Prevent spike on MDIO bus reset signal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161240220718.12107.15347516545043995262.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 01:30:07 +0000
References: <20210202143239.10714-1-mike.looijmans@topic.nl>
In-Reply-To: <20210202143239.10714-1-mike.looijmans@topic.nl>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        hkallweit1@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 15:32:39 +0100 you wrote:
> The mdio_bus reset code first de-asserted the reset by allocating with
> GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
> the reset signal defaulted to asserted, there'd be a short "spike"
> before the reset.
> 
> Here is what happens depending on the pre-existing state of the reset
> signal:
> Reset (previously asserted):   ~~~|_|~~~~|_______
> Reset (previously deasserted): _____|~~~~|_______
>                                   ^ ^    ^
>                                   A B    C
> 
> [...]

Here is the summary with links:
  - [v2] net: mdiobus: Prevent spike on MDIO bus reset signal
    https://git.kernel.org/netdev/net-next/c/e0183b974d30

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


