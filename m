Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089D84EEBE7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbiDALCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245638AbiDALCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0FEBADF
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB5E6187A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E071C34114;
        Fri,  1 Apr 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810812;
        bh=1/AyoVLWgrUpQcOIpfrwoDVdtebfq9BwuNP6wzLKANk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oy7bIUZglNfiGMqxFO/0s495qPhtBv3Se2mup6qE4vLd/kf52HH0DVo9JFxhWcrEs
         uZFi28C6OtB9C5jCzkgnpUFb4KZm9soGp9C8n+aYg5SJiJCH7hdeyEw7FEOmrM+yIA
         SxueKeXpNUPN6m84p1VMHuXk4PAczJqnH45JUewWvyDSvsMj8MUSlpKisnRgUIJVpv
         AIoB6Whss1zZVC4ciLUOSa8jdR9kzzsS6+X9t6g5TcGNBC5KBg5Ne1QQZv/ZpZeF6d
         jU9A4fTgBNeOVYvLehxHllT3XJmF72nzk0jUZxGSycFhWhdlLBKiZI3RZlPZbQetjY
         DmI9FlrCwJwZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFAA7F0384D;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vrf: fix packet sniffing for traffic originating from ip
 tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881081197.13357.9237951319464430801.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:00:11 +0000
References: <20220331072643.3026742-1-eyal.birger@gmail.com>
In-Reply-To: <20220331072643.3026742-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, andrea.mayer@uniroma2.it, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 31 Mar 2022 10:26:43 +0300 you wrote:
> in commit 048939088220
> ("vrf: add mac header for tunneled packets when sniffer is attached")
> an Ethernet header was cooked for traffic originating from tunnel devices.
> 
> However, the header is added based on whether the mac_header is unset
> and ignores cases where the device doesn't expose a mac header to upper
> layers, such as in ip tunnels like ipip and gre.
> 
> [...]

Here is the summary with links:
  - [net] vrf: fix packet sniffing for traffic originating from ip tunnels
    https://git.kernel.org/netdev/net/c/012d69fbfcc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


