Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2825EEF54
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiI2HkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiI2HkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7F278201
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5553662072
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADCA5C43140;
        Thu, 29 Sep 2022 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664437214;
        bh=j3ToGRzJ61eAUOKkwwirlln7hf4iubQb5X0xphtyn8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U2zjVeCNJZ3XNoI8VZH2b3wr5VLsrn/Rb2/rk3MiScA38h3D6koDSK6mn+uuKY7Si
         9ATwINJ3T1C9CQc8kaz1Cf5Qbt2/CT+vAyDN9YEXJ6g3jodIVrJiR4E06+4VjbNLx1
         IfZR1Wl1Q9yn1pUKEbCZ9K2hdi6cBOnCYQuhgbQnx7JQj+MUnJXeoL64pa5xN+H/ZO
         zuBLGUtON9UoFMSydBL2+H62Hl0L8XAzgwNY2XMbp4EIRHo2Sq2Ggt+bPn3jNCRQAD
         x117BUZVxrIWNal8y0Vi20jxpViTE/ktPV6qizv0BnlJDlluwV0smOmLUtu65THi5n
         RFRQKf3dEgckg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94D4DC070C8;
        Thu, 29 Sep 2022 07:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] ethernet: s2io: Use skb_put_data() instead of
 skb_put/memcpy pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166443721460.16048.14908258334986158537.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 07:40:14 +0000
References: <20220927022802.16050-1-shangxiaojing@huawei.com>
In-Reply-To: <20220927022802.16050-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     jdmason@kudzu.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 10:28:02 +0800 you wrote:
> Use skb_put_data() instead of skb_put() and memcpy(), which is shorter
> and clear. Drop the tmp variable that is not needed any more.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/ethernet/neterion/s2io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [-next] ethernet: s2io: Use skb_put_data() instead of skb_put/memcpy pair
    https://git.kernel.org/netdev/net-next/c/1469327bb3dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


