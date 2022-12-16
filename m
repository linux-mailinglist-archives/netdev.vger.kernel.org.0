Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5E964E997
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLPKk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiLPKkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDBE50D50;
        Fri, 16 Dec 2022 02:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06DB66205F;
        Fri, 16 Dec 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61384C433F0;
        Fri, 16 Dec 2022 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671187215;
        bh=Wewkd5SDmHkbUAt3XZtiSnVIPvV83GRDz92fOI4moq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STd4O5b6gOTqcXOGhCgaxVitKqzYwpp0UxSkJ8kMG6/WNOOoInIHbqEvB/+XZzMr+
         INA4KAs+CUMBZSm2ejJpxtWUKE6eSGSiaLKN07rUc7RikyoXpmsUdJqgO/sJIgR3DW
         x4MbFOtRobXq8v9+sKKiJpliD3syEN7On/hrsLbVqYIU6eJqABtvk7HP+llYywrpL9
         dHIFgH/BwK5eU2BWm4PoIASatbw51PyZgy6tnByCIbKZbWkf/55u/gJrPjSZ+fyAIn
         36D4XJ0uKy1nlFL2MlosGZvcL7sulTDv0OCvAvrC+4QgXqGZOQyUbpAAWgr7jhD4mw
         TSAtQYtdjaq1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47B91C00445;
        Fri, 16 Dec 2022 10:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] openvswitch: Fix flow lookup to use unmasked key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167118721529.24472.8358404813504371626.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Dec 2022 10:40:15 +0000
References: <167111551443.359845.7122827280135116424.stgit@ebuild>
In-Reply-To: <167111551443.359845.7122827280135116424.stgit@ebuild>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, i.maximets@ovn.org, aconole@redhat.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
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

On Thu, 15 Dec 2022 15:46:33 +0100 you wrote:
> The commit mentioned below causes the ovs_flow_tbl_lookup() function
> to be called with the masked key. However, it's supposed to be called
> with the unmasked key. This due to the fact that the datapath supports
> installing wider flows, and OVS relies on this behavior. For example
> if ipv4(src=1.1.1.1/192.0.0.0, dst=1.1.1.2/192.0.0.0) exists, a wider
> flow (smaller mask) of ipv4(src=192.1.1.1/128.0.0.0,dst=192.1.1.2/
> 128.0.0.0) is allowed to be added.
> 
> [...]

Here is the summary with links:
  - [net,v3] openvswitch: Fix flow lookup to use unmasked key
    https://git.kernel.org/netdev/net/c/68bb10101e6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


