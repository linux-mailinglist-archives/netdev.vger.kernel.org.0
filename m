Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62F6644275
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiLFLuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiLFLuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E576F1CFF3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8244AB819BD
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27E98C433B5;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670327416;
        bh=V+2rJ7bTGSC6gLewb9u86vlDsp6+CNVI0WHP5fljDIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SdzUIiXB7aWyPYnh1X5GEKSvM73fW3pF+K5E0lbYBj10C5nGmNZWQ0SFV1YEBM2xO
         f2ysqyFH2TDT1O5kMRsIq8RT7YW2YXCawGcIYDBcqoCmNTErPaqOjXepN3ofSv8wnA
         mxFnXvbT5pmf6YL63anyX7cUXCyiIpMxtP8kFqndUNKw3YnghQIkeD0AAqE6EXiUTI
         h/4glERZmxPDsysZg7BLDKbGXqDEQfEpwosniI+F+tGFCOgrQm6NfLn1Vxb/ToMnqb
         BEOog/dk9wkzfg3Z46sANb555d0NWzxQrH/5kJjtBLDIRWCLyxR2QyPsyyYItyj+mQ
         ff/K2xwtPU2aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C97FE21EFD;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hisilicon: Fix potential use-after-free in
 hisi_femac_rx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032741604.10641.15208610432084156064.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 11:50:16 +0000
References: <20221203094240.1240211-1-liujian56@huawei.com>
In-Reply-To: <20221203094240.1240211-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zhangfei.gao@linaro.org, netdev@vger.kernel.org
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

On Sat, 3 Dec 2022 17:42:39 +0800 you wrote:
> The skb is delivered to napi_gro_receive() which may free it, after
> calling this, dereferencing skb may trigger use-after-free.
> 
> Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hisi_femac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
    https://git.kernel.org/netdev/net/c/464017704954

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


