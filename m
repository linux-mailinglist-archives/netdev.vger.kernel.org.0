Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4757359F5D0
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiHXJAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiHXJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107924E84F
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9731B8238F
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78661C433D7;
        Wed, 24 Aug 2022 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661331615;
        bh=/dxcjadzvg/612E+p5FCSwRfuWmFqSNpZyvBlxXafoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lC2M9qfpcN0n/6oCxghnnNnpTjAWwObb63Mk7Ab3W3cQ0876FXFgalUSPzECqQbnG
         yV9CItODBu9jJR2Lipizb7tGeTWBfRktK2caUQTlWxn5a84SUkqmAuvrEW9fRcXxlh
         tWvklCg4YNpOvAG2ox7bZTvlcosJh/4DRw5Ps0L5OklOwtBYDmB1FQOF5cD8Fr2X5G
         csiy3UjcOBnwRHy1e8lkP0gi6iPDDL7xPMIB/+2F8KP1r2HyGBaObXMA+cIL9JDnn9
         beprqGFmyHvH4/luWz+PXBykXJLK4FmP/AnZO1AG9ZRdZtv4+FEm02mu6XS61mO0Sy
         jmtHtDk/TBArQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54F5AC0C3EC;
        Wed, 24 Aug 2022 09:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 resubmit] fec: Restart PPS after link state change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166133161533.23661.112567039539561723.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 09:00:15 +0000
References: <20220822081051.7873-1-csokas.bence@prolan.hu>
In-Reply-To: <20220822081051.7873-1-csokas.bence@prolan.hu>
To:     =?utf-8?b?Q3PDs2vDoXMgQmVuY2UgPGNzb2thcy5iZW5jZUBwcm9sYW4uaHU+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org, qiangqing.zhang@nxp.com,
        andrew@lunn.ch
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Aug 2022 10:10:52 +0200 you wrote:
> On link state change, the controller gets reset,
> causing PPS to drop out and the PHC to lose its
> time and calibration. So we restart it if needed,
> restoring calibration and time registers.
> 
> Changes since v2:
> * Add `fec_ptp_save_state()`/`fec_ptp_restore_state()`
> * Use `ktime_get_real_ns()`
> * Use `BIT()` macro
> Changes since v1:
> * More ECR #define's
> * Stop PPS in `fec_ptp_stop()`
> 
> [...]

Here is the summary with links:
  - [v3,resubmit] fec: Restart PPS after link state change
    https://git.kernel.org/netdev/net/c/f79959220fa5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


