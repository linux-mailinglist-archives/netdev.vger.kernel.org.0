Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6C85E5852
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIVCAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIVCAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55769564D5
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 19:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C541562E03
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 261A0C433C1;
        Thu, 22 Sep 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663812015;
        bh=l/ry+FKoyatrm0WcLtj+60LYSybVFEg0dTdDcnI4qbw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gtDgF3Kzcrnn7gJDu/oPkHffNz8/GJU2tggUmYOAaeQ+tWPzpbEmFoMwcA+TkxR37
         3AbRuaFLXT778IbLai7cRu1EJz9ZY46Muf0/Etzn/WxAiK9abKC2llshwjczyWkCj4
         bV1V+FilzTCDCvmJgCUeSL4dPFpS8P731i7kI9R9waiI7YkIYIiiVcRlXwWJwaFoZD
         wjPY/v5VIPyvy0sm7MdPdepyrr4pVWHyZHa768rLp+aAnnkqMv2p1OdqXcE+7wl2Fx
         427arUZtGQxOAKOJ+i9PMJ9O70sWWUndyRtBoHGJRODAHvoRX/8DOnjavDj5/T8TBP
         9/a34iKCbucPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05539E4D03C;
        Thu, 22 Sep 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-09-20 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381201501.16388.2916203548614339813.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:00:15 +0000
References: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
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

On Tue, 20 Sep 2022 13:53:42 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Michal re-sets TC configuration when changing number of queues.
> 
> Mateusz moves the check and call for link-down-on-close to the specific
> path for downing/closing the interface.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: config netdev tc before setting queues number
    https://git.kernel.org/netdev/net/c/122045ca7704
  - [net,2/2] ice: Fix interface being down after reset with link-down-on-close flag on
    https://git.kernel.org/netdev/net/c/8ac7132704f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


