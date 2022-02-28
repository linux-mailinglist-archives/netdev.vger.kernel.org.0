Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76D44C6ADF
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiB1Lkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiB1Lku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:40:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745D471C88;
        Mon, 28 Feb 2022 03:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBA860FDA;
        Mon, 28 Feb 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B048C340F2;
        Mon, 28 Feb 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646048411;
        bh=R4l8vCaaNANcTkRuuzGTf3lPNGoX9+TFaa0rG56HN0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dyT3lCRZBDZZpDdzoajZVkaQYvP+bEgLwRu156X6uo7VhqzIO0ANYzw1hMiPYIaWQ
         87rKwnP4MPwNTHdZLzd4WuugDO2XeP9OQeTZCxhHb6tfhccjwzkBg5ROs1KDaAb/+K
         mSe2X11Ga+mPpAiwbzoK3MoNi9em3fcasuTgmGwvQ/2FOWQvD9y03CeUuMLHEQQvzj
         abaEdKfbwGc7Iww6CpR1EExrMNRoH9TOI0SIFAJcQWo7f2BB5cOCoVr3zPSeq/APpc
         NJLwS6CgFlwV1Ab9bMG0d/DUdvIxgnxtiehKTn2YtroHt4M+DYCDJCOrQWtkUL2RZS
         wz2LfK2f2dEDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30157E6D4BB;
        Mon, 28 Feb 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Fix cleanup when register ULP fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604841119.9255.16751027729230312686.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:40:11 +0000
References: <20220225065656.60828-1-tonylu@linux.alibaba.com>
In-Reply-To: <20220225065656.60828-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 14:56:57 +0800 you wrote:
> This patch calls smc_ib_unregister_client() when tcp_register_ulp()
> fails, and make sure to clean it up.
> 
> Fixes: d7cd421da9da ("net/smc: Introduce TCP ULP support")
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  net/smc/af_smc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net/smc: Fix cleanup when register ULP fails
    https://git.kernel.org/netdev/net/c/4d08b7b57ece

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


