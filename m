Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7BF622182
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKICAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719AB24F19
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD2F61879
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DA8AC433D7;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959215;
        bh=vtGtyGLQWf39uLiwii0sBePsjQdVoJapvXLJVKClSVU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktVEXOtQahhFtFE1wvcVHPRyPYMsizBO2esEjoABRKhaUzbekw+qA+o8RjFZt6Rlx
         Vt9YcWbG3fREAR4akTJBU1wgHdjQxl03PfrJNBZEXfbRR+YNuddIJq3tma82RTu3E5
         EsDWkfylM1wMU9D/NejLc7RXRddJ7Y8z9sJPi752/r8kAjsn5DUH7tiTA2jbL4f74r
         oQyFyLhT+6aNSWXNbHxeWbFBeAKUEgiFMgUEcc+cwDg1C0tBtDyteHNB/3wwxryroX
         8AGVD5aJPs2z9P5wtOTSeCHY0k8kQlyXjVFrX28j2m1UoX/UZ7XVqm8BPXcQlMXnVF
         jAEVpE2mm7cqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E7F2C4166D;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix memory leak in
 prestera_rxtx_switch_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795921518.12027.10529628612022206281.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 02:00:15 +0000
References: <20221108025607.338450-1-shaozhengchao@huawei.com>
In-Reply-To: <20221108025607.338450-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, tchornyi@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vadym.kochan@plvision.eu, andrii.savka@plvision.eu,
        oleksandr.mazur@plvision.eu, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

On Tue, 8 Nov 2022 10:56:07 +0800 you wrote:
> When prestera_sdma_switch_init() failed, the memory pointed to by
> sw->rxtx isn't released. Fix it. Only be compiled, not be tested.
> 
> Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
    https://git.kernel.org/netdev/net/c/519b58bbfa82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


