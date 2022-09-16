Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57E5BA9AF
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiIPJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPJuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:50:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2483687D;
        Fri, 16 Sep 2022 02:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5550DCE1D79;
        Fri, 16 Sep 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B35AC433D7;
        Fri, 16 Sep 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663321815;
        bh=r6MOh9ORGZWJfKQC62Jv2S5HZTd0CL90Lp4ZU58WMCA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uoVFbPdxhXlEJe07jFx6eYi+o/QKqA3cIxfDGPRaAYOBQQvVeyMCeb/IKWMDI/fsV
         DbPZc1Q8X5eXHyBoIndh25vrqqe+MweTaGuUFg+yCXr06Gmie1OhrNaeIqq2gfmS4k
         K2o+/P6hGKMzsImZxOPL182ngw0GfS+wGBNOmGN7wbgokXy63nPC3pQNjNRiBKw00/
         Bh6KlsPmTeBcEDW0vN18j6gO+NHRPXE2unLOwCWf9JAnoDpfXeEUjwuV0OZLXP1iXO
         SDFXhFZUvb4nZvTq0HKjMBTHhduiMSFXVqYP5FzFASeMVyLr/ZoXx2OJUwUomQVa4b
         qS/Hsws8Bsgwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21E43C73FE5;
        Fri, 16 Sep 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: amd: Cleanup for clearing static warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332181513.31748.2631239140314157418.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 09:50:15 +0000
References: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
In-Reply-To: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
To:     Haoyue Xu <xuhaoyue1@hisilicon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, huangdaode@huawei.com,
        liangwenpeng@huawei.com, liyangyang20@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Sep 2022 14:28:09 +0800 you wrote:
> Most static warnings are detected by tools, mainly about:
> 
> (1) #1: About the if stament.
> (2) #2: About the spelling.
> (2) #3: About the indent.
> 
> Guofeng Yue (3):
>   net: amd: Unified the comparison between pointers and NULL to the same
>     writing
>   net: amd: Correct spelling errors
>   net: amd: Switch and case should be at the same indent
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: amd: Unified the comparison between pointers and NULL to the same writing
    https://git.kernel.org/netdev/net-next/c/b0b815a356aa
  - [net-next,2/3] net: amd: Correct spelling errors
    https://git.kernel.org/netdev/net-next/c/7c13f4426b0e
  - [net-next,3/3] net: amd: Switch and case should be at the same indent
    https://git.kernel.org/netdev/net-next/c/78923e8ae427

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


