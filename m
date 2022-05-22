Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1F5305A0
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 21:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350492AbiEVTui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 15:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350838AbiEVTuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 15:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C3F38BE9;
        Sun, 22 May 2022 12:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F908B80D26;
        Sun, 22 May 2022 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4973C341C0;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=xT0/tDJMxVH4y39FKUN2xoHcLo4oEF5jN24iQkqS/OM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSdl0U6Lf7q7f7nv1DYKuEaRWfIg/5FA+5VTSWywrwxQCw3/RC7ysr5WRNXjFwQGx
         gDLxxVmM69yu6v+kBCXKp5ctTDYPR7BqJXG+Gtq49Z3K7f1fnLen+Ar/zIGEBFyU+e
         0wHwNQo2mUz5GOAH93/OexQG60nPDdEZLbJRZd8idlNMsu0o1HiJpWCT+4wUjgZ+NK
         y6k1Fb5w7Q8sTS5znEpJNrOhTLd0RD6MTYFZSMDyZn336mUbgB5VJQJWT6S4Lkj5cQ
         SCh4FW5WY+mVR+XlTWnVxh46dKsmfaLoX2LANOcY/NUUhSauijLayC2m1h/4H2X4/b
         VIA1f06yAwlCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86576F03947;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfp: flower: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901254.28407.16794692392930354264.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-73-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-73-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     simon.horman@corigine.com, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, oss-drivers@corigine.com,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:11:23 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/net/ethernet/netronome/nfp/flower/lag_conf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - nfp: flower: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/b993e72cdd44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


