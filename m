Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69054596C11
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiHQJa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiHQJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFDC58DC8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F24DCB81CB3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0BFCC433C1;
        Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660728616;
        bh=HK8t3EAQOytT3vZwJUgrJ/p7lwzcMKS+Y3gGfVwnTyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E+Vb6SS1McvLYWcJusVws045JHPyzJCG4bFRyh5a0nr8zOiI5l9R32Q7hHCLHHjbF
         28lVmLJ7IaB/pBwd3xzEnFXDb2L/tMTPIhG07f9253WA+UpZ/chF+gv8hviT3igsRt
         O0MVGZ9hJpNjQCBlIbdIgHXn/AwB8nKlGP6fD43EPl6GNUOmiMbPXisH2Yuj4sdXGR
         GQAM33UnKFpEgVy++gNVe+jLWqx1h1z0PtfxASRHPchojR9cjWyD7Xz3MlnXBTy48H
         GUinUOig6lRSLYpPaZFhnxq6CAdaNbSStiQZa2pChIlfOhsWYSkHhXinuMAAD8ulRE
         BkOJgqSvKlDMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E631E2A04C;
        Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] ice: detect and report PTP
 timestamp issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166072861664.2597.13721922163698505871.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 09:30:16 +0000
References: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 16 Aug 2022 10:23:46 -0700 you wrote:
> Jacob Keller says:
> 
> This series fixes a few small issues with the cached PTP Hardware Clock
> timestamp used for timestamp extension. It also introduces extra checks to
> help detect issues with this logic, such as if the cached timestamp is not
> updated within the 2 second window.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ice: set tx_tstamps when creating new Tx rings via ethtool
    https://git.kernel.org/netdev/net-next/c/b3b173745c8c
  - [net-next,2/6] ice: initialize cached_phctime when creating Rx rings
    https://git.kernel.org/netdev/net-next/c/cf6b82fd3fbc
  - [net-next,3/6] ice: track Tx timestamp stats similar to other Intel drivers
    https://git.kernel.org/netdev/net-next/c/f020481be540
  - [net-next,4/6] ice: track and warn when PHC update is late
    https://git.kernel.org/netdev/net-next/c/cd25507a31e1
  - [net-next,5/6] ice: re-arrange some static functions in ice_ptp.c
    https://git.kernel.org/netdev/net-next/c/4b1251bdd188
  - [net-next,6/6] ice: introduce ice_ptp_reset_cached_phctime function
    https://git.kernel.org/netdev/net-next/c/b1a582e64bf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


