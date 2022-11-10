Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF90623A08
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiKJCuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiKJCuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B422EF48;
        Wed,  9 Nov 2022 18:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D951761D4C;
        Thu, 10 Nov 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F187C433D7;
        Thu, 10 Nov 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668048614;
        bh=ahZ3E/50V7Zw58bHNzS10THCBASQ+JFWuXNa3ZbHRiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KNg8mpGgIUrSKPH5DN4hvfcxCO7a4wvx5cJ8tdQSJ8mk2i9KYduEkI/LhBuBupTwT
         YWaX5w+Yh02xDRph2bc50RN5HfCN10ElRJysUvRImGNGx0IctaI28MgTD+HBFC1s1q
         5TSd+GmoH6sPLTqVlTmd7v5POVzyXLFCBKJACoY03dhZoFBcquqUqdBMbMNkhhBIk0
         MBgzXJMRq9vvPAFPPOcyYrNx5LYlmiSKJCdDieYyU3Q5ByQgnZCk35A0V0+sa9MdkS
         7OFOEaapq857w/zinZuffsyZ+AeId6C8QO9LvWuTA7A+JRqZpl2ULq51kSGVXn7xMP
         6FqqzOatx7lmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1FC53C395F6;
        Thu, 10 Nov 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] stmmac: intel: Update PCH PTP clock rate from 200MHz
 to 204.8MHz
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166804861412.6959.10905430097116561347.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 02:50:14 +0000
References: <20221108020811.12919-1-yi.fang.gan@intel.com>
In-Reply-To: <20221108020811.12919-1-yi.fang.gan@intel.com>
To:     Gan Yi Fang <yi.fang.gan@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hong.aun.looi@intel.com, weifeng.voon@intel.com,
        pei.lee.ling@intel.com, tee.min.tan@intel.com,
        muhammad.husaini.zulkifli@intel.com, michael.wei.hong.sit@intel.com
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

On Mon,  7 Nov 2022 21:08:11 -0500 you wrote:
> From: "Tan, Tee Min" <tee.min.tan@intel.com>
> 
> Current Intel platform has an output of ~976ms interval
> when probed on 1 Pulse-per-Second(PPS) hardware pin.
> 
> The correct PTP clock frequency for PCH GbE should be 204.8MHz
> instead of 200MHz. PSE GbE PTP clock rate remains at 200MHz.
> 
> [...]

Here is the summary with links:
  - [net,1/1] stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz
    https://git.kernel.org/netdev/net/c/dcea1a8107c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


