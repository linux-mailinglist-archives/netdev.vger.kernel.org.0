Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6B83EBEA4
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhHMXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235368AbhHMXUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA9BF610FE;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628896806;
        bh=+QYAK0Vw09zAJN6CbYMzhPWTd+nSvJsTkcCEvsoHj30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tI47/iZIxLbNwzdq112eIopKxF22WFpLUeIK2/HDXnYk+VguTpm6bBPhntThQ95lo
         GgbThO7edgYpIhDSLW9faJGuJ593YXdfxuxCOaLbpS0BigCtaBdpCAS19Rfx8oiUNu
         g64WG+EyJ4wpn0+Y9SITWyb6oLQaickA3Yv0AqoSKEZLWBL66F+QNnQtSCyYCrge/j
         VP4BE4PlK/Fun33lyW7JbmBAAKaZp/QFO3Mo6/lmPR3LrCeSx/tOx+YORuIiCWr8Se
         V+b1kznmQ6lXICxlnEMoMWUfa1ikfbHgrh4rkdwLVnNO9erk7/m7QQmz+QvL7vHDgE
         qzO6193M6UP9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B869C60A9C;
        Fri, 13 Aug 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: fec: add WoL support for i.MX8MQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162889680675.8729.3067058658924808151.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 23:20:06 +0000
References: <20210812070948.25797-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210812070948.25797-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 15:09:48 +0800 you wrote:
> By default FEC driver treat irq[0] (i.e. int0 described in dt-binding) as
> wakeup interrupt, but this situation changed on i.MX8M serials, SoC
> integration guys mix wakeup interrupt signal into int2 interrupt line.
> This patch introduces FEC_QUIRK_WAKEUP_FROM_INT2 to indicate int2 as wakeup
> interrupt for i.MX8MQ.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: fec: add WoL support for i.MX8MQ
    https://git.kernel.org/netdev/net-next/c/b7cdc9658ac8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


