Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67D96258F6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 12:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiKKLAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 06:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiKKLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 06:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8419014D27;
        Fri, 11 Nov 2022 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4160FB825B5;
        Fri, 11 Nov 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8629C433D7;
        Fri, 11 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668164416;
        bh=TT3UJ1xJjo5vGLg8LWdCfr+dxglb/a+F7BZsZCNvbOw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S7WytFWwRjXzwxcf1sL6IP4FDPyseg2nsjrpbMAyi3nmyC21cFuKXOw3ND0rfO2oe
         +KbqckEw58FGeApnZm7hOGiOtJBA3KPCccvOFwBuq3eLcvzIr8KzP4JIrJUlM5VJdj
         kXTnq5FkMrUIQsrUsVU97CKa/nnQjHGmwYTZaJQ6YPGjeQWbugPeazpC9qo1NZbV4t
         /Xxpp8Xi39rwtZSrnmpq/LPrXY9vq+FfrUln+0bjvSJpw6ZLe6gB5dmRcPRMuDp3FF
         mO5oFAKRgUOZ4NU+sNvNJOSf5qMj50y9gZTusPJjK7i34tPRLaGQuLrcfoVVJIh5U5
         6xe9cWe5HJJ5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6A3EE270C3;
        Fri, 11 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816441667.11358.7443670994453158493.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 11:00:16 +0000
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        linux@armlinux.org.uk, alexandr.lobakin@intel.com,
        UNGLinuxDriver@microchip.com
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

On Wed, 9 Nov 2022 21:46:09 +0100 you wrote:
> Add support for xdp in lan966x driver. Currently only XDP_PASS and
> XDP_DROP are supported.
> 
> The first 2 patches are just moving things around just to simplify
> the code for when the xdp is added.
> Patch 3 actually adds the xdp. Currently the only supported actions
> are XDP_PASS and XDP_DROP. In the future this will be extended with
> XDP_TX and XDP_REDIRECT.
> Patch 4 changes to use page pool API, because the handling of the
> pages is similar with what already lan966x driver is doing. In this
> way is possible to remove some of the code.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: lan966x: Add define IFH_LEN_BYTES
    https://git.kernel.org/netdev/net-next/c/e83163b66a37
  - [net-next,v3,2/4] net: lan966x: Split function lan966x_fdma_rx_get_frame
    https://git.kernel.org/netdev/net-next/c/4a00b0c712e3
  - [net-next,v3,3/4] net: lan966x: Add basic XDP support
    https://git.kernel.org/netdev/net-next/c/6a2159be7604
  - [net-next,v3,4/4] net: lan96x: Use page_pool API
    https://git.kernel.org/netdev/net-next/c/11871aba1974

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


