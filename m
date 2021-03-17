Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B433FAED
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCQWUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230398AbhCQWUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 18:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 670F664F20;
        Wed, 17 Mar 2021 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616019608;
        bh=Y15VSVC8mNDsOgb7F6/oH5qffa3/MovlBNzDcU0NDOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STxf/7Ln4ugR0Ajp7A3l1dF6DuV+7tDf71St1w0aBGGWnS5AXckWG3kPhAHorTI5x
         qqeh+mQehWAgPoiDMnzJsAYiAlyukPTR8L1yIGIkQ23W4KO+3Ukw0+6lhb8dXL+DGZ
         Sxz/iMH05AYPBKIf9ykg5S0hoJ3MFDXPMfIKl8TUwnKemtOuwxTyuqnb0Vw8hUs0WZ
         YvkZ+quojDjMFE9vX+VJBCqCv8iDxjBoxoWLw8Ktj4cEkjTscpGt00XAq3zj9kH9g7
         8IRyowtCpKMITunLjTJm0RsZxc5ZSbROFLsS0IU5jT5MMEAUwreDI6QpadQjwmhuv8
         86pdwtAVk/Q+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5771860A45;
        Wed, 17 Mar 2021 22:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: simplify clk_init with dev_err_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601960835.21494.17923662578432892297.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 22:20:08 +0000
References: <20210317161609.2104738-1-m.tretter@pengutronix.de>
In-Reply-To: <20210317161609.2104738-1-m.tretter@pengutronix.de>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 17:16:09 +0100 you wrote:
> On some platforms, e.g., the ZynqMP, devm_clk_get can return
> -EPROBE_DEFER if the clock controller, which is implemented in firmware,
> has not been probed yet.
> 
> As clk_init is only called during probe, use dev_err_probe to simplify
> the error message and hide it for -EPROBE_DEFER.
> 
> [...]

Here is the summary with links:
  - net: macb: simplify clk_init with dev_err_probe
    https://git.kernel.org/netdev/net-next/c/a04be4b6b539

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


