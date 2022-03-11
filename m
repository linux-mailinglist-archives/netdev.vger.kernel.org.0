Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135244D597E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346187AbiCKEV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiCKEVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:21:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAE41A1295;
        Thu, 10 Mar 2022 20:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 235CE6191D;
        Fri, 11 Mar 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70D75C340F3;
        Fri, 11 Mar 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646972416;
        bh=8UMDEKb+dFf1zR9kfW4ts0xq7mHj2Wz9lOo4zGn7Wz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOZDplzCei7DQ0ly1xxQ90GjNMP/aKOAnz+2935fK0uPHEihw3owJItNGaQSZk1Lp
         mtfTd/7D0eeyHfxUMJXHMvGLYpr6YXAXk+zt0Q+HSsR0ejDyJH0lEmqp3bscwK3VfR
         FyssxSRiPBjZrLk7QrlDKs+VDpIbhAuYMbTCO27wLjFYZ79CU/sIF+MeZl0Le4Aaor
         TB6yJh9jhym/Zao/nmtTUk+Z9GZW0Z1iS4eD0p+IrgLQLewdb4XsMVcfzjFl9t6sKN
         SQIa0+E2T1WMsb8Mebb6GwNMasDlVHooUMDEUBThBfW5FzcSMe+fZcYODTr/TL2E13
         kJS112Ar270xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56343E6D3DD;
        Fri, 11 Mar 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/4] can: rcar_canfd: Add support for V3U flavor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697241634.8307.12005930852651825961.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:20:16 +0000
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
In-Reply-To: <20220309162609.3726306-1-uli+renesas@fpond.eu>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com, horms@verge.net.au
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  9 Mar 2022 17:26:05 +0100 you wrote:
> Hi!
> 
> This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up
> to eight channels and has some other minor differences to the Gen3 variety:
> 
> - changes to some register offsets and layouts
> - absence of "classic CAN" registers, both modes are handled through the
>   CANFD register set
> 
> [...]

Here is the summary with links:
  - [v4,1/4] can: rcar_canfd: Add support for r8a779a0 SoC
    https://git.kernel.org/netdev/net-next/c/45721c406dcf
  - [v4,2/4] arm64: dts: renesas: r8a779a0: Add CANFD device node
    (no matching commit)
  - [v4,3/4] arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
    (no matching commit)
  - [v4,4/4] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
    https://git.kernel.org/netdev/net-next/c/d6254d52d70d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


