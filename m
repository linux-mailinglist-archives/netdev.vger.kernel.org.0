Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A2C524786
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351279AbiELIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351272AbiELIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:00:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CD1E122A;
        Thu, 12 May 2022 01:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6404CE2808;
        Thu, 12 May 2022 08:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 514E0C34113;
        Thu, 12 May 2022 08:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652342412;
        bh=gNpLYA0CVJo+44QjEOzPtR7Xpn/S46BHQXAcJmGmc+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KVzTM/PZ2Nb9gxqx7Mb8Ztk2peiZX1GYuUdzV1Cw4ddlm3fkBXLMkXlD4iauHfLus
         vSkDGPsNDc1wPj20DK5pHT6PI347LU0GLJ8yHHKpjqk3XMqpQNE6FklfOmnzui06jQ
         mwlHh9GSmSk+9M4NVDxLVTIRn0YMqQPhy0tiJBv1Go7JfkxOqK7+SOvPZMbS8qexvI
         oFdJ18k0KcX0HiBjZdiz0YdPrnK2E4nsg/tj62DiOOAJ5DiuGrtoSLg++DsI5bb70p
         SDn6uRC5ryG2D7szqCKpv/8BnZfke/7MJjw367nPoBD8rM3SwjPDH7G+zj5LQUCowu
         7DzPcYTIyu9iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EC24F03935;
        Thu, 12 May 2022 08:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mediatek: ppe: fix wrong size passed to
 memset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165234241218.23640.3865091641010227800.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 08:00:12 +0000
References: <20220511030829.3308094-1-yangyingliang@huawei.com>
In-Reply-To: <20220511030829.3308094-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        nbd@nbd.name, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 11 May 2022 11:08:29 +0800 you wrote:
> 'foe_table' is a pointer, the real size of struct mtk_foe_entry
> should be pass to memset().
> 
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ethernet: mediatek: ppe: fix wrong size passed to memset()
    https://git.kernel.org/netdev/net/c/00832b1d1a39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


