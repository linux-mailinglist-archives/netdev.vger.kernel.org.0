Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2780C57B3DA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbiGTJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiGTJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BCB205C0;
        Wed, 20 Jul 2022 02:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C454361B36;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24D83C341CA;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658309421;
        bh=LBvkA7/grsrPitI5UhkZxFyHe3jePMr6XLA6REDTzQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MhcCnNPzUWUfifcgfOaIM/+mDQH7nsyKEQb+UvxP7Twqua2JGAOsvcv3UZsdjmXjB
         HV3kCuV6lLnIrz+j6McXH2obVXp2DOVLeqnH5Iglw6Gze0RHdprzfatIEfG2AYaeSN
         07wS/oDgcLH8EdzohL0LTe+2d9NjIZCFXFo/EpeNPKaFYJ6cNv6raL8Jp7veq2Wt/d
         x/rZcWprJ2jnq6O/WbWfPm91GcW43g/7Ora7nD7eEHIfi8yS8NyZD/P40zlTM2tLgC
         8JnONi3BCDM9vZr2oxAtEfK40yhgPczbJoESv4goyS3L/IQeFDv/ElHAFFofRtHaSV
         hhsIJMXw5NIsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E8F7E451B3;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/29] can: slcan: use scnprintf() as a hardening
 measure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165830942105.20880.1809860032673593964.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 09:30:21 +0000
References: <20220720081034.3277385-2-mkl@pengutronix.de>
In-Reply-To: <20220720081034.3277385-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 20 Jul 2022 10:10:06 +0200 you wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> The snprintf() function returns the number of bytes which *would* have
> been copied if there were no space. So, since this code does not check
> the return value, there if the buffer was not large enough then there
> would be a buffer overflow two lines later when it does:
> 
> [...]

Here is the summary with links:
  - [net-next,01/29] can: slcan: use scnprintf() as a hardening measure
    https://git.kernel.org/netdev/net-next/c/0159a9305d40
  - [net-next,02/29] can: slcan: convert comments to network style comments
    https://git.kernel.org/netdev/net-next/c/71f3a4cc740a
  - [net-next,03/29] can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
    https://git.kernel.org/netdev/net-next/c/ded5fa885b2d
  - [net-next,04/29] can: slcan: fix whitespace issues
    https://git.kernel.org/netdev/net-next/c/f07d9e3c849b
  - [net-next,05/29] can: slcan: convert comparison to NULL into !val
    https://git.kernel.org/netdev/net-next/c/69a6539632dd
  - [net-next,06/29] can: slcan: clean up if/else
    https://git.kernel.org/netdev/net-next/c/18de712a5802
  - [net-next,07/29] dt-bindings: can: sja1000: Convert to json-schema
    https://git.kernel.org/netdev/net-next/c/f6b8061db9af
  - [net-next,08/29] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
    https://git.kernel.org/netdev/net-next/c/4591c760b797
  - [net-next,09/29] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
    https://git.kernel.org/netdev/net-next/c/2d99bfbf3386
  - [net-next,10/29] can: sja1000: Use device_get_match_data to get device data
    https://git.kernel.org/netdev/net-next/c/63ab1b63695e
  - [net-next,11/29] can: sja1000: Change the return type as void for SoC specific init
    https://git.kernel.org/netdev/net-next/c/6d5fe10796bb
  - [net-next,12/29] can: slcan: do not sleep with a spin lock held
    https://git.kernel.org/netdev/net-next/c/c6887023268e
  - [net-next,13/29] can: c_can: remove wrong comment
    https://git.kernel.org/netdev/net-next/c/4940eb51fc49
  - [net-next,14/29] can: ctucanfd: Update CTU CAN FD IP core registers to match version 3.x.
    https://git.kernel.org/netdev/net-next/c/9e7c9b8eb719
  - [net-next,15/29] can: peak_usb: pcan_dump_mem(): mark input prompt and data pointer as const
    https://git.kernel.org/netdev/net-next/c/92505df464ff
  - [net-next,16/29] can: peak_usb: correction of an initially misnamed field name
    https://git.kernel.org/netdev/net-next/c/a0cf2fe6cf2e
  - [net-next,17/29] can: peak_usb: include support for a new MCU
    https://git.kernel.org/netdev/net-next/c/4f232482467a
  - [net-next,18/29] can: pch_can: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/3a5c7e4611dd
  - [net-next,19/29] can: rcar_can: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/a37b7245e831
  - [net-next,20/29] can: sja1000: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/164d7cb2d5a3
  - [net-next,21/29] can: slcan: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/ce0e7aeb676b
  - [net-next,22/29] can: hi311x: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/a22bd630cfff
  - [net-next,23/29] can: sun4i_can: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/0ac15a8f661b
  - [net-next,24/29] can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/936e90595376
  - [net-next,25/29] can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/a57732084e06
  - [net-next,26/29] can: usb_8dev: do not report txerr and rxerr during bus-off
    https://git.kernel.org/netdev/net-next/c/aebe8a2433cd
  - [net-next,27/29] can: error: specify the values of data[5..7] of CAN error frames
    https://git.kernel.org/netdev/net-next/c/e70a3263a7ee
  - [net-next,28/29] can: add CAN_ERR_CNT flag to notify availability of error counter
    https://git.kernel.org/netdev/net-next/c/3e5c291c7942
  - [net-next,29/29] can: error: add definitions for the different CAN error thresholds
    https://git.kernel.org/netdev/net-next/c/3f9c26210cf8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


