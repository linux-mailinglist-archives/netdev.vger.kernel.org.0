Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6931D303
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBPXas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhBPXas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 18:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 77ED764EAE;
        Tue, 16 Feb 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613518207;
        bh=J+mWyP3Bn4+Eglnvaj+9cVpk6cKgopC7zOX12tI+dZk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D/I2UEneBDsOJC4exBYOUZY5WkWLFZ8a5YADYcU+SCOWYFVp7BuvgVLjEJG/Zm1mP
         Hrf7xWs3WamqwNtEyo7GzgX4hmdJ2BdV3CXREPB1hlmlWTiG+KsXH7kMC4Stmqqo1F
         2moo4odfn+aqPvxMstuzumXeC2R3RErVqO0gzVckfUhHoUNzxWwyZHSiNbYDlmAuCk
         3nAdyw9jBb34ByyfqF8HxMliJ0c6nyoUTEhRmd08pSvTnyZOwxoaS9cYBABTnI4xa0
         PHkS+8zEC/oQuRoIHRNwMyETsa5GTiwh+ek4bfy5RJEb8I5wrSzH/yZIY3l8os1izr
         Kz14zqESbLplA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62058609EA;
        Tue, 16 Feb 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] Broadcom PHY driver updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351820739.22868.6742732407736406223.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:30:07 +0000
References: <20210216225454.2944373-1-robert.hancock@calian.com>
In-Reply-To: <20210216225454.2944373-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 16:54:51 -0600 you wrote:
> Updates to the Broadcom PHY driver related to use with copper SFP modules.
> 
> Changed since v3:
> -fixed kerneldoc error
> 
> Changed since v2:
> -Create flag for PHY on SFP module and use that rather than accessing
>  attached_dev directly in PHY driver
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
    https://git.kernel.org/netdev/net-next/c/3afd0218992a
  - [net-next,v4,2/3] net: phy: Add is_on_sfp_module flag and phy_on_sfp helper
    https://git.kernel.org/netdev/net-next/c/b834489bcecc
  - [net-next,v4,3/3] net: phy: broadcom: Do not modify LED configuration for SFP module PHYs
    https://git.kernel.org/netdev/net-next/c/b5d007e2aac8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


