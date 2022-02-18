Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C894BBC52
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbiBRPkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:40:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiBRPk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:40:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EE58E53
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36CF661D5F
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C3B0C340EF;
        Fri, 18 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645198809;
        bh=zhvulasA5POoe2OWYWy/ZqN2vJ5Y3Gr2ueD1Bd0Da9M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BK4jyTkUo/MnQqY0ruyTHlrp7LajPjfUZ7HL+mxQr0hyA+i7hn0zHC6WK5XRzsw3f
         ImKMofTY/2PN+0uaJE8NwQq2ipVjr7zV7VE+I1hxqB2buxb2SG2L9frC3QZ9GHFu/s
         qP9/Jm/+SEeNcpPhazBGXdhYc8DaB59FQFbi1QCLbs3pKu45qevn5yD4xYMkdio+0j
         KDZ8A2LIZ9mwL6/NVyTcBVcljiMPbsnGxJoQRXu8s9elFlr+e7QEs+HwPfaE842NaV
         uILuGiu93EScQfVsyLLjRVCi6oVCslgR0hKlO8Vy4jULqfYmAyxIhw+mCmIUk5fkIz
         0SkcLKAdQPqVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7480DE7BB08;
        Fri, 18 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: avoid quadratic behavior in
 netdev_wait_allrefs_any()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164519880947.26462.4723858379906156643.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 15:40:09 +0000
References: <20220218065430.2613262-1-eric.dumazet@gmail.com>
In-Reply-To: <20220218065430.2613262-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 22:54:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If the list of devices has N elements, netdev_wait_allrefs_any()
> is called N times, and linkwatch_forget_dev() is called N*(N-1)/2 times.
> 
> Fix this by calling linkwatch_forget_dev() only once per device.
> 
> [...]

Here is the summary with links:
  - [net-next] net: avoid quadratic behavior in netdev_wait_allrefs_any()
    https://git.kernel.org/netdev/net-next/c/86213f80da1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


