Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F777536CB4
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 13:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355034AbiE1LuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 07:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355854AbiE1LuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 07:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770511EAD7;
        Sat, 28 May 2022 04:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E66A560EA6;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BE34C34119;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738612;
        bh=fBpem0ykHROYu0A4ucgxepwaPZnPrNOdW3xfdCf2DXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sQ041HWog7TUPLUEqcY9mm+lO/tMU4Fu//cBako/qtGOkFf5ryoT3Kx50snnI58Ch
         MfgkbadtpG8Am+j9f1o76rOZ+eKpoGGMXYOdCSu7YJBZZ3iMEW7Ke1BQfqbz9LxmNU
         7Ia/yJmssPL5POIOc7/5RnOzbP6FEZYaMDr1Y5oSXe7a1vIpB7DW4/dGFJz62KrUDS
         VI9sQJooLBcCsS8hIbX88VDFmle4wFLsgXANUfe1mzVRSnpwEqOvRezwBrxCEXosW6
         lvgkAkcFtALuYJvcHSSVdl8jb50nh03lZ+qHOa6/uwsmX4kCWFk0mLxxq2szi8Uj4I
         /JhY87eeJttPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31716F03942;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: Directly use ida_alloc()/free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165373861219.5820.2178379489520863399.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 11:50:12 +0000
References: <20220528045437.102232-1-liuke94@huawei.com>
In-Reply-To: <20220528045437.102232-1-liuke94@huawei.com>
To:     Ke Liu <liuke94@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 28 May 2022 04:54:37 +0000 you wrote:
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove().
> 
> Signed-off-by: Ke Liu <liuke94@huawei.com>
> ---
>  drivers/net/phy/fixed_phy.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: phy: Directly use ida_alloc()/free()
    https://git.kernel.org/netdev/net/c/2f1de254a25b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


