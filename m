Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE1D525885
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359560AbiELXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359045AbiELXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F02286FFC;
        Thu, 12 May 2022 16:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F29EE62059;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5513FC34118;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652398813;
        bh=fxawoRZm7HHdnOAKqA+Ar1XQM5WiZ0dq7/qFO9WM5V4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbVVE7oQuyJjtfMWimCXYqsa3PPlu4nfaaW1dXJ9omOyVwUZmIUITAzOuX1xNMAoa
         UUG9809mxy7NhRCna4o92nD2FDe3JL0NrVHgro3JR7OAKROEJrcTvjU6p0kLvBDuoT
         JXg4sB4J1DS52SKw+rqR2cWEOKREvM1YLecoUezf+Zs8mCeIGjoJpTOB0/uHeBZH/W
         CE/WehS1G+wPHcaxaN1Xd71M9OTLgLhtXwRLKYgsFkSUBwgnJt90JxgeGby3a/a3qZ
         Tbx+7rJL46UEEL9HdQ3AYko7g0RDBW0KgtZwSOGhP+CfgaxLO+TuAIxaYiLes4ly2A
         plL9FFZYsjTVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F482F03935;
        Thu, 12 May 2022 23:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix use of pointer after being freed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239881318.13563.9379638810266990590.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:40:13 +0000
References: <20220511204059.2689199-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220511204059.2689199-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dan.carpenter@oracle.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 22:40:59 +0200 you wrote:
> The smatch found the following warning:
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c:736 lan966x_fdma_reload()
> warn: 'rx_dcbs' was already freed.
> 
> This issue can happen when changing the MTU on one of the ports and once
> the RX buffers are allocated and then the TX buffer allocation fails.
> In that case the RX buffers should not be restore. This fix this issue
> such that the RX buffers will not be restored if the TX buffers failed
> to be allocated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix use of pointer after being freed
    https://git.kernel.org/netdev/net-next/c/f0a65f815f64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


