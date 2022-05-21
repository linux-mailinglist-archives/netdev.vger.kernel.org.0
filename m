Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD352F6CE
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350004AbiEUAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiEUAaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B31A90E1;
        Fri, 20 May 2022 17:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D93861E79;
        Sat, 21 May 2022 00:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A29B6C34119;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653093012;
        bh=romPb1m7BCaZKliDlGaR9szxJOdOcNEB+jJBTqlaxZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iaj2Smbi2urjtd4iTA6wKfARRCKtlZujdu7lKCLPtJVKhGBpvYDCQaeNUhXo7HuPS
         eGR/ZncPbvcLm7DAwJkyLmpydxG/S1h89mFotZ8Gmmq8ZoJ4Db3pVZ7eoR7XW3Nxhw
         J5gvXmHABvRsC/WtWm9QVH+RGoUPY1P5hl/HB3bflf94Hf2Xr0lH8uFAsmezDfK8Ya
         LEPp5vR/nUPutiXz0KCS4xtRo4hgBGQevbdjkiJpLiNUv1XNz/jEQn17QPChrgkN82
         DRbQp2qkJI2DR0yCb4bMZhBqxLb6rkV8H2yZJKlazYA0XMZejJW4lurrs6olrssVZv
         lzqtEKlce0yCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CDD4F03935;
        Sat, 21 May 2022 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] net: wwan: t7xx: use GFP_ATOMIC under spin lock in
 t7xx_cldma_gpd_set_next_ptr()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309301257.22995.9619477553610888846.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:30:12 +0000
References: <20220519032108.2996400-1-yangyingliang@huawei.com>
In-Reply-To: <20220519032108.2996400-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        haijun.liu@mediatek.com, chandrashekar.devegowda@intel.com,
        ricardo.martinez@linux.intel.com, loic.poulain@linaro.org,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 11:21:08 +0800 you wrote:
> Sometimes t7xx_cldma_gpd_set_next_ptr() is called under spin lock,
> so add 'gfp_mask' parameter in t7xx_cldma_gpd_set_next_ptr() to pass
> the flag.
> 
> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2] net: wwan: t7xx: use GFP_ATOMIC under spin lock in t7xx_cldma_gpd_set_next_ptr()
    https://git.kernel.org/netdev/net-next/c/9ee152ee3ee3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


