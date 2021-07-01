Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B013B9612
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhGASWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhGASWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 585A461422;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625163604;
        bh=XFltTWcxDU1KP76KWFFxAFMse4pbMnTWGzAdab8E1Jw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YixcfPz31JAcOX8oT7wa15wr3u2bt7rLRJ+PizQS7Y7i261KK7Dw9lF+lKW6OzOl9
         Mmk41DiUwqM0HCvoedWRBqRsU6EJru5EOyVh56IMQH4obHpdLr079IAIRFLDDTjD8k
         +oYfrAjun4ETJvv3SLbaoy4KFbOD75uDDl8XNQrO6tfuJo6qOJjj6JRlPTMMVnXqAw
         NyFB38ORHAUVu7UT0v6fGYjXnnpaOqw2qtgwzH2YV7SNakwi6xHck5XK6geu6s2cAw
         jxUcqwABrkUk9CzV3ALh1DuT+dloOEtHIaiwaYAbFw7m3SdEXP1g2KzUjuIXogSJnc
         OKA8UE5DCzfSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4970760CD0;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: usb: asix: ax88772: suspend PHY on
 driver probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516360429.12749.17906449690561610280.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:20:04 +0000
References: <20210629044305.32322-1-o.rempel@pengutronix.de>
In-Reply-To: <20210629044305.32322-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        m.szyprowski@samsung.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 06:43:05 +0200 you wrote:
> After probe/bind sequence is the PHY in active state, even if interface
> is stopped. As result, on some systems like Samsung Exynos5250 SoC based Arndale
> board, the ASIX PHY will be able to negotiate the link but fail to
> transmit the data.
> 
> To handle it, suspend the PHY on probe.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: usb: asix: ax88772: suspend PHY on driver probe
    https://git.kernel.org/netdev/net/c/a3609ac24c18

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


