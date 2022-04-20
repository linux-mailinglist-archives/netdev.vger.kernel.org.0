Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303915085EE
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351809AbiDTKdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351823AbiDTKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:33:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AC93F8A5;
        Wed, 20 Apr 2022 03:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1275BB81E8C;
        Wed, 20 Apr 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACBBCC385A8;
        Wed, 20 Apr 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650450615;
        bh=uqhLbbl7GmOvkQnVpqLj51Rsm3L6qxhwNld5DTCBE3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OjQdqqzrypUhiY8GEVLVRV2uedH+oKEz1/7UlTlZD5uO+RnQEu/fpOwhHp1VjKAlj
         pV/cbf+S+VVL76DDn+DxpidcPjehMTLPf56HC1AeUZ8EwSRjId7HnKEpGpUv1XLK5H
         3O2yMksQlLW+ENzbsrN/FhfgvjbdG/C/Bw4egEcZSGrErg2sDbcsfV4e7Zdjo2jTDF
         m836Ezn9sSY4EmfLj5XxP71HZkbvS7vSucTKYFHkeNMlW/shdaonf9ucMFAgF/i4u7
         L90vB5bkiwohH3yDRuAL/XmynZzzGUdVeBBF7ByXLOtBcV2Si76NFcdJTjlOF0Ie6m
         QDgWUnnrBCYVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F31DE7399D;
        Wed, 20 Apr 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/17] can: rx-offload: rename
 can_rx_offload_queue_sorted() -> can_rx_offload_queue_timestamp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165045061558.18792.15126070255101157595.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:30:15 +0000
References: <20220419152554.2925353-2-mkl@pengutronix.de>
In-Reply-To: <20220419152554.2925353-2-mkl@pengutronix.de>
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

On Tue, 19 Apr 2022 17:25:38 +0200 you wrote:
> This patch renames the function can_rx_offload_queue_sorted() to
> can_rx_offload_queue_timestamp(). This better describes what the
> function does, it adds a newly RX'ed skb to the sorted queue by its
> timestamp.
> 
> Link: https://lore.kernel.org/all/20220417194327.2699059-1-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] can: rx-offload: rename can_rx_offload_queue_sorted() -> can_rx_offload_queue_timestamp()
    https://git.kernel.org/netdev/net-next/c/eb38c2053b67
  - [net-next,02/17] can: bittiming: can_calc_bittiming(): prefer small bit rate pre-scalers over larger ones
    https://git.kernel.org/netdev/net-next/c/85d4eb2a3dfe
  - [net-next,03/17] can: Fix Links to Technologic Systems web resources
    https://git.kernel.org/netdev/net-next/c/20c7258980e0
  - [net-next,04/17] can: mscan: mpc5xxx_can: Prepare cleanup of powerpc's asm/prom.h
    https://git.kernel.org/netdev/net-next/c/bb75e352d7ac
  - [net-next,05/17] can: flexcan: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/e6ec83790593
  - [net-next,06/17] MAINTAINERS: rectify entry for XILINX CAN DRIVER
    https://git.kernel.org/netdev/net-next/c/badea4fc7025
  - [net-next,07/17] can: xilinx_can: mark bit timing constants as const
    https://git.kernel.org/netdev/net-next/c/ae38fda02996
  - [net-next,08/17] dt-bindings: can: renesas,rcar-canfd: document r8a77961 support
    https://git.kernel.org/netdev/net-next/c/44b6b105dd24
  - [net-next,09/17] dt-binding: can: mcp251xfd: add binding information for mcp251863
    https://git.kernel.org/netdev/net-next/c/621119764850
  - [net-next,10/17] can: mcp251xfd: add support for mcp251863
    https://git.kernel.org/netdev/net-next/c/c6f2a617a0a8
  - [net-next,11/17] dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
    https://git.kernel.org/netdev/net-next/c/fb23e43a0a9c
  - [net-next,12/17] dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
    https://git.kernel.org/netdev/net-next/c/1da9d6e35b6b
  - [net-next,13/17] can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.
    https://git.kernel.org/netdev/net-next/c/2dcb8e8782d8
  - [net-next,14/17] can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
    https://git.kernel.org/netdev/net-next/c/792a5b678e81
  - [net-next,15/17] can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
    https://git.kernel.org/netdev/net-next/c/e8f0c23a2415
  - [net-next,16/17] docs: ctucanfd: CTU CAN FD open-source IP core documentation.
    https://git.kernel.org/netdev/net-next/c/c3a0addefbde
  - [net-next,17/17] MAINTAINERS: Add maintainers for CTU CAN FD IP core driver
    https://git.kernel.org/netdev/net-next/c/cfdb2f365cb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


