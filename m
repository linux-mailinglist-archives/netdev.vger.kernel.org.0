Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0472A4EDDE3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbiCaPwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238998AbiCaPwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B75BE4B;
        Thu, 31 Mar 2022 08:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB3BB82057;
        Thu, 31 Mar 2022 15:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1ADE0C3410F;
        Thu, 31 Mar 2022 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648741812;
        bh=WRc6Q1GDF3Ec8WBySt6kxHgaGo6VPOd3GwTQ88nmaSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tBYM0dydCRU5UCh+qRvTQ0ZS/qY2Oc4nZxwzZW3nXNDQjn26AZTmx8XswfJdbPW0S
         gf+XAy3gzkso7SOlJy6ymKsFCsexgR45cvIYqzUOqVP9eYd2n4/U0480TM4he9JUYZ
         A9DjiGLwTbmOQkSKh4C7ofGWMFtwqRSFz12lkRfSOrLQusIynvf5g1P3r5JSIBkhQ9
         qTwiPuxVcEuixv0xQIXChYYk+Os8kfa5gzXNOg4SZvqVfbccsIDQ2TDdCC4bo6aPnO
         Dv5DsZXyPKbed2VO4P6B/nG/frZVpNbZwAk04EmgLPhf7S/hAoxO9KjeiSWruKFjsS
         Btb3HldzTjz6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00239F03849;
        Thu, 31 Mar 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/n] pull-request: can 2022-03-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164874181199.9626.6692510362778511286.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 15:50:11 +0000
References: <20220331084634.869744-1-mkl@pengutronix.de>
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 31 Mar 2022 10:46:26 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 8 patches for net/master.
> 
> The first patch is by Oliver Hartkopp and fixes MSG_PEEK feature in
> the CAN ISOTP protocol (broken in net-next for v5.18 only).
> 
> [...]

Here is the summary with links:
  - [net,0/n] pull-request: can 2022-03-31
    https://git.kernel.org/netdev/net/c/46b556205dce
  - [net,2/8] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value
    https://git.kernel.org/netdev/net/c/fa7b514d2b28
  - [net,3/8] can: m_can: m_can_tx_handler(): fix use after free of skb
    https://git.kernel.org/netdev/net/c/2e8e79c416aa
  - [net,4/8] can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
    https://git.kernel.org/netdev/net/c/c70222752228
  - [net,5/8] can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
    https://git.kernel.org/netdev/net/c/3d3925ff6433
  - [net,6/8] can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path
    https://git.kernel.org/netdev/net/c/04c9b00ba835
  - [net,7/8] can: mcba_usb: properly check endpoint type
    https://git.kernel.org/netdev/net/c/136bed0bfd3b
  - [net,8/8] can: gs_usb: gs_make_candev(): fix memory leak for devices with extended bit timing configuration
    https://git.kernel.org/netdev/net/c/50d34a0d151d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


