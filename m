Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B56595CD
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiL3Hlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiL3HkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A48364F5
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 23:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19C84B81B1B
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 07:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC4D8C433A0;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386018;
        bh=XajUQ2SdAcwFAiWk80H8EsnvmXtWzzMbSHracKraMok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tRLSoh28+wTfcYl9dw6MMyEpzXlEzFuD2Oi7qJxD3RIKQMO1cTEAuDdXYtc2gDUAi
         QGfupFtpWXaMcTt161OHA1mpB5QIeGCM6U2IdGeOrupRVFWnWrIRZnM+4YHwXAn1ik
         AXGf4iBxAhxYuC7DB6Qqhfsl4UtCQrbrtRWwCFY3nNaB5lv75cyXjpw4CncGwLmUS5
         ad02uMPcE7a94XRwXeZlabJwgk7Q1dMrIunCP6nUTLRSl/wTiWXyvztKvtloT4S8GV
         Mqe8lFnHf7GWisYq2afgzV+GOYIAE17o+n0/d8ovfsgr8grq5vX5Q+ZRqLWLxkC80G
         I16h4/moZln2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FA74F82DEF;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: hns3: refine the handling for VF heartbeat
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238601851.1408.14860488227965492757.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:40:18 +0000
References: <20221228062749.58809-1-lanhao@huawei.com>
In-Reply-To: <20221228062749.58809-1-lanhao@huawei.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, huangguangbin2@huawei.com,
        tanhuazhong@huawei.com, shenjian15@huawei.com,
        netdev@vger.kernel.org, lkp@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Dec 2022 14:27:49 +0800 you wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> Currently, the PF check the VF alive by the KEEP_ALVE
> mailbox from VF. VF keep sending the mailbox per 2
> seconds. Once PF lost the mailbox for more than 8
> seconds, it will regards the VF is abnormal, and stop
> notifying the state change to VF, include link state,
> vf mac, reset, even though it receives the KEEP_ALIVE
> mailbox again. It's inreasonable.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: hns3: refine the handling for VF heartbeat
    https://git.kernel.org/netdev/net/c/fec7352117fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


