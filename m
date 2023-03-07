Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBABB6AE2A5
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCGOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjCGOe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:34:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3C285A59;
        Tue,  7 Mar 2023 06:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3DF60DBB;
        Tue,  7 Mar 2023 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98807C433D2;
        Tue,  7 Mar 2023 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678199418;
        bh=gXPkTWbahz3ORbfpJZiBGYEwqJ/rCSLFbAFkrFKsIlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c+AUUZrfajAt1OLLGXhkxoECKDnahh2grC0BEunkmlG3xRq63e0SClRfjfq7Za4Hc
         1PZVXfIwfVZGrL9RoRFE+gWF61sMPuIohgiRV/WQtOs/UzLOEKQYsynkOL0P8itVS8
         ABlPvSm0oRCxEAlpPoBy0Y9sv18pI85t0UVr1vRcnrAIOjkvnzjGkMh47Zt07PFkXH
         msfrYqWBH08G2rpHMzxOpqeac/FGQfuXAKt9deA5n/e/gYJABzulBxH4JB8FaUaof4
         qeMyPgnY5nylM5xoDReJTymLIN+9n6XJhTWI0B5XIJ58OVL97e7W/BLxa7Nh1Lz1SQ
         aRcp+HNjU+e7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73419E61B65;
        Tue,  7 Mar 2023 14:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: ctnetlink: revert to dumping mark
 regardless of event type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167819941844.11375.13263488021043524057.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 14:30:18 +0000
References: <20230307100424.2037-2-pablo@netfilter.org>
In-Reply-To: <20230307100424.2037-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue,  7 Mar 2023 11:04:22 +0100 you wrote:
> From: Ivan Delalande <colona@arista.com>
> 
> It seems that change was unintentional, we have userspace code that
> needs the mark while listening for events like REPLY, DESTROY, etc.
> Also include 0-marks in requested dumps, as they were before that fix.
> 
> Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
> Signed-off-by: Ivan Delalande <colona@arista.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: ctnetlink: revert to dumping mark regardless of event type
    https://git.kernel.org/netdev/net/c/9f7dd42f0db1
  - [net,2/3] netfilter: tproxy: fix deadlock due to missing BH disable
    https://git.kernel.org/netdev/net/c/4a02426787bf
  - [net,3/3] netfilter: conntrack: adopt safer max chain length
    https://git.kernel.org/netdev/net/c/c77737b736ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


