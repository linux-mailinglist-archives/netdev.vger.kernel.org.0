Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B74361A6F3
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKECkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKECkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879CF32B88;
        Fri,  4 Nov 2022 19:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B9DCB8306A;
        Sat,  5 Nov 2022 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4152C43144;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667616016;
        bh=LvVJwvczjJn+XP0eZyC5ywkLqnY9k7dQh7bidNRFIDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kdJVTst15IypdLHD05BX/IGowCb1ppXWfh1RC32sJbWJUuVMc47ErKhk8XIoi6AqK
         uPXPSTa/xGlMtycNK80ycQtWCMy+p62FYNAo9nCjCLLMDalYuAzN7npXAxf51drwYV
         Qb7MTTStcuwRlPmyU2xekf3KdfEuE9e69Ai+QnsKJkQYnAlYUNTawFHVI1jabn3Kb9
         laNnFljHJQXUBhaN/spCFkgpYTQjDZuKUtG9F06khuRfTF/gaEsou34zucEAQfKBWP
         REC7/XU0pwkVIbFN4VCWn1FuzfNPRHpIZmubYIyBfrBddhO2+SqN8K2YpxVeTidZk+
         mAKK/xay8MaNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB3C8E6BAC0;
        Sat,  5 Nov 2022 02:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: renesas: Fix return type of
 rswitch_start_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761601669.5821.12760894848990416491.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 02:40:16 +0000
References: <20221103220032.2142122-1-nathan@kernel.org>
In-Reply-To: <20221103220032.2142122-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, s.shtylyov@omp.ru,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, ndesaulniers@google.com,
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

On Thu,  3 Nov 2022 15:00:32 -0700 you wrote:
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
  - [net-next] net: ethernet: renesas: Fix return type of rswitch_start_xmit()
    https://git.kernel.org/netdev/net-next/c/8e0aa1ff44ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


