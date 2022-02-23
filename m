Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D383D4C129E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240347AbiBWMUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiBWMUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:20:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E349F6EB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6D4EB81F1A
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D11AC340EB;
        Wed, 23 Feb 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645618810;
        bh=zO7B7hLxs1Q/E0MbtTtr9Ywq+lEDfGYDWzg6oIboCPo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=beoCuqSYrsH+l+yPMgNlsJlPKAIYDeWt1Ahj/HrQAfyu4ZysOwX+TVOMYJY0Av8eO
         E86Ab2SUJbj1Unj+E6iWX5GbTjgP7qSD4ixnimazktPmhIzMo/8b/wgIJWuKI0//ND
         5zVCwN8/kN2uWG4q/b4rDxcuGpsc3ZAzbE5zFMkR9dQi3Fc24kb2K736d+QptFdsQ+
         G2a3zzLrLYYAPtMlkyGPtnUee6gSjh9m2DS8snW+dFMcLfigFveywfEibXtLXoimJX
         H76W5IowsYkfFhh4RKBJ9vkSmMxV6M7uff5dySKAN7HdBjfYWUB+NMX7SslFZyaL1a
         ygL4100S5xPYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73744E5D09D;
        Wed, 23 Feb 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: switchdev: avoid infinite recursion from LAG to
 bridge with port object handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164561881046.16247.7870352572507957342.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:20:10 +0000
References: <20220221120130.1342581-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220221120130.1342581-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@nvidia.com, idosch@nvidia.com, rafael.richter@gin.de,
        daniel.klauer@gin.de, tobias@waldekranz.com
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

On Mon, 21 Feb 2022 14:01:30 +0200 you wrote:
> The logic from switchdev_handle_port_obj_add_foreign() is directly
> adapted from switchdev_handle_fdb_event_to_device(), which already
> detects events on foreign interfaces and reoffloads them towards the
> switchdev neighbors.
> 
> However, when we have a simple br0 <-> bond0 <-> swp0 topology and the
> switchdev_handle_port_obj_add_foreign() gets called on bond0, we get
> stuck into an infinite recursion:
> 
> [...]

Here is the summary with links:
  - [net-next] net: switchdev: avoid infinite recursion from LAG to bridge with port object handler
    https://git.kernel.org/netdev/net-next/c/acd8df5880d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


