Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032726CD26F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjC2HAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjC2HAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:00:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F6B2D48;
        Wed, 29 Mar 2023 00:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64F81CE205B;
        Wed, 29 Mar 2023 07:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A103FC433AC;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073226;
        bh=o3XMwkKFc/9gw3C2hK2L/IcL6DgEwgMxWrL7BZDVfmk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZBQtbh8b29TURLpAsY7EgF3z6dQRIIRgy6J7j6DYhzRjp1o8dWPs387fc8tYWOvbJ
         qoUQw0iXgpyyfZYzS7tBEPJS5mADsMCMM6JBPXj0CiHK8YzyMaJazYyqec3q1m3PQn
         uWXAkUA4rb2dtC5q+14eSYWciNnigB7Jxa9EPmxrsOky7RCpsOIJsRA727yYw/qM+d
         UaPbaR9w+zUvdA37JUBWY9y52p/otcNGqKdlAT57taWMRHCL7Ni1tWWPYYHEblFbU4
         wu1kSX/SGATcoyirKd4umc2dz9wvbc+/q9nqR0iHXyMKI3MimxM88ndo4XjOjizIIb
         8S/h0nGzLkIgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A3ECE55B23;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: 8390: axnet_cs: remove unused xfer_count
 variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007322649.11543.775880323471781097.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 07:00:26 +0000
References: <20230327235423.1777590-1-trix@redhat.com>
In-Reply-To: <20230327235423.1777590-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Mar 2023 19:54:23 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/8390/axnet_cs.c:653:9: error: variable
>   'xfer_count' set but not used [-Werror,-Wunused-but-set-variable]
>     int xfer_count = count;
>         ^
> This variable is not used so remove it.
> 
> [...]

Here is the summary with links:
  - net: ethernet: 8390: axnet_cs: remove unused xfer_count variable
    https://git.kernel.org/netdev/net-next/c/e48cefb9c8d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


