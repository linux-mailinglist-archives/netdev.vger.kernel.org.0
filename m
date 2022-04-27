Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B25510D80
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356502AbiD0Axd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356497AbiD0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D1912085
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5283DB82415
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4372C385AC;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020612;
        bh=KI03yIcASmEJV8m46FSiWlMMRE6ln7v2cT+Q7NQrSbQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rSo3TuvoyLR8FgStE7gDicZEhTLSsV9OL0/gkIdibtF9/S2rO+aY/bH+kDhYXdwUC
         VY1LbFKj2YiRv86JTEZDTLtg/7tfoMtAbV7Mj8epUfPT1L2Rr0rbtfnqBuKn8x4dkY
         nf61e1W+AbbQj96JfEgLB8NBszmgdh3Gh8sTLNRRqUYdi5OY6Su58xn9mV+M7EkTlm
         KDeMgo5w/lOHUbTR1xwXb46rX4XUTGgqi2DzvvX3092g8NdTHUJX3wHXrigpuorMaR
         DLw+pr3ltLch0KSpZOZvmHRaQvz5MNEk/c8FKc1cec5YGoKi/5xBGQn5QfEJAzfAan
         4W2Js29/xWwRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA8A7EAC09C;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tls: fix async vs NIC crypto offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102061182.18100.7720177184206724633.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 00:50:11 +0000
References: <20220425233309.344858-1-kuba@kernel.org>
In-Reply-To: <20220425233309.344858-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        gal@nvidia.com, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Apr 2022 16:33:09 -0700 you wrote:
> When NIC takes care of crypto (or the record has already
> been decrypted) we forget to update darg->async. ->async
> is supposed to mean whether record is async capable on
> input and whether record has been queued for async crypto
> on output.
> 
> Reported-by: Gal Pressman <gal@nvidia.com>
> Fixes: 3547a1f9d988 ("tls: rx: use async as an in-out argument")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: tls: fix async vs NIC crypto offload
    https://git.kernel.org/netdev/net-next/c/c706b2b5ed74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


