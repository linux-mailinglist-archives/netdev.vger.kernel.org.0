Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EC0644190
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiLFKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiLFKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B78221256
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5075B818EE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8012AC433C1;
        Tue,  6 Dec 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670323815;
        bh=hAOeU6UCepfoPmneGWigTze6I4sBJkVI9K+ZIGNHI4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3c2p3JIWIp2GmlZAmqdr7upiCO3W1Uu0BVb8bZbpQx6PR65nUROnouUowBG47+op
         ua16/T6mQ74IZfXILgWDoeAIByGTT8rQy1eUFuexv9pTb07zpZ0JtGV+jNxmRcQYFr
         JlwILw6zO8df0xeBi8uo10rn5KoF0IoJOm2H1jWbbs2FRhKd3EtCKS4Q7VtpWrG/6Z
         DRwG4LjZof+i630EVjaz8JiKfaDG8lwzwE4ffa1lJsqEd+gk9uJWZ3RmiQyYg+ERO8
         6GZH85XWpuKZJxDHzCYIgLMe8qLbGOzCqJRUUunbrHq56vEjo7lgsV6nimvl54aCQm
         bEmrClPP4ebkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66433C395E5;
        Tue,  6 Dec 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: fix memory leak in ipc_mux_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032381541.8282.6618784314163924438.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 10:50:15 +0000
References: <20221203020903.383235-1-shaozhengchao@huawei.com>
In-Reply-To: <20221203020903.383235-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes@sipsolutions.net,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 10:09:03 +0800 you wrote:
> When failed to alloc ipc_mux->ul_adb.pp_qlt in ipc_mux_init(), ipc_mux
> is not released.
> 
> Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_mux.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: wwan: iosm: fix memory leak in ipc_mux_init()
    https://git.kernel.org/netdev/net/c/23353efc26e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


