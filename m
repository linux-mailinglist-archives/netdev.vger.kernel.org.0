Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB11E6D17EA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjCaHAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjCaHAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0FFAD0D;
        Fri, 31 Mar 2023 00:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31485B82C40;
        Fri, 31 Mar 2023 07:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 905A7C4339B;
        Fri, 31 Mar 2023 07:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680246018;
        bh=2W/QIdXtpCkPeXuD1+dLf9+7F6p8aZMu99EW74DldQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DyZRFCfvU+twZs5X+p4jvMj10JLnf3zA8fP3zz0s5FL/DdXM1a6GmYr3/X+AkeEG+
         u9A1MWlhQ9e2uPcWuez0fqsJFb8klgywJasvgFDWVOGPwO+yzAXbzc78s05HHj0vbd
         n4cdP7uuvrBSMgR3W0IszUgDc+dlb3OKnN9I0w0PuSnt9jLMtVD4nJUHukg0ERj34e
         SmwoCQBIIXd/c8SYdGS4k/aon6CZCP75PqyQRqDeWv/0XmhnxTdQM2k1iRmligouoQ
         HkUwhXpvkmDtfN6TEmR2gzuDuHYy6ym77H2nza9JETsCCUBBkyy65+4TShoVdb7iy1
         049H5CkAKeE8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76882C73FE0;
        Fri, 31 Mar 2023 07:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-03-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024601848.14217.10402936934072301063.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 07:00:18 +0000
References: <20230330203313.919164-1-johannes@sipsolutions.net>
In-Reply-To: <20230330203313.919164-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Mar 2023 22:33:12 +0200 you wrote:
> Hi,
> 
> Here's a small set of fixes for the net. Most of the
> issues are relatively new.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-03-30
    https://git.kernel.org/netdev/net/c/6b36d68cc9bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


