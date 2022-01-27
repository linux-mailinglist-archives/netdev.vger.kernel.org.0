Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CE049E873
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244329AbiA0RKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244326AbiA0RKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:10:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36BEC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4073CE22ED
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02CF9C340EE;
        Thu, 27 Jan 2022 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643303410;
        bh=vvlPCAPfzLCIRpZexTvt5GdE/5/136xCq9xrTcnexvQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UlO1c7LKBjZRxqc3h5j6E9R4et+ESwB2b+o8nBLHnry/XSR+iMcos1RLK03N+L8lu
         Ay7782suiv3A23OZKsevFHfTuwCWjvXmi3Un0WMfywVPnzxzAEd9mojEJJFWCSOAVz
         txvYMWdK5SfPj2G/t+wB4vDVbgbwCDkAyOCtXWSaw9siO++RobRQ38N56OIL9DXmGE
         s4dpbryE/qJqgXDMrHbCDoRGt3KVbIzMTvmSgfUYqfDMkVStRsvW3zxKp9yEjd2rK9
         uMOR7s+yCFRM4nEXtzs/tLLxDq5XC3QE0TUePW+gvQVgWA2WokltbJG7V7rVNrij5X
         z4D1b+yw41INQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCF34E5D08C;
        Thu, 27 Jan 2022 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: remove sparse error in ip_neigh_gw4()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164330340990.19448.12077727125467937766.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 17:10:09 +0000
References: <20220127013404.1279313-1-eric.dumazet@gmail.com>
In-Reply-To: <20220127013404.1279313-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Jan 2022 17:34:04 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ./include/net/route.h:373:48: warning: incorrect type in argument 2 (different base types)
> ./include/net/route.h:373:48:    expected unsigned int [usertype] key
> ./include/net/route.h:373:48:    got restricted __be32 [usertype] daddr
> 
> Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] ipv4: remove sparse error in ip_neigh_gw4()
    https://git.kernel.org/netdev/net/c/3c42b2019863

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


