Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812906C7B10
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjCXJU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjCXJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11742196C;
        Fri, 24 Mar 2023 02:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 724DC629EA;
        Fri, 24 Mar 2023 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE017C433A1;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649620;
        bh=5LqmC99QtmV+r9u1aeFABBghmVJFQzyx0SJew6QHq60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G+VoTBUfDHkImrxDTOsbaJ4s5dUdorpTHTEX4ToIJzpEHz8YZZ+sD/vur3vjLo8Ve
         8NifeBRlQcRcGR3rENT1e16hFTxxCDLgE65Lbxdkfis2Y6lSDIpePIRk5vUAA85tM0
         PU3Tq6y31cNB8imtuUt+Rht01UN2sqsfmX315Rzpq/n95vDGSYG2Y8sNknf5ZEgL5s
         VB4p+QQjU0djZqieC9O6mT/D2Mjdi3yJ8Pw3vNymasIzcpXNV6RnNjZ7GiRH+B5dz2
         W/GpBH201nCdDPp+emMgf2QfaKP7HJmYrOIpOCJDdYjSGVKBefxYU9I91REBPWOmdZ
         Fpx4wDD4eNybw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89D36E55B3C;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: micrel: Add support for PTP_PF_EXTTS
 for lan8841
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964962055.21111.17239786384362789296.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:20:20 +0000
References: <20230323105557.2436767-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230323105557.2436767-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, error27@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 11:55:57 +0100 you wrote:
> Extend the PTP programmable gpios to implement also PTP_PF_EXTTS
> function. The pins can be configured to capture both of rising
> and falling edge. Once the event is seen, then an interrupt is
> generated and the LTC is saved in the registers.
> 
> This was tested using:
> ts2phc -m -l 7 -s generic -f ts2phc.cfg
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: micrel: Add support for PTP_PF_EXTTS for lan8841
    https://git.kernel.org/netdev/net-next/c/fac63186f116

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


