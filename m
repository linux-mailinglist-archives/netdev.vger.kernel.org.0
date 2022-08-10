Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183F658ECCA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiHJNKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 09:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiHJNKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 09:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705D3188
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 06:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC8EB81C62
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 13:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7503C433D7;
        Wed, 10 Aug 2022 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660137014;
        bh=MnRIdPgdDn2EZ3LuYBZE55UxqNxMwa0hZiK4kBYmi6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jSyvPrVs1L4xBf97TZ4nS9GR8YwlYMg5aGd+ilROyCo5g+VlqbHhZL2JIATXUaBrs
         NWkrzdGIWQvNLIeKCZGrlvxPOGHyfXQBqHWKc1+ADo78Rte7RJ8M0ZNZ2awQIpDJhZ
         +GW1boaBOQMd8g8Qx2oorNsCEr2Mojd8ET8fe0OzpnUgnYRicd6Etx4ioRVCVwNjWW
         ys6w18X3Gvm8A7dXfQiSQGcNMaGjyXgcDH4ppg59KGUhOg/pDolou08rj4kIbs4dC0
         QbuCi0cdmBAOEtmFAVANWzKoMuJee2LtwqzA21Ro7KSiP+IgFmy/cYXcGK5KlmOkcf
         PEf5Foj83VPdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC5B8C43142;
        Wed, 10 Aug 2022 13:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] genetlink: correct uAPI defines
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166013701470.15040.6477602916351777863.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 13:10:14 +0000
References: <20220809232740.405668-1-kuba@kernel.org>
In-Reply-To: <20220809232740.405668-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes.berg@intel.com,
        johannes@sipsolutions.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 Aug 2022 16:27:40 -0700 you wrote:
> Commit 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
> seems to have copy'n'pasted things a little incorrectly.
> 
> The #define CTRL_ATTR_MCAST_GRP_MAX should have stayed right
> after the previous enum. The new CTRL_ATTR_POLICY_* needs
> its own define for MAX and that max should not contain the
> superfluous _DUMP in the name.
> 
> [...]

Here is the summary with links:
  - [net] genetlink: correct uAPI defines
    https://git.kernel.org/netdev/net/c/f329a0ebeaba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


