Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C556CBE18
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjC1Luk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjC1Lui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:50:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57249010;
        Tue, 28 Mar 2023 04:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A732B81C1E;
        Tue, 28 Mar 2023 11:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F4064C433D2;
        Tue, 28 Mar 2023 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680004218;
        bh=5gLAAzggvqc3Cky3TNGia+APndyQKbvhduMYxrInOh0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NMtNWvtZwsJJCJb+S1KM5f3zMJDdcVe4H0NVV4Xk2h+gmzTyTOk97G8pEUTkCU+Tz
         HiUjoSuSRValV/b2pHVBDR+4v+lE1LlnQUy8SH+opJ572VV47aVXNFoU7iitEPGf4g
         F8td4QlbC7KumdkzIn2Kzr4IKRjNCUGbRbR4R19XXDKG0Id707m0xxSN+HXG/MRev+
         LzlcAWeHi/GIe+MqEFiWwfA833keOLvrjYHFwhEYboxUKLJKhiW9uQZlzN5+dFulY5
         FDw4QoSu5EKNybGl/Uz7SzcDyu30hEIOPvWDrMwfe5gzeMJ4xXUOdtKgHT8K0PGEDq
         fWgdBLRZK66+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2252E21EE2;
        Tue, 28 Mar 2023 11:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] smsc911x: avoid PHY being resumed when interface is
 not up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168000421785.22915.2029328516158962114.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 11:50:17 +0000
References: <20230327083138.6044-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230327083138.6044-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hkallweit1@gmail.com, simon.horman@corigine.com,
        steve.glendinning@shawell.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Mar 2023 10:31:38 +0200 you wrote:
> SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
> 'mac_managed_pm'. However, setting it needs to be moved from init to
> probe, so mdiobus PM functions will really never be called (e.g. when
> the interface is not up yet during suspend/resume).
> 
> Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net,v4] smsc911x: avoid PHY being resumed when interface is not up
    https://git.kernel.org/netdev/net/c/f22c993f31fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


