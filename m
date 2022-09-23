Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0CF5E7921
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiIWLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiIWLKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E09BA831E;
        Fri, 23 Sep 2022 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B07161EF9;
        Fri, 23 Sep 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 664ADC433D7;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663931418;
        bh=LbW+VUr9DWt/bljfn5Ciy9AmuInJestA0k3eWHVTt6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RYaHvTqq5gghs2gneIkUOvpWfNcxCgBpvD6gOB5162wt+2McsR83Vl73OpvKKpn2e
         RCIj0oiS5U9XleKIyItiMsDYWY7jx4UwundC1RMm11QNkhKurfeeYjheFmSqh6K5qY
         OBSyTf9SANNaAQbOhMIXGABEEELA27gxx/Duuy+S4hNZFFLmh6PcNRiCnF3JBzzKWK
         H7pB5v4PvKiuDSEJArKoxH+VBuG4dU/CIVcC7PM8M/M9t6dc/0NGqDl0iHqXKrb7WH
         eRS6PuSv+GP7U8IbZbN6XWS+Ihk1huu0GGk2GnIt2CQTNQNzrGtUaJlmfaYoW9Yj9n
         V4fAEnH9CmyKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A6F4E4D03A;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/8] net: phy: Add support for rate matching
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393141830.14679.9638727148672158207.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:10:18 +0000
References: <20220920221235.1487501-1-sean.anderson@seco.com>
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, olteanv@gmail.com, edumazet@google.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        alexandru.marginean@nxp.com, davem@davemloft.net,
        claudiu.manoil@nxp.com, ioana.ciornei@nxp.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
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

On Tue, 20 Sep 2022 18:12:27 -0400 you wrote:
> This adds support for phy rate matching: when a phy adapts between
> differing phy interface and link speeds. It was originally submitted as
> part of [1], which is considered "v1" of this series.
> 
> Several past discussions [2-4] around adding rate adaptation provide
> some context.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/8] net: phylink: Document MAC_(A)SYM_PAUSE
    https://git.kernel.org/netdev/net-next/c/72bc36956f73
  - [net-next,v6,2/8] net: phylink: Export phylink_caps_to_linkmodes
    https://git.kernel.org/netdev/net-next/c/606116529ab2
  - [net-next,v6,3/8] net: phylink: Generate caps and convert to linkmodes separately
    https://git.kernel.org/netdev/net-next/c/3e6eab8f3ef9
  - [net-next,v6,4/8] net: phy: Add support for rate matching
    https://git.kernel.org/netdev/net-next/c/0c3e10cb4423
  - [net-next,v6,5/8] net: phylink: Adjust link settings based on rate matching
    https://git.kernel.org/netdev/net-next/c/ae0e4bb2a0e0
  - [net-next,v6,6/8] net: phylink: Adjust advertisement based on rate matching
    https://git.kernel.org/netdev/net-next/c/b7e9294885b6
  - [net-next,v6,7/8] net: phy: aquantia: Add some additional phy interfaces
    https://git.kernel.org/netdev/net-next/c/7de26bf144f6
  - [net-next,v6,8/8] net: phy: aquantia: Add support for rate matching
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


