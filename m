Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B8B4E3425
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiCUXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiCUXNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:13:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF9F3DE8F9
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89689CE1BEE
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E77A0C340F3;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647903612;
        bh=tvhOW3iEpGEXnaSpF0iwoGb6pE8PDIaIB4L1O743EJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kiYkGVAqOR7q0LAkmqXvb5jos+yHeA+Ek0rTUle1l7Gj6Hz+ms8QEd7dyUBuxzfvu
         ABlPQl+Its0HD2cIsOpX9MpzJuBWUR+11RJP07+aGGRRYr55Shkq7T4bwRrHXffUXC
         ca+KWeOFcEgzZt5oU2Hp6NwhVvdvyy0K4/+tiI4oRfoNSNGtcxyDEAQ7kes/hStIwf
         ENORew7iHqXG9j/JOyBmBe6wRX6mJohD/0jC5FbIWr56KZrevwcbMT7jp2/YU/iGH5
         SEie5vZtlz07IVZiT2iBTEF76xI8+Qznr5Qrg/GqZrnoJqKxjjNfqO2Uwwmifcpj6M
         LcmFwxEyzI4fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B95F1F03845;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: felix: allow PHY_INTERFACE_MODE_INTERNAL
 on port 5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164790361175.11439.16385044414945437391.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 23:00:11 +0000
References: <20220318195812.276276-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220318195812.276276-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        colin.foster@in-advantage.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 21:58:12 +0200 you wrote:
> The Felix switch has 6 ports, 2 of which are internal.
> Due to some misunderstanding, my initial suggestion for
> vsc9959_port_modes[]:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220129220221.2823127-10-colin.foster@in-advantage.com/#24718277
> 
> got translated by Colin into a 5-port array, leading to an all-zero port
> mode mask for port 5.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: felix: allow PHY_INTERFACE_MODE_INTERNAL on port 5
    https://git.kernel.org/netdev/net-next/c/a53cbe5d628c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


