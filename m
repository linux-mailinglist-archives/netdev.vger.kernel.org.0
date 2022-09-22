Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A711D5E5772
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIVAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVAkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CA76744F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32EBD63334
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E024C433D7;
        Thu, 22 Sep 2022 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663807215;
        bh=NnMufUJqoZpWykiGjUMdy235zk49t4JUyB/rhmfLIwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L4n/CpRyHrfX7PHFgzRA6eAJ6bw5nqIppqbNw8SkRT0WGuazw5FMbZ5EG77AuBNiR
         5OXb/qHEgs2H/A/pldwPa68hj+lAvVK2FlGN2Tc15WKvmOJ7eigWYtofosWI6R7ROu
         Fla3UnZLZT88CIEC7uPyVpVsf3Er5crCcn+3T9GauKJhfJZL/OMaqdKESdxPRyIXYP
         ox9ZX1wL6wioEfrrjSNwQMF8jzfcWALiULo5hFmG+3cOc/dc3p+pyCeSONtxIEANCy
         WAsWBxATryhF2DbD+/m/om+P0xKRmOGMYIFbtw5KLFjbXEFe8MghzyDIY7xyVBmixt
         M/5Kx1oB0wjJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7837AE4D03D;
        Thu, 22 Sep 2022 00:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-09-19 (iavf, i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166380721548.7808.3107330846620507834.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 00:40:15 +0000
References: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220919223428.572091-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 19 Sep 2022 15:34:24 -0700 you wrote:
> This series contains updates to iavf and i40e drivers.
> 
> Norbert adds checking of buffer size for Rx buffer checks in iavf.
> 
> Michal corrects setting of max MTU in iavf to account for MTU data provided
> by PF, fixes i40e to set VF max MTU, and resolves lack of rate limiting
> when value was less than divisor for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/4] iavf: Fix bad page state
    https://git.kernel.org/netdev/net/c/66039eb9015e
  - [net,2/4] iavf: Fix set max MTU size with port VLAN and jumbo frames
    https://git.kernel.org/netdev/net/c/399c98c4dc50
  - [net,3/4] i40e: Fix VF set max MTU size
    https://git.kernel.org/netdev/net/c/372539def282
  - [net,4/4] i40e: Fix set max_tx_rate when it is lower than 1 Mbps
    https://git.kernel.org/netdev/net/c/198eb7e1b81d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


