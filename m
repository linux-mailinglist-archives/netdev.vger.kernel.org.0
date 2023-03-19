Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1F26C0091
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCSKub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCSKuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6180C13D7C;
        Sun, 19 Mar 2023 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CF5B80B26;
        Sun, 19 Mar 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60BDBC433AF;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223019;
        bh=ya14NSVjLlqfvq5SendpcQMNOmiH43rD0cHiDc5r2UU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WaiZep4EAdjZiO5jjbDWmcE4qZq4c2YMl0DRL3bqAdzEAGQpE9j+7RiqMJvQXO+04
         eHfacOKhtga96ET6293yIumXGO5t55UqfR300lDxDaUCQcnTEE+ubCTJeW9wxqa7zK
         1Pyv0rE7S5OR0ElaaMJxi2nAfl+uhLdDAVdDg4KEcuYzuDUWfpxAPh8PlZgn6rrv2i
         6YVlvr8R/fxLIRe5wOA9VdlRol9P6t3hKA6dcRYgDR8V1QIN+Opzrlj73jk0kMmPh4
         47+Co4+mHkF9RC2UljhXL++N8WQVsuE1NH2v7G2t/eyPe50EM2ZCQBZtJzFyUyxGzA
         5M7i3cJihAqVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E233C43161;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: phy: at803x: Replace of_gpio.h with what
 indeed is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922301931.22899.3145867356894965208.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 10:50:19 +0000
References: <20230316120826.14242-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230316120826.14242-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 14:08:26 +0200 you wrote:
> of_gpio.h in this driver is solely used as a proxy to other headers.
> This is incorrect usage of the of_gpio.h. Replace it .h with what
> indeed is used in the code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/phy/at803x.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,v1,1/1] net: phy: at803x: Replace of_gpio.h with what indeed is used
    https://git.kernel.org/netdev/net-next/c/a593a2fcfdfb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


