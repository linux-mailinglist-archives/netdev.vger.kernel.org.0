Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DCD5AD473
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 16:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiIEOAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 10:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238058AbiIEOAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 10:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5522FD10;
        Mon,  5 Sep 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E433612C6;
        Mon,  5 Sep 2022 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A36E3C433D7;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662386414;
        bh=Xuprs2MAHE3FNmZK/wLqJF3xpvEk6SEVjYJwRRAVh70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KKV9kimMSkHJHH/2mLd7bbMxvzRNSI98TWtghR1rSt/83kgRhgjwV84dFCtwfPuBt
         aVNcVFX/Wmd25Vx+WcRyz4+uytjbGniVTOGDDQynndCpfFyAnPgmYDNqTvCr2XRKrP
         JnSe6UM1WtjLqycB0xJopkhg1XYXY/mtXVM3hpbSwgEJRvB4h8EPVccKTdHRjxnjJQ
         M0tv7ytOJzKgCojUkEwDv43BCBtogCNtJomvkJmb9IxfijuieoiK9aAUDVvmGdpWFS
         W362tM0BbpHbCHz/Uz6T+prIUYDbwmvidxXAvUC2xuzHsA+5v+Q8mmu1rHH6CxmYVm
         N8hvGpvWh0v/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D02FE1CABF;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3] net: phy: Add 1000BASE-KX interface mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238641457.11602.14140679950100520661.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 14:00:14 +0000
References: <20220902220240.996257-1-sean.anderson@seco.com>
In-Reply-To: <20220902220240.996257-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kuba@kernel.org, corbet@lwn.net,
        pabeni@redhat.com, olteanv@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, linux-phy@lists.infradead.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 18:02:39 -0400 you wrote:
> Add 1000BASE-KX interface mode. This 1G backplane ethernet as described in
> clause 70. Clause 73 autonegotiation is mandatory, and only full duplex
> operation is supported.
> 
> Although at the PMA level this interface mode is identical to
> 1000BASE-X, it uses a different form of in-band autonegation. This
> justifies a separate interface mode, since the interface mode (along
> with the MLO_AN_* autonegotiation mode) sets the type of autonegotiation
> which will be used on a link. This results in more than just electrical
> differences between the link modes.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: phy: Add 1000BASE-KX interface mode
    https://git.kernel.org/netdev/net-next/c/05ad5d4581c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


