Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6360F630B97
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiKSDyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiKSDxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5BC287E;
        Fri, 18 Nov 2022 19:50:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E650B8270C;
        Sat, 19 Nov 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69673C4314A;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=6pHQSurXmK8PLRRQAIFF6F4L914A6yuhhJOoHhbwDRM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmnUTLXsKOaBsvgoDzoj8RrPXYZxch4OK3qT5M2jeKF1fMH21DrtUQRnnuy0JRO5d
         ttNpHEmhATdQF5qdX5u9fZAYfeT4KT5WH4lU9EuG0znkUw3kXFGYBDf/UcFhsKmNdn
         Rft+f0Cph/rkMcTIzoUEEb3gHacS6Zfy5zEltb1UbsN6fD44/33n63f0d6Zwj1qUz1
         XOMtYdok7fokWkm91kfh7wrwbK8T8omRq7IxsIccIjsKCnUK+yRpStJm6VlKa2qOxv
         1BU6qM0UzXjkVyV367KPPqmWDG6/TEHUMfstBGOL4q5/ZBmwBs0VkJKJHMZOma/CuR
         PBe650MPdqobQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EE35E524E7;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] macsec: Fix invalid error code set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981825.27279.863723544634896362.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221118011249.48112-1-yuehaibing@huawei.com>
In-Reply-To: <20221118011249.48112-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 09:12:49 +0800 you wrote:
> 'ret' is defined twice in macsec_changelink(), when it is set in macsec_is_offloaded
> case, it will be invalid before return.
> 
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/macsec.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - macsec: Fix invalid error code set
    https://git.kernel.org/netdev/net/c/7cef6b73fba9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


