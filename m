Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97825F1881
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiJABu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiJABuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82401BF1C4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 263F9B82AFF
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAD52C433C1;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664589018;
        bh=6HUKw5HLfPZg96dHA6LT8TaNZpcF3vtOAyAEM2gQraY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XRZ+1r2ltU1gCzCCDkXZf3ATkW7iVq18mjSTbEaMG0fhmUC+DoFGw1nlKT3WJXJ4F
         v1HPq2zqNT0/b92FY35s/J2rj6jhOi2kLDraZQyOLvjE8tWcmqKx1Osq/Ea/Lha4Iv
         GTd7q0aO7QIFui9Eg4VrPBogaGlPkYUXiXv3fXrjV8xJe6vsy2q7BP18/8IR2pds6G
         zQgaEG4cxCWqiwFC1FwWKoas39MMo6uKXRvuKe5Y4bU1QTPDliv7qiSYhDgTYVIsEQ
         4cRo5mloRLiZwc5EtLVcSXQgmG+ooeJjovtKlxtqh0EnlFmOz4pbjtyso6gT1bSvEi
         ftKLCC1V0pXoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA7FCE49FA7;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] r8169: add rtl_disable_rxdvgate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166458901868.12957.10190608408617928573.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 01:50:18 +0000
References: <20220928171356.3951-1-hau@realtek.com>
In-Reply-To: <20220928171356.3951-1-hau@realtek.com>
To:     Chunhao Lin <hau@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 29 Sep 2022 01:13:56 +0800 you wrote:
> rtl_disable_rxdvgate() is used for disable RXDV_GATE. It is opposite function
> of rtl_enable_rxdvgate().
> 
> Disable RXDV_GATE does not have to delay. So in this patch, also remove the
> delay after disale RXDV_GATE.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] r8169: add rtl_disable_rxdvgate()
    https://git.kernel.org/netdev/net-next/c/3406079bbb27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


