Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0CB4C86A9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiCAIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiCAIky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:40:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA1347AF5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 00:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17297B817CF
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D13CC340F1;
        Tue,  1 Mar 2022 08:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646124010;
        bh=Znu5r13RYdxEzH9Rpzy4ToJZ2sBa4xYvUd1PnNLeI44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uHS1uR0tqvcAAIog/8pBghRP2AqPRxzBd2OLYcaP+8Tal+l1fEbsHJz5JawtHkhVF
         Z5y620InL3DfrEUOQ6slmBO1+EVhcarjwPXDPTC1rLRArx7CNkWJHolklRPZAx93n/
         K8FWIzoqh2GzyYVlypLIkiUF/RG60i2Y6eDmGsIb1J84ujd0Mkuf+/gHg4gU+tMQOX
         JufprgiQbKLRWyGeCeTJW8GzQoYQFaLopsTFvbqFvU/zyTt6N8h/3Wpq9dwURV/ghv
         f8HcLsJqoWBEXxHcjEHeyLRFtEia6vTO1flEnrwH+DiI1EZLUPYUe/oblIrFRgD2jh
         uGQTT1xhx/UdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8393CEAC096;
        Tue,  1 Mar 2022 08:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates
 2022-02-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164612401053.5459.11064965315115856891.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Mar 2022 08:40:10 +0000
References: <20220228220412.2129191-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220228220412.2129191-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 28 Feb 2022 14:04:08 -0800 you wrote:
> This series contains updates to igc and e1000e drivers.
> 
> Corinna Vinschen ensures release of hardware sempahore on failed
> register read in igc_read_phy_reg_gpy().
> 
> Sasha does the same for the write variant, igc_write_phy_reg_gpy(). On
> e1000e, he resolves an issue with hardware unit hang on s0ix exit
> by disabling some bits and LAN connected device reset during power
> management flows. Lastly, he allows for TGP platforms to correct its
> NVM checksum.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] igc: igc_read_phy_reg_gpy: drop premature return
    https://git.kernel.org/netdev/net/c/fda2635466cd
  - [net,v2,2/4] igc: igc_write_phy_reg_gpy: drop premature return
    https://git.kernel.org/netdev/net/c/c4208653a327
  - [net,v2,3/4] e1000e: Fix possible HW unit hang after an s0ix exit
    https://git.kernel.org/netdev/net/c/1866aa0d0d64
  - [net,v2,4/4] e1000e: Correct NVM checksum verification flow
    https://git.kernel.org/netdev/net/c/ffd24fa2fcc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


