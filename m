Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEBA68E6FD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBHEU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHEUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744C27D59
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 20:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54428B81BE8
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB149C4339C;
        Wed,  8 Feb 2023 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675830020;
        bh=L4uGifL4GY/4iPvwHzd0TBRJLO9Ynt4tgZjSxhtAh04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HHWeB+3F5GeJUSyi+Xwu+68q1OoMJtF32PZHT2rSqZPvQvfzBpIwOZSizU1CNYObB
         Nj9Zm8qTyDCwdFru79LO6iylEA6c7h5SBSs6HBUtHk1Cr7rK2INn7Kc6dfPMDfaOiA
         iscaks720DurqHqG0BtC1elWHpOi3Us7GuYDeMeM7qx7Lh2/pB6n1U20S14vVOCU7M
         4/cRZRKVsu53By3NoDSopJTfI8W8agTI2/sKp11gt6GERs0KoJZAQEDZe4PNSEinnX
         820XZCeCZJo0E8CRPQHfGLkUmDxwdrqhTVP7sA4VL7O3Jeli3AlRJfoxrZNt7mJG4p
         3WMD/QoVBDQNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD956E524E8;
        Wed,  8 Feb 2023 04:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/2] net: enetc: add support for MAC Merge layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583001983.19489.16765141004898338254.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 04:20:19 +0000
References: <20230206094531.444988-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230206094531.444988-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Feb 2023 11:45:30 +0200 you wrote:
> Add PF driver support for viewing and changing the MAC Merge sublayer
> parameters, and seeing the verification state machine's current state.
> The verification handshake with the link partner is driven by hardware.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2:
> - remove stray enetc_reset_ptcfpr() and enetc_set_ptcfpr() definitions
> - move MM stats counter definitions to the other patch
> - set state->verify_enabled in enetc_get_mm()
> - add comment near ENETC_MMCSR_LPE in enetc_get_mm()
> - add comment as to what mm_lock does
> - add comment about enabling MAC Merge right away
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: enetc: add support for MAC Merge layer
    https://git.kernel.org/netdev/net-next/c/c7b9e8086902
  - [v2,net-next,2/2] net: enetc: add support for MAC Merge statistics counters
    https://git.kernel.org/netdev/net-next/c/cf52bd238b75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


