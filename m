Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AD508520
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359083AbiDTJnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353200AbiDTJnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E501245AC
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D676B81E1B
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 09:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D871DC385AC;
        Wed, 20 Apr 2022 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650447612;
        bh=OUcd8jVqFKpPpCILoLv3NOoKl1TgrevIWXmXpXyow2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F1fDO10f48ETFXTQfVOIDT99Yz0va7tOYg/9OQD+zN4nDT8q07y/k/yf1Gbj39taa
         q2KyCEB5kFNvgCBHEv8KEyTLd86RA4fcqNPZBqSG1pPKR4eDKIfBaTgutrNj8vgjxM
         b45lkdL6k4hkfVbsLv84c0BtTSyqLklpJxD1KO9R7fgSlhS+4Ng7HGz3Lxk/GiyLz2
         TbBJEoAht/90p2QQHroCCWEQYgm7P1xpR9NWNhujof0Vnfe/GQ/zGZA55NDKJhlYrg
         +B1R6ul16LDLNuomgw0E7Qrwn5c4vDHMDrk1XLF3zKwzHAHr08UhZgnlksz0X8n4q3
         Kl8R3hMhiqUdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5336E7399D;
        Wed, 20 Apr 2022 09:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] DSA cross-chip notifier cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044761280.27023.11451310717021718491.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 09:40:12 +0000
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Apr 2022 18:46:20 +0300 you wrote:
> This patch set makes the following improvements:
> 
> - Cross-chip notifiers pass a switch index, port index, sometimes tree
>   index, all as integers. Sometimes we need to recover the struct
>   dsa_port based on those integers. That recovery involves traversing a
>   list. By passing directly a pointer to the struct dsa_port we can
>   avoid that, and the indices passed previously can still be obtained
>   from the passed struct dsa_port.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
    https://git.kernel.org/netdev/net-next/c/8e9e678e4758
  - [net-next,2/6] net: dsa: make cross-chip notifiers more efficient for host events
    https://git.kernel.org/netdev/net-next/c/726816a129cb
  - [net-next,3/6] net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_mtu
    https://git.kernel.org/netdev/net-next/c/b2033a05a719
  - [net-next,4/6] net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
    https://git.kernel.org/netdev/net-next/c/cf1c39d3b3a5
  - [net-next,5/6] net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
    https://git.kernel.org/netdev/net-next/c/4715029fa7e9
  - [net-next,6/6] net: dsa: don't emit targeted cross-chip notifiers for MTU change
    https://git.kernel.org/netdev/net-next/c/be6ff9665d64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


