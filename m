Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779F86C5F2F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCWFub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCWFuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7882366C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5256FB81F69
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F25AFC433D2;
        Thu, 23 Mar 2023 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550622;
        bh=PIYxprbZclUMgKuPo9eucQKvaWDcvpC8eoTjpXmxugw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EcoRqsDxiiJsDmXjeqIwCgAVJnisYAvKddBmXeLw0bx/1JVzjwY0xHarZOI5umX6i
         cycoUFjuvGbZwBVEidyiNznYWZ1Q1EavcCc50/RWYilEy9GG9EtLqe2jA+/e6L4Dfg
         ObM9xPfGKhOtLBhikm7Tr9DYU2/C4Rjyc9jhOmmk2HNJUb/L2r/RrCuIIixp27H5JP
         a5b/Xq9Dy+OPGHR5spiPlgLTvC6284K7PNIBdspWNrmZWRk/ci2pidB4YEO4WXJ4tv
         esAoExicVfXlIIM9fw/yh/Lr9b8v6IYoCc5gK8D6waha4K2FErcirB3QrpAOj8R77S
         W7NE2VrK5DYXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DED06E4F0D7;
        Thu, 23 Mar 2023 05:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Quirk for OEM SFP-2.5G-T copper module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955062190.14332.12018910625899155487.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:21 +0000
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
In-Reply-To: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, frank-w@public-files.de, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 16:58:26 +0000 you wrote:
> Hi,
> 
> Frank Wunderlich reports that this copper module requires a quirk in
> order to function - in that the module needs to use 2500base-X.
> Moreover, negotiation must be disabled.
> 
> An example of this device would be:
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sfp-bus: allow SFP quirks to override Autoneg and pause bits
    https://git.kernel.org/netdev/net-next/c/8110633db49d
  - [net-next,2/2] net: sfp: add quirk for 2.5G copper SFP
    https://git.kernel.org/netdev/net-next/c/50e96acbe116

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


