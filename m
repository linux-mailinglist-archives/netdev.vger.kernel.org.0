Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF44F63EC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiDFPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiDFPoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE6E4DFA85;
        Wed,  6 Apr 2022 06:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AACF60B91;
        Wed,  6 Apr 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F79BC385A1;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649250613;
        bh=gG4mqrQyZIDY8ktwmoKEAPiG7OQRraAFlg8iIEBfa3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YuIbYIXmuQ5Q2p7CHH6erQKLgF1K+R1aMse2NZdSVVcsa50FU9rzJzGNB6mUyGUsf
         +qWI3A6qyLiNtwnAAYvlbWCpxjsuTDJkhRvJOBJmIpqR0jUjkVUmHPl6lHjESK+noA
         9kjbOv3bY1a422Myhw3j9yf86/bCWDEstM9+YJf32xfyI81BzkSpmWbZfw1555xJ8i
         hk7DgjFkyb2ZOaHmIzRwWvxJFI+Xc1PAHNml/JkDxJF3TeFi0ILWgvjsR9nEWCLIVx
         e8dG3ChYA64poMpSE1z5EkfRY3XmswXF7Xt1B1mZGrj7JUjic68BSXsi8Bxv+jXKrZ
         PAWF8sx5ffAGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75DB9E85BCB;
        Wed,  6 Apr 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: mscc-miim: reject clause 45 register accesses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925061347.5679.13887520366381747184.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:10:13 +0000
References: <20220405120233.4041760-1-michael@walle.cc>
In-Reply-To: <20220405120233.4041760-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Apr 2022 14:02:33 +0200 you wrote:
> The driver doesn't support clause 45 register access yet, but doesn't
> check if the access is a c45 one either. This leads to spurious register
> reads and writes. Add the check.
> 
> Fixes: 542671fe4d86 ("net: phy: mscc-miim: Add MDIO driver")
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: mscc-miim: reject clause 45 register accesses
    https://git.kernel.org/netdev/net/c/8d90991e5bf7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


