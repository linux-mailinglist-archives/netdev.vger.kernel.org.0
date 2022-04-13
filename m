Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BDA4FF7E9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiDMNmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbiDMNmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8860727CFA;
        Wed, 13 Apr 2022 06:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF2761A97;
        Wed, 13 Apr 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47249C385A4;
        Wed, 13 Apr 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649857211;
        bh=UqAlu4EI5mVDKiNbuIH/ikTpKLI8EHlJRLAoxFpNiC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NxQZkhXFSQBnAYZk6Kdjtwu95hRI9RZA1zeyovRcvFYA2/DhdfS/dZX9NsBiFYV57
         5uw/+GbKZfxlcYGnMtCAtZQe42TNRPNr9Q4sKR91sQgxIbCItNdKIulFz9mrz09dnf
         tUIwkf13fegssxekU/sboOTcCCp/aTbT3QVbIqyV4nD/9Q3znUxxuLAIO15G8XJt7F
         XJaI7pmoBVQhIx1SgRjOOZ1OdD8jJHo6LzOU0Ib9acZAWBA2cZJ8IKRwYbdznIjX8J
         AGfiyVMrHiyNwxa+BbQzDyePIMvkcm1DvZMYToXDDx0urozRVj5GhYmZ1wTEmxVuvM
         QwcX2rOO015DQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28538E7399B;
        Wed, 13 Apr 2022 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: realtek: fix Kconfig to assure consistent
 driver linkage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985721116.11835.15732143942368473091.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:40:11 +0000
References: <20220412155527.1824118-1-alvin@pqrs.dk>
In-Reply-To: <20220412155527.1824118-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        luizluca@gmail.com, lkp@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 12 Apr 2022 17:55:27 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The kernel test robot reported a build failure:
> 
> or1k-linux-ld: drivers/net/dsa/realtek/realtek-smi.o:(.rodata+0x16c): undefined reference to `rtl8366rb_variant'
> 
> ... with the following build configuration:
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: realtek: fix Kconfig to assure consistent driver linkage
    https://git.kernel.org/netdev/net/c/2511e0c87786

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


