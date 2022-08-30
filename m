Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19DB5A6467
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiH3NK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiH3NK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:10:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1547D4A13D
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 06:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52B686171A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 13:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6AD7C433D7;
        Tue, 30 Aug 2022 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661865016;
        bh=rtN027QrbkG2kxSwb4vkavDvxACRrGcz7MKkMsBebpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AgubAzPWo35WixClJj8FrMtF86HXMFE/KsDEOMDVicv1MnFcvGEYGBPGLHzbdMcGL
         2JRIKEs6icMPGQKe0qjNbylHL/uGTND4aMb7wZsZ5KzltLYoB+Og7OWjcFXKCEtInh
         HNle4+g51DAIgYd+0coIcFAHfpC8Ht3+TeDe+wW8wO6Vd+ppmlV6lOfN49+zxOVOkJ
         h2EozreAM5ZUNzT/nnLrRDY4z+I6peLohWZJ5uE7HZ8rwQKOOJM3FDEsq5nmrmucfr
         R+biR6ecBb4EzAfCSBzJ57NBWnaj7w6oqVpDq4AVeX5j90SBMUON+74qh6Okc9PHl7
         Ld+8xrJaLFw4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8744FC4166E;
        Tue, 30 Aug 2022 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2] net: devlink: stub port params cmds for they are
 unused internally
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166186501654.27518.3722697348390215936.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 13:10:16 +0000
References: <20220826082730.1399735-1-jiri@resnulli.us>
In-Reply-To: <20220826082730.1399735-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 Aug 2022 10:27:30 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Follow-up the removal of unused internal api of port params made by
> commit 42ded61aa75e ("devlink: Delete not used port parameters APIs")
> and stub the commands and add extack message to tell the user what is
> going on.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: devlink: stub port params cmds for they are unused internally
    https://git.kernel.org/netdev/net-next/c/146ecbac1d32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


