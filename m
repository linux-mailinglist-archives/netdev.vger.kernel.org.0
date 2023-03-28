Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3F86CB493
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjC1DK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjC1DKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651112114;
        Mon, 27 Mar 2023 20:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAC4A61598;
        Tue, 28 Mar 2023 03:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EE8BC4339B;
        Tue, 28 Mar 2023 03:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679973022;
        bh=5b2uwDKv8tMhRw7PjoNG8+hyRGiiIOPEFOsPlE+wtGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZSbkzEnlQLL5qpm0KhD3lW1E5YgcYdBugYor/+p0Trip2LDtcCc0pvHPAPoFlfHKp
         f1RjVx8NeBKZxuLQkoGateiufLWS+kWmnbpDnVLbqHUyto2IEtiXv9RwZkPnJnpWV7
         Upa1unXsVuMQsu4wz8PSNMFMT07XZsa0JB9h5TayWVtQJNb4AdgdZdztIOH1eaQ+h2
         OAKBCUisQ+4W77sed9W8nJwaysX40DtbIR+Vqp60+ktbTma6o6x9lyYYzbf50NztSC
         SJw3ACMgCvVllp1EuggVlQiK0f3LQJ92yvsZi8D3OHF89TUy86JcoDW4h1oBX6bd+F
         ExJvoe21/GbtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49DCEE4D029;
        Tue, 28 Mar 2023 03:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] can: rcar_canfd: Add transceiver support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167997302229.22360.14426132499017428755.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 03:10:22 +0000
References: <20230327073354.1003134-2-mkl@pengutronix.de>
In-Reply-To: <20230327073354.1003134-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        geert+renesas@glider.be, simon.horman@corigine.com,
        mailhol.vincent@wanadoo.fr
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 27 Mar 2023 09:33:44 +0200 you wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Add support for CAN transceivers described as PHYs.
> 
> While simple CAN transceivers can do without, this is needed for CAN
> transceivers like NXP TJR1443 that need a configuration step (like
> pulling standby or enable lines), and/or impose a bitrate limit.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] can: rcar_canfd: Add transceiver support
    https://git.kernel.org/netdev/net-next/c/a0340df7eca4
  - [net-next,02/11] can: rcar_canfd: Improve error messages
    https://git.kernel.org/netdev/net-next/c/33eced402b18
  - [net-next,03/11] can: c_can: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/594503341de7
  - [net-next,04/11] can: ctucanfd: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/c9d23f9657ca
  - [net-next,05/11] can: kvaser_pciefd: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/8db931835fad
  - [net-next,06/11] can: esd_usb: Improve code readability by means of replacing struct esd_usb_msg with a union
    https://git.kernel.org/netdev/net-next/c/a57915aee315
  - [net-next,07/11] can: m_can: Remove repeated check for is_peripheral
    https://git.kernel.org/netdev/net-next/c/73042934e4a3
  - [net-next,08/11] can: m_can: Always acknowledge all interrupts
    https://git.kernel.org/netdev/net-next/c/4ab639480900
  - [net-next,09/11] can: m_can: Remove double interrupt enable
    https://git.kernel.org/netdev/net-next/c/71725bfdbbf2
  - [net-next,10/11] can: m_can: Disable unused interrupts
    https://git.kernel.org/netdev/net-next/c/897e663218e2
  - [net-next,11/11] can: m_can: Keep interrupts enabled during peripheral read
    https://git.kernel.org/netdev/net-next/c/9083e0b09df3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


