Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF505BD91F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiITBK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiITBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8E04A81F;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8263C61FF8;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A38DC4314F;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=06dXw4ss1codrpHa3yFzX/NFgKEx6NLKYn+RdXtbP/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UDtlq6LOv+sBFnCsKB6hWBWbhfYT9FOa0CZ2CRnjH825iNDsyEAwex+o0DeCTnwqg
         /nUkjRaK1vajbyUUpyROeSpdGwdshWYRIvoAXEa7dCUCh+Q1B+9/KihCXKF3Xl24b7
         XRO8Nnt06ul7eHr3miNN7Mz12zo7gTUVHyfPGmFUqGw3dOFAZwaY457ZRkYF9tlqh7
         3CqH9ZfpsEjeriSdHkHdLolEkEWfkhG+EvZ1EKqkW555/bO9MwENTr/xhdsenG6NxL
         sZVgCOBXxLlEhbUuy4H+QtmuJ7NbZQ5mUwHcY02aRR55TTP3i0XqdIEKj64IrPu4Eb
         yYEcYhmelu4Vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A03CE5253A;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rxrpc: remove rxrpc_max_call_lifetime declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622110.23429.600288615352415757.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:21 +0000
References: <20220909064042.1149404-1-cuigaosheng1@huawei.com>
In-Reply-To: <20220909064042.1149404-1-cuigaosheng1@huawei.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 9 Sep 2022 14:40:42 +0800 you wrote:
> rxrpc_max_call_lifetime has been removed since
> commit a158bdd3247b ("rxrpc: Fix call timeouts"),
> so remove it.
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  net/rxrpc/ar-internal.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - rxrpc: remove rxrpc_max_call_lifetime declaration
    https://git.kernel.org/netdev/net-next/c/9621e74f39f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


