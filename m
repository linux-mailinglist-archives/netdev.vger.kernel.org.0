Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2953917A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344573AbiEaNKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiEaNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61084880C1;
        Tue, 31 May 2022 06:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE08B611E8;
        Tue, 31 May 2022 13:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BEECC3411D;
        Tue, 31 May 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654002613;
        bh=LaTXhCuMwgI4WA45VBnWzAMyaiH/DYYEL0PrWaBNUW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K1Tm64+RqHAbNl8i7qETqWYBbV8Ox/aZ3zddS2YiAdsffS425PSi8XFVJt5Cuy42F
         pwoOq7HZLY4R85tXusK2ITuquZqnEWx+nX1GCv0bmWrnXHE9bQU6oWUaMGOkBO6rRo
         /N0BJ/hf3FkYWxFzK5Siibnzxwc+LT0XMsgcrMM0AxINZw9XNjGEj42LLq3sto+MWd
         iHMieWSWHgHM/IAeTw8FBQn1bQNcYI+8rTJZp4D0ZokzVmPaKki3Prmi4Pr4tqGH32
         BfwmRlaDq8bv8Wc7N9ySlEwBBesltaYdIg0s0QNHH/g6fJW6cHfV2jdHOurhvZwPHQ
         xe8pPC23zUlxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B888F03944;
        Tue, 31 May 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xen/netback: fix incorrect usage of
 RING_HAS_UNCONSUMED_REQUESTS()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165400261317.8298.1056578023912493620.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 13:10:13 +0000
References: <20220530113459.20124-1-jgross@suse.com>
In-Reply-To: <20220530113459.20124-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jbeulich@suse.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 May 2022 13:34:59 +0200 you wrote:
> Commit 6fac592cca60 ("xen: update ring.h") missed to fix one use case
> of RING_HAS_UNCONSUMED_REQUESTS().
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Fixes: 6fac592cca60 ("xen: update ring.h")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> [...]

Here is the summary with links:
  - xen/netback: fix incorrect usage of RING_HAS_UNCONSUMED_REQUESTS()
    https://git.kernel.org/netdev/net/c/09e545f73814

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


