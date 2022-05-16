Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C7A52829F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbiEPKu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242347AbiEPKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98218275D3;
        Mon, 16 May 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE7BB81056;
        Mon, 16 May 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDA67C3411C;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652698212;
        bh=GmnZSzClyr9TWR4VzkC2aSeu6x1a6npWkK+f0m1rsUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJrDcwPmRqhefkLm5zGhAKF8dW304IeaT2BFPuoS/68axnad9oKhgDt48cdjzqlAJ
         LqLHvQ/jNIYc4QXG4MQ1BSLBbgqBTjdyS8G6nVSGQUUI6c0WW+2/kA4Rq2JdXBQo0Y
         mJKcG2PA/HK2zfXmhH0YvadYO9fTdbtHu2q/m1zUtT5kQDuVTmLHW7vtWLikJSTZpu
         htTfIfxMXF5qUOlYV/TDHv8ypXGJ9UBncyGeSdvwUbjsvkl51NRcPFv4qavo2vdOey
         CxXxxbmaQjSK5WX4bMkgvTWrxG9644bXggwZY7mHw+auYZa97g7wn2vEd4KlQYbwTx
         0RFz2Yo7fq4Bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD220F0393B;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: wwan: t7xx: Fix return type of
 t7xx_dl_add_timedout()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269821270.15644.10547033316337959014.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:50:12 +0000
References: <20220513075611.1972-1-yuehaibing@huawei.com>
In-Reply-To: <20220513075611.1972-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 15:56:11 +0800 you wrote:
> t7xx_dl_add_timedout() now return int 'ret', but the return type
> is bool. Change the return type to int for furthor errcode upstream.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: Remove unneeded ret variable
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: wwan: t7xx: Fix return type of t7xx_dl_add_timedout()
    https://git.kernel.org/netdev/net-next/c/b321dfafb0b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


