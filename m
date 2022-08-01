Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FFF5867D1
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiHAKuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiHAKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C6A38AD;
        Mon,  1 Aug 2022 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB71E60C2B;
        Mon,  1 Aug 2022 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 410FEC433C1;
        Mon,  1 Aug 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659351019;
        bh=2qnbqxAJWolh3lYMI94lhhm7ryew4kcmAlrTARC98G8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MXT1GNSbhjDDRnO4vfWMUqqSYPp/rxTvEnuFTwYmEJX/Nr8+nTgz+Ff5OUs3wZAGy
         TXwspVhgT9NI2pn6XH8VlLV/SsFfZiCFWK1duzKwM6IOluSoT2wrMcXyYCTEjpjC/J
         HqeIbEdg7U2x7mXdCBaJYIM0tPBDQ0xw2WNrm+77VbqOAq6O0mtNhDQYM0biK4AI2J
         U44miqiwpLQ3Ssp9Hvz27liiMPn6+in7W9H+lXAIuDbB4tGmIdGb1PHVZlX/R7uJKz
         rk+xPqIaOK4unzp20dYxhdakcRx61DX6B/oINVFoI6PEgTmpeZ+NBk1JcfvJ8yEUTZ
         IOJ8+janyBVgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DE81C43143;
        Mon,  1 Aug 2022 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/36] can: mcp251xfd: mcp251xfd_dump(): fix comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935101918.27984.4155329019875098901.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 10:50:19 +0000
References: <20220731192029.746751-2-mkl@pengutronix.de>
In-Reply-To: <20220731192029.746751-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 31 Jul 2022 21:19:54 +0200 you wrote:
> The driver uses only 1 TEF and 1 TX ring, but a variable number of RX
> rings. Fix comment accordingly.
> 
> Fixes: e0ab3dd5f98f ("can: mcp251xfd: add dev coredump support")
> Link: https://lore.kernel.org/all/20220726084328.4042678-1-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/36] can: mcp251xfd: mcp251xfd_dump(): fix comment
    https://git.kernel.org/netdev/net-next/c/1dba745ca8c6
  - [net-next,02/36] can: can327: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/63fe85678933
  - [net-next,03/36] can: ems_usb: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/f60df831d4c4
  - [net-next,04/36] can: softing: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/90a13aec104d
  - [net-next,05/36] can: esd_usb: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/4741b3aedc11
  - [net-next,06/36] can: gs_ubs: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/c250d5eb2225
  - [net-next,07/36] can: kvaser_usb: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/63c286e60892
  - [net-next,08/36] can: ubs_8dev: use KBUILD_MODNAME instead of hard coded names
    https://git.kernel.org/netdev/net-next/c/6f2660607282
  - [net-next,09/36] can: etas_es58x: replace ES58X_MODULE_NAME with KBUILD_MODNAME
    https://git.kernel.org/netdev/net-next/c/1190f520826a
  - [net-next,10/36] can: etas_es58x: remove DRV_VERSION
    https://git.kernel.org/netdev/net-next/c/ddbce345f194
  - [net-next,11/36] can: slcan: export slcan_ethtool_ops and remove slcan_set_ethtool_ops()
    https://git.kernel.org/netdev/net-next/c/1851532fd39c
  - [net-next,12/36] can: c_can: export c_can_ethtool_ops and remove c_can_set_ethtool_ops()
    https://git.kernel.org/netdev/net-next/c/0ccb3e0b0a00
  - [net-next,13/36] can: flexcan: export flexcan_ethtool_ops and remove flexcan_set_ethtool_ops()
    https://git.kernel.org/netdev/net-next/c/b4b97079a49e
  - [net-next,14/36] can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
    https://git.kernel.org/netdev/net-next/c/e2c9bb0297a3
  - [net-next,15/36] can: slcan: remove useless header inclusions
    https://git.kernel.org/netdev/net-next/c/7a1fc3eea76f
  - [net-next,16/36] can: slcan: remove legacy infrastructure
    https://git.kernel.org/netdev/net-next/c/cfcb4465e992
  - [net-next,17/36] can: slcan: change every `slc' occurrence in `slcan'
    https://git.kernel.org/netdev/net-next/c/0cef03b109ca
  - [net-next,18/36] can: slcan: use the generic can_change_mtu()
    https://git.kernel.org/netdev/net-next/c/341c5724d7a1
  - [net-next,19/36] can: slcan: add support for listen-only mode
    https://git.kernel.org/netdev/net-next/c/3e720131960b
  - [net-next,20/36] MAINTAINERS: Add maintainer for the slcan driver
    https://git.kernel.org/netdev/net-next/c/4aeccfd84d28
  - [net-next,21/36] can: can327: add software tx timestamps
    https://git.kernel.org/netdev/net-next/c/303066fc5a49
  - [net-next,22/36] can: janz-ican3: add software tx timestamp
    https://git.kernel.org/netdev/net-next/c/221d14bd3d2e
  - [net-next,23/36] can: slcan: add software tx timestamps
    https://git.kernel.org/netdev/net-next/c/6153a7ea650f
  - [net-next,24/36] can: v(x)can: add software tx timestamps
    https://git.kernel.org/netdev/net-next/c/6a37a28b1864
  - [net-next,25/36] can: tree-wide: advertise software timestamping capabilities
    https://git.kernel.org/netdev/net-next/c/409c188c57cd
  - [net-next,26/36] can: dev: add hardware TX timestamp
    https://git.kernel.org/netdev/net-next/c/8bdd1112edcd
  - [net-next,27/36] can: dev: add generic function can_ethtool_op_get_ts_info_hwts()
    https://git.kernel.org/netdev/net-next/c/7fb48d25b5ce
  - [net-next,28/36] can: dev: add generic function can_eth_ioctl_hwts()
    https://git.kernel.org/netdev/net-next/c/90f942c5a6d7
  - [net-next,29/36] can: mcp251xfd: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/b1f6b93e678f
  - [net-next,30/36] can: etas_es58x: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/1d46efa0008a
  - [net-next,31/36] can: kvaser_pciefd: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/fa5cc7e115d7
  - [net-next,32/36] can: kvaser_usb: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/1d5eeda23f36
  - [net-next,33/36] can: peak_canfd: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/8ba09bfa2b08
  - [net-next,34/36] can: peak_usb: advertise timestamping capabilities and add ioctl support
    https://git.kernel.org/netdev/net-next/c/bedd94835a35
  - [net-next,35/36] can: etas_es58x: remove useless calls to usb_fill_bulk_urb()
    https://git.kernel.org/netdev/net-next/c/e0f3907b3901
  - [net-next,36/36] can: can327: fix a broken link to Documentation
    https://git.kernel.org/netdev/net-next/c/7b584fbb3636

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


