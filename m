Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A4C5631A2
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiGAKkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiGAKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FF57B369
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F6A462469
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BD23C341C6;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656672017;
        bh=kgfR9Jhoy9lYa6/hWVxswfumJZxDUPZuZ1wiuWj4ekE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q7Nf7ycZBjlowb8d07BuYykqOMEccQ2BmP6AS9+kAjggh5/8/caNSSOuFWqRq04J8
         Qs3GhaJB4wBVRfDtBAHrzLO0YfARTAx06QKCKb2WVelIsslW0vS7HSVwN4Rj+h2xuw
         +1spmvjQPcbjvePIJ7fPLfKAl15oLVeBEEEGJ166NqL1Ai3tYpaO2pigBDvwAOln2W
         IF9Vupl32xCxFmh1E9RCPzgVZkkLg9wxB6lEKWr5tEm90lqCF4Yp4d0LI+5xrxcfcz
         bFslqJhaBgQNhozLO+RMIdumsbKRx3dWwg9fNSsiT54Uk+L2i3lpCxtvFq9lWsBFvf
         TaALNnJtZE7cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FF31E49FA0;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-06-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667201738.26485.10758361001030988627.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 10:40:17 +0000
References: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 30 Jun 2022 14:19:55 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Martyna adds support for VLAN related TC switchdev filters and reworks
> dummy packet implementation of VLANs to enable dynamic header insertion to
> allow for more rule types.
> 
> Lu Wei utilizes eth_broadcast_addr() helper over an open coded version.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: Add support for double VLAN in switchdev
    https://git.kernel.org/netdev/net-next/c/06bca7c2685a
  - [net-next,2/5] ice: Add support for VLAN TPID filters in switchdev
    https://git.kernel.org/netdev/net-next/c/ea71b967a507
  - [net-next,3/5] ice: switch: dynamically add VLAN headers to dummy packets
    https://git.kernel.org/netdev/net-next/c/263957263a00
  - [net-next,4/5] ice: use eth_broadcast_addr() to set broadcast address
    https://git.kernel.org/netdev/net-next/c/0ca85829903f
  - [net-next,5/5] ice: Remove unnecessary NULL check before dev_put
    https://git.kernel.org/netdev/net-next/c/afa646299a28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


