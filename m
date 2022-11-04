Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DB618FB9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiKDFAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKDFA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299E165BA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 22:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA75B6202D
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BB8BC43150;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=vut8U3mbOQUh8I5EUdhyCpgdugXnN6I63nUMRZwQzSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPCw4fxXUpzc0I1Wg9iKjbfS48d3Y+ZOhmQQDP9jInHnRHju8WRavl/z/X0/sRqxV
         aChWj8ta6hKh1CofjDSXppSkcA36kKhHKBRqv+5nZKWCjyMtuNboshIEVoYaRoGf9c
         Dv2HLosR4mCAcIo6vMN55dyK9p7DFpLg/jCXWVdc1q7w2G9s8kI6KsJez7c5x1420p
         EtPpUh/3FDSOIvM31Q3tNEhBj1VxdJPQWOntHFJnrZ03oXqsC5vCiqs3nSVCzEqu/d
         xIlY6StiKzvkEU01BjOy45A/Pa5PrimCAbWCOs1jBACtp4juKZoRgPFTAoYkioIwNs
         g/Z5RQyU84/9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDA56E270E2;
        Fri,  4 Nov 2022 05:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] Intel Wired LAN Driver Updates
 2022-11-02 (i40e, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802690.27738.1583721793443380430.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:26 +0000
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Nov 2022 14:10:04 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Joe Damato adds tracepoint information to i40e_napi_poll to expose helpful
> debug information for users who'd like to get a better understanding of
> how their NIC is performing as they adjust various parameters and tuning
> knobs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] i40e: Store the irq number in i40e_q_vector
    https://git.kernel.org/netdev/net-next/c/6b85a4f39ff7
  - [net-next,2/7] i40e: Record number TXes cleaned during NAPI
    https://git.kernel.org/netdev/net-next/c/8c1a595cc63e
  - [net-next,3/7] i40e: Record number of RXes cleaned during NAPI
    https://git.kernel.org/netdev/net-next/c/717b5bc43c1f
  - [net-next,4/7] i40e: Add i40e_napi_poll tracepoint
    https://git.kernel.org/netdev/net-next/c/6d4d584a7ea8
  - [net-next,5/7] i40e: Add appropriate error message logged for incorrect duplex setting
    https://git.kernel.org/netdev/net-next/c/30872d834bdb
  - [net-next,6/7] iavf: Replace __FUNCTION__ with __func__
    https://git.kernel.org/netdev/net-next/c/619058eca509
  - [net-next,7/7] iavf: Change information about device removal in dmesg
    https://git.kernel.org/netdev/net-next/c/69b957440a63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


