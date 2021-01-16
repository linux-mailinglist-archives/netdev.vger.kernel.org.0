Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7444B2F8B19
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbhAPELA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPEK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 23:10:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D861923A5E;
        Sat, 16 Jan 2021 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610770218;
        bh=St+LTBEs53MpkSacwmF8+eangs0K8pKh/u0cVIgXcUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KzrgKmiMaXYh8rguH/diInbPzrEffsjLHXCxb4nLjMh7HmQB/DQttQrbK/11b+VaU
         ceVTXESqLjWgARcWVLSQM+I/NsajKHkjE457cA+IN6DZgfaLViVvzkylNAjoEKqpoZ
         YtJxZo8CkLfduXebx9w46NVU2D3SooNHJK874LmiRi9IIzY4joGmHwt8IVkoIWLEX9
         BgQusoL2oc/xaSCLzcKDi79r2W1gasqacHGQZdwCNNua22dSTEi657uElMv2yQLnhW
         DObm+m/68qt+krxOAj5yTB1o1m+kad2EtKPsF1jSK2x+rfDCJSYxU2tTcQZ7ur9aPT
         /RsxT3x+yfTdg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B7F22605AB;
        Sat, 16 Jan 2021 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 00/10] Configuring congestion watermarks on ocelot
 switch using devlink-sb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161077021874.21538.9730914490384728652.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 04:10:18 +0000
References: <20210115021120.3055988-1-olteanv@gmail.com>
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 04:11:10 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In some applications, it is important to create resource reservations in
> the Ethernet switches, to prevent background traffic, or deliberate
> attacks, from inducing denial of service into the high-priority traffic.
> 
> These patches give the user some knobs to turn. The ocelot switches
> support per-port and per-port-tc reservations, on ingress and on egress.
> The resources that are monitored are packet buffers (in cells of 60
> bytes each) and frame references.
> 
> [...]

Here is the summary with links:
  - [v6,net-next,01/10] net: mscc: ocelot: auto-detect packet buffer size and number of frame references
    https://git.kernel.org/netdev/net-next/c/f6fe01d6fa24
  - [v6,net-next,02/10] net: mscc: ocelot: add ops for decoding watermark threshold and occupancy
    https://git.kernel.org/netdev/net-next/c/703b762190e6
  - [v6,net-next,03/10] net: dsa: add ops for devlink-sb
    https://git.kernel.org/netdev/net-next/c/2a6ef7630372
  - [v6,net-next,04/10] net: dsa: felix: reindent struct dsa_switch_ops
    https://git.kernel.org/netdev/net-next/c/a7096915e427
  - [v6,net-next,05/10] net: dsa: felix: perform teardown in reverse order of setup
    https://git.kernel.org/netdev/net-next/c/d19741b0f544
  - [v6,net-next,06/10] net: mscc: ocelot: export NUM_TC constant from felix to common switch lib
    https://git.kernel.org/netdev/net-next/c/70d39a6e62d3
  - [v6,net-next,07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
    https://git.kernel.org/netdev/net-next/c/c6c65d47ddeb
  - [v6,net-next,08/10] net: mscc: ocelot: register devlink ports
    https://git.kernel.org/netdev/net-next/c/6c30384eb1de
  - [v6,net-next,09/10] net: mscc: ocelot: initialize watermarks to sane defaults
    https://git.kernel.org/netdev/net-next/c/a4ae997adcbd
  - [v6,net-next,10/10] net: mscc: ocelot: configure watermarks using devlink-sb
    https://git.kernel.org/netdev/net-next/c/f59fd9cab730

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


