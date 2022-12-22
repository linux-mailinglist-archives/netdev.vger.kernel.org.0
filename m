Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84ED653A62
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiLVBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiLVBuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824371AA2F
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 17:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8490619B2
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B23FC433F2;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671673816;
        bh=vwfBpD4Y9HPmAJ3yRCH8vbTvbu6X+tw3vU3jFgTmmMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cDSfugN/x7c96PZ8IkjtDQoI7syTD5Y9wQvczexDDeFv0XE4lsn7HUHA+HZS1BUqy
         YOTEJJSc8J19emwfzEVZbu/ooj0fFnNPtM6iHhud53tpYOH1h3jXfiqYO+WorVY5eI
         JTRZklrW89dA3O1eSDk0KqTjkfrjCN6b/aMdYrMU6vPlIewnAduZCPaHqDtQ9Rj5ms
         yHRmS7Z5dfHIIUHhbfmd4zJyoOCfSF5LXm1r/ySlhibkYkR9LYe5Rc7ogxEtMcf1qG
         0sF6JDCbFkyyMaJQgzXXtkRWv4nCGtt129+7NMi7BI7awOfrbXlpI7hegC2v9aJSsv
         YJMpsPwvvgmuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20BF6C74000;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: vrf: determine the dst using the original ifindex
 for multicast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167381612.8581.13679322807839148456.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 01:50:16 +0000
References: <20221220171825.1172237-1-atenart@kernel.org>
In-Reply-To: <20221220171825.1172237-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
        jishi@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Dec 2022 18:18:25 +0100 you wrote:
> Multicast packets received on an interface bound to a VRF are marked as
> belonging to the VRF and the skb device is updated to point to the VRF
> device itself. This was fine even when a route was associated to a
> device as when performing a fib table lookup 'oif' in fib6_table_lookup
> (coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
> FLOWI_FLAG_SKIP_NH_OIF was set.
> 
> [...]

Here is the summary with links:
  - [net] net: vrf: determine the dst using the original ifindex for multicast
    https://git.kernel.org/netdev/net/c/f2575c8f4049

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


