Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F325355E1A7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiF0KuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiF0KuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45FC62E0;
        Mon, 27 Jun 2022 03:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B57761359;
        Mon, 27 Jun 2022 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B72C0C341C7;
        Mon, 27 Jun 2022 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656327017;
        bh=8LxALkYX99QM0o3OZgiKgB0ILjh8O2RMDXaPQIHDGUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mcSm99tpafBJecQ/I28UXwi0I5xqsZKQLuRriUF/iDPwE/EgWmjNAtNJakzD9w9gt
         EVhCwLH/ujOiWejPqgmTGSQWqt+t4Hs6ydYu2eySUQjAC/fZ/PEhe+gReMco8Kh9I3
         xcA2dWf+XIuItslFOzZaAgO1I3MtkiT/7if+F0beNz10j0M0Ph05IH7fbB7sHi/WwB
         ObNhdNvX1mjgd9I37Scd1YvXo6I0hjxSA65z0cQtsxvz83yTV4zGVcr9MSZfxki8t0
         AzcsI1YE39xOGwNaCnGR5P7eNSiy4tXH88tKdBxdQJhaJW/q2czsmSGIm8AkzeJ9p7
         mV7xKm3AxW0yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99722E49BBB;
        Mon, 27 Jun 2022 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9 00/16] add support for Renesas RZ/N1 ethernet
 subsystem devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632701762.8538.13185906941735942250.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 10:50:17 +0000
References: <20220624144001.95518-1-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, geert+renesas@glider.be, magnus.damm@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, thomas.petazzoni@bootlin.com,
        herve.codina@bootlin.com, miquel.raynal@bootlin.com,
        milan.stevanovic@se.com, jimmy.lalande@se.com,
        pascal.eberhard@se.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Jun 2022 16:39:45 +0200 you wrote:
> The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> (most notably) a switch, two GMACs, and a MII converter [1]. This
> series adds support for the switch and the MII converter.
> 
> The MII converter present on this SoC has been represented as a PCS
> which sit between the MACs and the PHY. This PCS driver is probed from
> the device-tree since it requires to be configured. Indeed the MII
> converter also contains the registers that are handling the muxing of
> ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> 
> [...]

Here is the summary with links:
  - [net-next,v9,01/16] net: dsa: allow port_bridge_join() to override extack message
    https://git.kernel.org/netdev/net-next/c/1c6e8088d9a7
  - [net-next,v9,02/16] net: dsa: add support for ethtool get_rmon_stats()
    https://git.kernel.org/netdev/net-next/c/67f38b1c7324
  - [net-next,v9,03/16] net: dsa: add Renesas RZ/N1 switch tag driver
    https://git.kernel.org/netdev/net-next/c/a08d6a6dc820
  - [net-next,v9,04/16] dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
    https://git.kernel.org/netdev/net-next/c/c823c2bf9156
  - [net-next,v9,05/16] net: pcs: add Renesas MII converter driver
    https://git.kernel.org/netdev/net-next/c/7dc54d3b8d91
  - [net-next,v9,06/16] dt-bindings: net: dsa: add bindings for Renesas RZ/N1 Advanced 5 port switch
    https://git.kernel.org/netdev/net-next/c/8956e96c1d4d
  - [net-next,v9,07/16] net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver
    https://git.kernel.org/netdev/net-next/c/888cdb892b61
  - [net-next,v9,08/16] net: dsa: rzn1-a5psw: add statistics support
    https://git.kernel.org/netdev/net-next/c/c7243fd4a62f
  - [net-next,v9,09/16] net: dsa: rzn1-a5psw: add FDB support
    https://git.kernel.org/netdev/net-next/c/5edf246c6869
  - [net-next,v9,10/16] dt-bindings: net: snps,dwmac: add "power-domains" property
    https://git.kernel.org/netdev/net-next/c/955fe312a9d2
  - [net-next,v9,11/16] dt-bindings: net: snps,dwmac: add "renesas,rzn1" compatible
    https://git.kernel.org/netdev/net-next/c/d7cc14bc9802
  - [net-next,v9,12/16] ARM: dts: r9a06g032: describe MII converter
    https://git.kernel.org/netdev/net-next/c/066c3bd35835
  - [net-next,v9,13/16] ARM: dts: r9a06g032: describe GMAC2
    https://git.kernel.org/netdev/net-next/c/3f5261f1c2a8
  - [net-next,v9,14/16] ARM: dts: r9a06g032: describe switch
    https://git.kernel.org/netdev/net-next/c/cf9695d8a7e9
  - [net-next,v9,15/16] ARM: dts: r9a06g032-rzn1d400-db: add switch description
    https://git.kernel.org/netdev/net-next/c/9aab31d66ec9
  - [net-next,v9,16/16] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
    https://git.kernel.org/netdev/net-next/c/717a5c56deec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


