Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E545E84E9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiIWVbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiIWVaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2897F122A5B;
        Fri, 23 Sep 2022 14:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986D261D2B;
        Fri, 23 Sep 2022 21:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8461C433D6;
        Fri, 23 Sep 2022 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663968615;
        bh=O9XEUaCyxF3JjaIUUJdoZWaH92MUOaVYW0w5+QeOhes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=joHNQlTEJYoicUei15DkvpT2aLjJYPV8WRPEgvqXuqk3k5tjt7HD7tgtZ3miq/RoY
         M6cLshj2PLfs8ga6gvJrPSQgKuiCoD52wC0sIVO08HQDPGtbOynp+FqWI+8dYljdZ5
         iQPKcsK2Tsa/+VkQ+PEBMbeEELjNsbAZ2oMtffHmE3oIXQLG1BmkafJwYjifIIq8Mg
         618Wy0vP3nGgOD3ocNbNLY4HlRxQHYbaK3hE6HgNhfV8sqxpUenKd5rxHGAuRSiSYG
         90oZt0/LzOdFYz1EPlRbQ4whmjTX/4cqd/cWphDRZ+AACln/8ejsLZ59t/kvYmWh5I
         VeDyp5xi4UtRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3B1AC73FEC;
        Fri, 23 Sep 2022 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next v4] libbpf: Add pathname_concat() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166396861479.13278.10304313759608194185.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 21:30:14 +0000
References: <1663828124-10437-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663828124-10437-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 22 Sep 2022 14:28:44 +0800 you wrote:
> Move snprintf and len check to common helper pathname_concat() to make the
> code simpler.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 47 deletions(-)

Here is the summary with links:
  - [bpf-next,v4] libbpf: Add pathname_concat() helper
    https://git.kernel.org/bpf/bpf-next/c/e588c116df6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


