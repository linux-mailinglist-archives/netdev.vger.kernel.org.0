Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96294BCAB9
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 22:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiBSVUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 16:20:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiBSVUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 16:20:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BD04739B
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 13:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F894B80CDA
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 21:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA5C5C340EB;
        Sat, 19 Feb 2022 21:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645305608;
        bh=kcckSGCHC5K32XW9VLcfTMdn6dYLnZYolXTK5XiQ8bY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qiiv1AXgtkBW/xct9T5KHk48k+WKmluyQ9IFqSKLsd5wtVosMoJz2aiMMn41CDd8u
         eZGeoE4aGmhlfeRHB7X09/f9lqWpZwEy/JY4ieW42Z/DWKSW/gWqNd+J5tckMzwtGN
         5urJa6+CrXgeeyFyJXMvMWN1W+Wax+T3M7ox2/77WMoIGo3l06MBqPWjeJFQGeqIkZ
         yGB/RQDlqdqt1zaUyG/nPXO6dXIkFpkY/+3z/vwSj8IT4kA/ROhijGLCQk02OxCyTn
         Zr04thZYnH57X0qp2Dpv8Yw5cUXLHeWe0jS6L7m4TqP5CXTSQeUHo6aTW4tni/wDZU
         2P1rukCat6LZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B705E7BB0A;
        Sat, 19 Feb 2022 21:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: avoid call to __dev_set_promiscuity() while
 rtnl_mutex isn't held
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164530560863.19212.14892876083818590654.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 21:20:08 +0000
References: <20220218121302.3961040-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220218121302.3961040-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        o.rempel@pengutronix.de
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Feb 2022 14:13:02 +0200 you wrote:
> If the DSA master doesn't support IFF_UNICAST_FLT, then the following
> call path is possible:
> 
> dsa_slave_switchdev_event_work
> -> dsa_port_host_fdb_add
>    -> dev_uc_add
>       -> __dev_set_rx_mode
>          -> __dev_set_promiscuity
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: avoid call to __dev_set_promiscuity() while rtnl_mutex isn't held
    https://git.kernel.org/netdev/net/c/8940e6b669ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


