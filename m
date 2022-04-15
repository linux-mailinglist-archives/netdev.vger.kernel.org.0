Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3877C50272E
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 11:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351644AbiDOJDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 05:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiDOJDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 05:03:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528C58AE52;
        Fri, 15 Apr 2022 02:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F39C0B80171;
        Fri, 15 Apr 2022 09:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91CCBC385A8;
        Fri, 15 Apr 2022 09:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650013243;
        bh=MetiOuWbF050kxsHnVkalbwK32pwNS7n10G5RvDN38M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jjlPh2atZsOsN//6lP1kYJuOTvIOm78g7TfP2m0mcM/W4PlnGhR4mvca12pN7kDxr
         AZ1NOCC9EdqiHKvun/BkLlbOiIa7F9s1B9r+spHHjv0HajcUhqYC46Z07cDeyqWFUb
         NZd95laeV7JEqP6ES/L5epfx7B8I3PMtE5SBCJPjUbWDRzz0c1r6y2S37dZUCIOKZE
         FVuG6GqwYlhM9wwjX8Rfxs9hakdbi35miWRbPzpXsmysMKUXG35rL3ZmEKZx/YoPIV
         ClLwr5S2mTMsLHWg8DNQVemQrSUI2CxrRa+4E4juzCpoVOqM2yHBvpe1gHeIMqNEmH
         PlOx5XAu/sgHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FF4EE8DD6A;
        Fri, 15 Apr 2022 09:00:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: realtek: fix Kconfig to assure consistent
 driver linkage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001324345.27870.14252281044127630297.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 09:00:43 +0000
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

This patch was applied to netdev/net-next.git (master)
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
    https://git.kernel.org/netdev/net-next/c/2511e0c87786

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


