Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCBD4BC5F4
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 07:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiBSFub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:50:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiBSFub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:50:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979D8BDE44
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4B3F60A52
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E630C340EF;
        Sat, 19 Feb 2022 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645249810;
        bh=udUCsjjeN5Mv3URvOzHQfdU6kRRSIolCq6hPlfCl1Eg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PQn1RUfiJAIRqNEwnSLTGgeX0xeCy6LZvW37cdkA6KuVtvrW+FrYJoI7OaYt1Xx+S
         +703I5qDXfQvdbWNleg8zZuhus3ULBtwzVSim+OvQWPzmq8k0dV0j0+eqjchySm6dh
         uGOxwCexjAQz90j4yAD8hX0ykUksC8aNYOCoI5z8x+ufufiISUiM8n+/0Sp6d6cr4w
         36R68AGXvBL/ZTiL4AWtVvQH+bK632dx0QMvKNxaMwBL8YebB4QMqhkALBP0hy5Whd
         lJZXcyE6Lr45KSFMMhtLlWE54hyZ3n8bOgwTRZeXa/itQgIqL1ciHG5elsGosUjEAJ
         E0mYFt1fcfB9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3026AE7BB18;
        Sat, 19 Feb 2022 05:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/1] net: Add new protocol attribute to IP
 addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164524981019.32402.16502499683988851589.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 05:50:10 +0000
References: <20220217150202.80802-1-Jacques.De.Laval@westermo.com>
In-Reply-To: <20220217150202.80802-1-Jacques.De.Laval@westermo.com>
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Feb 2022 16:02:02 +0100 you wrote:
> This patch adds a new protocol attribute to IPv4 and IPv6 addresses.
> Inspiration was taken from the protocol attribute of routes. User space
> applications like iproute2 can set/get the protocol with the Netlink API.
> 
> The attribute is stored as an 8-bit unsigned integer.
> 
> The protocol attribute is set by kernel for these categories:
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/1] net: Add new protocol attribute to IP addresses
    https://git.kernel.org/netdev/net-next/c/47f0bd503210

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


