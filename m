Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF9257382F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiGMOA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiGMOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFED2DAAD;
        Wed, 13 Jul 2022 07:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4896861D99;
        Wed, 13 Jul 2022 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3A3FC341C0;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720815;
        bh=03+mvAvY4NyrjktKyF2ANKSxTrNWHhHdvSkI2OB6hO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rpRJySmiL+NZQeKhmWl/DCLeeX/TvrlxeJrBA9JBjQdP8X7v3XnQU2B0XROTNfVtL
         dYXHjlRMZCl76skDY9UhOinhqcBr+YdK7Sw2gSZ3XGAYQ4VS2URYT/KpWG+qFvHgyk
         EyS1Tj9HjYlWdXQxbXfy0p7oTDUcyTWHShwEmqxzsRLnCHTyPQy+1jI0PzRJpAVPZR
         hnbOHGj6p8k8tJ4BlowWU1mGIxYUOlaCrmGZIWXgoaCGH2nscsYh9Pd82+/QBOBmNZ
         Kly6xPemWqzL4T3ma+F/L8iKB0tHjZlgQ89k0RpXkJk+kISkGVuo2DRseDhnzmNGPq
         pr9TYVXbV6+YA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93D95E45230;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeontx2-af: fix error return code in
 rvu_npc_exact_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081560.13863.10407164404896518319.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:15 +0000
References: <20220713095600.3377927-1-yangyingliang@huawei.com>
In-Reply-To: <20220713095600.3377927-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rkannoth@marvell.com, sgoutham@marvell.com, davem@davemloft.net
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 17:56:00 +0800 you wrote:
> If rvu_npc_exact_save_drop_rule_chan_and_mask() returns false,
> the 'err' is uninitialized, return -EINVAL instead.
> 
> Fixes: c6238bc0614d ("octeontx2-af: Drop rules for NPC MCAM")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] octeontx2-af: fix error return code in rvu_npc_exact_init()
    https://git.kernel.org/netdev/net-next/c/6a605eb1d71e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


