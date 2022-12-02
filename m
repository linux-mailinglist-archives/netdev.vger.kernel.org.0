Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63DD640525
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiLBKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiLBKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC55CCFE77
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A564B80955
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FD84C433D6;
        Fri,  2 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669978216;
        bh=AEGVoUECyK49WOaqo+zEDiw2aGIiafzC7zPO0JIEJrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=StBcxK0V6pVlVLfZi3TWIkasjOdgiBc1knV/g8Rn+gL68n439ggC3yC2f17ZRukcf
         8AtepXgVKAHyaCVhziyn4zwF8mTWS6eAAfhDVbR0BVHh8zSazDDPfAXA+9bY3IXS/O
         cdeFJiG1LRsaZEIGYKZz366HCN3R74jRl90cFbgldwb0jumB2jOJ4zcDjuPa2rvihj
         Y+w0uVvSIeLvnRHy486uI/43qCu+HZlvEerIPl3MRJMM8l+jbLEfVed4VPff0wGXiY
         ELqfo7l0spApNatvil05ZNpMplsUDma6CM3dY29NefPYmL8bO1VJzhjOqr33eyJCM1
         Op3vbZir2T9DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0601FC395EC;
        Fri,  2 Dec 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v3] net: devlink: convert port_list into xarray
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166997821602.27168.7612890751481786992.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 10:50:16 +0000
References: <20221130085250.2141430-1-jiri@resnulli.us>
In-Reply-To: <20221130085250.2141430-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Nov 2022 09:52:50 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Some devlink instances may contain thousands of ports. Storing them in
> linked list and looking them up is not scalable. Convert the linked list
> into xarray.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: devlink: convert port_list into xarray
    https://git.kernel.org/netdev/net-next/c/47b438cc2725

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


