Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65346E02C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhLIBXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhLIBXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:23:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1B7C061746;
        Wed,  8 Dec 2021 17:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1F5ACE2455;
        Thu,  9 Dec 2021 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABFDCC341C6;
        Thu,  9 Dec 2021 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639012810;
        bh=U9piRp9VUHkIbNUEo20jl2DvHVU93YxLKpaQkRbT0Og=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sp0u/obZkb9zzBOKLxuBCwiaDDTCPN7ikpa5pzd4knsu8iqw6ql0iqszuV2QLo4mw
         5CGpD7Gxr7aw25VedwZfSM0gy7l7EO8INjDTsu4WmUJcm8J2+ECq1bDA3wK1g4hR+7
         0U2nX9a9mZSxtcC0KOzTOExVpnb+LbDYTODyP+hKwNSq/ifV8TlpFcHX7cUByXZCIv
         jO+zUyzbupkuBl2TtpMN4DVShSNSnDokpRsIHj+NmbtMnDxfdf+Dh5CjeXUrJKZW3v
         5pnuDWYlz0DBlCtPWg5CoxAXSGRMw/CJgBwmoLWGcLWFBWiL6Ht/d+rVEWA96jrqvf
         kC7Ro/UEPwbwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CFBF60966;
        Thu,  9 Dec 2021 01:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] can: bittiming: replace CAN units with the
 generic ones from linux/units.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901281057.2174.17545511832440179871.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 01:20:10 +0000
References: <20211208125055.223141-2-mkl@pengutronix.de>
In-Reply-To: <20211208125055.223141-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, extja@kvaser.com,
        socketcan@hartkopp.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  8 Dec 2021 13:50:48 +0100 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> In [1], we introduced a set of units in linux/can/bittiming.h. Since
> then, generic SI prefixes were added to linux/units.h in [2]. Those
> new prefixes can perfectly replace CAN specific ones.
> 
> This patch replaces all occurrences of the CAN units with their
> corresponding prefix (from linux/units) and the unit (as a comment)
> according to below table.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] can: bittiming: replace CAN units with the generic ones from linux/units.h
    https://git.kernel.org/netdev/net-next/c/330c6d3bfa26
  - [net-next,2/8] dt-bindings: net: can: add support for Allwinner R40 CAN controller
    https://git.kernel.org/netdev/net-next/c/d0342ceb78ed
  - [net-next,3/8] can: sun4i_can: add support for R40 CAN controller
    https://git.kernel.org/netdev/net-next/c/2c2fd0e68d9e
  - [net-next,4/8] ARM: dts: sun8i: r40: add node for CAN controller
    https://git.kernel.org/netdev/net-next/c/671f852c1bee
  - [net-next,5/8] can: hi311x: hi3110_can_probe(): use devm_clk_get_optional() to get the input clock
    https://git.kernel.org/netdev/net-next/c/369cf4e6ac53
  - [net-next,6/8] can: hi311x: hi3110_can_probe(): try to get crystal clock rate from property
    https://git.kernel.org/netdev/net-next/c/3a1ae63a4d21
  - [net-next,7/8] can: hi311x: hi3110_can_probe(): make use of device property API
    https://git.kernel.org/netdev/net-next/c/dc64d98aae75
  - [net-next,8/8] can: hi311x: hi3110_can_probe(): convert to use dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/6a93ea382177

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


