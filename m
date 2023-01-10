Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07287663EDE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjAJLCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238637AbjAJLAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:00:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B352010
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D756C615D2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DC92C433F0;
        Tue, 10 Jan 2023 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673348416;
        bh=7bIBNidZuV77f3/t0t48Xtu5pYR5aRUKMJdbUS1m5kM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yhxs015ux3292fQG0vdxkZec2dbD8Q0xsQPeYUazuWuUoKRl8BAcm/EEGE32CndUr
         ZSUD5CczaH3WmsWtvedYjCC8k0F3nD5YKvNU80zCOvHGlVpiw25HBA2AdbI2qw+NhL
         ARZXcUR1dq+e8nlsbXtyagxlzW4Z9c91nR7RHURjcleCbEM4hDHJTPVCj4K/rRx4L2
         jwspvjitvDFkNgQgLrK7Vs8N1XtUev2nCMXMYXECryVxVp027ZKeywYJuMelW5SDfU
         b6TSmFc1Yi/SsrKsMqsBWNiIdaf86SEhcffNr8gOtEj1boKLuduqLVxjSTPzNCrI7l
         qfpkWFF1EUuTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23D69E21EEA;
        Tue, 10 Jan 2023 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] amd-xgbe: Add support for 10 Mbps speed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167334841614.12595.5065567272812979396.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 11:00:16 +0000
References: <20230109101819.747572-1-Raju.Rangoju@amd.com>
In-Reply-To: <20230109101819.747572-1-Raju.Rangoju@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, thomas.lendacky@amd.com,
        Shyam-sundar.S-k@amd.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 9 Jan 2023 15:48:19 +0530 you wrote:
> Add the necessary changes to support 10 Mbps speed for BaseT and SFP
> port modes. This is supported in MAC ver >= 30H.
> 
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-dev.c    |   3 +
>  drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  24 +++++
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 107 ++++++++++++++++++--
>  drivers/net/ethernet/amd/xgbe/xgbe.h        |   2 +
>  4 files changed, 126 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] amd-xgbe: Add support for 10 Mbps speed
    https://git.kernel.org/netdev/net-next/c/07445f3c7ca1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


