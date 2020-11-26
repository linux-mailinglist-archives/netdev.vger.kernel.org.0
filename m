Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043992C4D00
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 03:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgKZCAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 21:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbgKZCAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 21:00:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606356006;
        bh=tSfDL+nPc5rTobRs+AYXM9ATSjEhnIs5yqsA8MEXEKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IsyTCbif//S9hnmfKInN4/keUJYO0cui2GQKL9qFutlPxrUn/d4qEmmF1Prb8HOve
         TxUkt6F/NRczAvmu4nXX0PryyY/qniEdwXuy4uS9zq0UMW2CBbUmoJRwmPyqtH7GJ+
         aQgcLQ5FGleNEggMbGUxrxoFW3JxL+hj4u+YSa2c=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] dt-bindings: net: dsa: microchip: convert KSZ
 bindings to yaml
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635600627.28583.6196679476073419959.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 02:00:06 +0000
References: <20201120112107.16334-1-ceggers@arri.de>
In-Reply-To: <20201120112107.16334-1-ceggers@arri.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     olteanv@gmail.com, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, richardcochran@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net,
        kurt.kanzenbach@linutronix.de, marex@denx.de,
        codrin.ciubotariu@microchip.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Nov 2020 12:21:03 +0100 you wrote:
> These patches are orginally from the series
> 
> "net: dsa: microchip: PTP support for KSZ956x"
> 
> As the the device tree conversion to yaml is not really related to the
> PTP patches and the original series is going to take more time than
> I expected, I would like to split this.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] dt-bindings: net: dsa: convert ksz bindings document to yaml
    https://git.kernel.org/netdev/net-next/c/4f36d97786c6
  - [net-next,2/4] net: dsa: microchip: support for "ethernet-ports" node
    https://git.kernel.org/netdev/net-next/c/44e53c88828f
  - [net-next,3/4] net: dsa: microchip: ksz9477: setup SPI mode
    https://git.kernel.org/netdev/net-next/c/9ed602bac971
  - [net-next,4/4] net: dsa: microchip: ksz8795: setup SPI mode
    https://git.kernel.org/netdev/net-next/c/8c4599f49841

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


