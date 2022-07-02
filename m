Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EEF563DF2
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiGBDUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiGBDUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB10D33360;
        Fri,  1 Jul 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DC5B832BC;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A34BC341CA;
        Sat,  2 Jul 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732014;
        bh=68rh7ufA452Dl9v8RHxzSzIT5CpzEUwnlnm8j9L2xxc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=akJY5CGQZhV7FVcWbHN0/wJmxfuLBWRNs49DbU7CjE5GLGEXq/9fa9rFNXwhv2RSV
         vk+fcds/ZXS5Q6qBgeH5cWNY/ByqNZAh3o04YMVyZZ2pDXH7LL7tzWPPEWnWs8UJ5D
         T01j+0kYzwtFIH58FT+VV03Bg4vMYpiu2PmiDwvvBfyEhTkAHAyBxdGVte/CBZLkjk
         kNTH4Kl3+x3m7beard0l8/PspYA3YIJKwfEDNdv+eH7JdsH28K4h764mca9+dP2tqJ
         gesMvy/ZGwX4rqEhEqHxAY7dFIDljMW3PuC84QUCQ5Y63HByZyCKVHzXJjRboIbACL
         RcM5RZIkFxwNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EB38E49FA0;
        Sat,  2 Jul 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-07-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201412.6297.7979220898548456738.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:14 +0000
References: <20220701230121.10354-1-daniel@iogearbox.net>
In-Reply-To: <20220701230121.10354-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  2 Jul 2022 01:01:21 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 14 day(s) which contain
> a total of 6 files changed, 193 insertions(+), 86 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-07-02
    https://git.kernel.org/netdev/net/c/bc38fae3a68b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


