Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6625B5AC3EA
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 12:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiIDKa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 06:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiIDKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 06:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD2221825;
        Sun,  4 Sep 2022 03:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222A560F50;
        Sun,  4 Sep 2022 10:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8204AC433D7;
        Sun,  4 Sep 2022 10:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662287421;
        bh=RkI0hhVrrvBqxRvzAZ5DNYiG0Bfm/d6twdk9t3loTRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uasdT41/7EUbJakvDPjIF5WgTfd9FzuRqAV3miqQWReQS1AG8ZYz0dACsC2SXJAla
         YRTsDumwa6qf8Q0PdfXBIaXgcnOgS3ZZII5Mbtr/+nG6aKA8vaYv/V7CdlGd4ADSFm
         vDtQkVQPV9R0H0ARNFbq80/+I9Vo8uJLm8Xpd4ClSc9vZUSA02nWURfErhI9yAsDPC
         SSdYxBGC4/BeHBaqXlb9sAVkO96rZ9h2MvwZSOYB7LTBcxgo8wg0VJF+k452XUMv8+
         n9mUsiIjCGy+Q2KglqLrZ2YDLztxtsjlVmuvdF1q7fbbwXODL/MsUdOZt5YimHN7uB
         /gEa7jSxYAsnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DD59C59A4C;
        Sun,  4 Sep 2022 10:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-09-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166228742144.4621.13260139142356270842.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Sep 2022 10:30:21 +0000
References: <20220903152903.134214-1-johannes@sipsolutions.net>
In-Reply-To: <20220903152903.134214-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  3 Sep 2022 17:29:02 +0200 you wrote:
> Hi,
> 
> Here's the promised pull request from wireless-next. Most of
> the updates are rtw89 and MLO work really, for more MLO work
> I'm waiting to get net merged into net-next (and then back to
> us) so we don't cause strange conflicts.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-09-03
    https://git.kernel.org/netdev/net-next/c/9837ec955b46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


