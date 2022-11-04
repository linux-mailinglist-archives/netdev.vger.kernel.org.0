Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D215618FBE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiKDFAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiKDFAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829B220F50;
        Thu,  3 Nov 2022 22:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379B8B82BF9;
        Fri,  4 Nov 2022 05:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A842C43143;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=o0TS4iNSKwql1CsNnSuW4sitQYzuR5b7ICfwjT9hlj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMcPukrQaw8/EXTbPawdxSTuK/v8isU3ErmVfi70IQsJte9NSNyZpfLls3itdoTvt
         p2dIVE4hvndPQsYhHly8evELSWbS4LBc73aeeCxs/tcRZcggPfTLh2kFlVVQkmuTib
         mE/3MSUIqiJVONpLgz06Xk8pjPUaJlAG1DHXPV5Cr5JdR8HT5WXhbXWg1tKMqAqAPZ
         kspQ6zj62a+RI+uMTNrAxK+Ns+kyCG46WDiJMhkvvdCsW2KAtlewNp5059mmxkJfbU
         FGfC5yyzIU2DVYvLC4SNYa5NsOIe15wEd0eNrdryxpQaH5qmln7ACjkuyPOp8DKb3U
         IiHEtq4Ht7IYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E2DEE6BAC5;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802712.27738.5840275256929015736.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:27 +0000
References: <20221102160933.1601260-1-nathan@kernel.org>
In-Reply-To: <20221102160933.1601260-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, ndesaulniers@google.com,
        trix@redhat.com, keescook@chromium.org, samitolvanen@google.com,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Nov 2022 09:09:33 -0700 you wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
    https://git.kernel.org/netdev/net-next/c/63fe6ff674a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


