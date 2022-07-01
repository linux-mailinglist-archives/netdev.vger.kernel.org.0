Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CA3562966
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiGADK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiGADKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589B25EA6;
        Thu, 30 Jun 2022 20:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70EE3B82E07;
        Fri,  1 Jul 2022 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EA3CC341D2;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645016;
        bh=j6jOROreW3+3syekmt4WxahSu3rHsGmaW4t/09lYLIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gPKgbsUyzs4I4RJyu9lVpbKN2yI7K+NPPw386xq1xr14+fisuUOpxKW7VMzVKPj4k
         0NsCxXvheGLPZaN3weC+rgea+aYwxq2e6U0PiwBACZos1igT7VBuA8knmIn30+Bguo
         H56ayE/Y6BwPwZt/77JqfVdfFihAxwk4k812pzshsNkttpU67wgw0traLyXrXduwZP
         03BomcvZ9xO9z5YK3+sbzIC0z2IEqWohWxREaOSR1skW4FDf9qLV9fceWFtMz+l8Ls
         2G18cT7kfKHAHGUlZzyTw47m14SFZXYP8W5J43wf4TUYU/Tpros5eToc/3MMYvv15L
         1SyWD1cQaOd+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7570BE49FA2;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] freescale/fs_enet:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664501647.21670.1917049788196328275.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 03:10:16 +0000
References: <20220629125441.62420-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220629125441.62420-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     pantelis.antoniou@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
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

On Wed, 29 Jun 2022 20:54:41 +0800 you wrote:
> Delete the redundant word 'a'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/freescale/fs_enet/fs_enet.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - freescale/fs_enet:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/b1769b6eb06b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


