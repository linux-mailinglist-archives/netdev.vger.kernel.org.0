Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5F612052
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJ2FKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJ2FKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F07D8D20A
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 22:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9687C60A67
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 05:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E93F1C433C1;
        Sat, 29 Oct 2022 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667020217;
        bh=X/sYnPZ0QOu+vKloPZM3mdYM8Jvq4uo3jj+EvmUdI4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XwZ22NM6w8r9p1hXHkYAwoUxrM31HhX03wGaZyDlt6ZjWzKgIolgnOzloMM4fqRKw
         E2995mAfEsTiZHF04xENIT7+nuPO9ppYHX+F+nawUEWlV/PcQ1FcCBQVboTJ03+06R
         /OfDjYI4eC/TC7exCi4LL4EUe5964CxNwhzBU4JAP/TxbmIXfsRf3NJqZBOtYCyEwu
         7ZaKNz2dZEEk6kTUXnOE8V036RgXhfJOXEzVvymTyJL5QJKLbonHpzmuGJc3W1z0+w
         7InL4BN0mtNUCnBUDx4i+HvdF0r/saeWg2ZH1guhXolhLknx59CQiH7VV8aZny8Wm5
         pKQoJANKbCZ/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9AA2C41672;
        Sat, 29 Oct 2022 05:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fall back to default tagger if we can't load
 the one from DT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702021681.21650.16266710469669138096.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 05:10:16 +0000
References: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, colin.foster@in-advantage.com, michael@walle.cc,
        heiko.thiery@gmail.com, tobias@waldekranz.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 17:54:39 +0300 you wrote:
> DSA tagging protocol drivers can be changed at runtime through sysfs and
> at probe time through the device tree (support for the latter was added
> later).
> 
> When changing through sysfs, it is assumed that the module for the new
> tagging protocol was already loaded into the kernel (in fact this is
> only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
> and tag_ocelot_8021q.ko; for every other switch, the default and
> alternative protocols are compiled within the same .ko, so there is
> nothing for the user to load).
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fall back to default tagger if we can't load the one from DT
    https://git.kernel.org/netdev/net/c/a2c65a9d0568

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


