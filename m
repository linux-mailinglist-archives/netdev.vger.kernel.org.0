Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71031E140
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhBQVVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234652AbhBQVUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 16:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CED564E6C;
        Wed, 17 Feb 2021 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613596807;
        bh=FTVotOfeaANi42YkE8+PgcSKHYsTEzO4ZmiPiYOF9zI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t+v8PnynShFMQ5nDTXf0FTNErAAVTOdGqEst7FulybLBpCsFoRgIXY4EvVHIeYWhZ
         M6XgQ3r6t/WY9wlfjqv2BkKJHGupgscWzvSWcN8j263J6lKVbe+RZid9oUUjjV7Q+j
         VyzJmb+d+HPWQGmuaG82Rmv3lr6B3yzr1sbVskQRiYh2snYY98AS17HQONbh+kGVf7
         XpY+igGgKA+Ba2SPPkSqxp6SjnN5Pwy2s5+PwZFzg9bRkba/B/iwXoZuJ8DEYHXfrN
         s4dIBs/0hWXobrVhZUMktGvacHfUw0acInuBkfZbjoZi7NSklDbScZOfNavy5hXwOs
         0mWNoXYALTloQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B42360A15;
        Wed, 17 Feb 2021 21:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: select PACKING in the Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161359680756.30698.6948150538481599383.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 21:20:07 +0000
References: <20210217203348.563282-1-olteanv@gmail.com>
In-Reply-To: <20210217203348.563282-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        naresh.kamboju@linaro.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 22:33:48 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Ocelot now uses include/linux/dsa/ocelot.h which makes use of
> CONFIG_PACKING to pack/unpack bits into the Injection/Extraction Frame
> Headers. So it needs to explicitly select it, otherwise there might be
> build errors due to the missing dependency.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: select PACKING in the Kconfig
    https://git.kernel.org/netdev/net-next/c/597565556581

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


