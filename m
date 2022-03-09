Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE44D2D67
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiCIKvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiCIKvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:51:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606A3F94C2
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF517B82030
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1381C36AE5;
        Wed,  9 Mar 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646823012;
        bh=6C1+KbDD5LJ7rKRGLaCHAC9xWtilzBnVhT3FYZFbdK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pawh8dP55eeY42ISWGsuZTL2lwTr0A4axZ293WhrCbVt7MpM0NYu/VEfgaplSvdhN
         Rda1EY5e8BDfrS34FlzNHWuW/ckUAoDzN+U5mkxxx7uKSaNR30mcSJ6P0Ftr55weiY
         UgRXQOOIsOKQX28JV7P3+lPZeDmRG2/Ht7MJJgKohehNmZ1rGrbISIF/r1k1JYV9iK
         BSl7RIpb9l9KeJaH5Tlo7jRYh2Yi0R87xJ5yhu+3X9EX1vbtNB87FkFykNG5+XqvVT
         kFDN9lHO+lDKcQngPSWMc0CkD4c1c+5jYx8YmtvWXcE3loqyDqwpiGzNklG+C9impE
         mxv6D/cJozc4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F3DFE8DD5B;
        Wed,  9 Mar 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-03-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682301251.2489.7111767342192292406.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 10:50:12 +0000
References: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  8 Mar 2022 09:11:52 -0800 you wrote:
> This series contains updates to ixgbe and ixgbevf drivers.
> 
> Slawomir adds an implementation for ndo_set_vf_link_state() to allow
> for disabling of VF link state as well a mailbox implementation so
> the VF can query the state. Additionally, for 82599, the option to
> disable a VF after receiving several malicious driver detection (MDD)
> events are encountered is added. For ixgbevf, the corresponding
> implementation to query and report a disabled state is added.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ixgbe: add the ability for the PF to disable VF link state
    https://git.kernel.org/netdev/net-next/c/366fd1000995
  - [net-next,2/3] ixgbe: add improvement for MDD response functionality
    https://git.kernel.org/netdev/net-next/c/008ca35f6e87
  - [net-next,3/3] ixgbevf: add disable link state
    https://git.kernel.org/netdev/net-next/c/443ebdd68b44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


