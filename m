Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A635B0125
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiIGKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiIGKAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EEE32AB1
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 03:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F379361835
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FF77C433C1;
        Wed,  7 Sep 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662544816;
        bh=+IOHo6laIs3PGtHXt1ArUcQ5O4/5HRsjEktGt8dElHs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=es6khtx5YznS2VErnsv1WpWlhYnPJGMBXyw23eHvF5eGK4aqWBBruPyaXaoJjPMXn
         fuiFUZgsC+uhhstBiR2vCQlyS0VMzKb9WQ5kP+6k+BLwVKRr7aGQfjywQkTlutXLEJ
         LVhFJT4ANh0QCKZPD/we10prXXiIpDCqF3S6OquoNOkvYpNerBjS6LgzbyN3JInGBg
         Tq8NbKRIK0MIJKZSGZQhSgO6CfynusHtZQgjXBRLfB2fNha0iHW0MF/qaArh0M8wPK
         Wk6bQkrVHNTjzfuxN23pAlJNBLJekovK5Fz4lPjEwU6ciwuapJzJRkz+NgMVJvTqMq
         RTnPHP0RoZYaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FA0DC4166E;
        Wed,  7 Sep 2022 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3: net-next 1/4] net: dsa: microchip: add KSZ9896 switch
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166254481612.23363.13927252378778359240.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 10:00:16 +0000
References: <20220902101610.109646-1-romain.naour@smile.fr>
In-Reply-To: <20220902101610.109646-1-romain.naour@smile.fr>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        romain.naour@skf.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 12:16:07 +0200 you wrote:
> From: Romain Naour <romain.naour@skf.com>
> 
> Add support for the KSZ9896 6-port Gigabit Ethernet Switch to the
> ksz9477 driver.
> 
> Although the KSZ9896 is already listed in the device tree binding
> documentation since a1c0ed24fe9b (dt-bindings: net: dsa: document
> additional Microchip KSZ9477 family switches) the chip id
> (0x00989600) is not recognized by ksz_switch_detect() and rejected
> by the driver.
> 
> [...]

Here is the summary with links:
  - [v3:,net-next,1/4] net: dsa: microchip: add KSZ9896 switch support
    https://git.kernel.org/netdev/net-next/c/2eb3ff3c0908
  - [v3:,net-next,2/4] net: dsa: microchip: add KSZ9896 to KSZ9477 I2C driver
    https://git.kernel.org/netdev/net-next/c/13767525929d
  - [v3:,net-next,3/4] net: dsa: microchip: ksz9477: remove 0x033C and 0x033D addresses from regmap_access_tables
    https://git.kernel.org/netdev/net-next/c/3a8b8ea6c7c2
  - [v3:,net-next,4/4] net: dsa: microchip: add regmap_range for KSZ9896 chip
    https://git.kernel.org/netdev/net-next/c/6674e7fd3bea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


