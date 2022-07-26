Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64510581B9E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiGZVUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiGZVUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60D9FFE
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 665AE61689
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFEBCC433D6;
        Tue, 26 Jul 2022 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658870415;
        bh=zt/T3qs5o+csndBIOI2a8CpO7cFr2I2QK6Wn05oerU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BHpNKD0xaaXb5mFqd7ij+kHsnTcXWLCQughTH1ybQ9KF4j5AaQnm0LxwLc5VI8Ixj
         Buw69JTHkMinzcFNeYmNV7z9O7qQoLclvlxUqeHkugRPUzv2e1azII+URn1ZE6Olbb
         9tjMSlkTQgUEwdQYzUz+N3xpSCiaVeEHjuWTCpEZ1LZ4hkbPaxGByfnRjqcN9FbIOW
         vLAG0h9Wninb4GC/NYFS2tx7v5ljI4inozl3bcN9Ww8AN6rxLBrcD3N08S01RCzlOH
         3kJNP2QKdxNWk0GtwPmi/Ok8xvO50WEbFHyNymKHKG7trkf1MB5R2qxwMebGCrouX2
         ysC/VRLpTKwpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A45F5C43140;
        Tue, 26 Jul 2022 21:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v4 00/12] Implement dev info and dev flash for line
 cards
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165887041566.30666.3741249109648776384.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 21:20:15 +0000
References: <20220725082925.366455-1-jiri@resnulli.us>
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        snelson@pensando.io
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Jul 2022 10:29:13 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset implements two features:
> 1) "devlink dev info" is exposed for line card (patches 6-9)
> 2) "devlink dev flash" is implemented for line card gearbox
>    flashing (patch 10)
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/12] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
    https://git.kernel.org/netdev/net-next/c/30bab7cdb56d
  - [net-next,v4,02/12] net: devlink: move net check into devlinks_xa_for_each_registered_get()
    https://git.kernel.org/netdev/net-next/c/294c4f57cfe3
  - [net-next,v4,03/12] net: devlink: introduce nested devlink entity for line card
    https://git.kernel.org/netdev/net-next/c/7b2d9a1a50ec
  - [net-next,v4,04/12] mlxsw: core_linecards: Introduce per line card auxiliary device
    https://git.kernel.org/netdev/net-next/c/bd02fd76d190
  - [net-next,v4,05/12] mlxsw: core_linecards: Expose HW revision and INI version
    https://git.kernel.org/netdev/net-next/c/5ba325fec511
  - [net-next,v4,06/12] mlxsw: reg: Extend MDDQ by device_info
    https://git.kernel.org/netdev/net-next/c/4ea07cf638db
  - [net-next,v4,07/12] mlxsw: core_linecards: Probe active line cards for devices and expose FW version
    https://git.kernel.org/netdev/net-next/c/4da0eb2a75eb
  - [net-next,v4,08/12] mlxsw: reg: Add Management DownStream Device Tunneling Register
    https://git.kernel.org/netdev/net-next/c/8f9b0513a950
  - [net-next,v4,09/12] mlxsw: core_linecards: Expose device PSID over device info
    https://git.kernel.org/netdev/net-next/c/3fc0c51905fb
  - [net-next,v4,10/12] mlxsw: core_linecards: Implement line card device flashing
    https://git.kernel.org/netdev/net-next/c/9ca6a7a5f42d
  - [net-next,v4,11/12] selftests: mlxsw: Check line card info on provisioned line card
    https://git.kernel.org/netdev/net-next/c/e96c8da38039
  - [net-next,v4,12/12] selftests: mlxsw: Check line card info on activated line card
    https://git.kernel.org/netdev/net-next/c/949c84f05eb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


