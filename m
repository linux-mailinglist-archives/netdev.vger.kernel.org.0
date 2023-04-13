Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C646E1361
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjDMRUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDMRUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB8C8A6F;
        Thu, 13 Apr 2023 10:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DE1C6406F;
        Thu, 13 Apr 2023 17:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFCA0C433A7;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406417;
        bh=DQD/+8HAjp6OZnwGNsp3dU3hAuoO/OL2EO3YXwXhJlY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MYbws1ZSweeGgVkddQZSrbRcdXS86g5o4Euu+HHWdUgTjCeyEJuuK8XUfmODrBsBq
         So7B9tiOfb7KrrMOySSl9NFKBHTgae3BvWur9T54uh+2LxM/qStKs67llHYHFD1xBh
         dUA/nyI7nIkgrNlmbIEwMcu7/3H6YhTm3OfNYyh494dFXjNyV9rBHiXoEQ3kdd3bYC
         /oT9bYyvrQooxhRYGNL0NlLN2ASw21G5cOcIaeoIVE3UOlZvuWbHq0KUTm2He0MrWt
         PVTcdPSpU8E8YZb8Df5xYjnZK0H0yg1pC+AiqRpt9GkCRJQuezPBe6cv7f8s620ihd
         Mf6odOPgXFfiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5B71E45092;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: macb: fix a memory corruption in extended buffer
 descriptor mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140641774.8255.13131382943054451292.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:20:17 +0000
References: <20230412232144.770336-1-roman.gushchin@linux.dev>
In-Reply-To: <20230412232144.770336-1-roman.gushchin@linux.dev>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rafalo@cadence.com, harini.katakam@xilinx.com,
        linux-kernel@vger.kernel.org, lars@metafoo.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Apr 2023 16:21:44 -0700 you wrote:
> For quite some time we were chasing a bug which looked like a sudden
> permanent failure of networking and mmc on some of our devices.
> The bug was very sensitive to any software changes and even more to
> any kernel debug options.
> 
> Finally we got a setup where the problem was reproducible with
> CONFIG_DMA_API_DEBUG=y and it revealed the issue with the rx dma:
> 
> [...]

Here is the summary with links:
  - [net,v2] net: macb: fix a memory corruption in extended buffer descriptor mode
    https://git.kernel.org/netdev/net/c/e8b744535558

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


