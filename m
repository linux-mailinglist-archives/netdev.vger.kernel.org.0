Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234085ABE49
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiICJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiICJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD5A40553
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 152AFB81FEB
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF21DC433C1;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198614;
        bh=BtE+X6tLYMmCedzC2rQQmiX+27il0gz5nMkRlwFtojU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gTiyuezDUPO8pG7uwcvI1+jaK41qPXvTUPhDnjmxnPgAnO//A4htGWG4XaZHxqIwP
         mPwWYNCb71kQrOI3MCQF5nIoa3LzfTLu2vjKERDQE3WoZH75VDpz97cmHBUy1Qq4Ry
         39HAxFSgDw70dRXt6wydx++EnaqiteND7zaj0S5F4Vxm+hHz5rXa9qEtgm4McVQ7lp
         0l8YoBUVnggsil51hvQx0Uci6ee1ugo+RbK+20lciYYsPwxgBF03HLd97FFwiSY8xe
         GvURHTkDp1X8JQPJS0sNaaUpeDeOhIeH60jyZoKPbL4/a4paTPWPq6TWcjGUilh36m
         zeyEcgmlhnoOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B544C395DB;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2022-09-02 (i40e, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219861463.29702.13021637432782491989.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:50:14 +0000
References: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  2 Sep 2022 11:38:54 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Przemyslaw adds reset to ADQ configuration to allow for setting of rate
> limit beyond TC0 for i40e.
> 
> Ivan Vecera does not free client on failure to open which could cause
> NULL pointer dereference to occur on i40e. He also detaches device
> during reset to prevent NDO calls with could cause races for iavf.
> 
> [...]

Here is the summary with links:
  - [net,1/3] i40e: Fix ADQ rate limiting for PF
    https://git.kernel.org/netdev/net/c/45bb006d3c92
  - [net,2/3] i40e: Fix kernel crash during module removal
    https://git.kernel.org/netdev/net/c/fb8396aeda58
  - [net,3/3] iavf: Detach device during reset task
    https://git.kernel.org/netdev/net/c/aa626da947e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


