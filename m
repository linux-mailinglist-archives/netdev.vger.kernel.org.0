Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC951D5D9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391011AbiEFKoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 06:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391027AbiEFKoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 06:44:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFB7B38
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C2C0B8350C
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 360ECC385AE;
        Fri,  6 May 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651833616;
        bh=CwE3vp8Zqv0Xh6JW9mFX5BZlWsQYBugkV4J7MLBGyGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=orflDwcL9R2vZOE7hyZTclIfMFchdf31jSHfw9YL7rVe5Y4mkXOP6xvRcdbloF/m2
         w6U0f88ZZqIKqnHwa7V1bU3bEpw/C5EayrZ2JBMkY+o1UlrV20IYyo42NyiNacztSb
         hz85flkPRA3E810ufEZ7mhj5B0v2BjBo7UFgCpBRL1tsatVg95hIPT4Xk9U8AIUDmV
         EFlaLLhCOM0TgwZuj9AFwz0DAXnoNdAQheuZdCXtsC/BV6kyFkV2rHzJKrsuGGoL3O
         SwZo8gnqswsoXKYG/wHgb3KbitMp7RZ9K0akJ12dApfJTEKxc2i360HF7x9dI8lRPB
         iIFtWp0md+PHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19DFBE7399D;
        Fri,  6 May 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] nfp: flower: decap neighbour table rework
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165183361610.1798.14970799269060227562.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 10:40:16 +0000
References: <20220505054348.269511-1-simon.horman@corigine.com>
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
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

On Thu,  5 May 2022 14:43:39 +0900 you wrote:
> Louis Peens says:
> 
> This patch series reworks the way in which flow rules that outputs to
> OVS internal ports gets handled by the nfp driver.
> 
> Previously this made use of a small pre_tun_table, but this only used
> destination MAC addresses, and made the implicit assumption that there is
> only a single source MAC":"destination MAC" mapping per tunnel. In
> hindsight this seems to be a pretty obvious oversight, but this was hidden
> in plain sight for quite some time.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] nfp: flower: add infrastructure for pre_tun rework
    https://git.kernel.org/netdev/net-next/c/29c691347e38
  - [net-next,2/9] nfp: flower: add/remove predt_list entries
    https://git.kernel.org/netdev/net-next/c/e30b2b68c14f
  - [net-next,3/9] nfp: flower: enforce more strict pre_tun checks
    https://git.kernel.org/netdev/net-next/c/38fc158e172b
  - [net-next,4/9] nfp: flower: fixup ipv6/ipv4 route lookup for neigh events
    https://git.kernel.org/netdev/net-next/c/9d5447ed44b5
  - [net-next,5/9] nfp: flower: update nfp_tun_neigh structs
    https://git.kernel.org/netdev/net-next/c/9ee7c42183d1
  - [net-next,6/9] nfp: flower: rework tunnel neighbour configuration
    https://git.kernel.org/netdev/net-next/c/f1df7956c11f
  - [net-next,7/9] nfp: flower: link pre_tun flow rules with neigh entries
    https://git.kernel.org/netdev/net-next/c/591c90a1d0b0
  - [net-next,8/9] nfp: flower: remove unused neighbour cache
    https://git.kernel.org/netdev/net-next/c/c83a0fbe9766
  - [net-next,9/9] nfp: flower: enable decap_v2 bit
    https://git.kernel.org/netdev/net-next/c/a7da2a864a4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


