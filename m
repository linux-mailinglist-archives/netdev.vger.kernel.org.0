Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53674C6B42
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiB1Luw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbiB1Luv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:50:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E216D971;
        Mon, 28 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4872B810BF;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55B3EC340F4;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049010;
        bh=BgYtvwcmMAzp2F72cRhoyjhWd222YLpUXgARFox3H7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QLhoZhMsRpkWEApjCACkY+GUp2CWtQObZgPhjNSostUgihywc1etqmwvy+2x6f5+5
         q5lGFsFV3aj7LCGHg53JO6kRzE6dic6q6aVWI+NNJuklFlxaIpBULfWqee3zff+D+q
         JhfvetNGFwJOvSWJciKqRQ8lJ1lWm7BJ55t2YaSajRhK9amwqylMitujmJeqh/C2Z3
         ga0YLmkCvZHT2grXxQCnx8OwjP8DAcJA/WPALMJIBMe2hs/T1s/nd3xBeXjXtJL4J1
         UcIOD4ZeQ8VWokxs1FapED4rGrxOxoK/fPpv7uFcYG72JeNau5ORruLsykHerAh3oV
         aSbj6tJOWAe+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4049EF0383A;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: firestream: check the return value of ioremap() in
 fs_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604901026.16787.11574408572805234440.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:50:10 +0000
References: <20220225125230.26707-1-baijiaju1990@gmail.com>
In-Reply-To: <20220225125230.26707-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, 25 Feb 2022 04:52:30 -0800 you wrote:
> The function ioremap() in fs_init() can fail, so its return value should
> be checked.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/atm/firestream.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - atm: firestream: check the return value of ioremap() in fs_init()
    https://git.kernel.org/netdev/net/c/d4e26aaea7f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


