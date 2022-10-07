Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB775F74E4
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJGHu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJGHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD53061B1D;
        Fri,  7 Oct 2022 00:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D25CC61C1D;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26945C43140;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=FXDAJUfi+hQdCA3ICkZQYIj8kFs69rSwptxmzmI8EtI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y9tfV0P7/km+tugLryewKZj8TROrKOLWSPoU8Kzph4/qeSScnpvWmovQJcT7m2C0Q
         aSK/EX+9ZaXmhPIeyscScvhcrtSjfEX3o3rFFq993/617qdWhEfsO7WziflzywnSW4
         7k57vU6fbaYzN+VUv3uQxtMvtBTCKsRJ0bY6KW4mKmfH5mVtvq8E0o92bXYnPn1I/G
         vmsCosAeYR5Nvz459ZHb6jDMQ/RfIdCH0dQrql1gXiVQNlutVKobbni8zkZslFLY8O
         bvJLJiXXxGOyLZpSuguW8/HDjLcLQB4QscLVFKQVB27fPPf8SMZS212R4sO0B7riTd
         L9rUXtkmoHT2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08AA1E43EFD;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeontx2-pf: mcs: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901603.847.7086047181788484705.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:16 +0000
References: <20221006114400.4262-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20221006114400.4262-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
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
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Oct 2022 19:44:00 +0800 you wrote:
> Semicolon is not required after curly braces.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2332
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] octeontx2-pf: mcs: remove unneeded semicolon
    https://git.kernel.org/netdev/net/c/7305e7804d04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


