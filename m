Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1705A993E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiIANmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 09:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiIANld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 09:41:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5C141D1B;
        Thu,  1 Sep 2022 06:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2722261463;
        Thu,  1 Sep 2022 13:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A9F1C433D7;
        Thu,  1 Sep 2022 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662039615;
        bh=vQY8xLuB9tLFMoqWbNAKi6pxyVgGbruL50N6VD2Mbmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XlOxy2GpcrndFMLwBzGCGCuE0Qy9VbPWeuMgb/nspGfZoUbBfhzl1bfgi8v2Zvm5K
         1q4ApC1dfZ/2m6j4+/rCXj8rMrFnTa5I6+G1DqgIkRbOFY71rcL5DsMI/81WGCMAXP
         4Shxjoi44z1EzMa8LBvTVofcSZKZ8lxN8crKs+YL41GANviPSPYX/ua2guPxQR/qj0
         CjryqgXh42ar/WaT2bx27zkwu7PXkjyJ/QcKxddq2aZvRJ2hawK6x6ftv9QkN5E1Ic
         wUWBW+hVKLhgX8jxF53cEsk6zuK0o3l+KpidfNNxs/D3JNL+SLT07Pe5NW+HhVfzNb
         VBHsNfg4rT2pQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DAF6C4166E;
        Thu,  1 Sep 2022 13:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: gred: remove NULL check before free
 table->tab in gred_destroy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166203961537.25428.11005972052008623368.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 13:40:15 +0000
References: <20220831041452.33026-1-shaozhengchao@huawei.com>
In-Reply-To: <20220831041452.33026-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 31 Aug 2022 12:14:52 +0800 you wrote:
> The kfree invoked by gred_destroy_vq checks whether the input parameter
> is empty. Therefore, gred_destroy() doesn't need to check table->tab.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_gred.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: gred: remove NULL check before free table->tab in gred_destroy()
    https://git.kernel.org/netdev/net-next/c/4bf8594a8036

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


