Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228FA6BA9F9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjCOHvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjCOHut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:50:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBEE64255
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03DC461BE2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6773CC4339B;
        Wed, 15 Mar 2023 07:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866618;
        bh=NtJQo/3W1tzwgQY/TcY/+NaFDkB3TNJ5hD7A8qMed9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GYfZl8kw6+SwdW5Yau+fYLXhNjxMmN2NmoMYrkHVwRWXOxLCLOUZMA6zNvQEg656P
         vj2OiBWQ+qsZj4nsmk/5QpWLsX+DhbuMOzB1VPzdbw62WBDHi+fgjJzWmU2MtDn9hQ
         7Y4QJGiT8yNZSTNx6slazFlRVxM4O2DXcxbCuX10iF5xqdS6XytDlIK6WcYBh+OQPE
         YvqFS57bx7hU7cpSDpUzLkwz1rZLNFDgpf6RbhqduzrPC9rMe+159n5yBCmMcqJC3T
         YPbYjwkHXSCOjHcSmb7ZArIbcamLvPg94bfeT/tjUj+BMxwdYiFrnBPffnUFWSiXeF
         SQpfp69ERyu4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51A59E66CBC;
        Wed, 15 Mar 2023 07:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ipv6: optimize rt6_score_route()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886661833.11035.7278696730302666659.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:50:18 +0000
References: <20230313201732.887488-1-edumazet@google.com>
In-Reply-To: <20230313201732.887488-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Mar 2023 20:17:30 +0000 you wrote:
> This patch series remove an expensive rwlock acquisition
> in rt6_check_neigh()/rt6_score_route().
> 
> First patch adds missing annotations, and second patch implements
> the optimization.
> 
> Eric Dumazet (2):
>   neighbour: annotate lockless accesses to n->nud_state
>   ipv6: remove one read_lock()/read_unlock() pair in rt6_check_neigh()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] neighbour: annotate lockless accesses to n->nud_state
    https://git.kernel.org/netdev/net-next/c/b071af523579
  - [net-next,2/2] ipv6: remove one read_lock()/read_unlock() pair in rt6_check_neigh()
    https://git.kernel.org/netdev/net-next/c/c486640aa710

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


