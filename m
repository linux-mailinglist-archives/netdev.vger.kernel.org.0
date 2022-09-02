Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F293D5AA6B4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiIBEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBEAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7932A941;
        Thu,  1 Sep 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1739D61F63;
        Fri,  2 Sep 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DFE6C433D6;
        Fri,  2 Sep 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091215;
        bh=/jI0a8+2s4qRjh3uAicgxsHCzVCnbf/GBPdrISNyGJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8TesHBrvQlRCyB05xiExWjAJ2Enys+qGeHIb8AbUipjiiWZpzEyjyA8AQSOkHHCf
         808dn9+uH4iey9Rlr0FwIsdSe/p2H1uburXSGFltZvqOrfA4vWw93SUu1y6/fXhpO0
         9/aIBn7lIV6FWUk0ov5V09I4ilkYPs9ZMR3gfZmCm5bbijW4kTgr5+kMzulbNpdYJj
         PW4ZCPyrru53jzdi8+3cie6qxFyANnlxIIwdyCGtA8QH7m6nUrOcmnZi0CAoabu0rc
         YBprUpYqlROy35RIkrt0EoFegx5AxvxDPnAYpgMyzUA/scHhqwajGthU8S9XfBUCNx
         Wfzfsvw2AnE7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F642E924D5;
        Fri,  2 Sep 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] netdevsim: remove redundant variable ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166209121531.15275.7872232484950693784.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 04:00:15 +0000
References: <20220831154329.305372-1-cui.jinpeng2@zte.com.cn>
In-Reply-To: <20220831154329.305372-1-cui.jinpeng2@zte.com.cn>
To:     xu xin <cgel.zte@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cui.jinpeng2@zte.com.cn,
        zealci@zte.com.cn
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 15:43:29 +0000 you wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Return value directly from nsim_dev_reload_create()
> instead of getting value from redundant variable ret.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] netdevsim: remove redundant variable ret
    https://git.kernel.org/netdev/net-next/c/5603072e0b37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


