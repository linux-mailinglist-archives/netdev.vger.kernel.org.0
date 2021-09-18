Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA94105FD
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 13:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhIRLBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 07:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhIRLBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 07:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 23C9760F6C;
        Sat, 18 Sep 2021 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631962807;
        bh=GP8hLMObdsqPxqm3gZxotOrtC5EcNirlj9lspyL5mqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ql6u9SjB3ETFtDNCa/VHLLkNATU8ZgxXJCh6Imls/YBmKGYnd1EOOqKN6gJxoWXdc
         Xae3rLTQ1iO3/0yJIMUQlXugVJPeiTCpQTglj4fz/Jii5kFbNGeDMuVOofGm1C+0Vu
         pyGJJlBm+r2qDvaOtLNkIEr10Xi3E8dGI01RVQo10v/X8bg4uqc+bJEfSG17TwuBmr
         mSw4D4fRRbYFnRv1HRQUAPmA8quxXQq8RfUspxPAlVJYLbvsic6oV04hjqOswJhneK
         OUOeVNY4AhoS136PlaDu6cvJ2qpR2hsKGqYGyFUnBW2eWqrBKIX4dmUJaITK0vz1Vn
         Chtx25BQh/pLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1556B60A22;
        Sat, 18 Sep 2021 11:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bcmgenet: Patch PHY interface for dedicated PHY
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163196280708.26352.2836098272804505174.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Sep 2021 11:00:07 +0000
References: <20210917215539.3020216-1-f.fainelli@gmail.com>
In-Reply-To: <20210917215539.3020216-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 14:55:38 -0700 you wrote:
> When we are using a dedicated PHY driver (not the Generic PHY driver)
> chances are that it is going to configure RGMII delays and do that in a
> way that is incompatible with our incorrect interpretation of the
> phy_interface value.
> 
> Add a quirk in order to reverse the PHY_INTERFACE_MODE_RGMII to the
> value of PHY_INTERFACE_MODE_RGMII_ID such that the MAC continues to be
> configured the way it used to be, but the PHY driver can account for
> adding delays. Conversely when PHY_INTERFACE_MODE_RGMII_TXID is
> specified, return PHY_INTERFACE_MODE_RGMII_RXID to the PHY since we will
> have enabled a TXC MAC delay (id_mode_dis=0, meaning there is a delay
> inserted).
> 
> [...]

Here is the summary with links:
  - [net-next] net: bcmgenet: Patch PHY interface for dedicated PHY driver
    https://git.kernel.org/netdev/net-next/c/b972b54a68b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


