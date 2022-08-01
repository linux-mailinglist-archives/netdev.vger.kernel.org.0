Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2958706C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiHASaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiHASaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5B3116A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1214D611FE
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 669E1C43470;
        Mon,  1 Aug 2022 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659378614;
        bh=nyNnj8uAj7+ZCjcAMdmey71DM8WHz44NpwraLOu7GH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pgw+JUbPDoBsvKuZJBM/WqfE6iXQF/5wK+uYFXikICleNdaPRnDWDHP4prB7GQua/
         1VYu687fXSHJ31xz9sHlU3nTFS9I/afW0+lM/PiChknvr1XxITYZcF795FMyDjfopU
         9q5EnPKsEkqyZzWXbstxXLPmDhzhMwaIh/nrbvfUegksFF0x7Ohw4Zq4eKh/iVAAGV
         hDBdu8a3DilUolI2SzzU2aNLGMIZNWUxPYXUSdMUp/ceB+EyRYTNlYqEfrzFkZ4+IA
         kEWrVsLMlg+SpNA84i7zhszx0PQDVN/f0VOSlyGkkj4Fm8Ngz/UvbtxIB87fO3b2E9
         XwGGuJCKpa+gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DC6FC43140;
        Mon,  1 Aug 2022 18:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-07-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165937861431.31008.6507520694277325694.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 18:30:14 +0000
References: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, jacob.e.keller@intel.com
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

On Thu, 28 Jul 2022 11:18:29 -0700 you wrote:
> Jacob Keller says:
> 
> Convert all of the Intel drivers with PTP support to the newer .adjfine
> implementation which uses scaled parts per million.
> 
> This improves the precision of the frequency adjustments by taking advantage
> of the full scaled parts per million input coming from user space.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] ice: implement adjfine with mul_u64_u64_div_u64
    https://git.kernel.org/netdev/net-next/c/4488df140152
  - [net-next,2/7] e1000e: remove unnecessary range check in e1000e_phc_adjfreq
    https://git.kernel.org/netdev/net-next/c/ab8e8db27e82
  - [net-next,3/7] e1000e: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/abab010f1637
  - [net-next,4/7] i40e: use mul_u64_u64_div_u64 for PTP frequency calculation
    https://git.kernel.org/netdev/net-next/c/3626a690b717
  - [net-next,5/7] i40e: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/ccd3bf985921
  - [net-next,6/7] ixgbe: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/5a5542324a4a
  - [net-next,7/7] igb: convert .adjfreq to .adjfine
    https://git.kernel.org/netdev/net-next/c/d8fae2504efe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


