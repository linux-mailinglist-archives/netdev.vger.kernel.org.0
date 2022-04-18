Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C6504E65
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiDRJcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 05:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiDRJcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 05:32:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9086215FFE;
        Mon, 18 Apr 2022 02:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1016119B;
        Mon, 18 Apr 2022 09:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70AC8C385A8;
        Mon, 18 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650274211;
        bh=IqTxnwNtJXJUDGusPAvkbyyh35OmJ2YAsRP7xYuk54U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D5cslCjdOuqW3V6yNJd0yeShqTVKFvw62QfbrYLvh6eIVpJcd6YUm96LH015dRJ3T
         3ygceUapvDnZm//vwRo+gwvkrMcQwCYInSLf3zPPNFcMo2mS3kr8VOv3L4vvRrUxgI
         QJ4acKzLm2Oj2rrMd2xsSQKvNVUp2DAGWeozlNqx9j8YLACv1GmN1Zzk9Zu8XB7l3i
         knmO8wmc6J/gUaqD7jZ/jT/hZQHXOjRpnFzpnKT7fmY2FlBKdsPnL8UvElFFJ0gZ56
         Z3L0+FQGjlvA1Gz2UM+BsN26STQhIkW/1TqK4UDWRyALTY15CyfRGe1bt4uIVGPiUQ
         z17AuGbBhYETQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56A20E8DD61;
        Mon, 18 Apr 2022 09:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] can: isotp: stop timeout monitoring when no first frame
 was sent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165027421135.11239.7151679337117584143.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Apr 2022 09:30:11 +0000
References: <20220417152934.2696539-2-mkl@pengutronix.de>
In-Reply-To: <20220417152934.2696539-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sun, 17 Apr 2022 17:29:34 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> The first attempt to fix a the 'impossible' WARN_ON_ONCE(1) in
> isotp_tx_timer_handler() focussed on the identical CAN IDs created by
> the syzbot reproducer and lead to upstream fix/commit 3ea566422cbd
> ("can: isotp: sanitize CAN ID checks in isotp_bind()"). But this did
> not catch the root cause of the wrong tx.state in the tx_timer handler.
> 
> [...]

Here is the summary with links:
  - [net] can: isotp: stop timeout monitoring when no first frame was sent
    https://git.kernel.org/netdev/net/c/d73497081710

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


