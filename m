Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167E85159B2
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382030AbiD3Bxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbiD3Bxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBA41129;
        Fri, 29 Apr 2022 18:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D8EF624AB;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9C42C385B0;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283411;
        bh=lwhjMBYIT1JRzTaq5z9qYblRXgqG3fiwN5yJPyj+BqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OtyL6vVC+fRLY4/H8xn3melL87dEgNgQdfIo2sQILk/KTDszNIMkHUPVtCmDBpFqC
         nG2PD2uw+hR/J74a88vuFZX1/f/F76JbGVmeMDU9YxGjuuK1ktpkB8VirwJh2WLn2/
         j9BBiAsoXm9KYOijFhWQgj9MEyYiA6yaIP8hlhonhinfmSF6tF/i+npGbOU1z8wuUu
         5+9VfuzD09W84Ws9yPv4CuLHWnmLbv1aQabH6Pc1nvvOtoQbV8TL3MyLft1C58nxnw
         nM7UAXNp3+IGR4GDRgzzaAiwH/Dp7ZM6MTJOOCfKH1U+jo/wKK3msL6gbNO+s7XGdF
         EOwYfo6q9cxAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B65CAF0383D;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mediatek: add missing of_node_put() in
 mtk_sgmii_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341174.13664.12317514377406720211.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:11 +0000
References: <20220428062543.64883-1-yangyingliang@huawei.com>
In-Reply-To: <20220428062543.64883-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        kuba@kernel.org, davem@davemloft.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Apr 2022 14:25:43 +0800 you wrote:
> The node pointer returned by of_parse_phandle() with refcount incremented,
> so add of_node_put() after using it in mtk_sgmii_init().
> 
> Fixes: 9ffee4a8276c ("net: ethernet: mediatek: Extend SGMII related functions")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
    https://git.kernel.org/netdev/net/c/ff5265d45345

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


