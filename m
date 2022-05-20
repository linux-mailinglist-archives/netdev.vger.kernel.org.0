Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2773152E22D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344614AbiETBuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiETBuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85AE7302
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B91DBB829D5
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 812A3C3411C;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653011413;
        bh=nzs6P0vh6sPPeZx0TKCvgI0WfllYMbKzp4yL5BlzvWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ViNJjk+CcoUH7gscrThToZOv9dXlnkyYta3x0bJIYOkDvogalkDXYwJP76UI4/Ftz
         qLDif+p6Ys9BpN0AAg21WjM/arXSnXYB2zRk7Moexb7QwxHYcal39la2Ay8OaljgQy
         qSRv/+iq5Ofr0Vx8KIyapdriINeFwYLm0zeyKK/P16wZi3tvNkcj9dpSBqH715ehcf
         nj/usBNvAHqcBFdFDhl6TvsFaIzWzbAx1IfsNUgAf9aADvN6HzsvXwku9Di8Is60Gq
         DUkCi7XGjC3/VtuEnf70+UDAtZT8wZvhcZNvuvhMgnPDSQdqfrqKBYp0WVd7+oyoJq
         rYlq0f0fjbQHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C2B0F0393E;
        Fri, 20 May 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: remove pointless null check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301141337.6731.2355844886209555602.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:50:13 +0000
References: <20220519004342.2109832-1-kuba@kernel.org>
In-Reply-To: <20220519004342.2109832-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 17:43:42 -0700 you wrote:
> GCC 12 warns:
> 
> drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function ‘ipc_protocol_dl_td_process’:
> drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: warning: the comparison will always evaluate as ‘true’ for the address of ‘cb’ will never be NULL [-Waddress]
>   406 |         if (!IPC_CB(skb)) {
>       |             ^
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: remove pointless null check
    https://git.kernel.org/netdev/net-next/c/dbbc7d04c549

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


