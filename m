Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705C7649BC6
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiLLKLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiLLKLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:11:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77883E0CE;
        Mon, 12 Dec 2022 02:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB769CE0E31;
        Mon, 12 Dec 2022 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4FB8C43398;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839816;
        bh=Wxn+B7aX6FMW92W1Pzy0RWLBT2/JJUshAI0KEIcp3AE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qKcuHS/+VEjE6c+fTOoTdpgwrFF9rNJbW77T3rPaOzo4pcUClQW0rEA1bAPNYzo5X
         bbCdW/O+A/nejSX6jhFDG2uhXdPzG08AnGTRf1DF5u+S1rUuRGcX/nEpQMe9vFEP0x
         YFuWK0cQaUMyKMB5UuSJxInMOLANV1BgrDV4SDXx9+jRbZVPCSERyJyJluyKg51R7I
         IOMUyFpS7IFu14clFwjpQ96RT8gw28OqpPks24JOx62dUubjjprcoqYsHU27b3dwT3
         h1w8C0Pn56l1ztbkuSHSQab4TmyDWOZCiXlPJD871Db9UedH+NaUM/UK2FsGQO0odl
         B+U2WXhGbyVGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7427C41612;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: setsockopt: fix IPV6_UNICAST_IF option for connected
 sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083981667.16910.15861355638445401606.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:10:16 +0000
References: <20221208145437.GA75680@debian>
In-Reply-To: <20221208145437.GA75680@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 15:54:46 +0100 you wrote:
> Change the behaviour of ip6_datagram_connect to consider the interface
> set by the IPV6_UNICAST_IF socket option, similarly to udpv6_sendmsg.
> 
> This change is the IPv6 counterpart of the fix for IP_UNICAST_IF.
> The tests introduced by that patch showed that the incorrect
> behavior is present in IPv6 as well.
> This patch fixes the broken test.
> 
> [...]

Here is the summary with links:
  - [v2] net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets
    https://git.kernel.org/netdev/net/c/526682b458b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


