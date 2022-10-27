Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7760FF77
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiJ0Rke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbiJ0RkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAC3578B2;
        Thu, 27 Oct 2022 10:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB725B82731;
        Thu, 27 Oct 2022 17:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83380C43141;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666892419;
        bh=JRe0eDq+okg933vXfQhwZYi9AoAytZNfWjSHEgU3cWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cGTtt0Tlqh9UBvEw/M8pBosfR9S8IB8emClWTlJBLy3/lQBIF/5phSfniMwKtk4eS
         w/gxWnJqo93JjN487ro1ugrF+Jw4CNZW3OxeRD0IuTf6cd8VgaPACHg8eI0uO1SxUY
         a/4w493PH9wlVuVmVUNlO5gbVxpnoKf3wThSmvGdD2ugy9phXb23M1muJXwNHYBCsq
         us6jLxzSEGialaUQS5C2zm25o7MX8k4VRvySRuGRZAQXokn8HNbJaExGALzDLqBVU1
         X5MUp09gMH5pxWM1qSzWTRTtgpxIiFEjxmpnEHOFGsXoMXdgC9P5PTJAC8K+sJdyjo
         v+x9qphEiEMig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65975E270D8;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] can: kvaser_usb: Fix possible completions during
 init_completion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689241941.10875.15815557488092799175.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 17:40:19 +0000
References: <20221027114356.1939821-2-mkl@pengutronix.de>
In-Reply-To: <20221027114356.1939821-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        anssi.hannula@bitwise.fi, extja@kvaser.com, stable@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 27 Oct 2022 13:43:53 +0200 you wrote:
> From: Anssi Hannula <anssi.hannula@bitwise.fi>
> 
> kvaser_usb uses completions to signal when a response event is received
> for outgoing commands.
> 
> However, it uses init_completion() to reinitialize the start_comp and
> stop_comp completions before sending the start/stop commands.
> 
> [...]

Here is the summary with links:
  - [net,1/4] can: kvaser_usb: Fix possible completions during init_completion
    https://git.kernel.org/netdev/net/c/2871edb32f46
  - [net,2/4] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
    https://git.kernel.org/netdev/net/c/702de2c21eed
  - [net,3/4] can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L
    https://git.kernel.org/netdev/net/c/d887087c8968
  - [net,4/4] can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
    https://git.kernel.org/netdev/net/c/c3c06c61890d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


