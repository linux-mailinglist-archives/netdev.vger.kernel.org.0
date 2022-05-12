Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9831E525506
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357756AbiELSkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357733AbiELSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF0270C9C;
        Thu, 12 May 2022 11:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA41BB82AD2;
        Thu, 12 May 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A916C36AE5;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652380813;
        bh=DIkBcwiBP7eLnXH/EArwAiEEFxkhnx85Yfb5gtm5f8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PDfFObaFtUVfU1gyRN4PP0oeaP0eEe5d3UHsZ5okr+c30QraSe0apJoAn6PoYTpbg
         WyMDoNq2AhDRp4I7YHh6XOF0NeBMwF5z7gqR8Na7sX0ITcIpqUKEFUBTf1fqkMjh85
         HE/yHPLh3Vs6QKtFyWZDA9qS8hIc6FIFlVXl5AwLWNjXEjOvglL+KDA64Bxl11Jokk
         HusWQT0l7ABffPiu/EjJn09uxCmRvLmOsOgJyKkpiJ+0TS8fYvmPLKx5dH/t5l9TPe
         xlwDertn92bhw3I/mtNl5O9IODXcFUrA+QNSJ3MKpV58NxI40L9C5CQesqxMSiKjt6
         JTmOB+FoHf5AQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21660F0393D;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: non blocking recvmsg() return -EAGAIN when no
 data and signal_pending
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165238081313.29516.9624732494315218204.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 18:40:13 +0000
References: <20220512030820.73848-1-guangguan.wang@linux.alibaba.com>
In-Reply-To: <20220512030820.73848-1-guangguan.wang@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        tonylu@linux.alibaba.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, 12 May 2022 11:08:20 +0800 you wrote:
> Non blocking sendmsg will return -EAGAIN when any signal pending
> and no send space left, while non blocking recvmsg return -EINTR
> when signal pending and no data received. This may makes confused.
> As TCP returns -EAGAIN in the conditions described above. Align the
> behavior of smc with TCP.
> 
> Fixes: 846e344eb722 ("net/smc: add receive timeout check")
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending
    https://git.kernel.org/netdev/net/c/f3c46e41b32b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


