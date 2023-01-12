Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4938A666A53
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbjALEbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbjALEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85C165AA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A952B81DC4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A497C433F0;
        Thu, 12 Jan 2023 04:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673497817;
        bh=iUfFu6Fa8xk9Zls0KSqmAP2mer/cLW1wO5iYHDYBaFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FTmbgi638n2sBrJRbY6wkMjnKFq/ah/W1qj3jGUAV5e1MZq/lcgyP0NYFvgkXu7uQ
         xyQbVMQr4LRHgOTCejYZV3pN3T1UT28R8lGDktvIoW9AIW+/bDJkwkx49dzvok70lZ
         wbOJ+Cmjcuww97qrGR5rvLsibuXmgBFoL4VV9hGIbu2Z3gFW9dP94CV7CMunE7IUd9
         FqmuFY47euV4TaZHDY/U/auuCIdYO6HSgxUHJttDW06sVa46qg6zKUwx6wV4frTF9p
         uQGCEhyX6pv51rb1imWfbwpWO7GCcdk41d0stMk79dtwolxKtpo8hGmw6RUM+6iYuG
         Jikuai+NW6p0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 156CAC395D8;
        Thu, 12 Jan 2023 04:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: fix wrong use of rss size during VF rss config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349781708.342.12778377713010527066.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 04:30:17 +0000
References: <20230110115359.10163-1-lanhao@huawei.com>
In-Reply-To: <20230110115359.10163-1-lanhao@huawei.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        wangjie125@huawei.com, netdev@vger.kernel.org
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

On Tue, 10 Jan 2023 19:53:59 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently, it used old rss size to get current tc mode. As a result, the
> rss size is updated, but the tc mode is still configured based on the old
> rss size.
> 
> So this patch fixes it by using the new rss size in both process.
> 
> [...]

Here is the summary with links:
  - [net] net: hns3: fix wrong use of rss size during VF rss config
    https://git.kernel.org/netdev/net/c/ae9f29fdfd82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


