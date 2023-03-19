Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A329A6C0095
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCSKue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCSKuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149C713D65;
        Sun, 19 Mar 2023 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1090D60F97;
        Sun, 19 Mar 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D211C433B0;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223019;
        bh=J9WleyAvr3NB2krI/jamJJEz2l4ytGLuPJcw2FxFan8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hkZAAfA80Epl0vignGVUzO3JLQXKbF8ECjHC4D/Zxrf9Z9/DRaOLLxS+st1uMaecj
         rqIRP6N/A+4PQKzOhcTVXr5F1OOGHt9eR4ved8+WJuMA3CfIpoH1EQ7jo/xnd6YCRy
         kADtlougqXr04NvjXFPaFczHy+Rv+fqTzmzxu6S3gdCF7Pz1gds5pgsS9TuAvMIUGO
         07/kv5N1xHOKDKPQuwWFWiuYgHKaMRa7hAKtki1+xaM06oBaXuHLJ8FMa457FBNd+L
         +gxWu/Co1osRliJo7cvsi+NFDw0nv5t7YVdNEQpNrxoBPnwB/M6UzQCVnfYBWDNNRW
         KjCOsXNjukGtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 563F1E2A03D;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: smc91x: Replace of_gpio.h with what
 indeed is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922301935.22899.18379131947509541304.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 10:50:19 +0000
References: <20230316120419.37835-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230316120419.37835-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@fluxnic.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 14:04:19 +0200 you wrote:
> of_gpio.h in this driver is solely used as a proxy to other headers.
> This is incorrect usage of the of_gpio.h. Replace it .h with what
> indeed is used in the code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/ethernet/smsc/smc91x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,v1,1/1] net: smc91x: Replace of_gpio.h with what indeed is used
    https://git.kernel.org/netdev/net-next/c/c0e906a953f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


