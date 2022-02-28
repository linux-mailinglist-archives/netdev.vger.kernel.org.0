Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7B24C6AE4
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiB1Lk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiB1Lkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:40:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E286C71C88;
        Mon, 28 Feb 2022 03:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FA3B810C2;
        Mon, 28 Feb 2022 11:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21936C340F8;
        Mon, 28 Feb 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646048412;
        bh=HO5mukOsh1CQY6TQPZOqEsX7jfChMuGFDsi0dNfJMHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OUGY+rF5DWnGXspdM2HcFddZfGLrHumzRaKbypy7JLOdT0KB1kFQUwYOQcYtILJrT
         kHEK0vBBmxUTcPjeJJJ4szqdUIFx75zJ1b9Ni7j3chsFbLyrUBpM2LGiI6EgqlRiZr
         E+3/3Q23anEOrtjl18CeTghMZyeeb9CKuPlYYac1uvpBcH6/4bgectRIE1pck+8cmF
         qIliVIOr90damhnxbwjwQIZALZSdQQYvCBQMgSkCoCWWNrvty3qz4Jsny06Uh3Gb9p
         mnPRURznx6SfhqA63ZobE1gzUEMy5EXGC9BmyFputZIFSruRZreyHA8KwS9u7W2bt3
         XgLmwGR3Zrpqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0546FF0383A;
        Mon, 28 Feb 2022 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Call trace_smc_tx_sendmsg when data corked
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604841201.9255.3198550734243809450.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:40:12 +0000
References: <20220225073420.84025-1-tonylu@linux.alibaba.com>
In-Reply-To: <20220225073420.84025-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     raspl@linux.ibm.com, kgraul@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 15:34:21 +0800 you wrote:
> This also calls trace_smc_tx_sendmsg() even if data is corked. For ease
> of understanding, if statements are not expanded here.
> 
> Link: https://lore.kernel.org/all/f4166712-9a1e-51a0-409d-b7df25a66c52@linux.ibm.com/
> Fixes: 139653bc6635 ("net/smc: Remove corked dealyed work")
> Suggested-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Call trace_smc_tx_sendmsg when data corked
    https://git.kernel.org/netdev/net-next/c/6900de507cd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


