Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681D15240FB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349232AbiEKXYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349444AbiEKXXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC152469F1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A5EB8265B
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 23:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEDEEC34114;
        Wed, 11 May 2022 23:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652311214;
        bh=klShiE1uvq2Sor2Yt8dAbva5uVWOLXLaur6zf9mKEi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FrgkyYMJwfo/VpsSRaZ8JTrPzT41yWFIXSDFWKe9WQ56fGi/A/Ijcpjf+Mj3bCCAG
         /NLuH5JzhNBzvcUjNa0IOahVHHQdOlTJOGdBrOeFccQFM9hPFMqPSvtmjhLETUlJHk
         pU6/knK9mGOZjvogGjy5vocS94IUk1P9HEAROTbT+UIOz03xNSOCbeztTQa5GACrwr
         gjPHqH7hrLnCS68Lk6b79dNaXcLeh7dsSQ8DpUTFqM9sc0QZyIjebaJv2YX9VrmV7t
         CyEIg38HvG7/o/SEecdKTYAvjsFxRf/4CUPHgq/vImtPol3igroA2Tr6Rppt6XOA6d
         R4cPbJP3lp1gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F7D5F03936;
        Wed, 11 May 2022 23:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] MACB NAPI improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165231121464.1756.4308716572256208263.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 23:20:14 +0000
References: <20220509194635.3094080-1-robert.hancock@calian.com>
In-Reply-To: <20220509194635.3094080-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, tomas.melin@vaisala.com, harinik@xilinx.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 May 2022 13:46:33 -0600 you wrote:
> Simplify the logic in the Cadence MACB/GEM driver for determining
> when to reschedule NAPI processing, and update it to use NAPI for the
> TX path as well as the RX path.
> 
> Changes since v1: Changed to use separate TX and RX NAPI instances and
> poll functions to avoid unnecessary checks of the other ring (TX/RX)
> states during polling and to use budget handling for both RX and TX.
> Fixed locking to protect against concurrent access to TX ring on
> TX transmit and TX poll paths.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: macb: simplify/cleanup NAPI reschedule checking
    https://git.kernel.org/netdev/net-next/c/1900e30d0ef7
  - [net-next,v2,2/2] net: macb: use NAPI for TX completion path
    https://git.kernel.org/netdev/net-next/c/138badbc21a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


