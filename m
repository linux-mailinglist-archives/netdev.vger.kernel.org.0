Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD915663372
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbjAIVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237588AbjAIVuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E783590C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 13:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482AF61382
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 21:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 635BEC433D2;
        Mon,  9 Jan 2023 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673301016;
        bh=8ExIuP1C5lkB/tLEu69tkqEWSl1Tyho4TwcR3biCE6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r6vJCnRDk+CApiR3r3gLp0ahXpN0pBzZDTApPiZ/w8/tN0s0CyHpV1rWQDKxF3Q7v
         4PwtTWvAedQ9k9E/HCgq/GLchtXTXA3UOGWzVagfoKNiTIN738Cr1jJmPUa+zR2rvX
         7bPawu02BYCjmX54AduuRHWPGcA429bNMz74bgCiacHjKyia5MnWqDvPU7TM5Xtdjl
         diLn8ig1Z5uru0Je5dYYzCSF0imE9eufwQOXA2N9hdrY/ABx1prpK1XaKmmjfsxPpp
         NGSBQYK8G/pc/Tj9ETSjpiYzudUxgbKOXxfqM2zTOTQi5iq5zjGiCJJlO4R2XfgHGr
         PhOMyXNrexVRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38EFAE21EE8;
        Mon,  9 Jan 2023 21:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2 0/1] tc: Add JSON output to tc-class
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167330101622.28139.7353662408147216772.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 21:50:16 +0000
References: <20230109105316.204902-1-mtottenh@akamai.com>
In-Reply-To: <20230109105316.204902-1-mtottenh@akamai.com>
To:     Max Tottenham <mtottenh@akamai.com>
Cc:     netdev@vger.kernel.org, johunt@akamai.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 9 Jan 2023 05:53:15 -0500 you wrote:
> Address comments from Stephen's review.
> 
> Max Tottenham (1):
>   tc: Add JSON output to tc-class
> 
>  tc/q_htb.c    | 36 ++++++++++++++++++++----------------
>  tc/tc_class.c | 28 +++++++++++++++++-----------
>  2 files changed, 37 insertions(+), 27 deletions(-)

Here is the summary with links:
  - [v2,iproute2,1/1] tc: Add JSON output to tc-class
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=010a8388aea1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


