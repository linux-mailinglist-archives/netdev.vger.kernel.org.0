Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1779F6D8BE8
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjDFAab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjDFAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DCF65B9;
        Wed,  5 Apr 2023 17:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7426E64246;
        Thu,  6 Apr 2023 00:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DADEEC4339B;
        Thu,  6 Apr 2023 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680741021;
        bh=Mjy8xm/0wFcuxqG6ydzqqqw2VXTM8OPwMHRvyIPMi38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CkhOAlVpP28HNJPlBlTpETvxEqrWv4sAGy5Pj286JI3pVmR68T0LOnw8fKbSZPhZ2
         Yu3osC6AXfnW5PbKdSuBJrExfuaYBEE1mloJCLYnQMCkEGi3/ZdpqTglo+3SJhTtIt
         OojoyZ1ZhwI1vfNa9dhUibn46rmC0TJZ4Q4odYAei8Zhm9gAAZoy9JPUzavnB63qKg
         KCNfmpOJCpFMsQoZNuxezyZ5OlLD+tCGo15ewSccREWgNZv58apeK3S9biEva4S7Qe
         bXyR7Au83HYFdfbbWqXdnUpgdtf1zhzcOnUfpKfZp0+/mjC14zxPc16769v2w8bxmX
         JhbhvSZcYHUzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C488FC395D8;
        Thu,  6 Apr 2023 00:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/10] can: isotp: add module parameter for maximum
 pdu size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074102180.1850.14791477985441172582.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 00:30:21 +0000
References: <20230404145908.1714400-2-mkl@pengutronix.de>
In-Reply-To: <20230404145908.1714400-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Tue,  4 Apr 2023 16:58:59 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> With ISO 15765-2:2016 the PDU size is not limited to 2^12 - 1 (4095)
> bytes but can be represented as a 32 bit unsigned integer value which
> allows 2^32 - 1 bytes (~4GB). The use-cases like automotive unified
> diagnostic services (UDS) and flashing of ECUs still use the small
> static buffers which are provided at socket creation time.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] can: isotp: add module parameter for maximum pdu size
    https://git.kernel.org/netdev/net-next/c/96d1c81e6a04
  - [net-next,02/10] dt-bindings: arm: stm32: add compatible for syscon gcan node
    https://git.kernel.org/netdev/net-next/c/b341be6de98c
  - [net-next,03/10] dt-bindings: net: can: add STM32 bxcan DT bindings
    https://git.kernel.org/netdev/net-next/c/e43250c0ac81
  - [net-next,04/10] ARM: dts: stm32: add CAN support on stm32f429
    https://git.kernel.org/netdev/net-next/c/7355ad1950f4
  - [net-next,05/10] ARM: dts: stm32: add pin map for CAN controller on stm32f4
    https://git.kernel.org/netdev/net-next/c/559a6e75b4bc
  - [net-next,06/10] can: bxcan: add support for ST bxCAN controller
    https://git.kernel.org/netdev/net-next/c/f00647d8127b
  - [net-next,07/10] can: rcar_canfd: rcar_canfd_probe(): fix plain integer in transceivers[] init
    https://git.kernel.org/netdev/net-next/c/8e85d550c127
  - [net-next,08/10] dt-bindings: can: fsl,flexcan: add optional power-domains property
    https://git.kernel.org/netdev/net-next/c/066b41a599d6
  - [net-next,09/10] can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING
    https://git.kernel.org/netdev/net-next/c/c42fc3694923
  - [net-next,10/10] kvaser_usb: convert USB IDs to hexadecimal values
    https://git.kernel.org/netdev/net-next/c/1afae605e0b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


