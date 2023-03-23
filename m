Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2236E6C5F29
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjCWFuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCWFuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A2A234D1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B742B81F63
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC6DEC4339C;
        Thu, 23 Mar 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550618;
        bh=8gbOZ1kc0sVnN4jq703SVoqug0TzjSl8PO/GqxPtJX0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ff9/gw7cdQJmEDRn8FO5oWX4XT/aWG7ZrDgne6jU7umi+otSJxTSzW61y7B4cmKG9
         uZrDUUSvLZa/0UOkulwhbIUsQwvPe4YHMFe0JO7ewtdZwz0zThXrGoLMGyZhi2B/Ry
         nKGMYDyKaLaT77QuI5AkJXxg/6TEQJ6FnEFFS1q7nDjo7eFVAWJpkJWnJpzxdGTYvd
         cgNr+rqwJ1ZoFB3NjeLXoNn5wiBom9INQdSO3crsbEgayBz27Tiv54KBjAdaFDLGFE
         AVYBnawHQ4cXeaLd5rzR70RgJJqyL0AxmkNLC2oVO0ZBVzNGVEV843m/iXKf4yHE/b
         /a6Xnd9bC5Pug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A942CE4F0D7;
        Thu, 23 Mar 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-21 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955061868.14332.2482366315808559060.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:18 +0000
References: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Mar 2023 11:36:38 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Piotr sets first_desc field for proper handling of Flow Director
> packets.
> 
> Michal moves error checking for VF earlier in function to properly return
> error before other checks/reporting; he also corrects VSI filter removal to
> be done during VSI removal and not rebuild.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ice: fix rx buffers handling for flow director packets
    https://git.kernel.org/netdev/net/c/387d42ae6df7
  - [net,2/3] ice: check if VF exists before mode check
    https://git.kernel.org/netdev/net/c/83b49e7f63da
  - [net,3/3] ice: remove filters only if VSI is deleted
    https://git.kernel.org/netdev/net/c/7d46c0e670d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


