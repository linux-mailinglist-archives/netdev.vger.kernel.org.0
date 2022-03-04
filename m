Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292484CD268
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiCDKbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiCDKbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:31:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D81680AF
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD0661BCD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72223C340F2;
        Fri,  4 Mar 2022 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646389814;
        bh=dW6dUkE8EtfjxAXRnEXLGBoIz/ZZDAIHCWj83OXPnkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MsgcetWaHcbqrznE2C2OZoY6nJfgfEWmXrtKksJRYKEh0lYClv1ritzStOYSvHr9l
         4lx4/DXbwwRlmLQW5atn+kDnv0xlhPZujFvUoFJ6p77t2kEHNU/iWXPfhk0lJchryf
         T+jNBr3Nlj4jM7UrYClTTYRa5MBrLpbz2u7MN7mWxdsJeld5LL2BhoR82/aZoY4JjV
         6vX0m3PQUgo0kkab/pStyZLD7KrVEVHvPZx71SAyg9nOLAF4J6kwo0imHnWfJG2608
         rJwuGdY+kr62e5JrFcthkFP9tB6TvSZyCVJqDYCNrotdcLMrfv38ROqJro3DGU0KUz
         6+rV1VTAUFoTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58625EAC095;
        Fri,  4 Mar 2022 10:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] Cleanups for ocelot/felix drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164638981435.20580.933935079764294543.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 10:30:14 +0000
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, idosch@nvidia.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Mar 2022 16:01:19 +0200 you wrote:
> This patch set is an assorted collection of minor cleanups brought to
> the felix DSA driver and ocelot switch library.
> 
> Vladimir Oltean (7):
>   net: mscc: ocelot: use list_for_each_entry in
>     ocelot_vcap_block_remove_filter
>   net: mscc: ocelot: use pretty names for IPPROTO_UDP and IPPROTO_TCP
>   net: dsa: felix: remove ocelot->npi assignment from
>     felix_8021q_cpu_port_init
>   net: dsa: felix: drop the ptp_type argument from felix_check_xtr_pkt()
>   net: dsa: felix: initialize "err" to 0 in felix_check_xtr_pkt()
>   net: dsa: felix: print error message in felix_check_xtr_pkt()
>   net: dsa: felix: remove redundant assignment in
>     felix_8021q_cpu_port_deinit
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_block_remove_filter
    https://git.kernel.org/netdev/net-next/c/c5a0edaeb9e1
  - [net-next,2/7] net: mscc: ocelot: use pretty names for IPPROTO_UDP and IPPROTO_TCP
    https://git.kernel.org/netdev/net-next/c/c3cde44f3c6e
  - [net-next,3/7] net: dsa: felix: remove ocelot->npi assignment from felix_8021q_cpu_port_init
    https://git.kernel.org/netdev/net-next/c/28c1305b0b72
  - [net-next,4/7] net: dsa: felix: drop the ptp_type argument from felix_check_xtr_pkt()
    https://git.kernel.org/netdev/net-next/c/d219b4b674e9
  - [net-next,5/7] net: dsa: felix: initialize "err" to 0 in felix_check_xtr_pkt()
    https://git.kernel.org/netdev/net-next/c/dbd032856ba3
  - [net-next,6/7] net: dsa: felix: print error message in felix_check_xtr_pkt()
    https://git.kernel.org/netdev/net-next/c/5d3bb7dda43a
  - [net-next,7/7] net: dsa: felix: remove redundant assignment in felix_8021q_cpu_port_deinit
    https://git.kernel.org/netdev/net-next/c/162fbf6a2f95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


