Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63FA59F03D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiHXAkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXAkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22866CF56
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 17:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD3BB8229E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45E61C433D7;
        Wed, 24 Aug 2022 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661301617;
        bh=17J6d1Ysuo1Az6/n1Qip4htaohxL2PvPCGuBT0EhC4M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tKSfV8IACfiDV++2W9G+gPH9faUWbwMwvK+8tz8BHModetVn3LFrOxwQLBZDLlufp
         3Gk9cA1Y8hHE4jP18CSOIAlA+fG59YlS7XIZG2nO5VqztgWdZiwjhWBHvBEl6T2u+p
         iR1VkSOai3jcDuLDS4ZkcZnt7E9LpFcBcPQssNN3LvSbCYdPsGtGAB5d1eW5pgSJu0
         pOJsQW1xOVp/BeoEubzPhClZCTZeS1Pth8E+hmS5yayGh3FcyASjA2BSIvwcmyP/06
         b8hZEOGAPQonr4wpKj1kzOeuK1Q1S762VGK4H1LmQ1WX49SvyvT5h+tBHzdTCEvLgY
         4X9GPpixKoDVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28D05E2A03B;
        Wed, 24 Aug 2022 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Introduce modular system support by
 minimal driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166130161716.14513.116953999817260959.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 00:40:17 +0000
References: <cover.1661093502.git.petrm@nvidia.com>
In-Reply-To: <cover.1661093502.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, vadimp@nvidia.com,
        idosch@nvidia.com, mlxsw@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 21 Aug 2022 18:20:10 +0200 you wrote:
> Vadim Pasternak writes:
> 
> This patchset adds line cards support in mlxsw_minimal, which is used
> for monitoring purposes on BMC systems. The BMC is connected to the
> ASIC over I2C bus, unlike the host CPU that is connected to the ASIC
> via PCI bus.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: core_linecards: Separate line card init and fini flow
    (no matching commit)
  - [net-next,2/8] mlxsw: core: Add registration APIs for system event handler
    https://git.kernel.org/netdev/net-next/c/2ab4e70966a2
  - [net-next,3/8] mlxsw: core_linecards: Register a system event handler
    https://git.kernel.org/netdev/net-next/c/508c29bf15ea
  - [net-next,4/8] mlxsw: i2c: Add support for system interrupt handling
    https://git.kernel.org/netdev/net-next/c/33fa6909a263
  - [net-next,5/8] mlxsw: minimal: Extend APIs with slot index for modular system support
    https://git.kernel.org/netdev/net-next/c/c7ea08badd5f
  - [net-next,6/8] mlxsw: minimal: Move ports allocation to separate routine
    https://git.kernel.org/netdev/net-next/c/9421c8b89dbb
  - [net-next,7/8] mlxsw: minimal: Extend module to port mapping with slot index
    (no matching commit)
  - [net-next,8/8] mlxsw: minimal: Extend to support line card dynamic operations
    https://git.kernel.org/netdev/net-next/c/706ddb7821be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


