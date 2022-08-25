Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25A5A1AA8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiHYVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiHYVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EDA2C124
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48B746156B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 21:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E08BC433C1;
        Thu, 25 Aug 2022 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661461217;
        bh=2L7BzmDo/iK4V8OP8K9mihY71eVHpyIUEypkqhIack8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HL/YMHVzfdFV7v+8pkCT+tKS2MKmfkU/6zDfRZnQzgkE7/4CtjKi5COnCzHdqENRl
         TWq/Yeo2W8OfL9txKbGGi8/2W34mU7DJmYKppQH53u6K0jHaMPsC0IGlwCih9Ch7qv
         O+Yxl7nOVtwKGU9zFJBIYmXbe5YtmQ/xlcepqegLg3TPhicE9qVzU6HDBXddH9EjYN
         YV1QyUmtBRMvwQTLVi1yO0V66kYu509pNU6zLatq7inidqyACEOORXeEtlMnaSOIaJ
         nvUGoueHZ3RYCj/vjLQ6ZGiJWhY0LBBvTtozQx45IWGVeKhtUfkdfSsfHv/8glugVi
         l/XLp8P05mKCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81863E2A03D;
        Thu, 25 Aug 2022 21:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mlxsw: Remove some unused code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166146121752.1643.15178200963530509593.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 21:00:17 +0000
References: <cover.1661350629.git.petrm@nvidia.com>
In-Reply-To: <cover.1661350629.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 17:18:48 +0200 you wrote:
> This patchset removes code that is not used anymore after the following two
> commits removed all users:
> 
> - commit b0d80c013b04 ("mlxsw: Remove Mellanox SwitchX-2 ASIC support")
> - commit 9b43fbb8ce24 ("mlxsw: Remove Mellanox SwitchIB ASIC support")
> 
> Jiri Pirko (3):
>   mlxsw: Remove unused IB stuff
>   mlxsw: Remove unused port_type_set devlink op
>   mlxsw: Remove unused mlxsw_core_port_type_get()
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mlxsw: Remove unused IB stuff
    https://git.kernel.org/netdev/net-next/c/3471ac9b22c1
  - [net-next,2/3] mlxsw: Remove unused port_type_set devlink op
    https://git.kernel.org/netdev/net-next/c/04a1b674d655
  - [net-next,3/3] mlxsw: Remove unused mlxsw_core_port_type_get()
    https://git.kernel.org/netdev/net-next/c/12be3edfa827

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


