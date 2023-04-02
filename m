Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE07D6D37D5
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDBMaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA28E1B6
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31C661147
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A910C4339B;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680438617;
        bh=3gTFvVIgNvAM3LkNFMqKW9xnpTGMtKbXsQaNIITkhCk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQK1Er57DVaqyL09B6tQaUNCdQti2DwyhJBm3HacTKzfqRKE2MVICqPvNc4cPRnWZ
         GCSKLWA1xsct1n59laZZVrTJSzRwZmL3SSK6aUv5FMv7gnnS/PYPJbtGemiH6lVukO
         Rfu2SABrc6ww801I7wMQRRkybG+x3jy39wRkwZEREd10UofX1V8ha3aeP2Ci4ODfq9
         1qW56u6VRQCMZO8XncvzaFEqICxXDl4PNfmyB3+B98xyNWNhTx40W4Vq5cnPEJvvS5
         x6OWcIi8oTEI8hap9wVL7xSRvijoMTbRGPAb8Bmw/y+mHFK3r0hbZk2Ig15rWYLhs5
         48m9P7i3gOjwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F094C73FE0;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: don't let netpoll invoke NAPI if in xmit context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043861712.6785.3457308303039271721.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:30:17 +0000
References: <20230331022144.2998493-1-kuba@kernel.org>
In-Reply-To: <20230331022144.2998493-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, roman.gushchin@linux.dev, leitao@debian.org,
        shemminger@linux.foundation.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Mar 2023 19:21:44 -0700 you wrote:
> Commit 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix") narrowed
> down the region under netif_tx_trylock() inside netpoll_send_skb().
> (At that point in time netif_tx_trylock() would lock all queues of
> the device.) Taking the tx lock was problematic because driver's
> cleanup method may take the same lock. So the change made us hold
> the xmit lock only around xmit, and expected the driver to take
> care of locking within ->ndo_poll_controller().
> 
> [...]

Here is the summary with links:
  - [net] net: don't let netpoll invoke NAPI if in xmit context
    https://git.kernel.org/netdev/net/c/275b471e3d2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


