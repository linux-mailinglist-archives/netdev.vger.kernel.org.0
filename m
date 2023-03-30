Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD496CFA61
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjC3Eu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjC3EuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8F630F2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C257B825D0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC427C4339C;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151819;
        bh=5CaZea8hgTBfs9DZK0iGAwohAIASgD98oIrRdwK0Drw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GyOXdLEQhbkhoXdiY2IY2P845ie526Fem9mw/yCAMFuAhs7FBbstCwMoeDPCFlH+U
         z8AS6hH3ivcwMy5fv3upoKelw6/si8UuUNNeodsAIvVZ8B3BmQQH1mp33X/KFvVsHF
         5GtOJOmLWJgoGEhgGlJJ8e3dXAigDN5wm5IqbmACCMM0qMSBkYJhcb0yuLIDhueS2J
         QQLw9zoPD0U5j39ANVhabGo0dvHAWs9dTOivA5d/PTbWSz43yoOcwG7xnOttxoirfB
         8zthUvRE16u+N+s9dDw5R9GovZs2d5CVATpl0Xv5NF449VLmDKfVdG1HsC4bxeilsy
         7Cqy4bGl9Z4KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C16F3E49FA8;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] i40e: fix registers dump after run ethtool adapter
 self test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015181978.11752.2408900189768204879.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:50:19 +0000
References: <20230328172659.3906413-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230328172659.3906413-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        radoslawx.tyl@intel.com, michal.swiatkowski@linux.intel.com,
        arpanax.arland@intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 10:26:59 -0700 you wrote:
> From: Radoslaw Tyl <radoslawx.tyl@intel.com>
> 
> Fix invalid registers dump from ethtool -d ethX after adapter self test
> by ethtool -t ethY. It causes invalid data display.
> 
> The problem was caused by overwriting i40e_reg_list[].elements
> which is common for ethtool self test and dump.
> 
> [...]

Here is the summary with links:
  - [net,1/1] i40e: fix registers dump after run ethtool adapter self test
    https://git.kernel.org/netdev/net/c/c5cff16f461a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


