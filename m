Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A565ED2D9
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 04:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiI1CAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 22:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiI1CAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 22:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1135161CD7;
        Tue, 27 Sep 2022 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E7E61C4B;
        Wed, 28 Sep 2022 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9548CC4347C;
        Wed, 28 Sep 2022 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664330418;
        bh=C2/ags9atpaX4TGKxqEvxbE7WIB0bOC3jCQn+XcnZDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B29KIaB47VKv3cI9VFnGfu3KfhdUBCbOPnhZefoeslkrwx30ah5oSL6KKOejQYLwW
         v9ETdFjsd9XsHaQ5EHhLHEtMMkX9oEXuzFfuIx/RaHiqRdUoXrmCj9G0YEWCRgMMdL
         p+VXL1/nQo6C8ZdSv/3oRc2aMM9Aw8qlmQHIK9PsNweX8z9wT4DVssUvpb0B6tqSNc
         Cov9sykcgC6/j4U5UuYN6FxRsbL85SfYDjraMKy3FOEHsSCfGNs22DDiLPf222OxQC
         QJnas2eaf7OV6U5aGct/UFS+qKk1N0a2M9/OWnH8gP/QV4xERZDDdd1CktxvwzPiZA
         9vFQeevyXLmYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71DDDE21EC6;
        Wed, 28 Sep 2022 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mlxsw: core_acl_flex_actions: Split memcpy() of struct
 flow_action_cookie flexible array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166433041846.32421.13784055301688350147.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 02:00:18 +0000
References: <20220927004033.1942992-1-keescook@chromium.org>
In-Reply-To: <20220927004033.1942992-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 17:40:33 -0700 you wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org
> 
> [...]

Here is the summary with links:
  - mlxsw: core_acl_flex_actions: Split memcpy() of struct flow_action_cookie flexible array
    https://git.kernel.org/netdev/net-next/c/d89318bbdf2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


