Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2B75330AE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbiEXSuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiEXSuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B3D167FA;
        Tue, 24 May 2022 11:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C9BB81B87;
        Tue, 24 May 2022 18:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08F07C34113;
        Tue, 24 May 2022 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653418216;
        bh=bPYLomqq+IDt+hcVr24VNY6CkBAitCaV+xfKCuRVj0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DtC4dsctItMJoAE9ABWo0L2f8qotyqGWqeW3XP1EH0DdAuPD3d6T8YJW+QYKvcpDi
         J6TZUE8ZXTv8NY0UPY7h3GRJ5hEfcz+QejZjCNE4AI47ioyT9I4Zycu8anbwzPK0mQ
         FJbKE7lRQlRf8yXc/yDvQiXfRzi/g3pFWNouptrBTC33AiuHyxnQPbTq2t6aq+GKKo
         euWwHPH6fGg4vrCxrirlQwGXWfOrA6X65INF6zfdCSt2wJeA1zdZZ5W/+07Win10Q3
         XSqTRvJyoPFA0iaLCZ1hxCvzP0hFPxfHk4cMJ05THNTIVF2x0ZQ394knTGvSBMaxnq
         iAwGQxd/wEbIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA9B1F03945;
        Tue, 24 May 2022 18:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] Revert "net/smc: fix listen processing for SMC-Rv2"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165341821589.16038.88620820798797922.git-patchwork-notify@kernel.org>
Date:   Tue, 24 May 2022 18:50:15 +0000
References: <20220524090230.2140302-1-liuyacan@corp.netease.com>
In-Reply-To: <20220524090230.2140302-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, ubraun@linux.ibm.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 May 2022 17:02:30 +0800 you wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> This reverts commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d.
> 
> Some rollback issue will be fixed in other patches in the future.
> 
> Link: https://lore.kernel.org/all/20220523055056.2078994-1-liuyacan@corp.netease.com/
> 
> [...]

Here is the summary with links:
  - [v3,net] Revert "net/smc: fix listen processing for SMC-Rv2"
    https://git.kernel.org/netdev/net-next/c/9029ac03f20a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


