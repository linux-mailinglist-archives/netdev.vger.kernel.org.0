Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9922168A7FB
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjBDDa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjBDDaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:30:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E705028D25
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BB6BB82CCA
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BFF1C433EF;
        Sat,  4 Feb 2023 03:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675481419;
        bh=XCEB+j0XIMXiwadn+X/ErztvJ6MjS4/BQ3W0M5pRMtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRPhzbWKwMxiRc+JCsUW9c+ZP/HXPcVDJdZ+HmJAYlmDmNKLcaBYArvprw7Nh83Hi
         BAhbRCw4uu/sJVtQEwWI+k2/lBHggv+JS2dyH5iym2rcl1qlFQWGJBJOZ1/IdlaG2k
         En4Z/V6hKWu8xlTAXd0btB2bSQyS8JwL+BG0XjuHmj82RPTHYxLfxjprEnHNTUyeaZ
         4c3aHthQl7Twj3OyRoo/sjGAA+sl+8lKpA5xDn12hrgZCjuHp1yR0SlBy3KBT1k9bI
         jNxCDdGP+SVf2nYVzsSyypaFAwG/XHguJWyRFtY8kv7jXp1UQZSdXII2mp6UFh+r/U
         eYLlflgLb30lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D93EE4448D;
        Sat,  4 Feb 2023 03:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more
 consistently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548141951.31101.17566572700650872764.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 03:30:19 +0000
References: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230202140354.3158129-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Feb 2023 16:03:54 +0200 you wrote:
> Now that commit 028fb19c6ba7 ("netlink: provide an ability to set
> default extack message") provides a weak function that doesn't override
> an existing extack message provided by the driver, it makes sense to use
> it also for LAG and HSR offloading, not just for bridge offloading.
> 
> Also consistently put the message string on a separate line, to reduce
> line length from 92 to 84 characters.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more consistently
    https://git.kernel.org/netdev/net-next/c/d795527d5079

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


