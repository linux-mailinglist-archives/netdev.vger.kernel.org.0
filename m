Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D115696449
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjBNNKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjBNNKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C5125E31;
        Tue, 14 Feb 2023 05:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACDE615FD;
        Tue, 14 Feb 2023 13:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C607EC4339B;
        Tue, 14 Feb 2023 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676380216;
        bh=ho24ZQU+5EOMGBAmuBmpO4sBosy4WC266JK1rlfvEW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sb9koF5O4nXobQEGXY3vTtivOsdFyh6q2H1kyIc+EGPx7PHVNfUUrhvFJ/hM4DFCe
         aYK1T8zk86tIL7L8O7G5hCJB81UraH5uBscQffxCaP4AvgscIkrUo9MAl3le5pqyhH
         2zm2pHEBNRvFzs0DMGWGNGdquK8GCQxxuVodhknVKVC38mWJPI7Iy1KBzZGjhritIr
         FQMPPWz48VsPL6pw3VakLYlx4MPsqtuG9BTuZzQ57UjdDfZLnEqTEB0HlG5H36v1Fi
         ykvVmbOalGqmnWEikfBYb3psLdoFTdasDETZQ4C0T6RSJjuKtS40MjGhu5h+Lqg6wd
         /eI0N61rbMKdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA4B1E68D39;
        Tue, 14 Feb 2023 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167638021669.21305.9259204926008867600.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 13:10:16 +0000
References: <1676264881-48928-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1676264881-48928-1-git-send-email-mikelley@microsoft.com>
To:     Michael Kelley (LINUX) <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 12 Feb 2023 21:08:01 -0800 you wrote:
> Completion responses to SEND_RNDIS_PKT messages are currently processed
> regardless of the status in the response, so that resources associated
> with the request are freed.  While this is appropriate, code bugs that
> cause sending a malformed message, or errors on the Hyper-V host, go
> undetected. Fix this by checking the status and outputting a rate-limited
> message if there is an error.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/1] hv_netvsc: Check status in SEND_RNDIS_PKT completion message
    https://git.kernel.org/netdev/net-next/c/dca5161f9bd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


