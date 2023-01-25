Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2FE67A90B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjAYDAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjAYDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6A94741F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 19:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F18A6137C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DBF2C433D2;
        Wed, 25 Jan 2023 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674615616;
        bh=syTsz5L5I05B3XyavE4RGHs7trpnS7IlUTlpGxc8koQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z9f/D9663kq/3hAUIKSK0RyG9rJuTZFZgaYjFSsPQTqIbtAZ302h81XY1MNEPF3lJ
         q3GnS+dG8MT8ggIRiDpGT3CVgcg0Q6WXbul1xVWaSwZXWq76l4Vn9/RS/6CVvnJiZ/
         hReVw8mJhDRRqu+ooTONTYtTeJ9m7FGSOp3ygt4XqC2QOv5L28AXjx9eDRaPMuJJRV
         JGgRv4Py+nJwxxpP7R/KHtk9dDia65e+M0iv9CK3owcWfJSRh6jIoY5UncEvtNJ2QJ
         5srnCK5JvuVffs4ie3pqnFszQmQJrcmS1qPWjVI98US7el9RyiG395c4B4gKo3WfNI
         t2RZ71WhIydHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69763E52508;
        Wed, 25 Jan 2023 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: move devlink port creation/deletion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461561642.10338.10803939391791859107.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 03:00:16 +0000
References: <20230124005714.3996270-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230124005714.3996270-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, jiri@nvidia.com, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 16:57:14 -0800 you wrote:
> From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
> 
> Commit a286ba738714 ("ice: reorder PF/representor devlink
> port register/unregister flows") moved the code to create
> and destroy the devlink PF port. This was fine, but created
> a corner case issue in the case of ice_register_netdev()
> failing. In that case, the driver would end up calling
> ice_devlink_destroy_pf_port() twice.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: move devlink port creation/deletion
    https://git.kernel.org/netdev/net/c/418e53401e47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


