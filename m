Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1F8624202
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKJMKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiKJMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:10:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC601CFC7
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF05E61638
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F7CFC433D7;
        Thu, 10 Nov 2022 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668082214;
        bh=uq4QUfaSO73fvFqj9U7YfWsvKd+Ni07BtKAfA7oqXec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4VTjLdxMLc5n6Yn6p2w0eMsfbjv5rAbIQ9cG5wNPOXRngiAQ5bhprF88UKS2Thkv
         EfUOwOCpOwVZoW5RB3RL52iod0kvEC24L1o32uTwvTBbzyG8DAnnoV9NCD14tQWxsd
         9BoDmc/Z4Hgf+ASQPLIXOXlun6ejuZejjtW2SpmLkAwOXpaAnDjulHc/0F7WqU+zug
         9G00wgYmFH+uNOu9sbERw6PdtSi1mZnTNCfbeoK4GptnSlN8v49w6gpc5Upw1FebWy
         su+/YVsnyGbeDIJGyNc2Yi/I9foD5SXvIcg0urShiQLexMbSUnnm40xEr3GRD4pPz4
         fGAfTpJQPsS1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECD16E270C5;
        Thu, 10 Nov 2022 12:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ethernet: s2io: disable napi when start nic failed in
 s2io_card_up()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166808221396.28858.10382540524958246976.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 12:10:13 +0000
References: <20221109023741.131552-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109023741.131552-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jeffrey.t.kirsher@intel.com, weiyongjun1@huawei.com,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 9 Nov 2022 10:37:41 +0800 you wrote:
> When failed to start nic or add interrupt service routine in
> s2io_card_up() for opening device, napi isn't disabled. When open
> s2io device next time, it will trigger a BUG_ON()in napi_enable().
> Compile tested only.
> 
> Fixes: 5f490c968056 ("S2io: Fixed synchronization between scheduling of napi with card reset and close")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] ethernet: s2io: disable napi when start nic failed in s2io_card_up()
    https://git.kernel.org/netdev/net/c/0348c1ab980c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


