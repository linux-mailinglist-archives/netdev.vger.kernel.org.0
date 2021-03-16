Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5233DD02
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 20:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhCPTAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 15:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240232AbhCPTAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 15:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1068C65070;
        Tue, 16 Mar 2021 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615921208;
        bh=dPxXJ/zwwuDGlopOdTZYQqlIpIO7D2z4REtZztyZZr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZ+UEURGVuqu7ZOM4hzKa4iEMRS62fp0Ris98ZWP/XKpoOljnUWlEXccUfplbJYsi
         tnb/0k4l9ekT1hEr9S8pNE4BHaowoeZvRXBz0NxLCG5KngSAh695fqJCFcPB7U+0DT
         649sOMtByX2jpnxi/qLLoxezlAaGmOqcylBlc4Loz584+IU+6LL+4lkbMI5YxszZMl
         UH67BbtjJ9J/vbrYvawvHSmknw/UCzaRnzIa1ggB7R6CjTvoYoLcynvpKCFtuKMunD
         pEtVxefpznVJr38zYrlBCHxFbyYl7RBn2Xhhpcs/EW5iQ6wpswnnCaV+i2iiPr1GFl
         HyUXl5mX4I8Og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F303860A45;
        Tue, 16 Mar 2021 19:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] net: mdio: Add BCM6368 MDIO mux bus
 controller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161592120798.24247.13693268552230553993.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 19:00:07 +0000
References: <20210315154528.30212-1-noltari@gmail.com>
In-Reply-To: <20210315154528.30212-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     jonas.gorski@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 16:45:26 +0100 you wrote:
> This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM63268
> SoCs.
> 
> v2: add changes suggested by Andrew Lunn and Jakub Kicinski.
> 
> Álvaro Fernández Rojas (2):
>   dt-bindings: net: Add bcm6368-mdio-mux bindings
>   net: mdio: Add BCM6368 MDIO mux bus controller
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] dt-bindings: net: Add bcm6368-mdio-mux bindings
    https://git.kernel.org/netdev/net-next/c/da6557edb9f3
  - [v2,net-next,2/2] net: mdio: Add BCM6368 MDIO mux bus controller
    https://git.kernel.org/netdev/net-next/c/e239756717b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


