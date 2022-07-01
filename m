Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EDE562968
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiGADKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiGADKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34994248CC;
        Thu, 30 Jun 2022 20:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D52B9B82DFF;
        Fri,  1 Jul 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70560C341C8;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645016;
        bh=yKpyVbEwaRVeeBopFcglD9zHLi9ml/4kkHdK1r89flA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KwgY0YzQJie0qsC1y5ZW3sfQK2HsmwhzyyiCI5Emmwnu2dyr+mo0zXQX89Rv1Fzsy
         de2IwhdzNgA0vDHL2ZBqicxz5P+3BuZNOFhe/8zXa2440xeG8/ijQKE3F96A5DbG/w
         PfyxaIqemQ0ZS8XwFTCMp6/DjXOvWPrnWJsywyBKnXch+iBjZuEuJzyucL8HP7+tVi
         670/cm7BCsiCfDN6F/8UBy2FvdgdxUkCjXroCy8D/XBWWpWzMYKPxV+O6ODacxXz5Z
         EnWik/MZABoxHML6BVpCK6Zm7wM/AQOpqfnT7eERviOD4jaHGCu073PwHf+v6MYRp9
         RS2A6iqvSU6ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46104E49F61;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hisilicon/hns3/hns3vf:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664501628.21670.18401986399623472310.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 03:10:16 +0000
References: <20220629131330.16812-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220629131330.16812-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shenjian15@huawei.com, lipeng321@huawei.com,
        zhangjiaran@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 21:13:30 +0800 you wrote:
> Delete the redundant word 'new'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - hisilicon/hns3/hns3vf:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/34eff17ec4e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


