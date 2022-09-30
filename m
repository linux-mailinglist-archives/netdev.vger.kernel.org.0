Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C34F5F02E5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiI3Ck2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiI3CkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EC6F9621
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 19:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39FB462223
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EDBCC433C1;
        Fri, 30 Sep 2022 02:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505622;
        bh=oQELkgnHRqNuWovwlF08b68rtJlC77I0EcVv7ArwNO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lH/kC1iGx6g/0WlsfYrIjTV6b4GF3q3it76tHNJHi3fAzPXeyK6V4P+EVCl341Gfy
         NjsJ69+lBM9tjIGfWtuq/9lxafLc/zBNfFMYMKPsiu+rX6HcekxHSjJoSRF4GPN/wA
         r8ITpu9BH8jKYubleXPTF8ztSpiEEFS+d6qO8eb8CZNaWDE/OniNtXUpWejhK5QioQ
         bEGPnO9hiWibV0KSVFARN4PJv0FkusqQDeml0ft1LdLwmEatSLX41DJCXIMhUoWbNm
         iU396lphpM9qUsUXhOWENcOCthzRWYFqCWX23rp+3DvtvY/uV/PizKWH43Pr/RbSoU
         Uy76510sbvNQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74AADE49FA3;
        Fri, 30 Sep 2022 02:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: phy: Convert to use sysfs_emit() APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450562247.6749.8874023519412189209.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:40:22 +0000
References: <1664364860-29153-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1664364860-29153-1-git-send-email-wangyufen@huawei.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Sep 2022 19:34:20 +0800 you wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/net/phy/mdio_bus.c   |  4 ++--
>  drivers/net/phy/phy_device.c | 10 +++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: Convert to use sysfs_emit() APIs
    https://git.kernel.org/netdev/net-next/c/b5155ddd22bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


