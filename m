Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE66008DC
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 10:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJQIkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 04:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJQIkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 04:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9CD27152;
        Mon, 17 Oct 2022 01:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1648DB80D42;
        Mon, 17 Oct 2022 08:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98742C433C1;
        Mon, 17 Oct 2022 08:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665996015;
        bh=5B9h/k6fvZ8XhtiJMKKeQKqbgIAM1tVeviJr8d119vA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZpoKFaJZ90WD9KqESHzDwZLjFDgCPg2qAAjw7+wSVb55OFC3v26phN+PRdIlAHtu+
         zeVQvL5WY0qvNz5OziCioQxhLwQQ3hmSE1mbCgqXBqKFahN3KQh5uv6rZjHOo2Yvju
         kLYFour9qZu43bwa0Bc7ija6DbaSvEQGFZ3mFrRffgh83mfKFypl4qyqSThXHzSw9h
         WM7nyS9/g04+T26NPEjiFZs6wO6YVI9GAghvElA+n2SRfvaknoJC9eikTyZY19haVF
         yzY7rb7X7aYl43rg8RMisJ5WR6cix/CpVxUCQ3NR2cA9s09lGe4RUILvY5C8aWmb8c
         skSD67y6pFFFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6ECBAE270EF;
        Mon, 17 Oct 2022 08:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mediatek: ppe: Remove the unused function
 mtk_foe_entry_usable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166599601544.19223.5494089989228063967.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Oct 2022 08:40:15 +0000
References: <20221017064920.83732-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221017064920.83732-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Oct 2022 14:49:20 +0800 you wrote:
> The function mtk_foe_entry_usable() is defined in the mtk_ppe.c file, but
> not called elsewhere, so delete this unused function.
> 
> drivers/net/ethernet/mediatek/mtk_ppe.c:400:20: warning: unused function 'mtk_foe_entry_usable'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2409
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: ethernet: mediatek: ppe: Remove the unused function mtk_foe_entry_usable()
    https://git.kernel.org/netdev/net/c/402fe7a57287

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


