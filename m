Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9445C4E57D1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343786AbiCWRvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343777AbiCWRvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB805DA1E;
        Wed, 23 Mar 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EEA9B81FF9;
        Wed, 23 Mar 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C917C340F4;
        Wed, 23 Mar 2022 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057812;
        bh=sCbYYQaRkBRs0vqpjSJ6vXS4B1YRtkpy+wuheCEovxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z7Yq9JoUJe1WBFG9f0iB0jZVMQecTQrNHrTLoqjqxgx4LKpS3xs6OsE9faFr+hMeX
         GM9RGYvnEqasf4a75RkDrDTlHe5ANYhH6ACqFysyKGklMtOU6BH09okHbECUMHQjbE
         vLA3zg3rJwqROsf9x76HqrPQYlGGCEiyyamwy26OqYbfRcEPQTBMsYcwrhI1co51lC
         eH9wWVwpkJIbcHsKQ6Y/H49KSMbZEoj3Qmk9P7O0EXV8cTR4SBa+MXy11CtFUMmGsG
         TVtgze+E85zBX1Nm95ugOHlKP718ftsNSw0w7gdtQAm6veGPEQGCYf4E5rDpWf6C0D
         SXrOImbeP92Sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDF6FEAC081;
        Wed, 23 Mar 2022 17:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: marvell: prestera: add missing destroy_workqueue()
 in prestera_module_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805781197.23946.18251414527647703024.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 17:50:11 +0000
References: <20220322090236.1439649-1-yangyingliang@huawei.com>
In-Reply-To: <20220322090236.1439649-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yevhen.orlov@plvision.eu, tchornyi@marvell.com,
        oleksandr.mazur@plvision.eu, davem@davemloft.net
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 17:02:36 +0800 you wrote:
> Add the missing destroy_workqueue() before return from
> prestera_module_init() in the error handling case.
> 
> Fixes: 4394fbcb78cf ("net: marvell: prestera: handle fib notifications")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: marvell: prestera: add missing destroy_workqueue() in prestera_module_init()
    https://git.kernel.org/netdev/net-next/c/4a6806cfcbca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


