Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A95ABD0C
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 06:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiICEag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 00:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiICEaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 00:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5B04360F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 21:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DACA5B82E55
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FB69C43147;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662179421;
        bh=tbyY+iLcw7TBt061NwT8wEPNz32elVMvtqPBH4A38cU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bNJ4ob8CCxhV6DN1yvaHI493gvIMrZd8JIQk8lNpGWT2C9dIYfTLI6AK95UmunTpI
         SQu6AMTnq2WikuIDKBubfNkkcd9nSvj+KQYCsY8oEyBtA27LgsiqhqKZ6yBLwq2Iu0
         +n3FcoF/fg6CX+y3qCQHSYGazsQDWdI551B6TlkgBBiWqUqcjpKUp64f4OTV7BR5YR
         UuRD3TO4yIChRTCHBT9kozOx9wpQyxmvuYMMj6zlTIpjmtaN93AvaWVa5LwiThzN32
         LxeXIh32jOeRtcbswwpaQHnUGArTP6VrDLi31ud6LHmKHCtk6MQhqeVGM7mg4hPsQb
         QeRS2PUbeMaww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B1CBC73FE1;
        Sat,  3 Sep 2022 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] net: broadcom: Fix return type for implementation of
 ndo_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217942123.8630.17317478630830737915.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 04:30:21 +0000
References: <20220902081454.59598-1-guozihua@huawei.com>
In-Reply-To: <20220902081454.59598-1-guozihua@huawei.com>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     netdev@vger.kernel.org, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 2 Sep 2022 16:14:54 +0800 you wrote:
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this might get
> cought out by CFI and cause a panic.
> 
> bcm4908_enet_start_xmit() would return either NETDEV_TX_BUSY or
> NETDEV_TX_OK, so change the return type to netdev_tx_t directly.
> 
> [...]

Here is the summary with links:
  - [RESEND] net: broadcom: Fix return type for implementation of ndo_start_xmit
    https://git.kernel.org/netdev/net-next/c/12f7bd252221

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


