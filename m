Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98C952F6B4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354198AbiEUAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiEUAUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:20:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04343190D06;
        Fri, 20 May 2022 17:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A0B961E6C;
        Sat, 21 May 2022 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA043C34113;
        Sat, 21 May 2022 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653092411;
        bh=okerM4+dRze994O7cYyBfgw7RR8XASMlqcJVm//DF3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hPSzRDHYe4x6lPC6MeRMkCgle1xdmP/ct8ODkQYkooLYkXrY4VbCgLOLTD95jbVb8
         bjbdIA+2UUPvGNGw7cjOM+k56pyCmU6E/6kyrXu3vF0lYmabnqHR8GXx42q1OZPuku
         8s+/MUwDODiEMwsvPba7RiZkXhy3TQ2ndWuorH2cdd+GQks8awG4TcqSpJpLslxEq6
         xJizSRFpOfBPVh/HJ/VD734iafX/ntXU3mlvhx7Zo3Ll7Eaa/x6V9yTWm4LRHuvvyS
         K7s8oaFB764MeGy73SNMQ5SEHoZVSk3OvYKt9Z4WSBt/0irNXxkujbfWskY7ydHsbZ
         Q4arg8yyQBWbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90126F0383D;
        Sat, 21 May 2022 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: tulip: fix build with CONFIG_GSC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309241158.18678.4082296643005446274.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:20:11 +0000
References: <4719560.GXAFRqVoOG@eto.sf-tec.de>
In-Reply-To: <4719560.GXAFRqVoOG@eto.sf-tec.de>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        yangyingliang@huawei.com, davem@davemloft.net, edumazet@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 20 May 2022 15:28:21 +0200 you wrote:
> Fixes: 3daebfbeb455 ("net: tulip: convert to devres")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  drivers/net/ethernet/dec/tulip/eeprom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: tulip: fix build with CONFIG_GSC
    https://git.kernel.org/netdev/net-next/c/dc2df00af951

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


