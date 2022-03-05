Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9427C4CE2C3
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiCEFVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiCEFVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:21:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88529120F61
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 21:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27FD2609AE
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 05:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89AE0C340F2;
        Sat,  5 Mar 2022 05:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646457612;
        bh=MVmtRshqvM+IMe8p2m94E6O0r1hiE5mb7Ys9cTPnpKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mx8YqaG23NYJxMBkgqH/Go60Nlvr3kP+6ZtsYcS87mNxwiP4noyt9/rmOOtxU2j9H
         +WpIEnRnbcoHgSDLZbLj938QTzUosl/j7p1WkYbW8CYO2mGdbLX7Fu1iQA4NHCbG4c
         BN6LUNOTCtp4tWq14eIrQWjZ8CtQVmbekiFRB4iPAKVYXA0AbihCh8OsR3/HOJ4dxq
         lwy/LZHd70Cc4kXVHM/3encBKSJXKoUg6G1PG7U8rVy2EUXXZMQGaNxarwT6nFmr0F
         dIZ3ketmYKzauEkQx3kD4Y3gIbXTcL3wn8xbpkKEBhm6hdaqORKvfwRePEWOMZFcMB
         hveSKxbhJn16g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74447E7BB18;
        Sat,  5 Mar 2022 05:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next] ptp: ocp: Add serial port information to the
 debug summary
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164645761247.14498.15580645857349298898.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 05:20:12 +0000
References: <20220304054615.1737-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220304054615.1737-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org, kernel-team@fb.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Mar 2022 21:46:15 -0800 you wrote:
> On the debug summary page, show the /dev/ttyS<port> mapping.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/ptp_ocp.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Here is the summary with links:
  - [RESEND,net-next] ptp: ocp: Add serial port information to the debug summary
    https://git.kernel.org/netdev/net-next/c/61fd7ac21522

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


