Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67757EC28
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 07:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiGWFAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 01:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiGWFAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 01:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9718BDEA8;
        Fri, 22 Jul 2022 22:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3B560BA0;
        Sat, 23 Jul 2022 05:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EB8CC341CB;
        Sat, 23 Jul 2022 05:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658552414;
        bh=vFe9xXqxuKH4IXLF98XoeXst5sI5G/VWT5rCfvFFDNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jUinCYLnJJY8MPU9BERe3sm1oOZU0BT7C0elo66cxG2dMfprhTrn7EsVvVVOqg+wY
         Tr79Ry7Y5DnuJRKMUM5vtFRtjiNUhu19onc6LkS/s7e3YhG8+QOdZ4ZRjWjgDP0Fjj
         dPbzt165rh44+YGM/T69ciiqAaEjBIyV+cSNH+dqRg85g/ZeqG7vkIV0tDIcD9Uwpx
         q8wFJ4qEtHp4qdC95vUqf74MQKBhevUDIWfYSswoVpDLrCiIyz8B8dXi+2xknFsopA
         z+k3JBJPsBZyIpo3WGaMbutDVMOfTCr16ns1kpj2zzdRJuPXCY7FEckLvYHmL3yVxv
         9y+duxHyazqbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40942E45200;
        Sat, 23 Jul 2022 05:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL
 from VLAN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165855241426.3532.9698805298871914394.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jul 2022 05:00:14 +0000
References: <20220721202718.10092-1-matthias.may@westermo.com>
In-Reply-To: <20220721202718.10092-1-matthias.may@westermo.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Jul 2022 22:27:19 +0200 you wrote:
> The current code allows for VXLAN and GENEVE to inherit the TOS
> respective the TTL when skb-protocol is ETH_P_IP or ETH_P_IPV6.
> However when the payload is VLAN encapsulated, then this inheriting
> does not work, because the visible skb-protocol is of type
> ETH_P_8021Q or ETH_P_8021AD.
> 
> Instead of skb->protocol use skb_protocol().
> 
> [...]

Here is the summary with links:
  - [net-next] ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL from VLAN
    https://git.kernel.org/netdev/net-next/c/7074732c8fae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


