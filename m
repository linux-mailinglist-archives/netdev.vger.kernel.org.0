Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAC6D1768
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCaGaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCaGaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76051903A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B1AD623A5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E9E3C433AA;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244220;
        bh=a/ZbPiCPjorXCWjiq1SUjK4uipqt9qE4X0ohZTRVga0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HwiZF0D0necHWqb8Q6swIkvm5fmxDfkSlXXXh4/k8wRdtmK5/QpVWDWKNVZztZYSC
         NUqsCax23EpPQkW76vk1NrLH0U0GI0Pu06CSy6yQyRDxpec8OVbPZP+SH8yHq9e5SM
         eEAPhaiuDmRGHFTsjT05gIq7dHdbl6HBmrJNoxBdNMcdEZrURio73pWFcfGr4gDgWJ
         p27CAYuB3kyGSb8MV2hgo1OtdQMcsQdoEET1Dj/Hbf4CU+MOPvUrLhrCGpauSOM9k0
         nB097AOM1iPiH280epIJqYX6YozpJxipU3u+D74+ppcM/IP7A9SvJLITLWYPw8bJv7
         Am6wDuxJ/rvNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CB9FE2A034;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: fix db type confusion in host fdb/mdb
 add/del
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024422030.32019.8660293048422950854.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:30:20 +0000
References: <20230329133819.697642-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230329133819.697642-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 16:38:19 +0300 you wrote:
> We have the following code paths:
> 
> Host FDB (unicast RX filtering):
> 
> dsa_port_standalone_host_fdb_add()   dsa_port_bridge_host_fdb_add()
>                |                                     |
>                +--------------+         +------------+
>                               |         |
>                               v         v
>                          dsa_port_host_fdb_add()
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: fix db type confusion in host fdb/mdb add/del
    https://git.kernel.org/netdev/net-next/c/eb1ab7650d35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


