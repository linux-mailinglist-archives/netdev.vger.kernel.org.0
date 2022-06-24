Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B972558F49
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiFXDuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiFXDuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E0F4EF47
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C08A620A7
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABDB4C3411C;
        Fri, 24 Jun 2022 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656042612;
        bh=twrNlzytDuXk9c7fCjqfnzdzQC7MMmdE1t7ekmvrW48=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b8lOWUZ6C+nVk7NDHFdK0JgCCQTzjaubqPD3akbx1+vSomzE5pJNBtrVpQczj7vNu
         kI/+YiwBqNFMDLCZbnIWuGVzPe7oTJmtFa6wzsEQQbpsOmMcLCgQx5Z6hPUQ/7l9VC
         UnQXKo6QojKhBDHitiRi0hz9hF/92MejhBsmU+q3tOxZ6mp1Sc8dB95Xg3Dm6lLwyz
         FPROIWMgOOxrFK11uACGEcILwT7aTsEpRQceN9WEjaIA3keu3SkvuADqome6dgDDWC
         8fdKWfUjJOR+mbhWlFOwPeUpdOYRCxzwierSMztHMaynwad1ftjruqcLTQWCBOYOj7
         cY51A+XQZHaCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 912EBE737F0;
        Fri, 24 Jun 2022 03:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/dsa/hirschmann: Add missing of_node_get() in
 hellcreek_led_setup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604261259.22770.11448381186092793401.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 03:50:12 +0000
References: <20220622040621.4094304-1-windhl@126.com>
In-Reply-To: <20220622040621.4094304-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     andrew@lunn.ch, kurt@linutronix.de, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 12:06:21 +0800 you wrote:
> of_find_node_by_name() will decrease the refcount of its first arg and
> we need a of_node_get() to keep refcount balance.
> 
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()
    https://git.kernel.org/netdev/net/c/16d584d2fc8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


