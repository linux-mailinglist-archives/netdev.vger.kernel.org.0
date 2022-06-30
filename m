Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4E8562254
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbiF3SuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiF3SuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:50:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED64F2AC7E
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41340CE301C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 250F9C341CE;
        Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656615014;
        bh=YcignpNyJI6CSOioj51Bh2U+tbipaUKSEEQMg6nQNy0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pRanSsqQ6yvxbIChDJ+Ouxrb4E7uwe7TQYcN4cVnv3HoPVbec7KHckYBqV18RGiVU
         LspIQ19KlARYVKFaSXQfQxSHReF5Oi7Vb59h7nia665R8B0UP8uC00EjLfcIjxjoC1
         yiIPWCREbbnr6XuL2ULg34NjB0TMEIlplLR6uu2I7N/fx+U0Pv9/+jYG4zEATbpvl5
         t1OLMWIy1/M3XOTo6pNT641uUHk3ohNiOFiQxrqhJyqguh2JVWildCMQOsexCGlsMN
         RhVEgg74VKILHnQs0qOqUmq/FLxUqOhB9G2WmpXaEPUeiZwNcGlY+4ubzZki56RJ48
         jxpnBpDdvPrXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AB22E49FA1;
        Thu, 30 Jun 2022 18:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] net: tun: avoid disabling NAPI twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165661501404.16120.7210700918246805550.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 18:50:14 +0000
References: <20220629181911.372047-1-kuba@kernel.org>
In-Reply-To: <20220629181911.372047-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, syzkaller@googlegroups.com, ppenkov@aviatrix.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 11:19:10 -0700 you wrote:
> Eric reports that syzbot made short work out of my speculative
> fix. Indeed when queue gets detached its tfile->tun remains,
> so we would try to stop NAPI twice with a detach(), close()
> sequence.
> 
> Alternative fix would be to move tun_napi_disable() to
> tun_detach_all() and let the NAPI run after the queue
> has been detached.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: tun: avoid disabling NAPI twice
    https://git.kernel.org/netdev/net/c/ff1fa2081d17
  - [net,2/2] selftest: tun: add test for NAPI dismantle
    https://git.kernel.org/netdev/net/c/839b92fede7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


