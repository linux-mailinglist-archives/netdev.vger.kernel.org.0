Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2D2F6F51
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbhAOAKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731129AbhAOAKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 34B3C23A9D;
        Fri, 15 Jan 2021 00:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610669409;
        bh=kVEUHIxff0phQc9DnNmH/bx74FiuNiWN3pgt2uBNmBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tv6goNAL9QR+v+4IK6QcTi/TtSz26CIhhjajmCvkP2Z9MCMIeRF2FOWAchWapLtjK
         heh5W8vaGNt88MSClP+T03Lo1g3Q2UFz57hkVAxGPa2kTiOYqOr3Uv1V36lICjNi1H
         Dsm9ZzcGEAjvfZmfsP14f/pwFZ0LTlSWXQ8oWM2qQOF/feeYSq2YGAK8EKoM7HZXS4
         PVLO3QTYnjGExCbY6w3EvnYLY8fXhXYVQRFy7WKKl7EbDcVk2GKgJwf14Tbvd1FvL5
         KfCfBjU7fUCOkYtCPe9Fce8CQiWFAjZmVHu0IVvg8Tyd98XnaQ5XRA4uRXAVYvbapH
         Y/pseClPrPr9w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 25DE36017C;
        Fri, 15 Jan 2021 00:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Add 100 base-x mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161066940915.21117.2897572607965003813.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jan 2021 00:10:09 +0000
References: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
In-Reply-To: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 12:56:24 +0100 you wrote:
> Adding support for 100 base-x in phylink.
> The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause 24) 4b5b encoded.
> These patches adds phylink support for that mode.
> 
> Tested in Sparx5, using sfp modules:
> Axcen 100fx AXFE-1314-0521 (base-fx)
> Axcen 100lx AXFE-1314-0551 (base-lx)
> HP SFP 100FX J9054C (bx-10)
> Excom SFP-SX-M1002 (base-lx)
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: phy: Add 100 base-x mode
    https://git.kernel.org/netdev/net-next/c/b1ae3587d16a
  - [net-next,v2,2/2] sfp: add support for 100 base-x SFPs
    https://git.kernel.org/netdev/net-next/c/6e12f35cef6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


