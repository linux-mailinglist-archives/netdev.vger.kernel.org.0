Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0874F4E9BBE
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiC1QB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbiC1QB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F7926ADF;
        Mon, 28 Mar 2022 09:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12FBB8115F;
        Mon, 28 Mar 2022 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82A2AC340F3;
        Mon, 28 Mar 2022 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648483211;
        bh=dEcILtGw+9X7ohrkAcFU2ski0Oskh/hbYv28iHFh0v4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=akFw0ZyTBtNP1FzMslPBPPMSmB/mnIR7dLomSsy0jkJ9c/rdn8XFiNzmquqFEaenJ
         GNwKDqE0GaJZBZKFzsIy1MA2JFiYFeNofiI33x8ONH4tjpOeddBesNA82bMe+gg8/9
         woYz/7nlsBSZH30CkayKbwzZ9KrY2nFc1lZS6iQXHhbBzK06nFJLqGfcoN0BMkgBb2
         MynN9PNDrWCOgEnMp7Y2nmYwAmkzVawy84LAjG31+j4MOl7DdqtQfSgpZs/riM5Lqg
         QrIbT0pwcf9T1ss/5s7GJZmxlkx/Wq57mrOnj78OtPdBcEBEc/nGUOBFmRc+GzFUjd
         QVuUaRfp6cLBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 690B9F03848;
        Mon, 28 Mar 2022 16:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: egress: Report interface as outgoing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164848321142.11751.9110855831733710740.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Mar 2022 16:00:11 +0000
References: <20220328082022.636423-2-pablo@netfilter.org>
In-Reply-To: <20220328082022.636423-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 28 Mar 2022 10:20:20 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Otherwise packets in egress chains seem like they are being received by
> the interface, not sent out via it.
> 
> Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: egress: Report interface as outgoing
    https://git.kernel.org/netdev/net/c/d645552e9bd9
  - [net,2/3] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options
    https://git.kernel.org/netdev/net/c/f2dd495a8d58
  - [net,3/3] memcg: enable accounting for nft objects
    https://git.kernel.org/netdev/net/c/33758c891479

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


