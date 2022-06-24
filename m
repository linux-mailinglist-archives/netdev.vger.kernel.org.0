Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E748558F68
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiFXEA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiFXEAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A41527C5;
        Thu, 23 Jun 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BF9620C4;
        Fri, 24 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38357C3411C;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656043214;
        bh=1wAFV39uOZAw9FJTlxJNm38YSsjZv5Y6vxnZ+S2Nhi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ItmEDBVW+/UdGgKJCcjPUBhvqGsijnAAAf9JknaoeaqBmD4HT2RLyapQIxz8xljPi
         8pcWErIqn+aDB1VxWHR5KwfaLdprT/g2jyt8OnKvbPl7pf6la6dmMN3Ihp+O+tXqKc
         mC7AviS6hXtyinB6QcotB3nvgDVIt1sNrcF60bDoOs1kmfxYTK6XZlUpR7xgYDGo2W
         koMcBYVzelv8E6A/oLF1aT0Eryjj8jPM8eVTkv318le5U9Cf6GznuQKIPFQJ63swkO
         BNwZObd2yaoDQL7Q4l2AJMKcVhR2jTwZmu40WyIDmmnWqogElVJp3JtUkgAfFMzo3W
         GjXrM9aUXbffg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BA86E8DBCB;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: add temperature sensor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604321410.27108.3691210316310321779.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:00:14 +0000
References: <20220622141716.3517645-1-michael@walle.cc>
In-Reply-To: <20220622141716.3517645-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lxu@maxlinear.com, jdelvare@suse.com,
        linux@roeck-us.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hwmon@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 16:17:16 +0200 you wrote:
> The GPY115 and GPY2xx PHYs contain an integrated temperature sensor. It
> accuracy is +/- 5°C. Add support for it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/Kconfig   |   2 +
>  drivers/net/phy/mxl-gpy.c | 106 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+)

Here is the summary with links:
  - [net-next] net: phy: mxl-gpy: add temperature sensor
    https://git.kernel.org/netdev/net-next/c/09ce6b20103b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


