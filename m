Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1089567547B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjATMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjATMa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9AE4CE58;
        Fri, 20 Jan 2023 04:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E560B82762;
        Fri, 20 Jan 2023 12:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B6C5C4339C;
        Fri, 20 Jan 2023 12:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674217821;
        bh=71WXQ8JX+KWMcSFzIAQwrZNsJKzSN7MpkuVjbEnIFdM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iyw/GKkXftIoOuq3Ffizq++1TQc+5FLSw+lpg2J/96j643lX2XS/e03MPzYhZmeJm
         5jCnM2jALWaR47fQ/vwoiX1K6/IYh/XrEHXJmhqeboDTsjVIeJP4qzlwdQMlELlds4
         W9a9/IWnQqM40L58Az1Mu0TcsKREZwHAxlDlMikF+Jnvexvuf974vBzi6pRF+fr5U4
         yyhDv5hiZD7cqjBoxiPMpCaaF/qZRj1yZxh5NdKFKiYbamziO5GORDRCRBFXX6t0sf
         Kc+hgLC++AflMt3p+JOdSBTzWMJ0GYFzcDQXSVy8UewCM6Tkj+oyd5KW51Nwqec2+3
         9d85k39pb49xA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC700E54D2B;
        Fri, 20 Jan 2023 12:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/6] Introduce new DCB rewrite table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167421782096.21057.3566863729140483303.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 12:30:20 +0000
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
In-Reply-To: <20230118210830.2287069-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, error27@gmail.com, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, petrm@nvidia.com, vladimir.oltean@nxp.com,
        maxime.chevallier@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 Jan 2023 22:08:24 +0100 you wrote:
> There is currently no support for per-port egress mapping of priority to PCP and
> priority to DSCP. Some support for expressing egress mapping of PCP is supported
> through ip link, with the 'egress-qos-map', however this command only maps
> priority to PCP, and for vlan interfaces only. DCB APP already has support for
> per-port ingress mapping of PCP/DEI, DSCP and a bunch of other stuff. So why not
> take advantage of this fact, and add a new table that does the reverse.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] net: dcb: modify dcb_app_add to take list_head ptr as parameter
    https://git.kernel.org/netdev/net-next/c/34b7074d3fba
  - [net-next,v3,2/6] net: dcb: add new common function for set/del of app/rewr entries
    https://git.kernel.org/netdev/net-next/c/30568334b657
  - [net-next,v3,3/6] net: dcb: add new rewrite table
    https://git.kernel.org/netdev/net-next/c/622f1b2fae2e
  - [net-next,v3,4/6] net: dcb: add helper functions to retrieve PCP and DSCP rewrite maps
    https://git.kernel.org/netdev/net-next/c/1df99338e6d4
  - [net-next,v3,5/6] net: microchip: sparx5: add support for PCP rewrite
    https://git.kernel.org/netdev/net-next/c/2234879f4ca1
  - [net-next,v3,6/6] net: microchip: sparx5: add support for DSCP rewrite
    https://git.kernel.org/netdev/net-next/c/246c77f666b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


