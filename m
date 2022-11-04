Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3652618FC2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiKDFAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDFAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ACA1C924;
        Thu,  3 Nov 2022 22:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43EF4B82BEB;
        Fri,  4 Nov 2022 05:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 432A5C4314B;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=8Yu68FFz/IN/iw6z8M5F7puwnDwMQ8M52dLpIpPz1qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gu9GOrgtD6qZ/mexeYWrZbP9Cl4WDrho4OP/vxhf/g5wvHBbyaUt9XJxmOIp+gT2v
         FIbwYcs91eOoQmm4vBmz7a29plDHMyJSjB8ahlWSEoW4zMNSr7Bnh8EUPmitk1lA3g
         trHoWEmZrlNWWv3fqk5Gj1F8p/9eBzs0e/GIqREkj+9QBDPOQ5EhdmJHEIusYJyQOb
         k1MAi9EkckrEJD7b09H2ArFw2GHmyO1pqaE5O2DTuqU/3+pBRd440QW3dVjZlcXy+h
         uYVHv+LLyHdmDOivwLiff4uubCb5P8VlGweBel/Tc8zcaIrebzOPTdWRs3SYQfWrV3
         wuTjhp8HFeAGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0612E270EA;
        Fri,  4 Nov 2022 05:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v4 00/13] net: fix netdev to devlink_port linkage and
 expose to user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802697.27738.796894733261826728.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:26 +0000
References: <20221102160211.662752-1-jiri@resnulli.us>
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Nov 2022 17:01:58 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently, the info about linkage from netdev to the related
> devlink_port instance is done using ndo_get_devlink_port().
> This is not sufficient, as it is up to the driver to implement it and
> some of them don't do that. Also it leads to a lot of unnecessary
> boilerplate code in all the drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/13] net: devlink: convert devlink port type-specific pointers to union
    https://git.kernel.org/netdev/net-next/c/3830c5719af6
  - [net-next,v4,02/13] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
    https://git.kernel.org/netdev/net-next/c/8573a04404dd
  - [net-next,v4,03/13] net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
    https://git.kernel.org/netdev/net-next/c/45791e0d00c4
  - [net-next,v4,04/13] net: devlink: take RTNL in port_fill() function only if it is not held
    https://git.kernel.org/netdev/net-next/c/d41c9dbd1274
  - [net-next,v4,05/13] net: devlink: track netdev with devlink_port assigned
    https://git.kernel.org/netdev/net-next/c/02a68a47eade
  - [net-next,v4,06/13] net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port
    https://git.kernel.org/netdev/net-next/c/ac73d4bf2cda
  - [net-next,v4,07/13] net: devlink: remove netdev arg from devlink_port_type_eth_set()
    https://git.kernel.org/netdev/net-next/c/c80965784dbf
  - [net-next,v4,08/13] net: devlink: remove net namespace check from devlink_nl_port_fill()
    https://git.kernel.org/netdev/net-next/c/d0f517262933
  - [net-next,v4,09/13] net: devlink: store copy netdevice ifindex and ifname to allow port_fill() without RTNL held
    https://git.kernel.org/netdev/net-next/c/31265c1e29eb
  - [net-next,v4,10/13] net: devlink: add not cleared type warning to port unregister
    https://git.kernel.org/netdev/net-next/c/e705a621c071
  - [net-next,v4,11/13] net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
    https://git.kernel.org/netdev/net-next/c/8eba37f7e9bc
  - [net-next,v4,12/13] net: remove unused ndo_get_devlink_port
    https://git.kernel.org/netdev/net-next/c/77df1db80da3
  - [net-next,v4,13/13] net: expose devlink port over rtnetlink
    https://git.kernel.org/netdev/net-next/c/dca56c3038c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


