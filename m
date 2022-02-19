Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0E4BCA5A
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbiBSTAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:00:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBSTAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:00:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EF259A53;
        Sat, 19 Feb 2022 11:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67DA60E84;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B344C340EC;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645297210;
        bh=koCVmhrrOoMAENsrk2W+MxsXDFkkYZ7Hlx1gDJI17a8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D1LbqvijCZ+M250vjz9yT5c65gxKVLrDA4NSV/7QW6dCB53mquo5xKspQMT0vOL1n
         Vf8+5qG5zU3RYrOsb4tcKV4k75+FA1JeLZKHe9W+hjA4j7Koa1b9z9iKen6o0cXLwa
         WRT/gknJrrklbDmBDO+lQr87UtY+562nhVt2X4m8zzEOX4QyZO/NgEdtGenfbtDgBt
         +Y+Q+tF1xubl+KU9ZBVKCVPZe4r852ZtgjHclx2LYvQ7fpaE7vOZuZgc8mpgSzgDRM
         PxdYY1SvSHURF5DeGc6C+OJlGVtDzfTiUhPBWEaHTPivnK6ccHQOYw37SNabnaONK8
         b37YaUj+dP+fQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F266FE7BB0B;
        Sat, 19 Feb 2022 19:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/1] net: dsa: microchip: ksz9477: export HW stats
 over stats64 interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164529720998.31615.18049890364706478684.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 19:00:09 +0000
References: <20220219082630.2454948-1-o.rempel@pengutronix.de>
In-Reply-To: <20220219082630.2454948-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 19 Feb 2022 09:26:30 +0100 you wrote:
> Provide access to HW offloaded packets over stats64 interface.
> The rx/tx_bytes values needed some fixing since HW is accounting size of
> the Ethernet frame together with FCS.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v4:
> - do not copy raw counters to the stack
> changes v3:
> - move dev->dev_ops->r_mib_stat64 insight of the mutex
> changes v2:
> - fix locking issue in in atomic context
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/1] net: dsa: microchip: ksz9477: export HW stats over stats64 interface
    https://git.kernel.org/netdev/net-next/c/a7f4f13a0a68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


