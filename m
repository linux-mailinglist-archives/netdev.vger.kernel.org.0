Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A3C5A2420
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245698AbiHZJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245171AbiHZJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA8397D6E;
        Fri, 26 Aug 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE31E61E10;
        Fri, 26 Aug 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EC60C433C1;
        Fri, 26 Aug 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661505616;
        bh=OHzYkl4gk18ulrMv6ViSukKSb4ow2EkIUFfEWE7QM1I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dzR0ws4ls7DIkUk+WL4F4hAMCcExe+7uBz2pf5i9yoCdJCcD1wTEWkP1KFIl/ECXz
         a5aI7X3wZsqEURv0j/5J6vbpB0S9pfMz5jan1ICLYD1HTaFbBXezMSWmXnwwodtM/K
         g56LIGkQ/bV+te0UhdylVNsILp5tjKoW6lv14plWhtbMdXMe3hoNkHFvESUaAh8ZWS
         Ra9ShYYZ04trRfoTWC8wKoJuEe34QqqRhpn2LQUqQJ9FtqRWxd0p3w37NLtvXjnUlk
         +vGDqtBJmJWGkVh7m4i4GWvGwhTf9FjMeoS/qEY593ZMjdTP1AFBFrJnz1RuUoyKJG
         PvAT30WNuxJ7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E74A3E2A041;
        Fri, 26 Aug 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: prestera: matchall features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166150561594.22218.246405629634101041.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 09:20:15 +0000
References: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tchornyi@marvell.com, serhiy.boiko@plvision.eu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Aug 2022 14:39:55 +0300 you wrote:
> This patch series extracts matchall rules management out of SPAN API
> implementation and adds 2 features on top of that:
>   - support for egress traffic (mirred egress action)
>   - proper rule priorities management between matchall and flower
> 
> Maksym Glubokiy (1):
>   net: prestera: manage matchall and flower priorities
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: prestera: acl: extract matchall logic into a separate file
    https://git.kernel.org/netdev/net-next/c/8afd552db463
  - [net-next,2/3] net: prestera: add support for egress traffic mirroring
    https://git.kernel.org/netdev/net-next/c/8c448c2b5fd2
  - [net-next,3/3] net: prestera: manage matchall and flower priorities
    https://git.kernel.org/netdev/net-next/c/44af95718fed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


