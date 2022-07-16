Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD7576B59
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 05:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiGPDAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 23:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGPDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 23:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB383A4AA;
        Fri, 15 Jul 2022 20:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5DDB82F44;
        Sat, 16 Jul 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA012C341C6;
        Sat, 16 Jul 2022 03:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657940414;
        bh=WesvKr+3zgDR6OKOPO4nXw36zLe4wI89fpPU7PRtOxw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pwOi4xRqa3sfInzx7tBHPxeZPndDjiem9mW3Hc8rZSQQMTjrpNWC2/C2rCF1Ayj1Q
         xd6dclTqL2MHv7WMadXtScIaEMgps+dThSScXjsMhFNGfz8DVhwDSHClKeatMvc2/w
         ewkZ3sTyDIN11Hyp89LWRWnDmd/y0DjqezErSjrV45ZdsNl/yxj1j2aL8OYstKfbLG
         DkaEunRTzqzk6pOxpbR6rq9O53Gr2AJWIUIkIjBpoZEPwA0nEJ3Tb1T1UI8aOzzGtG
         V/A57Vta0YUBzrDBeKQQ9AxGgwimiCDZhFgtFzMkgutJWUPR5/IxPrd2NM7q1Q1Jrn
         RLaOzJWcGk+Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A41ADE4522F;
        Sat, 16 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] net: ipv4/ipv6: new option to accept
 garp/untracked na only if in-network
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165794041466.22960.16853534349610766541.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jul 2022 03:00:14 +0000
References: <cover.1657755188.git.jhpark1013@gmail.com>
In-Reply-To: <cover.1657755188.git.jhpark1013@gmail.com>
To:     Jaehee <jhpark1013@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, dsahern@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, roopa.prabhu@gmail.com, aroulin@nvidia.com,
        sbrivio@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Jul 2022 16:40:46 -0700 you wrote:
> The first patch adds an option to learn a neighbor from garp only if
> the source ip is in the same subnet as an address configured on the
> interface that received the garp message. The option has been added
> to arp_accept in ipv4.
> 
> The same feature has been added to ndisc (patch 2). For ipv6, the
> subnet filtering knob is an extension of the accept_untracked_na
> option introduced in these patches:
> https://lore.kernel.org/all/642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com/t/
> https://lore.kernel.org/netdev/20220530101414.65439-1-aajith@arista.com/T/
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] net: ipv4: new arp_accept option to accept garp only if in-network
    https://git.kernel.org/netdev/net-next/c/e68c5dcf0aac
  - [v3,net-next,2/3] net: ipv6: new accept_untracked_na option to accept na only if in-network
    https://git.kernel.org/netdev/net-next/c/aaa5f515b16b
  - [v3,net-next,3/3] selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and accept_untracked_na
    https://git.kernel.org/netdev/net-next/c/0ea7b0a454ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


