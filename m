Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DEC516518
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348892AbiEAQNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 12:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbiEAQNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 12:13:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8F81002
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 09:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE126B80E61
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3890C385B5;
        Sun,  1 May 2022 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651421410;
        bh=tIWc6xp9Cd8lYOMTVtOoVFVIGGLOZyLTFbptQ6UUTL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bm2IOzIPjJ7Xawlkz1SmUq85Uianct3ZtMrd97Gi7uRAH0htuK7qR1g6PehKfw4Jq
         vmy5PWoopM9qkVhcjqT2kk/aCJF0EXbla39Vsv3bq5jQNhnWrz+ZK5GkjNpH5kx+Ne
         NzIUQ08iP0aj9E7riMRDO+hKT1w5frAdhBOhhDYACUUnM6RXB0+coUTHw56/AhLsDa
         MGVXbCivNwLFHIk8uXB0O9Aexgqy3j2Uh3A2+ZNwASCmW4iutOdkig32f5822qTTjh
         56FNLpKxHu6AYwYWZKgL/QHzDMDM1jiMG/EArkv409bAMtPz8lydQU0yxlX96JvoVE
         WrMij8DgCdiHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E6EDE85D90;
        Sun,  1 May 2022 16:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Cosmetic change spaces to tabs
 in dsa_switch_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165142141064.5854.18237777174235896399.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 16:10:10 +0000
References: <20220429143214.24031-1-kabel@kernel.org>
In-Reply-To: <20220429143214.24031-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, andrew@lunn.ch
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 16:32:14 +0200 you wrote:
> All but 5 methods in dsa_swith_ops use tabs for indentation.
> 
> Change the 5 methods that break this rule.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: Cosmetic change spaces to tabs in dsa_switch_ops
    https://git.kernel.org/netdev/net-next/c/411a1476ea41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


