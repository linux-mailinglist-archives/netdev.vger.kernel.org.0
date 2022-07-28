Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4420583C30
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiG1KkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiG1KkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C833BCBA
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B70F5B823DC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 486AEC433D7;
        Thu, 28 Jul 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659004813;
        bh=RSBSvtHPMhjyzJL02un+VukZ/n/zfa5MKbFzLkrKbNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STXR23poOlRMh4IP2CF/HTj4OWp2I1yTt8xAOGv8GAZKjuFX1sIszK66NhnFodT/r
         EdyioXhsvCZXJR54ScEcjUKj5JdIFTwE+9SI8U/JEn3pt1cBsKzOfUA7dGuOpfymE7
         0WcM5dAWy0JkOy56VAt3e86Tw05MProQWxdFSQLMin9tWZcNl4id0KrXg6IrPbaRSL
         azVqO+cxz766ZI3ZBhSQ5zscpntG0vuSXHK2lsL+nfEAs91ZjieMEP7rvgXp9d99y0
         4VcY3hIwZHfE80D0enk3USZhDTCMIPsD49ZNqtEu9WwVVoCCsGkWMAA5xms1aRYLdj
         GQBl3eC2HknOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BFACC43142;
        Thu, 28 Jul 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] ice: PPPoE offload support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165900481317.4209.14681195524086568827.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 10:40:13 +0000
References: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, kurt@linutronix.de,
        pablo@netfilter.org, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, gnault@redhat.com,
        mostrows@speakeasy.net, paulus@samba.org,
        marcin.szycik@linux.intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Jul 2022 13:31:29 -0700 you wrote:
> Marcin Szycik says:
> 
> Add support for dissecting PPPoE and PPP-specific fields in flow dissector:
> PPPoE session id and PPP protocol type. Add support for those fields in
> tc-flower and support offloading PPPoE. Finally, add support for hardware
> offload of PPPoE packets in switchdev mode in ice driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] flow_dissector: Add PPPoE dissectors
    https://git.kernel.org/netdev/net-next/c/46126db9c861
  - [net-next,2/4] net/sched: flower: Add PPPoE filter
    https://git.kernel.org/netdev/net-next/c/5008750eff5d
  - [net-next,3/4] flow_offload: Introduce flow_match_pppoe
    https://git.kernel.org/netdev/net-next/c/6a21b0856daa
  - [net-next,4/4] ice: Add support for PPPoE hardware offload
    https://git.kernel.org/netdev/net-next/c/cd8efeeed16e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


