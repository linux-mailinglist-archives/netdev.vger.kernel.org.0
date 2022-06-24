Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61C555A138
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiFXSaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiFXSaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75C7C517;
        Fri, 24 Jun 2022 11:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E0F6202F;
        Fri, 24 Jun 2022 18:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7D3AC3411C;
        Fri, 24 Jun 2022 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656095413;
        bh=AgvFa2EcPdbzbQDUYdnd6rO70nf6ANtc/1Cr11BDFFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y7VHTDthbCphPPc6+xD4Y4M7UyzKGthTZwgbYyLWh0MRZQg18LT2rbpeSeSVcNjft
         3vmSedTxl6B/XfwFsjQ+Vnfx6/79uRLacc2FcivcbAzjJz1Ez/nykeFzdaogSkkZJV
         p8wEPhXF1wjlat9wKvloXpqgwQsPonukwiV8ZSP8CXnjDqEgTDGDG2pZf0it1Oi5Zb
         rOyGrVcURrnQ1xEmCDcihBVaYjNxutVDeXDUVJETbCO7umSEW3EqwPcs7FiMuPUaO1
         PtkcuciwU3R5nFc621+W/69b5bDYL3UydwDLt8/sM11ZI8n71elTULWePFFsCnWFrK
         i78CwgqoNg9fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D94EE85C6D;
        Fri, 24 Jun 2022 18:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] selftests/bpf: Test sockmap update when socket has ULP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165609541357.17645.8517214600623044678.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 18:30:13 +0000
References: <20220623091231.417138-1-jakub@cloudflare.com>
In-Reply-To: <20220623091231.417138-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        borisp@nvidia.com, cong.wang@bytedance.com, bpf@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 11:12:31 +0200 you wrote:
> Cover the scenario when we cannot insert a socket into the sockmap, because
> it has it is using ULP. Failed insert should not have any effect on the ULP
> state. This is a regression test.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> v2:
> - Don't leak open socket if family is not supported (John)
> 
> [...]

Here is the summary with links:
  - [net,v2] selftests/bpf: Test sockmap update when socket has ULP
    https://git.kernel.org/netdev/net/c/935336c19104

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


