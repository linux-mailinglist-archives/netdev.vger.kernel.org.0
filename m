Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DF04C4298
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbiBYKkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbiBYKkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:40:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D468FA8;
        Fri, 25 Feb 2022 02:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BDB8B82DB8;
        Fri, 25 Feb 2022 10:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1473EC340F3;
        Fri, 25 Feb 2022 10:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645785611;
        bh=XuS3BCY1hxK+FgMHmNVnxJ1VK7e/bZrGxXOkhZkayko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qh9l0yvlzln3bVm3IXXcNBVblx4GnTK+9EwVZ2Yo2zcpyn5vpSX+n0Wa+GfArPXyM
         FvSQyICs2XUjLOxAcabSWgNk7A5yPmwsp/qo9ED5G/EMv5PMQcgcu/3jprkeazmLKS
         o+bRWnSDOgTt7z9Q/6PSyGlXJ1qYVKrnc/VZVcvpaKK9j6pxNARB+qSSKMy5l0YRys
         WsE4rWxv//YGvTZcq4DBBNdjGoKaKQv87Lfrgv4iYu1UZgxiX7DbJ3ee+xXuawjr+h
         LRj31Y4fYjJFmrXA2VDLob0rUavJPg5RA+1fviHgqO9Qcc82Xd5z5EG+D5iWCl3SY5
         VDHRPgVTTVS2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1A79E6D453;
        Fri, 25 Feb 2022 10:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension header
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 10:40:10 +0000
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
In-Reply-To: <20220224005409.411626-1-cpp.code.lv@gmail.com>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        kuba@kernel.org, dev@openvswitch.org, linux-kernel@vger.kernel.org
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

On Wed, 23 Feb 2022 16:54:09 -0800 you wrote:
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
> 
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> ---
>  include/uapi/linux/openvswitch.h |   6 ++
>  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>  net/openvswitch/flow.h           |  14 ++++
>  net/openvswitch/flow_netlink.c   |  26 +++++-
>  4 files changed, 184 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,v8] net: openvswitch: IPv6: Add IPv6 extension header support
    https://git.kernel.org/netdev/net-next/c/28a3f0601727

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


