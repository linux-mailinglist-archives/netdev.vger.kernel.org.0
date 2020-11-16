Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35592B53FD
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgKPVuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgKPVuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605563405;
        bh=T0yfg0Ck3m11/ib7YMz+hav7/OgdqtrW6OV2NI4vKDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=1OsVoErF0pFvoc8JQjrRUCbDxXUl1qDhoCc+z8JoB17PkO8soeGDfbdoEOM3QmfnK
         Q1Jga51B1z+XwbzIUQnJ1vnKOn8qpE9ziNXMC/34TX7fPNwahDVi6BEwznLBle5scM
         1nInWI5/HdrC1cf7/QQcQqe/mjciv6Jhn9vpjlVA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: lantiq: Wait for the GPHY firmware to be ready
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160556340543.26491.18312190727350290865.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 21:50:05 +0000
References: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 15 Nov 2020 17:57:57 +0100 you wrote:
> A user reports (slightly shortened from the original message):
>   libphy: lantiq,xrx200-mdio: probed
>   mdio_bus 1e108000.switch-mii: MDIO device at address 17 is missing.
>   gswip 1e108000.switch lan: no phy at 2
>   gswip 1e108000.switch lan: failed to connect to port 2: -19
>   lantiq,xrx200-net 1e10b308.eth eth0: error -19 setting up slave phy
> 
> [...]

Here is the summary with links:
  - [v2] net: lantiq: Wait for the GPHY firmware to be ready
    https://git.kernel.org/netdev/net/c/2a1828e378c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


