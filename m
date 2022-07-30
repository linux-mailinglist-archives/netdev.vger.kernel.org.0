Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA87958589C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbiG3EaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiG3EaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C2183B3
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAC0160A5B
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEAAFC433C1;
        Sat, 30 Jul 2022 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659155417;
        bh=7NOUJneTrLGcbv3CxvXNE7nS64KzfZ/pnfROGSOBvXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hFaQVKPitnoqYijNLJyY8DKctexKmpThmtxx3Xeiu8SNxmnt5H3aaycK65QFUghlg
         rdYRFWp7W7ben/L9apFg7d9rSqGTWd3oxjtce9vCTVHAxDLYpl30eYicDXx9w2ByLw
         T0d+RaBN053f2dIEv79wfqRbbHPcIPyDvgow6zIBtNQDJntHm/9HI9punU9pgcR2uh
         121+Hn2XdgaFN/u2AENn080kWMXWPxUcBuohL8guj/mbuRY8D5UNEFC/NlMrCIcobz
         LNLljgQ2AG7loIWA4C2PH1wqlltEQ/r7FZrlGQxn9t23XMgD9Po73Wo0b4QsnzwNeW
         +K0lmQT1FwLpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7EE0C43140;
        Sat, 30 Jul 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-07-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165915541688.4914.27066815963683746.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 04:30:16 +0000
References: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220728195538.3391360-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 28 Jul 2022 12:55:34 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Michal allows for VF true promiscuous mode to be set for multiple VFs
> and adds clearing of promiscuous filters when VF trust is removed.
> 
> Maciej refactors ice_set_features() to track/check changed features
> instead of constantly checking against netdev features and adds support for
> NETIF_F_LOOPBACK.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ice: Introduce enabling promiscuous mode on multiple VF's
    https://git.kernel.org/netdev/net-next/c/d7393425e7c8
  - [net-next,2/4] ice: Fix promiscuous mode not turning off
    https://git.kernel.org/netdev/net-next/c/a419526de607
  - [net-next,3/4] ice: compress branches in ice_set_features()
    https://git.kernel.org/netdev/net-next/c/c67672fa2695
  - [net-next,4/4] ice: allow toggling loopback mode via ndo_set_features callback
    https://git.kernel.org/netdev/net-next/c/44ece4e1a3ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


