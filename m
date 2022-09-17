Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97955BBA15
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiIQTU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 15:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIQTUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 15:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4EC275DD;
        Sat, 17 Sep 2022 12:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D69F61170;
        Sat, 17 Sep 2022 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDD91C433D6;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663442421;
        bh=pB2NqJ7QmQ/SLGKnl5hY2V8z0YYnFa2HOjbqxxEJKVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YrsLYdOIT2FEvNwL3Uz5NfCZUS8II0TmKlWFMDVBQPXXRjBq2O9mLP60FdEHhkW/v
         gd0hbO9lokNH45XVspkPLpOIXW7QUkKvw+UThSCbKsTFxMg1WnVg+cP9pJX7wdOTsS
         6crSCLG/QhsurkN+EsGNjU4IFJA93fJNPFFMTcj/Jx12xilJ9And5yoIHnVz4O2U8C
         Qh1HyxR2hniW8seEzV4vLserNY/ECoISekM7o75YZz0PwIv8pJYVJgiW0nBU0KsGJR
         dIyh4er6/UWGkpB1klzdLymQa2qN4/oqSU93Yu1PWD7oFZpxySGlFDOXBczyN0OqyC
         5aCVwAtFu+reg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2CF3C74000;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/23] can: rx-offload: can_rx_offload_init_queue():
 fix typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166344242172.31603.16282918738271793500.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Sep 2022 19:20:21 +0000
References: <20220915082013.369072-2-mkl@pengutronix.de>
In-Reply-To: <20220915082013.369072-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 15 Sep 2022 10:19:51 +0200 you wrote:
> Fix typo "rounted" -> "rounded".
> 
> Link: https://lore.kernel.org/all/20220811093617.1861938-2-mkl@pengutronix.de
> Fixes: d254586c3453 ("can: rx-offload: Add support for HW fifo based irq offloading")
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/23] can: rx-offload: can_rx_offload_init_queue(): fix typo
    https://git.kernel.org/netdev/net-next/c/766108d91246
  - [net-next,02/23] can: flexcan: fix typo: FLEXCAN_QUIRK_SUPPPORT_* -> FLEXCAN_QUIRK_SUPPORT_*
    https://git.kernel.org/netdev/net-next/c/d945346db1ef
  - [net-next,03/23] can: rcar_canfd: Use dev_err_probe() to simplify code and better handle -EPROBE_DEFER
    https://git.kernel.org/netdev/net-next/c/ddbbed25309f
  - [net-next,04/23] can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for allocating only one element
    https://git.kernel.org/netdev/net-next/c/00784da3e6b8
  - [net-next,05/23] dt-bindings: can: nxp,sja1000: Document RZ/N1 power-domains support
    https://git.kernel.org/netdev/net-next/c/f4dda24432d7
  - [net-next,06/23] can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller
    https://git.kernel.org/netdev/net-next/c/0838921bb409
  - [net-next,07/23] can: sja1000: remove redundant variable ret
    https://git.kernel.org/netdev/net-next/c/3a71eba64c9c
  - [net-next,08/23] can: kvaser_pciefd: remove redundant variable ret
    https://git.kernel.org/netdev/net-next/c/7912fc9905ff
  - [net-next,09/23] can: gs_usb: use common spelling of GS_USB in macros
    https://git.kernel.org/netdev/net-next/c/49c007b9ecea
  - [net-next,10/23] can: gs_usb: add RX and TX hardware timestamp support
    https://git.kernel.org/netdev/net-next/c/45dfa45f52e6
  - [net-next,11/23] can: etas_es58x: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
    https://git.kernel.org/netdev/net-next/c/6fc5d84e6d85
  - [net-next,12/23] dt-bindings: net: can: nxp,sja1000: drop ref from reg-io-width
    https://git.kernel.org/netdev/net-next/c/2a50db2656e0
  - [net-next,13/23] docs: networking: device drivers: flexcan: fix invalid email
    https://git.kernel.org/netdev/net-next/c/318d8235bcb8
  - [net-next,14/23] can: raw: process optimization in raw_init()
    https://git.kernel.org/netdev/net-next/c/c28b3bffe49e
  - [net-next,15/23] can: raw: use guard clause to optimize nesting in raw_rcv()
    https://git.kernel.org/netdev/net-next/c/170277c53278
  - [net-next,16/23] can: flexcan: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/1c679f917397
  - [net-next,17/23] can: skb: unify skb CAN frame identification helpers
    https://git.kernel.org/netdev/net-next/c/96a7457a14d9
  - [net-next,18/23] can: skb: add skb CAN frame data length helpers
    https://git.kernel.org/netdev/net-next/c/467ef4c7b9d1
  - [net-next,19/23] can: set CANFD_FDF flag in all CAN FD frame structures
    https://git.kernel.org/netdev/net-next/c/061834624c87
  - [net-next,20/23] can: canxl: introduce CAN XL data structure
    https://git.kernel.org/netdev/net-next/c/1a3e3034c049
  - [net-next,21/23] can: canxl: update CAN infrastructure for CAN XL frames
    https://git.kernel.org/netdev/net-next/c/fb08cba12b52
  - [net-next,22/23] can: dev: add CAN XL support to virtual CAN
    https://git.kernel.org/netdev/net-next/c/ebf87fc72850
  - [net-next,23/23] can: raw: add CAN XL support
    https://git.kernel.org/netdev/net-next/c/626332696d75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


