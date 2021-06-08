Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD83A0363
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbhFHTQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236306AbhFHTNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:13:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3605C61963;
        Tue,  8 Jun 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623178204;
        bh=clsRNf3nlQ+uJxihaVjSTQRYNqW8TxNPv0hEFPPXUuE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oXvvuqSJa7jbEXay1Rz0XsEubbDftx1OEY/qMt1zIGOhVHRD2+6TIKOqZU/5kNIyH
         x+sPg3Z9DvoHZpwoPoX7HXv6IvyVnlJGK1Y+WsFQgwQpeOXUaxL5YBEnhwWOr6ktgT
         YDpfHz6S5Hsipxv5ry8dswNz/wrH5Lh0xk1lYEcyQkJuDUdvvOLsFE8uOLWph9YNx2
         wORhYiLvXO7GU/opLRqA8m5M32AGnZGsJGS5LHYlC1hY09qBbIkLXZtqcG1N7FE7sp
         hu0xbJs5TpoUAjODWHemRStShVrPudm4Ni23hvpMq42ss6QGTt2tsBREFRIdsgmfBD
         Ht7SWbfLb9YXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2CFE060A22;
        Tue,  8 Jun 2021 18:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next 0/4] net: phy: add dt property for realtek phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317820417.26494.14555476913857085620.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:50:04 +0000
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 11:15:31 +0800 you wrote:
> Add dt property for realtek phy.
> 
> ---
> ChangeLogs:
> V1->V2:
> 	* store the desired PHYCR1/2 register value in "priv" rather than
> 	using "quirks", per Russell King suggestion, as well as can
> 	cover the bootloader setting.
> 	* change the behavior of ALDPS mode, default is disabled, add dt
> 	property for users to enable it.
> 	* fix dt binding yaml build issues.
> V2->V3:
> 	* update the commit title
> 	net: phy: realtek: add dt property to disable ALDPS mode ->
> 	net: phy: realtek: add dt property to enable ALDPS mode
> 
> [...]

Here is the summary with links:
  - [V3,net-next,1/4] dt-bindings: net: add dt binding for realtek rtl82xx phy
    https://git.kernel.org/netdev/net-next/c/a9f15dc2b973
  - [V3,net-next,2/4] net: phy: realtek: add dt property to disable CLKOUT clock
    https://git.kernel.org/netdev/net-next/c/0a4355c2b7f8
  - [V3,net-next,3/4] net: phy: realtek: add dt property to enable ALDPS mode
    https://git.kernel.org/netdev/net-next/c/d90db36a9e74
  - [V3,net-next,4/4] net: phy: realtek: add delay to fix RXC generation issue
    https://git.kernel.org/netdev/net-next/c/6813cc8cfdaf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


