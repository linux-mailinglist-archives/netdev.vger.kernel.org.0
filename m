Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0FF6B84E3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCMWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCMWkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E969079E;
        Mon, 13 Mar 2023 15:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E91E9B815E6;
        Mon, 13 Mar 2023 22:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 774F2C433D2;
        Mon, 13 Mar 2023 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678747217;
        bh=KsjEdY2a+8NMgQ2onckdMyDaX8QgmgfLg+psxAsczA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S80lNgFMegJyk2KmtoUioNHpCT70sM4mWLC6Jq1iTFlzKt5q5N8axQaLdWgYJD/Mc
         NyiyMOupwEOziUQEurYGEAJQZrL/zLLlq/I4O66KJHGgId+OnP5Ofdry2lm4nKCN9r
         KGmyStjqt00BQXlvScBY6qOibjm2bKHM0Kp8Wbq/laUyf10O3//4vnHEXiyfw2A2aJ
         D5+HrWI7FhP50YUhOtRDEscXUPuvpva0Hy29KhxhtzwFMQZKU+k8+97ib4cU3eNpY4
         9eKTyxGWGrHtVikZuyYiUythXac8gR87z0PnFmUQNbTBCXE2YQbMTXgQgIOK4am+Qb
         l+DgnQ13NZYcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C104C43161;
        Mon, 13 Mar 2023 22:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874721737.4558.3993647614359972063.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 22:40:17 +0000
References: <20230307214402.793057-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230307214402.793057-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Mar 2023 22:44:02 +0100 you wrote:
> Lan8841 has 10 GPIOs and it has 2 events(EVENT_A and EVENT_B). It is
> possible to assigned the 2 events to any of the GPIOs, but a GPIO can
> have only 1 event at a time.
> These events are used to generate periodic signals. It is possible to
> configure the length, the start time and the period of the signal by
> configuring the event.
> Currently the SW uses only EVENT_A to generate the perout.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: phy: micrel: Add support for PTP_PF_PEROUT for lan8841
    https://git.kernel.org/netdev/net-next/c/e4ed8ba08e3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


