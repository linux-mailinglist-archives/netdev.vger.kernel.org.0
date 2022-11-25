Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8376384FD
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKYIKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKYIKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAF01CFC6;
        Fri, 25 Nov 2022 00:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B7D622B4;
        Fri, 25 Nov 2022 08:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 412A5C433C1;
        Fri, 25 Nov 2022 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669363816;
        bh=Xr/V0T+sz+5XuLdVL7uNnDXJytegZnrsBP4V8QXFwPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rd+1lWPKagjfs7yf6k38VNKiTFZQGaADKVHJu3zuJVX0Keh1aTXFTykSiLL6PZRcw
         vVmvZLRUUjSxSKZL5tfZvfsXGige4a3Lv0Wdz843/sM9LKPNSWD7J4MxMS/hOmYUuo
         sTog49g4fmXpIpFyc/E4Am56Wdv9y8D3SoVSds2KrVCxDdton19l7CVRApbTe11dnG
         vrq1YJTS1HhNWValt895kehe8pHE10kBqusR//K8j6bOczr0ySiDh6GtjL/2MUnink
         qQFT77ZtWHM8MjFNAvJlzX9fYQ1SuXC9eGfGKlbciVQQEiXJTf4WgexHBCTmE6544X
         aG/ms5vl2sJRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BAFEE270C7;
        Fri, 25 Nov 2022 08:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_linux-next=5D_net=3A_stmmac=3A_use_sysfs=5Fstreq?=
        =?utf-8?q?=28=29_instead_of_strncmp=28=29?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936381610.2494.9740628316490671479.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:10:16 +0000
References: <202211222009239312149@zte.com.cn>
In-Reply-To: <202211222009239312149@zte.com.cn>
To:     Yang Yang <yang.yang29@zte.com.cn>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Nov 2022 20:09:23 +0800 (CST) you wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> Replace the open-code with sysfs_streq().
> 
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> 
> [...]

Here is the summary with links:
  - [linux-next] net: stmmac: use sysfs_streq() instead of strncmp()
    https://git.kernel.org/netdev/net-next/c/f72cd76b05ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


