Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16085809A4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbiGZCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiGZCuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9A2FDF;
        Mon, 25 Jul 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A43EEB811C1;
        Tue, 26 Jul 2022 02:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F549C341CD;
        Tue, 26 Jul 2022 02:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803813;
        bh=m+lE6Y4rBfUQxaFUDQc6WjEoXOeeg7r2bbkXhxygMUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BiiJf2S2sDgv9/wnst9TXL0HXF39VkDGbkFYo2kSpADTV6BoxccUa5XJw9taXCYR1
         WmUAxpyUi6QXk93bonUcoRLLbIKlsM2jD0pcQXc86H4Pjt6mlrcOOljZIp0GRFuMOm
         gv0PBZiIhsfouKcm43Na8K73ATSS7kabkrXrQKOkT8/4hoaPBTke8SYgJyh2GRwPAi
         dP6FXwqn05cDSedyH96o5/+G+879hsPm7wz7Uw7VdZQaHrXB6jMJ5sSlotSTvWnd2W
         HbXH99ccqxq5v8U9QLfse/cjFpIBbCwjpYGwWB2J6Kfr+yWHs2hh3okIlZjHiOy3qD
         dT3OcsSUY1GNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 335C3E450B3;
        Tue, 26 Jul 2022 02:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix sleep in atomic context bug in timer handlers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165880381320.11874.16470003795860315599.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 02:50:13 +0000
References: <20220723015809.11553-1-duoming@zju.edu.cn>
In-Reply-To: <20220723015809.11553-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 23 Jul 2022 09:58:09 +0800 you wrote:
> There are sleep in atomic context bugs in timer handlers of sctp
> such as sctp_generate_t3_rtx_event(), sctp_generate_probe_event(),
> sctp_generate_t1_init_event(), sctp_generate_timeout_event(),
> sctp_generate_t3_rtx_event() and so on.
> 
> The root cause is sctp_sched_prio_init_sid() with GFP_KERNEL parameter
> that may sleep could be called by different timer handlers which is in
> interrupt context.
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix sleep in atomic context bug in timer handlers
    https://git.kernel.org/netdev/net/c/b89fc26f741d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


