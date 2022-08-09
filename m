Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBE58D289
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 06:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiHIEAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 00:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiHIEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 00:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E166DE8B;
        Mon,  8 Aug 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79739B81192;
        Tue,  9 Aug 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1BFBC43145;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660017614;
        bh=hFvBiNjX38zGdFyQFHryDp8eiU3ThkH9wEo0y74LRQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=giySWUqfIU5frMBtpecDM97Rqszg3+xYt073XQVQFpBZ+TF+anDMZ1GqnrtCa7nyg
         v3BsAjWOHP/9+5d53Jz+Y//4eFwRqflq/TYmSt3dXusSvCIR+Yw4gIMGR00REPCXW3
         Su874OnDnyJnL1MiOCQJe5yWZS5K0hwVJWLvwLVjtiRrtrJTtYzcwKGwLyqlvdhCBD
         n3pDfuicEctCnWASUE4e4FiaqXR1c6RRlFUcZd7ME7VNF1xl1YTZQhIcNOTW+RH0Ci
         2BkQa8pGbFm40gplfzOmLt1SvkPPIjWovomtZOyAz9/nfcPum7q63trEkzcjmw79bP
         LvxkJecYifVLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9AB58C43147;
        Tue,  9 Aug 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1 1/1] net: phy: c45 baset1: do not skip aneg
 configuration if clock role is not specified
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166001761462.6286.9959019131059137424.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 04:00:14 +0000
References: <20220805073159.908643-1-o.rempel@pengutronix.de>
In-Reply-To: <20220805073159.908643-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Aug 2022 09:31:59 +0200 you wrote:
> In case master/slave clock role is not specified (which is default), the
> aneg registers will not be written.
> 
> The visible impact of this is missing pause advertisement.
> 
> So, rework genphy_c45_baset1_an_config_aneg() to be able to write
> advertisement registers even if clock role is unknown.
> 
> [...]

Here is the summary with links:
  - [net,v1,1/1] net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified
    https://git.kernel.org/netdev/net/c/3702e4041cfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


