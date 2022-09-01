Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F165A91FA
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiIAIVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiIAIVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00CE5072B;
        Thu,  1 Sep 2022 01:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70CF4B824F8;
        Thu,  1 Sep 2022 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13ECAC433D6;
        Thu,  1 Sep 2022 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662020415;
        bh=iz6N3RM8oW5sfEA8TLJEB9lKt5aNn7YeuUrpiAyhjSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q37odR7v2AkE3wxhGNStQsbYWCbD1Cegx5UdIApz6qk6fZysLHmwwvJtw2utCKoZy
         FubCl2+eG1dNvXkKsz2HpYXWPyTv8sDLhRb57KsT2eXI7KP6268q4WBjSZVNnuGgBE
         i3GG/RquOvwxa3kKcF1QNBfyUzIZBzuMIkCkxBDrvgn7iq07kKt58lcmtrPRBpFunF
         ZsCZ+tUWd42NWxHK5P6N0/pxiGF6NA1kjZkQw91njskGq34i1UOxSQyH0DWO31sqoE
         r6NRHiMX2QO1g3EEr86BnaW4wYHkUw7ybwBkbWDEdX1c4xjB9xqGOVQnw/T5Xo+CPR
         qH4eUj/FimbzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6470E924D9;
        Thu,  1 Sep 2022 08:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: Remove redundant refcount increase
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166202041493.31176.9077678732779929548.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 08:20:14 +0000
References: <20220830152314.838736-1-liuyacan@corp.netease.com>
In-Reply-To: <20220830152314.838736-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     tonylu@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
        kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, wenjia@linux.ibm.com,
        hwippel@linux.ibm.com, ubraun@linux.ibm.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 Aug 2022 23:23:14 +0800 you wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> For passive connections, the refcount increment has been done in
> smc_clcsock_accept()-->smc_sock_alloc().
> 
> Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
> Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: Remove redundant refcount increase
    https://git.kernel.org/netdev/net/c/a8424a9b4522

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


