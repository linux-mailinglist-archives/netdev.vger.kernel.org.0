Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038B16B3794
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCJHlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjCJHkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74B4104930
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4516DB821DD
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2BBFC4339C;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678434020;
        bh=vtSkEfRwm+DBMTMuFkpOapHFGZTlruxbwDlRRt5KJBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G5zs712hwDEHzD86yA+frdJVLj/PYQu014k60LyfBQYy7FCyYuiQfNqE4hEV7NBfj
         5VDM49gUH5nb+46OcFV5CEmTifmBQvtB1Ru1mN3DYzkIZRRqlS299ne8xi0zyz8KFi
         qR+2YI99pFs+019ja2/zM3ROLKZSTJQk7UjZPngADU2pEsfBOiV1f4Asg1DV4OYOXS
         i+1bXv6ATznzq98tsyvYUkbTwuwoOXgPhZ7wTy7dJB6Y0xooK/BasB5zHuQ4pvw9gE
         G/DPUiEF5BkFv+nZJ/Wuk+rtw6pkpA7GpqYIRdU9kMbeV2HQ4qUJh/I71qfQvbo2v/
         UQz0xGKeqhu6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8915E21EEE;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-07 (igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843402074.26917.7713139834780812268.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:40:20 +0000
References: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        sasha.neftin@intel.com, muhammad.husaini.zulkifli@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  7 Mar 2023 14:13:29 -0800 you wrote:
> This series contains updates to igc driver only.
> 
> Muhammad adds tracking and reporting of QBV config errors.
> 
> Tan Tee adds support for configuring max SDU for each Tx queue.
> 
> Sasha removes check for alternate media as only one media type is
> supported.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] igc: Add qbv_config_change_errors counter
    https://git.kernel.org/netdev/net-next/c/ae4fe4698300
  - [net-next,v2,2/3] igc: offload queue max SDU from tc-taprio
    https://git.kernel.org/netdev/net-next/c/92a0dcb8427d
  - [net-next,v2,3/3] igc: Clean up and optimize watchdog task
    https://git.kernel.org/netdev/net-next/c/6cc1b2fd736d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


