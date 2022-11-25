Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40EE6386C9
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKYJwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiKYJw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:52:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D245C11C16;
        Fri, 25 Nov 2022 01:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D4662327;
        Fri, 25 Nov 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D78B3C433D7;
        Fri, 25 Nov 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669369815;
        bh=pZFOMOeXaqVMIJsCL2zHJgi5XCrvuVb8OE6x/N0CpcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lZsRWVPzDlSIktJ9646Vwmz6P5Ida4WD7NlEU3ZOSkjUrHa4jn7gf0t8bdTTa7E3/
         DHJtwZU+zkxsKI1B0sirPSsa1ReG8WOz4oglRmlQaXDsvEsh8Z+XJ9Nw/FrnQdtttu
         ms50L0m1WnA7k8Q85Rhq18E/npp3lbqm3oEVcZ75IVwU9kr9TWMpoQB6yzgDll//iX
         WuLp6uP71HxhSkFv7Mi7sA3gmLaAPki/iIsrjhlrOgr6y4/MIMFtR4vv7cbcOpwfDC
         39j9In7o/4hnsvmzOjTn4oz3rDO62bfH0jzcSG7JO/cwU7X5bp4eOG+MveKWn1kKFw
         wWvsHzZ7jffFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF8AAE29F3C;
        Fri, 25 Nov 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936981571.9141.17373646284844303302.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:50:15 +0000
References: <20221123141829.1825170-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221123141829.1825170-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 15:18:28 +0100 you wrote:
> When the name_assign_type attribute was introduced (commit
> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
> loopback device was explicitly mentioned as one which would make use
> of NET_NAME_PREDICTABLE:
> 
>     The name_assign_type attribute gives hints where the interface name of a
>     given net-device comes from. These values are currently defined:
> ...
>       NET_NAME_PREDICTABLE:
>         The ifname has been assigned by the kernel in a predictable way
>         that is guaranteed to avoid reuse and always be the same for a
>         given device. Examples include statically created devices like
>         the loopback device [...]
> 
> [...]

Here is the summary with links:
  - net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
    https://git.kernel.org/netdev/net/c/31d929de5a11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


