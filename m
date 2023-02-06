Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DAB68B8BA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBFJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCA914225
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6A83B80D89
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65D6DC433EF;
        Mon,  6 Feb 2023 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675675819;
        bh=Iwrxcxqksw08BXDe/cGHiSwIAFDFvuRaKZ6lTuadpXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PQcM3P+SLasbRcz+65EqF2HUVHVHjbS2QQPVq9/Uwffl/VtCOC1RZ6qWv775zYWhq
         cbD2k95GF9u2mp1tK6OnqEprUmBorBglQnaxbH+H91Pbg0nrLApgiaDgyTf1iWXnVE
         Pdt88uioDRH+GW88JMBJb8fjtIwf2oDAXwDJhOgs6/eYoOe8viFFWPjZ9xgCLJLEYe
         ETXMnBFcfSU6LvrapuyP9f93Do0jHE9yKflBV34TjSU6igjNXzmJJEAvf45OXdVBdo
         gbY/YVmpQwCGcFP1FjWtE2X8waBTQiNDbg+WMQqW26oQXF6TpvzIaUsp5U9+l44n/I
         n+7ETb8dutK4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50271E55EFD;
        Mon,  6 Feb 2023 09:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/10] Wangxun interrupt and RxTx support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567581932.9492.3212586042843555041.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:30:19 +0000
References: <20230203091135.3294377-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230203091135.3294377-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Feb 2023 17:11:25 +0800 you wrote:
> Configure interrupt, setup RxTx ring, support to receive and transmit
> packets.
> 
> change log:
> v3:
> - Use upper_32_bits() to avoid compile warning.
> - Remove useless codes.
> v2:
> - Andrew Lunn: https://lore.kernel.org/netdev/Y86kDphvyHj21IxK@lunn.ch/
> - Add a judgment when allocate dma for descriptor.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/10] net: libwx: Add irq flow functions
    https://git.kernel.org/netdev/net-next/c/3f703186113f
  - [net-next,v3,02/10] net: ngbe: Add irqs request flow
    https://git.kernel.org/netdev/net-next/c/e7956139a6cf
  - [net-next,v3,03/10] net: txgbe: Add interrupt support
    https://git.kernel.org/netdev/net-next/c/5d3ac705c281
  - [net-next,v3,04/10] net: libwx: Configure Rx and Tx unit on hardware
    https://git.kernel.org/netdev/net-next/c/18b5b8a9f178
  - [net-next,v3,05/10] net: libwx: Allocate Rx and Tx resources
    https://git.kernel.org/netdev/net-next/c/850b971110b2
  - [net-next,v3,06/10] net: txgbe: Setup Rx and Tx ring
    https://git.kernel.org/netdev/net-next/c/0ef7e1597a17
  - [net-next,v3,07/10] net: libwx: Support to receive packets in NAPI
    https://git.kernel.org/netdev/net-next/c/3c47e8ae113a
  - [net-next,v3,08/10] net: libwx: Add tx path to process packets
    https://git.kernel.org/netdev/net-next/c/09a508800952
  - [net-next,v3,09/10] net: txgbe: Support Rx and Tx process path
    https://git.kernel.org/netdev/net-next/c/0d22be525a61
  - [net-next,v3,10/10] net: ngbe: Support Rx and Tx process path
    https://git.kernel.org/netdev/net-next/c/b97f955ec47b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


