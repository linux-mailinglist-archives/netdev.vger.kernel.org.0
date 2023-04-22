Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AECF6EB70A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDVDUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDVDUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996D919B4
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3377863ACC
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83E77C4339B;
        Sat, 22 Apr 2023 03:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682133618;
        bh=xThQTwP3e/rzseXxr8L+2vMStwwkKU58lK7hRy5Ie8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EDJ59VCGTszcOXSDILfa+4/WUQ9RSWsTMs40DyRWzFr6qJ8KNIa8Y2WGIhhdGYNnS
         +MZUZrY+OSWI3u1RvIdFLFp1omnuOrUWB0vvz8vMu3qiG8Z2+DJt5nmyUGZQ5mujYK
         m7yCDyaf4ulm4GUcyaqReoZgPxLf7L4lnR32YMasB/ypT/dvn3UT7OZjSF++mTtrlh
         2KULLptpNT6639+R8LZV8UtsviNomE8xRQUuVlad6kYIojkRdkz+XYtyGvPTcIPfun
         o6bXFHOJSSGE6ipzWUBQOrVzj0oknVxOBso5f7OFW28jIy+Ob3vbQkyoLezyvka2/c
         CDIg6hU+CCpNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67C6CC395EA;
        Sat, 22 Apr 2023 03:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: add basic driver for NXP CBTX PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213361842.18367.5822261095281572491.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:20:18 +0000
References: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 22:01:41 +0300 you wrote:
> The CBTX PHY is a Fast Ethernet PHY integrated into the SJA1110 A/B/C
> automotive Ethernet switches.
> 
> It was hoped it would work with the Generic PHY driver, but alas, it
> doesn't. The most important reason why is that the PHY is powered down
> by default, and it needs a vendor register to power it on.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: add basic driver for NXP CBTX PHY
    https://git.kernel.org/netdev/net-next/c/f3b766d98131

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


