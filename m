Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5657FFB3
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiGYNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiGYNUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1082BA5
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12271B80EC9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8372C341C8;
        Mon, 25 Jul 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658755213;
        bh=2XL6W+0GjXNaBmL6Lak3nNcYPKDlLPGCQB5DrniDDCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fJPVYbCDcNXBCr3Np0xsWqGo6bO3Zv7LW/Cz/+DijqABmtBkHTmS85UJeFVTKDjiK
         XoUmGtwzjwJbev3ZzH3eC24j7DBZzo9Do4P98sUCob79wg9JZm3wi2bw9fEtLcJ7Iu
         827huJGaGM0MlFiEWLcoNxVEmMRacgK/uSrsRHh829eEMgScE8T7PQgRp6td3PH+4H
         D2rRvOpq25pR0GEv4crt80ES/CwmTecEHS0n/7ailnQu+0h0o5B4WkbEZQ2Lt4dd5R
         Shz4r/jPXYOJRhQOIqr17BNq8LxJs8+pWUvC86Bs1lDwrRXUQ4r80d4YeRxkjh2kHN
         Q6k6lOrmyrOew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DD62E450B3;
        Mon, 25 Jul 2022 13:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-07-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165875521357.10499.3341972627265684776.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 13:20:13 +0000
References: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
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

On Fri, 22 Jul 2022 10:53:11 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Przemyslaw adds a helper function for determining whether TC MQPRIO is
> enabled for i40e.
> 
> Avinash utilizes the driver's bookkeeping of filters to check for
> duplicate filter before sending the request to the PF for iavf.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] i40e: Refactor tc mqprio checks
    https://git.kernel.org/netdev/net-next/c/2313e69c84c0
  - [net-next,2/2] iavf: Check for duplicate TC flower filter before parsing
    https://git.kernel.org/netdev/net-next/c/40e589ba133c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


