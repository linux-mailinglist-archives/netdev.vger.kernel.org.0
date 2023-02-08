Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0A68EB10
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjBHJXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHJWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:22:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7744CC677;
        Wed,  8 Feb 2023 01:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30F29B81CD9;
        Wed,  8 Feb 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D22A0C433D2;
        Wed,  8 Feb 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675848018;
        bh=M7+OmCw25nxVDg8kyD+vfjOP6SDJ3peJh0O4adh2agM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyYrEWopMrpCbrcgaYUmR1ZhRDzQMoJZDHHeuCLpCAMtxm4Z+Xak7wvHSAuiTi5aJ
         QHx61njStxrQD06lwBzMv6Zp2Rsx17EKWo8pPD2SnURI+k7uGBu2ZvAoppecCCfi8+
         /6xztPolmTw1c67pRnqVNO6gelaxLhXKo+t35bmk8OQYzpHSSQohdogpXtyr+oPGUK
         g4E7ip1I6nFw+UotXZUT1EyhTZj/fv7F2JXyJq7WpM50P79S0SVtASJMIpqkwmCEnv
         fZuiqJhh8UbQwapKQf4A28AYCSJvefiNcv9XkliZrE9U+IR5CZvURy1NZTP97V3Ji+
         EN1ObUZKj3U0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD2E0E4D032;
        Wed,  8 Feb 2023 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net: micrel: Add support for lan8841 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584801877.16330.13349498131343728827.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:20:18 +0000
References: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael@walle.cc
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 7 Feb 2023 11:52:10 +0100 you wrote:
> Add support for lan8841 PHY.
> 
> The first patch add the support for lan8841 PHY which can run at
> 10/100/1000Mbit. It also has support for other features, but they are not
> added in this series.
> 
> The second patch updates the documentation for the dt-bindings which is
> similar to the ksz9131.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net: micrel: Add support for lan8841 PHY
    https://git.kernel.org/netdev/net-next/c/a8f1a19d27ef
  - [net-next,v4,2/2] dt-bindings: net: micrel-ksz90x1.txt: Update for lan8841
    https://git.kernel.org/netdev/net-next/c/33e581d76e35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


