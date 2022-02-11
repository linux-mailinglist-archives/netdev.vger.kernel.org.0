Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771A44B2519
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349824AbiBKMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:00:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbiBKMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF83F50
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2420B829B6
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 12:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC3B9C340F0;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580813;
        bh=Z0yHGzvPYUrA20GO8gC2jKhSqS3UkgxqbIDOGE5Wb4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DVlbfkm6peh5DPQE2L9uIszebVESlhpTpFCNnmLQVEDo+2q8ZA1XgqmDySMbcafCv
         MdMDnoa6xPIyf4ibGr9mmwGy1ix9mhZw4ZbvZEzD2Ll/d0tOGP1ccsfOOw1NGX7GwO
         wY3vAA6r5w6sHMtaQqen4kiBj3It89jlgkV+Fwg8zHcn1Lz/TNt44Yf7dkmty5yWY6
         2cUq+bA78FhF19Ti6da9TzYQZnN0/cF5aMgxAe6RFFnKgOKGSta+KBlxef3H8Pxbkq
         HYSDmHlORMC4YYbzCrjY4czsdL8Ha+MUBgh8RzQudPlOIITWFzk5vSavaNUu3EYGNI
         iZ2OF+hzh32CQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5D13E5CF96;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] More aggressive DSA cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458081367.17283.2101733740341432702.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:00:13 +0000
References: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
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

On Thu, 10 Feb 2022 15:44:57 +0200 you wrote:
> This series deletes some code which is apparently not needed.
> 
> I've had these patches in my tree for a while, and testing on my boards
> didn't reveal any issues.
> 
> Compared to the RFC v1 series, the only change is the addition of patch 3.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220107184842.550334-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
    https://git.kernel.org/netdev/net-next/c/45b987d5edf2
  - [v2,net-next,2/3] net: dsa: remove lockdep class for DSA master address list
    https://git.kernel.org/netdev/net-next/c/8db2bc790d20
  - [v2,net-next,3/3] net: dsa: remove lockdep class for DSA slave address list
    https://git.kernel.org/netdev/net-next/c/ddb44bdcdef7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


