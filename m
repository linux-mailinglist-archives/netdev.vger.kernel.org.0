Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D76D4024
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjDCJUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjDCJUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AA2BBA8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 02:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA886170D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59088C4339C;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680513625;
        bh=nFopoImzQBz7Q8lSGMuH2Fsn84umZj/C9wbiySmRFWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CF5Tfb0J4zHf0keKwjodzcIz2Ezj/Vw6yCdMpr/dHlUuxoPGI2N6O6AWPoFiM5vEb
         RqkwBH2G0/yyYehjOOVzxYR9YJqMXxpzqay6mdB/V5SaML1Fp6FIEniuTRAoPp3orw
         bsDoo/BLbDNl0XShU7/oZZ6UXfl0RoM29I6t6SRzalUjF3U8QT/nkGzwOk6BU9Vkv9
         Pts5wBj4bkficBGHkA+JJn9inRLl4JFCr6cs7i2EkmT+aS4kuMakTC4qbOyMvGYYKD
         M4eaMz+2wwNVWbAutYQ94/L4DVGaFeQ+R8lyD1PuyKhGOvCZOteT8I3zOfa2NhX3qS
         +GrgIiHgFbFpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43C98E5EA8A;
        Mon,  3 Apr 2023 09:20:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] Convert dsa_master_ioctl() to netdev notifier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168051362526.15794.12312457675415772790.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Apr 2023 09:20:25 +0000
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com, glipus@gmail.com,
        horatiu.vultur@microchip.com, kory.maincent@bootlin.com,
        maxime.chevallier@bootlin.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun,  2 Apr 2023 15:37:48 +0300 you wrote:
> This is preparatory work in order for Maxim Georgiev to be able to start
> the API conversion process of hardware timestamping from ndo_eth_ioctl()
> to ndo_hwtstamp_set():
> https://lore.kernel.org/netdev/20230331045619.40256-1-glipus@gmail.com/
> 
> In turn, Maxim Georgiev's work is a preparation so that Köry Maincent is
> able to make the active hardware timestamping layer selectable by user
> space.
> https://lore.kernel.org/netdev/20230308135936.761794-1-kory.maincent@bootlin.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: don't abuse "default" case for unknown ioctl in dev_ifsioc()
    https://git.kernel.org/netdev/net-next/c/00d521b39307
  - [net-next,2/7] net: simplify handling of dsa_ndo_eth_ioctl() return code
    https://git.kernel.org/netdev/net-next/c/1193db2a55b6
  - [net-next,3/7] net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated handlers
    https://git.kernel.org/netdev/net-next/c/4ee58e1e5680
  - [net-next,4/7] net: move copy_from_user() out of net_hwtstamp_validate()
    https://git.kernel.org/netdev/net-next/c/d5d5fd8f2552
  - [net-next,5/7] net: add struct kernel_hwtstamp_config and make net_hwtstamp_validate() use it
    https://git.kernel.org/netdev/net-next/c/c4bffeaa8d50
  - [net-next,6/7] net: dsa: make dsa_port_supports_hwtstamp() construct a fake ifreq
    https://git.kernel.org/netdev/net-next/c/ff6ac4d013e6
  - [net-next,7/7] net: create a netdev notifier for DSA to reject PTP on DSA master
    https://git.kernel.org/netdev/net-next/c/88c0a6b503b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


