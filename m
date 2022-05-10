Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6752116D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiEJJyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiEJJyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:54:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97B42A18BD;
        Tue, 10 May 2022 02:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A39461469;
        Tue, 10 May 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ED27C385C8;
        Tue, 10 May 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652176212;
        bh=H6NMXPkJDcWXHo7oQQZT0n+rj3So1Vt3NIL3g1YcJgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jEHU9K6ACpbRgDExuX1pAZ7LVQ01YW50DEFFrwgHkKfFE73UHj/egV3NAAewkal7V
         2cvfIzy8iKFZO/9vv8pUzkx1e6f+Gkilb7mFVPX1UoOuucdvb1hvJTiYZ/aLx822zv
         tU6PzfdbG6driMiShEONePTI5xvoSdWh0ayEwnGB5myJoYfO9tb6q4BCoE3e9iWqRV
         /JQ/F0ezsS4eqMudFTLwO90SIvvI2dOC1yId6TabdVUwyqoGb9W7o25clbyKAs1sKN
         pE8FKmIZRdEDKhzCNhARqOmZkKm4qpGVTARXWrn2XJ1cIzPBd1a8X822476+Rc1pqO
         wf/yhu1UtUu9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49256E8DCCE;
        Tue, 10 May 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 0/2] This is a patch series for Ethernet driver
 of Sunplus SP7021 SoC.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165217621229.17405.4440742282604327822.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 09:50:12 +0000
References: <1652004800-3212-1-git-send-email-wellslutw@gmail.com>
In-Reply-To: <1652004800-3212-1-git-send-email-wellslutw@gmail.com>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com, wells.lu@sunplus.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  8 May 2022 18:13:18 +0800 you wrote:
> Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
> many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
> etc.) into a single chip. It is designed for industrial control
> applications.
> 
> Refer to:
> https://sunplus.atlassian.net/wiki/spaces/doc/overview
> https://tibbo.com/store/plus1.html
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
    https://git.kernel.org/netdev/net-next/c/0cfeca62b56a
  - [net-next,v11,2/2] net: ethernet: Add driver for Sunplus SP7021
    https://git.kernel.org/netdev/net-next/c/fd3040b9394c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


