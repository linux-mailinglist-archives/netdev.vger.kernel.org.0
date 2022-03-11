Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E894D597D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346109AbiCKEVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343705AbiCKEVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:21:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9BF1A1296;
        Thu, 10 Mar 2022 20:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C866191A;
        Fri, 11 Mar 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6813BC340EF;
        Fri, 11 Mar 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646972416;
        bh=3QD11MvBTuDHenIl8JveXTDxEIViUauETihTvCjUkHc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LUL0m4djdpyXp+spzIRYPFS2kivGoOAH/4WGETWn55+A4oEJPQNYIz1q9Ix62A+Zg
         h9LwRQyeU0nfLkaHQzClKL0NPsnR9pQrTi99UopgoT60r9MlW9f/n6zf9XLBeVFpay
         oVBgTSglgEDw2Yw4ieXmc7jIocb6SfCfR7rB075zx0I/vkB9W3jtDLh/9n3Vp1nLFj
         W9d1TzmtC5Mo5bzTpqpc+kIs6wHsn0Di7dsTRZl9rFMSpUn748VensWAqnJRxR3yJx
         sn8mlX0QSuExDePZeLgjj0U+usYPkwJzBNkEkcK9Df5hhqgorLght9eMUlD2BFUr+h
         /Xl3pqmnLpxTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D86AF0383F;
        Fri, 11 Mar 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/29] can: isotp: add local echo tx processing for
 consecutive frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697241631.8307.38445538376038915.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:20:16 +0000
References: <20220310142903.341658-2-mkl@pengutronix.de>
In-Reply-To: <20220310142903.341658-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 10 Mar 2022 15:28:35 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Instead of dumping the CAN frames into the netdevice queue the process to
> transmit consecutive frames (CF) now waits for the frame to be transmitted
> and therefore echo'ed from the CAN interface.
> 
> Link: https://lore.kernel.org/all/20220309120416.83514-1-socketcan@hartkopp.net
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/29] can: isotp: add local echo tx processing for consecutive frames
    https://git.kernel.org/netdev/net-next/c/4b7fe92c0690
  - [net-next,02/29] can: isotp: set default value for N_As to 50 micro seconds
    https://git.kernel.org/netdev/net-next/c/530e0d46c613
  - [net-next,03/29] can: isotp: set max PDU size to 64 kByte
    https://git.kernel.org/netdev/net-next/c/9c0c191d82a1
  - [net-next,04/29] vxcan: remove sk reference in peer skb
    https://git.kernel.org/netdev/net-next/c/1574481bb3de
  - [net-next,05/29] vxcan: enable local echo for sent CAN frames
    https://git.kernel.org/netdev/net-next/c/259bdba27e32
  - [net-next,06/29] can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()
    https://git.kernel.org/netdev/net-next/c/7a8cd7c0ee82
  - [net-next,07/29] dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
    https://git.kernel.org/netdev/net-next/c/d6254d52d70d
  - [net-next,08/29] can: rcar_canfd: Add support for r8a779a0 SoC
    https://git.kernel.org/netdev/net-next/c/45721c406dcf
  - [net-next,09/29] can: gs_usb: use consistent one space indention
    https://git.kernel.org/netdev/net-next/c/4c7044f3efc0
  - [net-next,10/29] can: gs_usb: fix checkpatch warning
    https://git.kernel.org/netdev/net-next/c/b9d9b030d009
  - [net-next,11/29] can: gs_usb: sort include files alphabetically
    https://git.kernel.org/netdev/net-next/c/f6bb251096bf
  - [net-next,12/29] can: gs_usb: GS_CAN_FLAG_OVERFLOW: make use of BIT()
    https://git.kernel.org/netdev/net-next/c/4b8f03e33f07
  - [net-next,13/29] can: gs_usb: rewrap error messages
    https://git.kernel.org/netdev/net-next/c/d0cd2aa83fbc
  - [net-next,14/29] can: gs_usb: rewrap usb_control_msg() and usb_fill_bulk_urb()
    https://git.kernel.org/netdev/net-next/c/c1ee72690cdd
  - [net-next,15/29] can: gs_usb: gs_make_candev(): call SET_NETDEV_DEV() after handling all bt_const->feature
    https://git.kernel.org/netdev/net-next/c/e0d25759fa91
  - [net-next,16/29] can: gs_usb: add HW timestamp mode bit
    https://git.kernel.org/netdev/net-next/c/d42d21116943
  - [net-next,17/29] can: gs_usb: update GS_CAN_FEATURE_IDENTIFY documentation
    https://git.kernel.org/netdev/net-next/c/15564f821c04
  - [net-next,18/29] can: gs_usb: document the USER_ID feature
    https://git.kernel.org/netdev/net-next/c/e0902cad4b32
  - [net-next,19/29] can: gs_usb: document the PAD_PKTS_TO_MAX_PKT_SIZE feature
    https://git.kernel.org/netdev/net-next/c/4643e34eccfc
  - [net-next,20/29] can: gs_usb: gs_usb_probe(): introduce udev and make use of it
    https://git.kernel.org/netdev/net-next/c/5374d083117c
  - [net-next,21/29] can: gs_usb: support up to 3 channels per device
    https://git.kernel.org/netdev/net-next/c/e10ab8b39405
  - [net-next,22/29] can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame
    https://git.kernel.org/netdev/net-next/c/c359931d2545
  - [net-next,23/29] can: gs_usb: add CAN-FD support
    https://git.kernel.org/netdev/net-next/c/26949ac935e3
  - [net-next,24/29] can: gs_usb: add usb quirk for NXP LPC546xx controllers
    https://git.kernel.org/netdev/net-next/c/eb9fa77a4211
  - [net-next,25/29] can: gs_usb: add quirk for CANtact Pro overlapping GS_USB_BREQ value
    https://git.kernel.org/netdev/net-next/c/32cd9013c207
  - [net-next,26/29] can: gs_usb: activate quirks for CANtact Pro unconditionally
    https://git.kernel.org/netdev/net-next/c/b00ca070e022
  - [net-next,27/29] can: gs_usb: add extended bt_const feature
    https://git.kernel.org/netdev/net-next/c/6679f4c5e5a6
  - [net-next,28/29] can: gs_usb: add VID/PID for CES CANext FD devices
    https://git.kernel.org/netdev/net-next/c/d03bb08e2be1
  - [net-next,29/29] can: gs_usb: add VID/PID for ABE CAN Debugger devices
    https://git.kernel.org/netdev/net-next/c/0691a4b55c89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


