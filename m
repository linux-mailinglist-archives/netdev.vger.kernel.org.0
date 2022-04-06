Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D7E4F57E5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 10:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiDFIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 04:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357081AbiDFIYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 04:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA1FE41C;
        Tue,  5 Apr 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A2861978;
        Wed,  6 Apr 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25B47C385A6;
        Wed,  6 Apr 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649208012;
        bh=dC3v0I2tbjatrppFTcXtArePWkg3Hg3WP7/TXZKrEYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eU31G606J6itN38BjoJvPTgXdZX9D6h9QYMA93UzZGQsHvHjkWfL9P1Z4yEkPTWHb
         G3qrb/qmquK50artxYNOA9piMh4BLAOUIN58X0tAES7w+/jBtFNCU6g33XJqczHuRz
         yWrn3ed6ij3wseUkl4Dwdg7Kwhj2wTUDNSBo35R4rZADwjoolI0EIfJfXc985Wpenf
         MP9j1o4rp00XelBQh4vY5Ts3i4PpwY0XyPd7YwBDbGW2tvJy1UeerC1YJmANox8guI
         BqPF+gOqzyoAgDLTEgA15s/CDi0+9cpNX3B1COEASNaHS03QAkyUQFPuA0qIjCRZy+
         S7Y8QgH5UBkYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A490E85BCB;
        Wed,  6 Apr 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: micrel: Fix KS8851 Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164920801203.3942.12236675927293580268.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 01:20:12 +0000
References: <20220405065936.4105272-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220405065936.4105272-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Divya.Koppera@microchip.com, lkp@intel.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 5 Apr 2022 08:59:36 +0200 you wrote:
> KS8851 selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL, so
> make KS8851 also depend on PTP_1588_CLOCK_OPTIONAL.
> 
> Fixes kconfig warning and build errors:
> 
> WARNING: unmet direct dependencies detected for MICREL_PHY
>   Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
>     Selected by [y]:
>       - KS8851 [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && SPI [=y]
> 
> [...]

Here is the summary with links:
  - [net] net: micrel: Fix KS8851 Kconfig
    https://git.kernel.org/netdev/net/c/1d7e4fd72bb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


