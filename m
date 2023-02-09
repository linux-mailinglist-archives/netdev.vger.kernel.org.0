Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0B68FFA6
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjBIFKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBIFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63D124106;
        Wed,  8 Feb 2023 21:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F93B61919;
        Thu,  9 Feb 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99386C433EF;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675919418;
        bh=yBKzq2Ps2+hywPMPrB2pH5YTXcgkfvsadel5nLU8Xmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IOVNIrD8w4+FyT6usxOyrngUh1z2ghBCr/vhRiWTooKPtaqYS7xbC28uUNdAWw7on
         /XB2zzfzSCHrtpHPzi5hXoQxVooU1V3iW7MUUZvnjLrLbH+BBfVE4VnkVOpwu2+h7g
         eeK3/4n0GUX/KpzytfroyLN3NMeInpuDkTz6ilfIQUMj1tpDYOCppdenybTbheTdpS
         Db2XElFsTYaeXdjzhc0q0a5sjkQGszviRXnU3aCgz0kMuVV8fz242CrGv1hzsVeppx
         77Ou3hHtWWBRcympkb1O+fSGalmhNfBMlWL3quzatAeiisGnsQmu5V84tyoUW+KfBL
         uz09JLhHpSi2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79E2FE49FB0;
        Thu,  9 Feb 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: libwx: Remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167591941849.2876.12970748103354852991.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:10:18 +0000
References: <20230208004959.47553-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230208004959.47553-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiawenwu@trustnetic.com,
        mengyuanlou@net-swift.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 08:49:59 +0800 you wrote:
> ./drivers/net/ethernet/wangxun/libwx/wx_lib.c:683:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3976
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: libwx: Remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/3ca11619a3cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


