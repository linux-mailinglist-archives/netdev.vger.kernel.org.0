Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4C6E7206
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjDSEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjDSEAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656CCBD;
        Tue, 18 Apr 2023 21:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0039063AD8;
        Wed, 19 Apr 2023 04:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5552FC433D2;
        Wed, 19 Apr 2023 04:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681876820;
        bh=vgEhT3DN6ynf6R4F3xtCOzrOmgEJfNf7Nr38ap2Fl+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d4L49imguao0Ki9hRpAYBLGK4wkWkJSjSQeVVkziJXv1fuohiotzl5fRZ1tejHlpA
         8IzA9Ua+zrZ7OcZepQJMs4f8BG1Z/oQm/kcJt2ABsldYrZTsLtE4xrBTbgRzwTVhlK
         cluPIc9jcS/T6Aii6ke02wEy0lIE1pFESdqUSf+MeKjtgNCHbT1up3gwV6RRMONkb/
         vK7P2nO33D/ZhHrs7JbtrDuxkx2oILOu26tvU7I7y0UU4c25kWa1BTpijGLutKePDj
         tU+hhJIc4Odq4FWifpCVTv34q/ZhgQBZGc8A90WzxjpoTi96eblgybyeWPVLcOSRQQ
         q4vAmvTEqggxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3800AE270E4;
        Wed, 19 Apr 2023 04:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: br_netfilter: fix recent physdev match
 breakage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168187682022.7147.4357332163358366183.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 04:00:20 +0000
References: <20230418145048.67270-2-pablo@netfilter.org>
In-Reply-To: <20230418145048.67270-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 18 Apr 2023 16:50:44 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Recent attempt to ensure PREROUTING hook is executed again when a
> decrypted ipsec packet received on a bridge passes through the network
> stack a second time broke the physdev match in INPUT hook.
> 
> We can't discard the nf_bridge info strct from sabotage_in hook, as
> this is needed by the physdev match.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: br_netfilter: fix recent physdev match breakage
    https://git.kernel.org/netdev/net/c/94623f579ce3
  - [net,2/5] netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net/c/af0acf22aea3
  - [net,3/5] netfilter: nf_tables: fix ifdef to also consider nf_tables=m
    https://git.kernel.org/netdev/net/c/c55c0e91c813
  - [net,4/5] netfilter: nf_tables: validate catch-all set elements
    https://git.kernel.org/netdev/net/c/d46fc894147c
  - [net,5/5] netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements
    https://git.kernel.org/netdev/net/c/d4eb7e39929a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


