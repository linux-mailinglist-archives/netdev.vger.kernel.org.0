Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4BD671F16
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjAROKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjAROJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:09:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C231B65F0A;
        Wed, 18 Jan 2023 05:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963466181D;
        Wed, 18 Jan 2023 13:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 028D5C433D2;
        Wed, 18 Jan 2023 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674049818;
        bh=6jpMkKav0Mj1r8lN5adcTzY130KzSUqNv+IUkbhnCFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JaiIcpC7KqpISp/Ubq8Rz2bGaIPVBsCDcBvQp/TB3VtHigURhGmNGAR9J0aYfjb5A
         DjNgAeb4pLCtrLHriNvXJn7GXZ6Y7g6OOhTPxU36sXNPicELedbT1558ZQwCt26KI1
         AlGzHXxNLBlhlfj9RP8fg07toUSJjDAsYYSwboRH19gKFNkYb4c71WkV3dxQ33hPzh
         iAZfYXjNBb0dPkGeJCfWrk57Z++X9CBmj13ehIMHhEzpj/YJgzLH43xIfBDjLBwlqS
         tmzrELMop8HQaw1Wc9WcceWUrvmzTleRHxGhwXITzmJuM1rIt6VsM2A1XcZVBbtJk0
         QGylT+aIaPLkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E175BC3959E;
        Wed, 18 Jan 2023 13:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: conntrack: handle tcp challenge acks
 during connection reuse
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404981791.26997.17286007950287915154.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:50:17 +0000
References: <20230118095424.885014-2-pablo@netfilter.org>
In-Reply-To: <20230118095424.885014-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 18 Jan 2023 10:54:24 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> When a connection is re-used, following can happen:
> [ connection starts to close, fin sent in either direction ]
>  > syn   # initator quickly reuses connection
>  < ack   # peer sends a challenge ack
>  > rst   # rst, sequence number == ack_seq of previous challenge ack
>  > syn   # this syn is expected to pass
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: conntrack: handle tcp challenge acks during connection reuse
    https://git.kernel.org/netdev/net/c/c410cb974f2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


