Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84139610071
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiJ0Sk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiJ0SkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067BC4151C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B299B8275D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E70C0C433B5;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666896018;
        bh=ME2r36VOhEuLMzBGknUFz8tI/NUuV+E5uTHdHtvy5vQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n7utVEHOO9X1t4IALLwYQqJBwgpEtpYG3DZ5E0d/cNi51lXf28QIR87L7NQCfwEuT
         /FIcr+aUcFcLI8IiFAt68OEo2P5Nm2SL3TgL6NT4Jr6MdSL225FAfScCdGard7k6AG
         xUoksCEMzup9gCrK9Trbg8eK7F8PpZJm+KHXvuF6HBUvbby+JUkj08NUHeDuENc/l+
         +ghCgXWZDwTJl0pEfE7qnpBq1Qy1Rmh5BuKh4uaXBsjCTU6YsNOowAyzcrJ3JCW2KK
         6x8uRTWEKGwrvzZ6t1fy4tQHCnj7ZYDF7fYiAD04Y2BTGc/LS6GlR8Z+pKl2OcNGOX
         liMwAjgjeatVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CABD4C73FFC;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] kcm: do not sense pfmemalloc status in kcm_sendpage()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689601782.10145.11518079872887521722.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:40:17 +0000
References: <20221027040637.1107703-1-edumazet@google.com>
In-Reply-To: <20221027040637.1107703-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 04:06:37 +0000 you wrote:
> Similar to changes done in TCP in blamed commit.
> We should not sense pfmemalloc status in sendpage() methods.
> 
> Fixes: 326140063946 ("tcp: TX zerocopy should not sense pfmemalloc status")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/kcm/kcmsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] kcm: do not sense pfmemalloc status in kcm_sendpage()
    https://git.kernel.org/netdev/net/c/ee15e1f38dc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


