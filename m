Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AD16E870F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjDTBAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjDTBAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582F640CD
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D326441D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51029C433EF;
        Thu, 20 Apr 2023 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681952419;
        bh=ptBMnj0B1Q7Rt66ZYDt/KNmvrMvI6LS54DyCcCEC2a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=otZwEortehNhEHAODuiL9msIrIbGHvAg0rSoEIjpfV1HMsbVvht1uiI+xnDdPgXbS
         ORr14woa3CdA3ifd74n/fCy4otdpFfjJs8uTIB9ihOn25+xH+aZq8CKx4cvi/DrSKw
         PJchL9XMRA6lBAJqtLB/Ab7TyfSn0eHCaOgjfVDQQGvrjzbH++EBMuivElqAZKBPr2
         ebgDGNIMrTTe8rURqhc9LFwSGWg/JqjHQk00Y+epN7rVf/+L47AmJRfasAEuE8o5R8
         7RW1lKdzTuZKm7npkmo4DZFDrFtLR/MQ5hPu4p5LR9WWUFEVXcUrbVs6fzZVmpnhC0
         +lGZnn4BDilZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 352D5E4D033;
        Thu, 20 Apr 2023 01:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] e1000e: Disable TSO on i219-LM card to increase speed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195241921.21057.13372364812342041906.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:00:19 +0000
References: <20230417205345.1030801-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230417205345.1030801-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        sebastianx.basierski@intel.com, kai.heng.feng@canonical.com,
        sasha.neftin@intel.com, mateusz.palczewski@intel.com,
        naamax.meir@linux.intel.com
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 13:53:45 -0700 you wrote:
> From: Sebastian Basierski <sebastianx.basierski@intel.com>
> 
> While using i219-LM card currently it was only possible to achieve
> about 60% of maximum speed due to regression introduced in Linux 5.8.
> This was caused by TSO not being disabled by default despite commit
> f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround").
> Fix that by disabling TSO during driver probe.
> 
> [...]

Here is the summary with links:
  - [net,1/1] e1000e: Disable TSO on i219-LM card to increase speed
    https://git.kernel.org/netdev/net/c/67d47b95119a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


