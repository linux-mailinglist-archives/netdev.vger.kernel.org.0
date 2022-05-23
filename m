Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86940530DC2
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiEWJKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiEWJK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F35146B00;
        Mon, 23 May 2022 02:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10B6960FCC;
        Mon, 23 May 2022 09:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65DDCC34117;
        Mon, 23 May 2022 09:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653297022;
        bh=AqDcuNjRYK1dFcRCy7oOo26Fbt5wdRaP2WrpVpXvfpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MkzMNUzkGgSwMUHuje7rrmzqZZQaRDzMMsa1OXzXS4XB84aARkqeJd3+yumEfoNds
         p6zbkwgWSqAyxAYzceJPGzIcCNeNr4MdwKnrebNEZ46ubSDLI/b1LeFnMGUZpOP1kD
         0x/g3BjsTEdUNCMgigpc7UVvk4u869Y8/V+XjZ1fGomyYU5/4WH9lOCM4iXJu3ZykF
         xuUS5DuKP8Ep6urJASv7+4YkRDVDqm056LYjZZMOmRJGDfdA/0QI7ILtvAjCJPzP/b
         ocKUBBC8xWKSI2886EbJGepRdLtsvURIUQ8N+UF0sW7juC27Us+ZJDy5W0lZyUly9s
         b8V7xf8J8YpCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53A35F03944;
        Mon, 23 May 2022 09:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fix listen processing for SMC-Rv2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165329702233.13209.7366612253982941021.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 09:10:22 +0000
References: <20220523055056.2078994-1-liuyacan@corp.netease.com>
In-Reply-To: <20220523055056.2078994-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ubraun@linux.ibm.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 23 May 2022 13:50:56 +0800 you wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the process of checking whether RDMAv2 is available, the current
> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> smc buf desc, but the latter may fail. Unfortunately, the caller
> will only check the former. In this case, a NULL pointer reference
> will occur in smc_clc_send_confirm_accept() when accessing
> conn->rmb_desc.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: fix listen processing for SMC-Rv2
    https://git.kernel.org/netdev/net/c/8c3b8dc5cc9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


