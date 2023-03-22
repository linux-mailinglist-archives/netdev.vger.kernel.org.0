Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3646C4A8A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCVMac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjCVMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C28532BC;
        Wed, 22 Mar 2023 05:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D368C62084;
        Wed, 22 Mar 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28C7AC4339C;
        Wed, 22 Mar 2023 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679488219;
        bh=TDHq3cL0tnq/ChUUIXoye4vsdq/UVoKm4rtu4+CyqIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MZQHuIj/PB7DeqTXC2U/FLn2UvmGiK/t2Fv1L77qJruBW7p254Dk2ZKOeViluM0rI
         phhrzGLS2BPXH2Wo15TKMfhYC4CEZGqpq+9MjDRhmCLCc3O05dxAkZJlfkkyRnQeuj
         PX3+C8WMtV3l/fywxGfwe/R0sTs5lPMyO7Ws+uweKop20Ujjo5M5wpWjt5PtvWxx6E
         oSwgSYV4r7FdmmO7kmeu/hPYcVRTWmXO0CJ2vz07ZjET8+8GB95B/hBT/IXTlqUVjP
         vfN3wk0N0YZqP7ejBzZHpnlbV7Hcyb6GfcNnTz7X6WVdXm52MpfCR3763FrIwn+WaP
         gcPHdbshPBQ3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D254E4F0DA;
        Wed, 22 Mar 2023 12:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: adjust estf following
 ptp changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167948821905.6670.11403271818303294452.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 12:30:19 +0000
References: <20230321062600.2539544-1-s-vadapalli@ti.com>
In-Reply-To: <20230321062600.2539544-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, jacob.e.keller@intel.com,
        richardcochran@gmail.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Mar 2023 11:56:00 +0530 you wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> When the CPTS clock is synced/adjusted by running linuxptp (ptp4l/phc2sys),
> it will cause the TSN EST schedule to drift away over time. This is because
> the schedule is driven by the EstF periodic counter whose pulse length is
> defined in ref_clk cycles and it does not automatically sync to CPTS clock.
>    _______
>  _|
>   ^
>   expected cycle start time boundary
>    _______________
>  _|_|___|_|
>   ^
>   EstF drifted away -> direction
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpts: adjust estf following ptp changes
    https://git.kernel.org/netdev/net-next/c/7849c42da2ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


