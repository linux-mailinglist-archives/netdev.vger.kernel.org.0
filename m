Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A48E52E04A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245683AbiESXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiESXKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48070DFF79;
        Thu, 19 May 2022 16:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0826BB828CA;
        Thu, 19 May 2022 23:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6F63C385B8;
        Thu, 19 May 2022 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653001820;
        bh=LakY9AfnVD4g8Irae/udoUwnjW59Na5qcWoNY/gPbcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QJ8Im+Yv2gzo3ibk09zYXmTWLLtnQC9YiXrFLKYL2YdDhUk1Txh0eNEd4anhFpg5k
         UwgB2aaffrzLY1KpWl35ML7+yLWXbdlCWv6b5Qbh0JXvqcoTndObuJbsCdQEzehTk0
         p5ldK98vvxN3tyUsTAYLLS1r7ORGOllLE/xMvVvUpS2iLNnb8J1pZJV43lWVMKtnpg
         WTGYUn0uciZ88Zu5SjRfJOG9VYz1RxuI7WanWfUbFY3aUV6rcYivpfTuGGetWSAefa
         Rr+0eJFb60btUNL9KJyuDdBHLMv5pZQli5PYHphwkCBks4rG07tLIvhaP0JLFeC/4H
         WnKPY2ws14hxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6C45F0389D;
        Thu, 19 May 2022 23:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-05-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300182066.26365.1890416182579108141.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 23:10:20 +0000
References: <20220519153334.8D051C385AA@smtp.kernel.org>
In-Reply-To: <20220519153334.8D051C385AA@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 15:33:34 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-05-19
    https://git.kernel.org/netdev/net-next/c/d353e1a3bafd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


