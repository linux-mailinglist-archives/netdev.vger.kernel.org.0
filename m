Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B341747576B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhLOLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbhLOLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CF5C06173F;
        Wed, 15 Dec 2021 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CDE618AC;
        Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B659C34613;
        Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566613;
        bh=mN0rAbqQtQffJqBOdadPeRiHcW8redQts479nECbUfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kAq0hfItsd4pyzxqfHEpR89RAyqWbjF6oy+yjJBtXR/4qCalhM+rzuKa2Y6JnTNKy
         +RipMbIPZ3vLHNZq8/NSQrzKxDlEvB7NTpeD94+XxOXdkoFxcBJw0J7LsapGTqigxr
         Xj+MRsonAaSk8ErBwS80R5mKXkMPfFiOrPMP7gkvUBHnAbmM3Q/PGjXQ5NZLPgxuSI
         /M+CO+5EnDuQUuHLVx6gm1palBAOv3no0NRnuRKKY+UczzZvXjJg99/nULV+bR6myv
         UTyD9EXB6HYNwOqIhfRiJpUvacA1o3j1Iqi0sceKZim4pwuA+r3JDjfR457Gwlg/qs
         K4BbGt2HtDt7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EDB09609F5;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ocelot: add support to get port mac from
 device-tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956661296.16045.16297780447562530182.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:12 +0000
References: <20211214095534.563822-1-clement.leger@bootlin.com>
In-Reply-To: <20211214095534.563822-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 10:55:34 +0100 you wrote:
> Add support to get mac from device-tree using of_get_ethdev_address.
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: ocelot: add support to get port mac from device-tree
    https://git.kernel.org/netdev/net-next/c/843869951258

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


