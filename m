Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0F859C098
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiHVNay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbiHVNaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB3B1F615;
        Mon, 22 Aug 2022 06:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E829B8121C;
        Mon, 22 Aug 2022 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05D60C433D7;
        Mon, 22 Aug 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661175017;
        bh=b78FFULhsO3Za6l2UbreH9pHhLIqoEqFwFu/lJt1sfo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IsoMtGYjH+a8wVoz5Xl6W9iAKX5vDka6VdBsqzEP8GwyaydWjAYZMse3ViCIEhsCn
         XV49PelLo17lst8zuUIWC7ZpHwrdO/qJ2FmCGYl0C3Q06KSObZmw8svrYJ50Xo76tw
         AwMU6SwPMpzZOrlxGgkbyT2wcYXYWwrp9oU37m2Y7mbmeXeG6Lc7X+qVKbCse4e6AC
         FXeg8zC6APA1/O32kcp4Kvnugzp91y4OEhK4btfNGiSYRdaZQOQgCM4yg45YzAxwVF
         t0AvhxVNyVEa8mP8Bh+iAroVFPusXeBtm4VaPKJfRi3blsdWxOpW2F+MARCjgGQXyA
         d0iC3w3goPCTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2C95C04E59;
        Mon, 22 Aug 2022 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/8] net: lan966x: Add lag support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117501692.5977.2992380067711592787.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 13:30:16 +0000
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 21:34:41 +0200 you wrote:
> Add lag support for lan966x.
> First 4 patches don't do any changes to the current behaviour, they
> just prepare for lag support. While the rest is to add the lag support.
> 
> v3->v4:
> - aggregation configuration is global for all bonds, so make sure that
>   there can't be enabled multiple configurations at the same time
> - return error faster from lan966x_foreign_bridging_check, don't
>   continue the search if the error is seen already
> - flush fdb workqueue when a port leaves a bridge or lag.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] net: lan966x: Add registers used to configure lag interfaces
    https://git.kernel.org/netdev/net-next/c/7c300735a1a1
  - [net-next,v4,2/8] net: lan966x: Split lan966x_fdb_event_work
    https://git.kernel.org/netdev/net-next/c/9b4ed7d262f3
  - [net-next,v4,3/8] net: lan966x: Flush fdb workqueue when port is leaving a bridge.
    https://git.kernel.org/netdev/net-next/c/86bac7f11788
  - [net-next,v4,4/8] net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
    https://git.kernel.org/netdev/net-next/c/d6208adfc9a9
  - [net-next,v4,5/8] net: lan966x: Extend lan966x_foreign_bridging_check
    https://git.kernel.org/netdev/net-next/c/a751ea4d74e9
  - [net-next,v4,6/8] net: lan966x: Add lag support for lan966x
    https://git.kernel.org/netdev/net-next/c/cabc9d49333d
  - [net-next,v4,7/8] net: lan966x: Extend FDB to support also lag
    https://git.kernel.org/netdev/net-next/c/9be99f2d1d28
  - [net-next,v4,8/8] net: lan966x: Extend MAC to support also lag interfaces.
    https://git.kernel.org/netdev/net-next/c/e09ce97778e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


