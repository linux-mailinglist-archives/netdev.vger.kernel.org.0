Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639A42F904B
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 04:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbhAQDK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 22:10:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbhAQDKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 22:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4959922D05;
        Sun, 17 Jan 2021 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610853008;
        bh=Ai4cw/DfWBYuhXNl8S3SBCaEyr5e0/edEa6HSQZWV8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOxS/q5nwsNPapD0J45j6QMozG0OSVTOx/JbF4dHsvLFtYmGruVIvKQ+3cqRyvLb/
         Di0ljwjFnGjK8XiDQk0Ojfv0iItNS8eSR/eNeM68mXpmDzlA9l1DfYGFtOvBlj9qFI
         9ysi30XB9V5RnhMZ76nJ+NXyV4BiP64wlg0xFKeBXzniUV7ANgLjcqkY09s9Pln+PT
         bzwpWpLOIk5n7RZt65QZo01HesQ/VoeZluskKfNipbEr5m5OuO99y/aCSuIInkyyzN
         T9QusVuV1rIOF1VmAYNoovRgp6tu3wK/J+VL3vI1/Mnp6bOmOm1v8sgfTsgDIxR+qk
         Wtx+NNhfg8U/Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3E26760658;
        Sun, 17 Jan 2021 03:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: Remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161085300824.5035.10165885405483775740.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Jan 2021 03:10:08 +0000
References: <20210115095544.33164-1-vulab@iscas.ac.cn>
In-Reply-To: <20210115095544.33164-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 09:55:44 +0000 you wrote:
> fix semicolon.cocci warnings:
> drivers/net/ethernet/mscc/ocelot_net.c:460:2-3: Unneeded semicolon
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: mscc: ocelot: Remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/20efd2c79afb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


