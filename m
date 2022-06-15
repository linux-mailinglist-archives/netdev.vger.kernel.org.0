Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A688054C3B2
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346102AbiFOIkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbiFOIkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FD549F3D
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5096F619A2
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC75BC3411C;
        Wed, 15 Jun 2022 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655282413;
        bh=CZlcBK8KfGBynmOjEj6L8S+xVjvzgvny2E8tb3hfOrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QiKoa1WohUrnbvF3gjTjUoGBe2wSu3fnRO0g4JNqGm9O3XNxcqxYBqgVCjvw0oZwC
         lYGPoctmqQaJ7eTzKaPmi+/oFpqRe1cDCVuMx1eYUQ5/faTn1Gu2rs8abzg8Ln3Qf0
         PFqCbkLKubUFnboPRs8Rnc1KzrFxypcjHl/KjXZIaR0YNa0k4xs4EfLxCQFuWA1KPf
         Yr4yWkYQ9iZiU67sOz2Fb82AbWdiN/vAwhEB2LR0Oxaa0F2mI9ktZVev+dxbXXHs+e
         VneWfC0kvOe0Z7EWz+YRY73tnEwzryWessP77f1KRBr7wnsaPA8+7Jz0yZ+/CQYtQ7
         vytyhwX8ofr3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94F7BE73856;
        Wed, 15 Jun 2022 08:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-06-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528241359.21469.3816000067648987933.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:40:13 +0000
References: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Jun 2022 09:48:02 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Michal fixes incorrect Tx timestamp offset calculation for E822 devices.
> 
> Roman enforces required VLAN filtering settings for double VLAN mode.
> 
> Przemyslaw fixes memory corruption issues with VFs by ensuring
> queues are disabled in the error path of VF queue configuration and to
> disabled VFs during reset.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: Fix PTP TX timestamp offset calculation
    https://git.kernel.org/netdev/net/c/71a579f0d377
  - [net,2/4] ice: Sync VLAN filtering features for DVM
    https://git.kernel.org/netdev/net/c/9542ef4fba8c
  - [net,3/4] ice: Fix queue config fail handling
    https://git.kernel.org/netdev/net/c/be2af71496a5
  - [net,4/4] ice: Fix memory corruption in VF driver
    https://git.kernel.org/netdev/net/c/efe41860008e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


