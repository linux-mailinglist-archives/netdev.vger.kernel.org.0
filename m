Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346A16E1B9B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjDNFUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDNFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC46F4EDD;
        Thu, 13 Apr 2023 22:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 583E76440A;
        Fri, 14 Apr 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96A6CC433EF;
        Fri, 14 Apr 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681449620;
        bh=kiOIswmBeYcthTARkkk2yI7sjYjx1o8hc5/XDEYHYA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c7xLC2O4du+H6YxNwhq17vf3xshIYgXC+D2S5pk0cYVOpBZAxfIjEukLzJaWpRjGw
         cxtMBGA6AWxbGLoH3bUHu8nokUzsyvxbvCBQYVZ4PhgF4qrSljN0o+B9RzA4t9aRaq
         rPXVDt4t3N9jDGk+EXZ20/YACWafEZa25nqK1FxGiqcOqireuR1zXXu9hmEl/qC5jI
         R4JCjxXA/1WR6V2G3Rtu/nR2iaHg/InP7y8RZ14VY1k/e00eSLmARZmxiauUTTr7y0
         c0bKAvpM4Vc9vwm7r57LyPrPLTo+9Ji77WH4DVnihZ8uZOMfGjYai/LAdmBFCAkWy7
         pMmObr1r6l1xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7CFADE4508F;
        Fri, 14 Apr 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/3] Macb PTP minor updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168144962050.25322.10654838630358470877.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 05:20:20 +0000
References: <20230411123712.11459-1-harini.katakam@amd.com>
In-Reply-To: <20230411123712.11459-1-harini.katakam@amd.com>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        andrei.pistirica@microchip.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@amd.com,
        harinikatakamlinux@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 18:07:09 +0530 you wrote:
> - Enable PTP unicast
> - Optimize HW timestamp reading
> 
> v5:
> Remove unnecessary braces and !! in gem_has_ptp
> 
> v4:
> Fix kernel test robot error; use static check for
> CONFIG_MACB_USE_HWTSTAMP where necessary
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/3] net: macb: Update gem PTP support check
    https://git.kernel.org/netdev/net-next/c/adee474a3b43
  - [net-next,v5,2/3] net: macb: Enable PTP unicast
    https://git.kernel.org/netdev/net-next/c/ee4e92c26c60
  - [net-next,v5,3/3] net: macb: Optimize reading HW timestamp
    https://git.kernel.org/netdev/net-next/c/8c0d0fe04449

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


