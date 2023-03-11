Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8422E6B571E
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjCKAx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCKAxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440F7142674
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 16:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6353C61D9C
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE54CC433A4;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678495820;
        bh=jqsOy9mdlrOEpALn8ss5ZBLqqRYujGYE8azY7NXB1jc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iTqufZatJwopI+wkn9p+jAOUQcNlVS9M1WHAaJESZu/sTpmrjFDLuPXAZOCPWL2L0
         mJBP1VeYtUAkXrNUu/NxHQ3cLmgUxqxYhyMhziV7HzEe1EfXXg2VpB+8OcAh8rXsje
         dUzRosj+wMAdo6MCG7iYaga1drkgxibpeTOmlGl2mPqDAYbz31VeaLlFliPwbgCeKs
         n9J7dhNYMZqMcJX8VLn4cOj99/XIvdTWje19NIh35/TXiV1RHvDMSbkJtSwp0be8/A
         7TeD/w/AZqpJ8EU1b1HgjEO3ybE9NMkYpXQgXEt1DONl4jNj6fU9peElXmO6raoQmF
         bxDW8kQoRqs7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3EEEE21EEB;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tun: flag the device as supporting FMODE_NOWAIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849582066.26321.9229589765306275280.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:50:20 +0000
References: <3f7dc1f0-79ca-d85c-4d16-8c12c5bd492d@kernel.dk>
In-Reply-To: <3f7dc1f0-79ca-d85c-4d16-8c12c5bd492d@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Mar 2023 20:45:56 -0700 you wrote:
> tun already checks for both O_NONBLOCK and IOCB_NOWAIT in its read
> and write iter handlers, so it's fully ready for FMODE_NOWAIT. But
> for some reason it doesn't set it. Rectify that oversight.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> 
> [...]

Here is the summary with links:
  - tun: flag the device as supporting FMODE_NOWAIT
    https://git.kernel.org/netdev/net-next/c/438b406055cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


