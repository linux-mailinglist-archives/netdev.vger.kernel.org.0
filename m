Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCC564730
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiGCLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGCLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 07:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E8063BB;
        Sun,  3 Jul 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8101461300;
        Sun,  3 Jul 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4DECC341CD;
        Sun,  3 Jul 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656848415;
        bh=U+mhikf+YwvzpoOo8QWKoxBeJJvHHtGu4iUOOfxgvi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vFPh5RWFg4mab5ju83IZoTGbslXm6gTQ50id9RRMYLLUVEcsh+1pjaCKjq2vhX/Pm
         /IThDyWc+HOvxz9fTaQK3U8BPfsgLqPuBJ12AGeVKgKjf+mLr/PWXphqGfQat80RKD
         n69+jj1PAwwb3zvBn89dUBHo7XFievlWYGP96zCl24OzoyzkQEhYK5/4S4vjN7DuYK
         q+CPugNe6TXPmV5spnHAl9X74iN7VoXdfI039ntyCzM70juiTbZjDvSdqiwfK72ENK
         ZGbMZaEYSyB37jHzn1b74JTi2nLkgXp+Vskzbx0GHuG7TWMhETnG5U1+hBILL/b2uN
         2K0UPn0jVTyVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF429E49FA1;
        Sun,  3 Jul 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] tty: Add N_CAN327 line discipline ID for
 ELM327 based CAN driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165684841577.4107.12545012231996753529.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Jul 2022 11:40:15 +0000
References: <20220703101430.1306048-2-mkl@pengutronix.de>
In-Reply-To: <20220703101430.1306048-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, max@enpas.org,
        gregkh@linuxfoundation.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  3 Jul 2022 12:14:15 +0200 you wrote:
> From: Max Staudt <max@enpas.org>
> 
> The actual driver will be added via the CAN tree.
> 
> Link: https://lore.kernel.org/all/20220618180134.9890-1-max@enpas.org
> Link: https://lore.kernel.org/all/Yrm9Ezlw1dLmIxyS@kroah.com
> Signed-off-by: Max Staudt <max@enpas.org>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] tty: Add N_CAN327 line discipline ID for ELM327 based CAN driver
    https://git.kernel.org/netdev/net-next/c/713eb3c1261a
  - [net-next,02/15] can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters
    https://git.kernel.org/netdev/net-next/c/43da2f07622f
  - [net-next,03/15] can: ctucanfd: ctucan_interrupt(): fix typo
    https://git.kernel.org/netdev/net-next/c/50f2944009a2
  - [net-next,04/15] can: slcan: use the BIT() helper
    https://git.kernel.org/netdev/net-next/c/3cd864901bc5
  - [net-next,05/15] can: slcan: use netdev helpers to print out messages
    https://git.kernel.org/netdev/net-next/c/da6788ea025c
  - [net-next,06/15] can: slcan: use the alloc_can_skb() helper
    https://git.kernel.org/netdev/net-next/c/92a31782c848
  - [net-next,07/15] can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
    https://git.kernel.org/netdev/net-next/c/036bff2800cb
  - [net-next,08/15] can: slcan: use CAN network device driver API
    https://git.kernel.org/netdev/net-next/c/c4e54b063f42
  - [net-next,09/15] can: slcan: allow to send commands to the adapter
    https://git.kernel.org/netdev/net-next/c/52f9ac85b876
  - [net-next,10/15] can: slcan: set bitrate by CAN device driver API
    https://git.kernel.org/netdev/net-next/c/dca796299462
  - [net-next,11/15] can: slcan: send the open/close commands to the adapter
    https://git.kernel.org/netdev/net-next/c/5bac315be7eb
  - [net-next,12/15] can: slcan: move driver into separate sub directory
    https://git.kernel.org/netdev/net-next/c/98b12064591d
  - [net-next,13/15] can: slcan: add ethtool support to reset adapter errors
    https://git.kernel.org/netdev/net-next/c/4de0e8efa052
  - [net-next,14/15] can: slcan: extend the protocol with error info
    https://git.kernel.org/netdev/net-next/c/b32ff4668544
  - [net-next,15/15] can: slcan: extend the protocol with CAN state info
    https://git.kernel.org/netdev/net-next/c/0a9cdcf098a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


