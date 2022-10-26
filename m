Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77760E160
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiJZNAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiJZNAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F041E688A6;
        Wed, 26 Oct 2022 06:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E07D61EBB;
        Wed, 26 Oct 2022 13:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB0C7C433C1;
        Wed, 26 Oct 2022 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666789222;
        bh=1er536WIQpRb9kmkTNARefOgWVYoxav06rvZa3g9Xuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gz4K50qqJ5xnRSAqOYXO+shxioJyZk34UakBG5y8DC2D19YmKyVbfwU7dsWGKY4iy
         mRbOh0P+vlRLzzbc68oHcKQvV/3fCX5+dFXn4w6+/0Ugw4iLX3T08tdTEANBsm6QOt
         CXua/MlZxUzlsBZheaZeWpOKvQShS0DwrcNZHWYwm4FgZLKQBN/vXKA4FHIZ++ninP
         G/CEoS6JSbyeCpwuFKh2SEDQ7cQdr6edrzREUtt7CrN8lp8FrF8v2zA909xku9ItIR
         shkkMKunlXDUD5CUPy2INH3ys76wFltxrMWdWuXaFd9VO5gwhD9HYt1DweBowPfyEw
         eCdBusn/K5SAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C446DE270DB;
        Wed, 26 Oct 2022 13:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/29] can: add termination resistor documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166678922279.29060.2518413007329149073.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 13:00:22 +0000
References: <20221026084007.1583333-2-mkl@pengutronix.de>
In-Reply-To: <20221026084007.1583333-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, dan@sstrev.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Oct 2022 10:39:39 +0200 you wrote:
> From: "Daniel S. Trevitz" <dan@sstrev.com>
> 
> Add documentation for how to use and setup the switchable termination
> resistor support for CAN controllers.
> 
> Signed-off-by: Daniel Trevitz <dan@sstrev.com>
> Link: https://lore.kernel.org/all/3441354.44csPzL39Z@daniel6430
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/29] can: add termination resistor documentation
    https://git.kernel.org/netdev/net-next/c/85700ac19aa1
  - [net-next,02/29] can: j1939: j1939_session_tx_eoma(): fix debug info
    https://git.kernel.org/netdev/net-next/c/de1deb156970
  - [net-next,03/29] can: remove obsolete PCH CAN driver
    https://git.kernel.org/netdev/net-next/c/1dd1b521be85
  - [net-next,04/29] can: ucan: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
    https://git.kernel.org/netdev/net-next/c/b2df8a1bc303
  - [net-next,05/29] can: kvaser_usb: Remove -Warray-bounds exception
    https://git.kernel.org/netdev/net-next/c/26117d92d001
  - [net-next,06/29] can: m_can: is_lec_err(): clean up LEC error handling
    https://git.kernel.org/netdev/net-next/c/6a8836e3c24a
  - [net-next,07/29] can: m_can: m_can_handle_bus_errors(): add support for handling DLEC error on CAN-FD frames
    https://git.kernel.org/netdev/net-next/c/f5071d9e729d
  - [net-next,08/29] can: gs_usb: mention candleLight as supported device
    https://git.kernel.org/netdev/net-next/c/b1419cbebf5d
  - [net-next,09/29] can: gs_usb: gs_make_candev(): set netdev->dev_id
    https://git.kernel.org/netdev/net-next/c/acff76fa45b4
  - [net-next,10/29] can: gs_usb: gs_can_open(): allow loopback and listen only at the same time
    https://git.kernel.org/netdev/net-next/c/deb8534e8ef3
  - [net-next,11/29] can: gs_usb: gs_can_open(): sort checks for ctrlmode
    https://git.kernel.org/netdev/net-next/c/f6adf410f70b
  - [net-next,12/29] can: gs_usb: gs_can_open(): merge setting of timestamp flags and init
    https://git.kernel.org/netdev/net-next/c/ac3f25824e4f
  - [net-next,13/29] can: gs_usb: document GS_CAN_FEATURE_BERR_REPORTING
    https://git.kernel.org/netdev/net-next/c/1f1835264d81
  - [net-next,14/29] can: gs_usb: add ability to enable / disable berr reporting
    https://git.kernel.org/netdev/net-next/c/2f3cdad1c616
  - [net-next,15/29] can: gs_usb: document GS_CAN_FEATURE_GET_STATE
    https://git.kernel.org/netdev/net-next/c/40e1997d4551
  - [net-next,16/29] can: gs_usb: add support for reading error counters
    https://git.kernel.org/netdev/net-next/c/0c9f92a4b795
  - [net-next,17/29] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
    https://git.kernel.org/netdev/net-next/c/35364f5b41a4
  - [net-next,18/29] can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
    https://git.kernel.org/netdev/net-next/c/7ea56128dbf9
  - [net-next,19/29] can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
    https://git.kernel.org/netdev/net-next/c/b24cb2d169e0
  - [net-next,20/29] can: kvaser_usb_leaf: Set Warning state even without bus errors
    https://git.kernel.org/netdev/net-next/c/df1b7af2761b
  - [net-next,21/29] can: kvaser_usb_leaf: Fix improved state not being reported
    https://git.kernel.org/netdev/net-next/c/8d21f5927ae6
  - [net-next,22/29] can: kvaser_usb_leaf: Fix wrong CAN state after stopping
    https://git.kernel.org/netdev/net-next/c/a11249acf802
  - [net-next,23/29] can: kvaser_usb_leaf: Ignore stale bus-off after start
    https://git.kernel.org/netdev/net-next/c/abb8670938b2
  - [net-next,24/29] can: kvaser_usb_leaf: Fix bogus restart events
    https://git.kernel.org/netdev/net-next/c/90904d326269
  - [net-next,25/29] can: kvaser_usb: Add struct kvaser_usb_busparams
    https://git.kernel.org/netdev/net-next/c/00e578617764
  - [net-next,26/29] can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming
    https://git.kernel.org/netdev/net-next/c/39d3df6b0ea8
  - [net-next,27/29] can: m_can: use consistent indention
    https://git.kernel.org/netdev/net-next/c/4aeb91880999
  - [net-next,28/29] can: ucan: ucan_disconnect(): change unregister_netdev() to unregister_candev()
    https://git.kernel.org/netdev/net-next/c/aa9832e45012
  - [net-next,29/29] can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
    https://git.kernel.org/netdev/net-next/c/68399ff574e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


