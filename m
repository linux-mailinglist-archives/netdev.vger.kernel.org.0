Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528FA647CB7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLIDu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLIDuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:50:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261EB37D3;
        Thu,  8 Dec 2022 19:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C28CB82794;
        Fri,  9 Dec 2022 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEC42C433F1;
        Fri,  9 Dec 2022 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670557816;
        bh=0A/Gl9C3rbZRC+YbYXiHJ+7dsYzbx36XjEZs5M1NVgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VfRqm/+N/28eLKbI3yOBTZGD74fyIfRBSe0AtkTMKpqC7abOyGNqSwuRBbNUayeAu
         igY3k6UEy9MDtm3NDlW/hCEv0Y/GqRgaHwZp6QeWGVAG0CshiMX6u1lZloSyCbSu42
         humJyv+j23H+RWsxj9aufMY4gehp5bxsqYYTKPeJwfSJUwRdvOw3/bPtQxvu0u2DK7
         E4MVHTr7OxXH3XObY8Bwmzl+YzhL6tTEjQvWfvKUoF4Q3G5XdtKCSU08seMYQCmGSs
         J6+pgRle5gTjkqUUGWk/+psx2p5osJMjZkrPJ7B6YgqjGCbdJtHtKjB8HWE7un0wHO
         OWRsuRakqdJhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF93FC00442;
        Fri,  9 Dec 2022 03:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] nfp: Fix spelling mistake "tha" -> "the"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167055781671.4041.11921310235790161808.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 03:50:16 +0000
References: <20221207094312.2281493-1-colin.i.king@gmail.com>
In-Reply-To: <20221207094312.2281493-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, oss-drivers@corigine.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
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

On Wed,  7 Dec 2022 09:43:12 +0000 you wrote:
> There is a spelling mistake in a nn_dp_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] nfp: Fix spelling mistake "tha" -> "the"
    https://git.kernel.org/netdev/net-next/c/3df96774a422

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


