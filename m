Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8D1530F84
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiEWLaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbiEWLaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CD54F9C7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49915B8105C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFD9BC34116;
        Mon, 23 May 2022 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653305412;
        bh=PxbIPh7ZKtQbaojnrPrmHk7KncStZzXFGGFlTVi1rMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L2pb6ncv7MsbbCkSc+pfS3WjP047hTMxOGtkXHdRBWzfN7MOirf3c34lQLydy8fq4
         0bKMYzQ86g2vWtzRTxM80oMAvMUvV97ZLHoATc1tQd22jCDxWhCTRu+G0Q9v51DSRZ
         ik4vM63i5JPFDsv+WSy/mYPaz0TyiAGxSyCb9zjiCrxzWCCydYaV6pfG25nxTi7BdR
         zjTVJrDl+zDYWBMomMbkgAithO8wL8ewti+nUW0sjTqbFYptWpI1SYwphStSJoG0Rl
         hAgVGGJsKWeGOF3R87I9bI6iip49IldYoJmTA5kVLJqxSMHqaxcvbyS+9yqiH/pqf5
         ozBTI0OoT6G5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2F1BF03943;
        Mon, 23 May 2022 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND] net: dsa: OF-ware slave_mii_bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165330541186.29728.7833943571558286689.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 11:30:11 +0000
References: <20220523013233.20045-1-luizluca@gmail.com>
In-Reply-To: <20220523013233.20045-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 22 May 2022 22:32:34 -0300 you wrote:
> If found, register the DSA internally allocated slave_mii_bus with an OF
> "mdio" child object. It can save some drivers from creating their
> custom internal MDIO bus.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND] net: dsa: OF-ware slave_mii_bus
    https://git.kernel.org/netdev/net-next/c/fe7324b93222

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


