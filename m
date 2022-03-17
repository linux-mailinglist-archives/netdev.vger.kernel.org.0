Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6104DBD23
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358473AbiCQClb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354977AbiCQCl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A5F20185;
        Wed, 16 Mar 2022 19:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814FFB81DEA;
        Thu, 17 Mar 2022 02:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 294E7C340EF;
        Thu, 17 Mar 2022 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484811;
        bh=d6PHNPVPmTysZRBit4MXXt2WuAvPHuq0x2xiVX6+buQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bd03dVaQKeLa5kOBEyhtT8eCYCLD/LUX/77MAU8WEW/Gr/wbI9ZqqKXFS7jtixiZW
         rfJtkwdDOBlb9sx5sAIW6FCgXkbjhtX8OxzwhBFghAKl3zfDguPK1HFcAZ9cs50ixn
         R6xuGNdYYtfG8VzV/bzaKtPAc3B4ePpNZQcZmbEOarpoHzSkU9rbWpTzpPYNeivBx/
         t81cumUNi+67xotsGyRyc/UJ31hEI2xX0pvVqhAH+1VCH5q/uK9oNFqJod8dWMzZB5
         aQfl1vQS5gB8DRrxp8FwQscKBOMPPiiN3FQIfoPwuReXFMK/ddUO/VFZw3+3MsMVC2
         K1uaMWuAy1IMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8A2BF03848;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns3: Fix spelling mistake "does't" -> "doesn't"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748481094.31245.11981080354188425621.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:40:10 +0000
References: <20220315222914.2960786-1-colin.i.king@gmail.com>
In-Reply-To: <20220315222914.2960786-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, huangguangbin2@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Mar 2022 22:29:14 +0000 you wrote:
> There is a spelling mistake in a dev_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: hns3: Fix spelling mistake "does't" -> "doesn't"
    https://git.kernel.org/netdev/net-next/c/f403443015c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


