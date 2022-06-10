Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D4B545C25
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 08:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiFJGUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 02:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245420AbiFJGUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 02:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3972AD8
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 23:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8ED61EAC
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 06:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 980B8C3411D;
        Fri, 10 Jun 2022 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654842013;
        bh=aXA/r4rENh+M/hpNxzeJQ+iu3FL76m1eOHDXwshbxIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=peKLz8WxlNX06dxsafaLy90td1igR87VsQDxY1oeccN7DRLkWROAfr7VxrMHxpOWX
         E+7XTvxjW2DBss1uA0iSgfZbpQx6PESCQaD+JFhIYG9eDCDKT2FbRyW33FKcOSK6rC
         zKnKofpvromPMNRaqJ+GrcIhjQqOt6PJ/UMi/oKvYwrHhRYL2wX7YqA6PyFFNc9GUB
         ChoU4TgJTy1oa5mlXYsuHsgcQPYyF0UExRLS5CGL1dDzesu7b2ZgFaQkl/ohXl5tbW
         30JF2xfIPizudO6W5fzosj9bT7yD8gEFesiXzBEcAAB0vGU6r22DhcaKELaQRNjwf5
         H3BZPF5V+bZYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78415E737FE;
        Fri, 10 Jun 2022 06:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-06-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165484201348.1106.11331140889803122871.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 06:20:13 +0000
References: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  8 Jun 2022 09:07:53 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Michal prevents setting of VF VLAN capabilities in switchdev mode and
> removes, not needed, specific switchdev VLAN operations.
> 
> Karol converts u16 variables to unsigned int for GNSS calculations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ice: don't set VF VLAN caps in switchdev
    https://git.kernel.org/netdev/net-next/c/cede04b35258
  - [net-next,2/4] ice: remove VLAN representor specific ops
    https://git.kernel.org/netdev/net-next/c/b33de560f9e9
  - [net-next,3/4] ice: remove u16 arithmetic in ice_gnss
    https://git.kernel.org/netdev/net-next/c/0a3ca0867c1f
  - [net-next,4/4] ice: Use correct order for the parameters of devm_kcalloc()
    https://git.kernel.org/netdev/net-next/c/a4da4913a04d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


