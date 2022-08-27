Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21905A33A3
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbiH0CAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbiH0CAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD8512768
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 19:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750C961D2E
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCD8CC43143;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661565615;
        bh=frkcVQ9Rpre27mtBY+Holp4Nr6huNbwPeZVZfjaddIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uvfc+7HPhLQBT2HSY03HBSNDR/PjRcH3TFOsiDMLK90tXQnwvS2HRS5D3b1d3yK0k
         12+fgdcsgCWk57brrkwSHvnIIz0e0SQ13z6+ubi7bF+G8ALv34zxgTUoPmenzDNTbg
         PriazSlvF/j560STWioZDWDE10gQ1L1aO6GSvVsdLWBT3c+8/6K1RiYHWqW+uuiiHi
         4jbGrd8wJZoESviJfZaAbLIaZSb4pifHTXrn6zjnMKO4SsESn77matxouulammcRa3
         m+Kxlyg1BwTMgBWdua7ogsfGan3+Rf+5oK6ik1MpPXvfAoO/XsrXhgC4scrawZLc1P
         19d/SbzGy8QBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6988E2A03B;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] genetlink: hold read cb_lock during iteration of
 genl_fam_idr in genl_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156561574.8692.12885823752159034066.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:00:15 +0000
References: <20220825081940.1283335-1-jiri@resnulli.us>
In-Reply-To: <20220825081940.1283335-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com, fw@strlen.de
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

On Thu, 25 Aug 2022 10:19:40 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In genl_bind(), currently genl_lock and write cb_lock are taken
> for iteration of genl_fam_idr and processing of static values
> stored in struct genl_family. Take just read cb_lock for this task
> as it is sufficient to guard the idr and the struct against
> concurrent genl_register/unregister_family() calls.
> 
> [...]

Here is the summary with links:
  - [net-next] genetlink: hold read cb_lock during iteration of genl_fam_idr in genl_bind()
    https://git.kernel.org/netdev/net-next/c/8f1948bdcf2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


