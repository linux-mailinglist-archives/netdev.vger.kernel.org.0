Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62CA666A9B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbjALFAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbjALFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBC84E404
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F4A761F46
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B12A2C433F0;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673499617;
        bh=A/w4Qa8WqXvi6NM5LhhVtpap0K9IjSLSb0iHY7BEMEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATW5bSp8qH7ZxXEh13LFV1oalg9p2IVcaM0KjQ56cCft9+mw48WFpNwYv4WgVrjPx
         MIit4FtdflO6WptXoK7IfVViTypS18r/9Sm8p0uqKKbtVBzo2RLrdXRzGTMei158YO
         eHpn2W/50jZnrNcYQpPi2KFXFJbYlK/YDFZKUtm4gmMgLfosFAZB0p6gVzeEJem2gs
         4Q+nOvwFtVLkaqgh1bM4oCpa4FugC8bqtFch1CId5bmQTkW48SDgSaF/mG+m8okIjD
         UhySB8WD1IP99R9O1oFOfYgboFshVAgxt6q18IWiSzK0ufKCdmbN7nhAT2RYNTvtbC
         umCUBqXaPVI1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A6A3C395D9;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-01-10 (ixgbe, igc, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349961756.12703.16228801485351207523.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 05:00:17 +0000
References: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 10 Jan 2023 14:38:22 -0800 you wrote:
> This series contains updates to ixgbe, igc, and iavf drivers.
> 
> Yang Yingliang adds calls to pci_dev_put() for proper ref count tracking
> on ixgbe.
> 
> Christopher adds setting of Toggle on Target Time bits for proper
> pulse per second (PPS) synchronization for igc.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ixgbe: fix pci device refcount leak
    https://git.kernel.org/netdev/net/c/b93fb4405fcb
  - [net,2/3] igc: Fix PPS delta between two synchronized end-points
    https://git.kernel.org/netdev/net/c/5e91c72e560c
  - [net,3/3] iavf/iavf_main: actually log ->src mask when talking about it
    https://git.kernel.org/netdev/net/c/6650c8e906ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


