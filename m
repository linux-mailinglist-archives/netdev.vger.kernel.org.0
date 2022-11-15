Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D435629C44
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiKOOkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiKOOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A91FCDC;
        Tue, 15 Nov 2022 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7334EB8197B;
        Tue, 15 Nov 2022 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12A50C43150;
        Tue, 15 Nov 2022 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668523216;
        bh=Pqc6uaV5UWP/0g+cmhgfjSzu3puuY4a80Luj2vKLneM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRUqi9EmnV+pN1v6hLE1Nr81JgrJnyFm8zro0gTXipRyjLLgseU9rb9lMSSHHP2qZ
         QjAYrTpVk3piEM3vGTSDpm/tSvYhi+KDz3YB4inj9UDrNgJvbaqe1A+OgRIJs9u/46
         J4z1r1SPzd0xM/Za9BAp7R4EEw3l8NOQRknWwSfLGjnX9MFQ3UIbeqWopwjNZdiV3n
         rf8MYcYMLMcPecQecvdb4j5unCBHUU4HAxZVRvLFP2TjtW9T/xl0zuWW8es52Zf+3M
         zdZeXLo/O/MShrSkzMzbb/8asanLAx5AnUkVeHlh43oKGAlzXOxprDjsboE0Fwbm+2
         lioAfkNmN1qUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF49DC395F5;
        Tue, 15 Nov 2022 14:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] net: dcb: move getapptrust to separate
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166852321597.8656.17243417227147432834.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 14:40:15 +0000
References: <20221114092950.2490451-1-daniel.machon@microchip.com>
In-Reply-To: <20221114092950.2490451-1-daniel.machon@microchip.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joe@perches.com,
        vladimir.oltean@nxp.com, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        lkp@intel.com
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

On Mon, 14 Nov 2022 10:29:50 +0100 you wrote:
> This patch fixes a frame size warning, reported by kernel test robot.
> 
> >> net/dcb/dcbnl.c:1230:1: warning: the frame size of 1244 bytes is
> >> larger than 1024 bytes [-Wframe-larger-than=]
> 
> The getapptrust part of dcbnl_ieee_fill is moved to a separate function,
> and the selector array is now dynamically allocated, instead of stack
> allocated.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: dcb: move getapptrust to separate function
    https://git.kernel.org/netdev/net-next/c/7eba4505394e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


