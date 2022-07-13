Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0626757353C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiGMLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiGMLUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535DC1014BA;
        Wed, 13 Jul 2022 04:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51FC618B9;
        Wed, 13 Jul 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24D42C3411E;
        Wed, 13 Jul 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657711215;
        bh=Hru8gwAV4eo4rCHAk7DXzFg5JrNPvv9poAlkid6MCvQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UtkMFyVMQ1EPy2dY0r2DOgEQKCTq6VxGTvw0ShGt2QcfZQDvj+N7n3E2NB/X7c/HY
         9pfTsLInFGa98hTbRkKmuUFF1684rLMlhNIkeWRJCYqIBw78+XynOxTrRGn6zwIQvj
         xzcz12/S2JXhMzAKYWe8H+T3sWOKBsavYKD2F2vRxR3F/ZiCSdo4fHYWUcffAy1sOb
         AMhHxGb5v0NjyPxUZ13pFEft1kymmJAi1l7ZUsslZalsmO+R/A4DdJovlXpDS0uRHS
         fKSNGW54Xq184ckecMIRzBtlGj/OAzfWayTDF2R73Woo6+TzoFF2bJxb/VakTko7IC
         KRn0fA/87yekw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03692E45227;
        Wed, 13 Jul 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4 net-next] Allow to inherit from VLAN encapsulated IP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771121500.27638.11997159786649321214.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 11:20:15 +0000
References: <20220711091722.14485-1-matthias.may@westermo.com>
In-Reply-To: <20220711091722.14485-1-matthias.may@westermo.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 11 Jul 2022 11:17:18 +0200 you wrote:
> Currently IPv4 and IPv6 tunnels are able to inherit IP header fields
> like TOS, TTL or the DF from their payload, when the payload is IPv4
> or IPv6. Some types of tunnels, like GRETAP or VXLAN are able to carry
> VLANs. The visible skb->protocol shows in this case as protocol
> ETH_P_8021Q or ETH_P_8021AD. However all the relevant structures for IP
> payload are correct and just need to be used.
> 
> [...]

Here is the summary with links:
  - [1/4,v3,net-next] ip_tunnel: allow to inherit from VLAN encapsulated IP
    https://git.kernel.org/netdev/net-next/c/7ae29fd1be43
  - [2/4,net-next] ip6_gre: set DSCP for non-IP
    https://git.kernel.org/netdev/net-next/c/41337f52b967
  - [3/4,net-next] ip6_gre: use actual protocol to select xmit
    https://git.kernel.org/netdev/net-next/c/3f8a8447fd0b
  - [4/4,net-next] ip6_tunnel: allow to inherit from VLAN encapsulated IP
    https://git.kernel.org/netdev/net-next/c/b09ab9c92e50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


