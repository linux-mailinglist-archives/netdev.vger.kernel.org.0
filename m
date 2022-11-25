Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94306387D8
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiKYKu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiKYKuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D74F48420
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DACEB82A71
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B6BEC43141;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669373419;
        bh=U6AyUmVoeYNNiaTnU2aERA0bBIEnpVAth58ZLmOBki8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OLVJnl/nQx88vKVu+SXkqdzMulUKFUHBsJsaezgnDA+2cB/UmBI9Cc+NLeyoWa/JL
         ASMgMXQHjtHzgH1NaEqM675U0oTtU1SVzMq9ofYukusucqNMF4y/M57ETnjLEgNTUb
         juDQPOmewWxUk50RhF923BCN0HIig8er/D6uacHvt0BMHAtIOqovM1z/UFTclcvMAt
         /7nIoPEsz0tP1w51nYJbEjP/zYw+ZwylcwPpzsTSv92L0zBIQGIqdP4ta2vm6jnrTs
         NXI0db7iOBFgS2uCB65EGlnaQh+htGfim+R5rBBkzXCecYXxq/+6CjpsKWGSIttolT
         jcxIREZ0PotWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 554A0C395EC;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/6][pull request] Intel Wired LAN Driver Updates
 2022-11-23 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166937341934.11224.15143890744036849457.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 10:50:19 +0000
References: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 23 Nov 2022 15:06:15 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Karol adjusts check of PTP hardware to wait longer but check more often.
> 
> Brett removes use of driver defined link speed; instead using the values
> from ethtool.h, utilizing static tables for indexing.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] ice: Check for PTP HW lock more frequently
    https://git.kernel.org/netdev/net-next/c/a711a3288cc6
  - [net-next,v3,2/6] ice: Remove and replace ice speed defines with ethtool.h versions
    https://git.kernel.org/netdev/net-next/c/1d0e28a9be1f
  - [net-next,v3,3/6] ice: Accumulate HW and Netdev statistics over reset
    https://git.kernel.org/netdev/net-next/c/2fd5e433cd26
  - [net-next,v3,4/6] ice: Accumulate ring statistics over reset
    https://git.kernel.org/netdev/net-next/c/288ecf491b16
  - [net-next,v3,5/6] ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced queues
    https://git.kernel.org/netdev/net-next/c/c7cb9dfc57a2
  - [net-next,v3,6/6] ice: Use ICE_RLAN_BASE_S instead of magic number
    https://git.kernel.org/netdev/net-next/c/60aeca6dc474

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


