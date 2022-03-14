Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77A24D7F7A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238385AbiCNKLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbiCNKLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FEC3C705;
        Mon, 14 Mar 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C3D4B80D84;
        Mon, 14 Mar 2022 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1ABADC340EC;
        Mon, 14 Mar 2022 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647252611;
        bh=q/xdrtAgwiiURcskqczddr4CH3ntLAEamZxnYp0XNcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FqFDPXPCJiKlNJsV5R0/sZzEk+CCU0LCej4LeTQt/RhxtxM606kDzMlphv9IRx00b
         jRYwSft94H02ye4F9ElAo9DTlT9CQtS+yI/IRlcEw48MVLC3R4DTxPSoNiOCqSwVku
         qIZ6SAI3Y7yC15XAthMaMjRyqmzu5QjTV0s8AqH0ajSwx/1KQXTPJNZueBL39sS+Iu
         MZj//m+uRGy+DaAvylyh+l8PYuH2eUrSYFKAbfEAaZGb9lkYHqPZNfjSY6j7yd+vXg
         s0tubsNyDHMfuTeX150greEewqf982C/QzlaJSGIqkJSLIBDhYxTG623TLck0pXxo7
         HCvvFxqsGL6cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9E38E6D44B;
        Mon, 14 Mar 2022 10:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: microchip: add spi_device_id tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725261095.13129.4425416047349176928.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 10:10:10 +0000
References: <20220311111716.1481881-1-claudiu.beznea@microchip.com>
In-Reply-To: <20220311111716.1481881-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 13:17:16 +0200 you wrote:
> Add spi_device_id tables to avoid logs like "SPI driver ksz9477-switch
> has no spi_device_id".
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz8795_spi.c | 11 +++++++++++
>  drivers/net/dsa/microchip/ksz9477_spi.c | 12 ++++++++++++
>  2 files changed, 23 insertions(+)

Here is the summary with links:
  - net: dsa: microchip: add spi_device_id tables
    https://git.kernel.org/netdev/net/c/e981bc74aefc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


