Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7256B4FA210
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbiDIDmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiDIDmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A267F320DAE;
        Fri,  8 Apr 2022 20:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31F38622B7;
        Sat,  9 Apr 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E860C385A0;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649475612;
        bh=X9wiIfyLppOIHSG972BTYLoWyljPeZpmxByxZP13F/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hMuwLY4vFA7v3nOJMuS+Jvplvg+sQ85ctdb3ddVVoGw1V9TkxikgXaV4bY2cjBSyK
         igC9SOlMXeu2i8DX9OgQlJ2B593rrnnbmCCvfN8xr/QFhayIfkIDuBcg1PWldKB6BM
         jLVdWEdUkadnWIitmmaxCBuDqps+aBfZkb+0Bw7iPsKH/XkG4yzFPuurlPKj1/yFeO
         2pXzJiCNwYgS5j1AK/7UDGjBrp9pApE9qGVKXdgHqpuj56ulE01R4C+Ko+2d73QJpn
         iuvip1OzQH7FsVW19J1+txRQi6HuX4gKlAvsXp7R0YRJnWQvYrIuWBz5PDrA0JMQsn
         ln1myrbSM/adQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5669CE8DD5D;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: felix: suppress -EPROBE_DEFER errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164947561235.6004.4184764458750297677.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Apr 2022 03:40:12 +0000
References: <20220408101521.281886-1-michael@walle.cc>
In-Reply-To: <20220408101521.281886-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Apr 2022 12:15:21 +0200 you wrote:
> The DSA master might not have been probed yet in which case the probe of
> the felix switch fails with -EPROBE_DEFER:
> [    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517
> 
> It is not an error. Use dev_err_probe() to demote this particular error
> to a debug message.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: felix: suppress -EPROBE_DEFER errors
    https://git.kernel.org/netdev/net/c/e6934e4048c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


