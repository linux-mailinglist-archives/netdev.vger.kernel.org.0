Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4C54F5F9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382126AbiFQKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381839AbiFQKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60E6BFED
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F5EDB829CC
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3630CC341C0;
        Fri, 17 Jun 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655463013;
        bh=3uD7sReGKoKgyvImypO2Y9jTBPoHeNZvhqY6TPqtoM8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VYOSv0ocZAvZxpQIv9Ra/kEsJ6Jp8oKjm9X1rCDJsX+g8E2rKyiBL2vhPl5j7d3tL
         v4++HcDfLS8RlmU8CWwc5WMkDv3q+BJfTlg1NTC1A/wTqLD1GTK5qnc4cQOAEAGVS6
         deftTKhWfxrpd8Sl+KUYNBnD0uwBEvCfGpaWsAZdSiNszR2X0Vlkhcho/xS6Ck9FPQ
         9KSHdH5dvO0vgvW+efUOMoKrt9XsfWCX+9r+RaQZEIB/JjVPi9/P1cOaCQOE4GVZvx
         1yK6gEIqgY+rn5qdKEPA39exVczdjrvda7K77YmFmGzGF2yVrj+MZ2UWYtsjuBI/ky
         do2CU/ZQkHyzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19F61E7385E;
        Fri, 17 Jun 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tipc: cleanup unused function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546301310.24969.9965565948905484080.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:50:13 +0000
References: <20220617014751.3525-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20220617014751.3525-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org
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

On Fri, 17 Jun 2022 08:47:51 +0700 you wrote:
> tipc_dest_list_len() is not being called anywhere. Clean it up.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/name_table.c | 11 -----------
>  net/tipc/name_table.h |  1 -
>  2 files changed, 12 deletions(-)

Here is the summary with links:
  - [net-next] tipc: cleanup unused function
    https://git.kernel.org/netdev/net-next/c/4875d94c69d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


