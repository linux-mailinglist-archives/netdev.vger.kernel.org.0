Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D651CE63
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388139AbiEFBx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388141AbiEFBxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9862A27
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D386203B
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5A21C385A4;
        Fri,  6 May 2022 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651801812;
        bh=xKcGO9ek3kjJXGyMDbFe5S1WD11OMl2J/HggiQeX0zQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vBlNl0TtJ0BQMleKNwIml5ATIEPH6ugdslrS3FZ32sIA8r7bEcsIkZ2zYXnwzCc/Y
         o4cLbaCPqrNJIROrMNn6yQmU1bqBNv+mI0WpDbHQbbd9MBeida4Mk1fqs0Hm+wa6Pa
         UWz/aqNKBOGw/lz27q47GHuKFGU+VealCISUpReld/7gHW1QpzWQhMK+6PoPBIdoav
         YPsb9rUE6H0DfsvsjOD5LIJ/+JoxHe9bR7tAeSF3oRvdoS0/Uz9mzSGAuLGRhP8XQt
         OSuZe7eyziVrrcAFgzK44kwAqDR0Kl2ltn641P6hwl8a0mej9wUDMysMOuZv4QhxP/
         K9IM7AUPPuv1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC156F03874;
        Fri,  6 May 2022 01:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] vrf: fix address binding with icmp socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180181270.30469.14724657054910081010.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:50:12 +0000
References: <20220504090739.21821-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220504090739.21821-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 11:07:37 +0200 you wrote:
> The first patch fixes the issue.
> The second patch adds related tests in selftests.
> 
> v2 -> v3:
>  update seltests
>  fix ipv6
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] ping: fix address binding wrt vrf
    https://git.kernel.org/netdev/net/c/e1a7ac6f3ba6
  - [net,v3,2/2] selftests: add ping test with ping_group_range tuned
    https://git.kernel.org/netdev/net/c/e71b7f1f44d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


