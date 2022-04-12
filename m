Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86964FE778
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiDLRww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358591AbiDLRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:52:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA6347570;
        Tue, 12 Apr 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70774B81FAB;
        Tue, 12 Apr 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 073CFC385A8;
        Tue, 12 Apr 2022 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649785812;
        bh=R5GNybcC+QKP0Sr/SA2CJ/Dn1KBdDCfEP2k5ffl65w0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZDA3YybuZ4gX/PF5DRvK5wsk4D71mnEeN0wlWu3FgT97aTuBTt3i1/ZhF2OZzCgyG
         rMDI+ycVG/dpEBXOv64vaqpOEGowZAMZlDMYIWlkgNJ9pI9eJpupLDUyrAijRk6Glf
         8PXv2XCc9/IXHJi67CS7D8l60Q1l9YuX9sWefuRbYeYa8pmc4kthZhcP6BljjeGTGx
         ShFUfHjycTKxvRp4MjnAwZPGo9hkuZM4fp+GjTE8CxvXtQReov7/uzk+d+AStMolB8
         GDMaI05LiW4GetPlilbfiK3Yd+WMUyGW+dRu+HhJ01BLJ+uJwH3SgmEqT1YxhpE8wy
         cG0LvpVU4MF+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D92B4E6D402;
        Tue, 12 Apr 2022 17:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nft_socket: make cgroup match work in
 input too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164978581188.6445.15587964483471417022.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 17:50:11 +0000
References: <20220412094246.448055-2-pablo@netfilter.org>
In-Reply-To: <20220412094246.448055-2-pablo@netfilter.org>
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

On Tue, 12 Apr 2022 11:42:45 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> cgroupv2 helper function ignores the already-looked up sk
> and uses skb->sk instead.
> 
> Just pass sk from the calling function instead; this will
> make cgroup matching work for udp and tcp in input even when
> edemux did not set skb->sk already.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nft_socket: make cgroup match work in input too
    https://git.kernel.org/netdev/net/c/05ae2fba821c
  - [net,2/2] netfilter: nf_tables: nft_parse_register can return a negative value
    https://git.kernel.org/netdev/net/c/6c6f9f31ecd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


