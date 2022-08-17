Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FC0596C0D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiHQJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiHQJaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175635FAE0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB4D7B81CC0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6661CC433D7;
        Wed, 17 Aug 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660728615;
        bh=xLrSlMrSWlJBz7/C3j2ItYlfd+yRE3DvDHSUzNNkxGU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U/sAclsXvINtp++9iPyXB4dlVGmf763X/e+KPJ2OpYfyuBBlfG2HrAzRvgiVCdGwc
         fCOHX6sPAtKyS+YKRubUKsUoWksPJc2JwkIKVNeNlo9E0rN2PIDKWfMpr/dgX6eNxt
         JOLW2/q2k5aD31KLB/3+cAGBDWjQ4Pa3E5Fbx6I5PyEnpqhJ2hFRtMxD/8vmnfz2MQ
         L3MP9TtLRAc3+pf/WpFTN7SpyPF4ryyi7PZbMrKE+pmnnuqVtONpJQ8GXXDamsBatN
         feyB7WGLaTRLKtnEtRdwvTAPWAX8kh7M0CL9ofmluW9D9cB3cl9H8nmBuKLJc2l5+7
         2wXr1+GEYP+6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 493FAE2A04C;
        Wed, 17 Aug 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-08-16 (i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166072861529.2597.5541850038473855008.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 09:30:15 +0000
References: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220816182751.2534028-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 16 Aug 2022 11:27:49 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Przemyslaw fixes issue with checksum offload on VXLAN tunnels.
> 
> Alan disables VSI for Tx timeout when all recovery methods have failed.
> 
> The following are changes since commit ae806c7805571a9813e41bf6763dd08d0706f4ed:
>   Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] i40e: Fix tunnel checksum offload with fragmented traffic
    https://git.kernel.org/netdev/net/c/2c6482091f01
  - [net,2/2] i40e: Fix to stop tx_timeout recovery if GLOBR fails
    https://git.kernel.org/netdev/net/c/57c942bc3bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


