Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F494DD179
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiCQXvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiCQXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164FD2AD5CC
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 16:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B55D611BD
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 23:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA262C340F2;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561012;
        bh=H5XQHHGoDpsBed6ycSnty+J5zAIx8GGCszT2CVP5ltE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AnhIGDJPXQ+3Ja3no2U0ew/EBcTAKRViXXFQ9+8mREsFL1BBWLZ5EpC99SM+RN94g
         hOoQ/VxMsWQ9sd2JQwXmHhaK7qTmiM6Z8q+DjeTXJ8CZ+L+e/hrdl5B8zrG4SNRjgL
         uxDdRe7s8wBn/4NLvNWB4n6+jHwLBu4T+X57xaDoY9IIqF7DGtNmybsoCPD01iXhBN
         0MpPrN7QN4QMi3fetrcKfHZwPKkdSwn9BwbXsiMaWG48wOyKhscMUf1oJPELzuyGnD
         V2tIwQIQGVNg/8kF83s0QoL3vMFH52pb9FnOdb0hoCeJPxWDJ5bKGLX/8Nz31/CDBn
         z0BAe/tSqtI1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEEE7F0383F;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] 100GbE Intel Wired LAN Driver
 Updates 2022-03-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101277.14093.3397984917093483333.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, wojciech.drewek@intel.com,
        pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 13:40:20 -0700 you wrote:
> This series contains updates to gtp and ice driver.
> 
> Wojciech fixes smatch reported inconsistent indenting for gtp and ice.
> 
> Yang Yingliang fixes a couple of return value checks for GNSS to IS_PTR
> instead of null.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] gtp: Fix inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/02f393381d14
  - [net-next,2/4] ice: Fix inconsistent indenting in ice_switch
    https://git.kernel.org/netdev/net-next/c/2bcd5b9f357d
  - [net-next,3/4] ice: fix return value check in ice_gnss.c
    https://git.kernel.org/netdev/net-next/c/2b1d0a242a00
  - [net-next,4/4] ice: add trace events for tx timestamps
    https://git.kernel.org/netdev/net-next/c/4c1202189e35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


