Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F04DD1F4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 01:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiCRAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 20:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiCRAba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 20:31:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F41AA058;
        Thu, 17 Mar 2022 17:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F8F0B820FD;
        Fri, 18 Mar 2022 00:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43F4AC340EE;
        Fri, 18 Mar 2022 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647563410;
        bh=E2Vr9Rj9cTD0c26P/K+p388YiJfYXuN1UcSWwBEQLTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AKRNIPZoVmzw1F18R1UfzZJEF0gzxTGZtdbppC1GYZP7cZLqpPu/NggNeT0GyNppT
         eRlKc6q+i4yyat82Y1rvkrbHhtJd7wsDgnMQcH/cj5V7YJYzJF1MOpVMxaMLx7Zki/
         apsJcWj8FXFDg+3nLvDZVfPAC+OudxeLGdIquBxtcQ6lB/rxbsgA9kK05SHe9Z2If3
         DAHqMQqJC4B5EmIUQFXw3RPNf36AH12SbgMfxkWGUd6tsEepBuZeOaa3ET95mW6xx/
         +5yu3UI5oDUxJ0iOtm/bsiZJ2zo/jDO7UmdNpPWZy6ZAg7EMkvJSd0W4JJYglzNx9N
         FQZYHFBDM0yRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A513E6D3DD;
        Fri, 18 Mar 2022 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8795: handle eee
 specif erratum
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756341010.32270.6496971748158497644.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 00:30:10 +0000
References: <20220316125529.1489045-1-o.rempel@pengutronix.de>
In-Reply-To: <20220316125529.1489045-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 13:55:29 +0100 you wrote:
> According to erratum described in DS80000687C[1]: "Module 2: Link drops with
> some EEE link partners.", we need to "Disable the EEE next page
> exchange in EEE Global Register 2"
> 
> 1 - https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ87xx-Errata-DS80000687C.pdf
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: dsa: microchip: ksz8795: handle eee specif erratum
    https://git.kernel.org/netdev/net-next/c/7b6e6235b664

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


