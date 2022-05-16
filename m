Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0C5290BF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiEPUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348290AbiEPUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0EB47AD2
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 990A4B81664
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C788C36AEB;
        Mon, 16 May 2022 20:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652732414;
        bh=yVc4vG4SBh6CiP2ObDB9p0URWlQPgGWwBAbZSduftVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Era4HAdcxOT2IbO81j3OcZYs6B68IhM2A9JLDS/0jbBZ+rTxNjiVH9wO2nIHSmAJa
         LizkWb1TeT4ONElQVXLx9fwEIKQn7fp/ym9k35PD6YL9Fcs3qgm6cgbFAvuumSS4Lm
         4puPyg4urmpPsxKaVV86WEf7NrOS/YbX7va1WIpGnmqRhTfpTtkEUDjHlz0CMBgdwl
         Dja9jheDcwZ5KLUW5DK9efKAct1z1jUxEtm8sQGUseeXGekWc0gu3dgQLwXonqrZeO
         9ID/rwg5FxoricDpjX7UdiJOoeKxmlSiFZ/zBDEtTBS0ouPQj4cKIo6ZBtBdyfl38B
         NDE3YcUjXS3Lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41288E8DBDA;
        Mon, 16 May 2022 20:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: dsa: realtek: rtl8366rb: Serialize indirect
 PHY register access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165273241425.3924.15121346619659145136.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 20:20:14 +0000
References: <20220513213618.2742895-1-linus.walleij@linaro.org>
In-Reply-To: <20220513213618.2742895-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, alsi@bang-olufsen.dk, lkp@intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 May 2022 23:36:18 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Lock the regmap during the whole PHY register access routines in
> rtl8366rb.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reported-by: kernel test robot <lkp@intel.com>
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: dsa: realtek: rtl8366rb: Serialize indirect PHY register access
    https://git.kernel.org/netdev/net-next/c/f008f8d0305c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


