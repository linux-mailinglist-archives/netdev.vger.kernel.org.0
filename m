Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5CE51CEEA
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387864AbiEFBYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387846AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754C0381
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DA71B831FD
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8CE1C385B0;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800014;
        bh=Gpml0TQQddXUseHtneUe3Y5uWJA1rlZrJZ10zaCxaFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2QitPsjxeux3ANVj1O5LHDhD0Fbf2RZbiyA5ZeOhi9j7mXkZhzTPIP66P68mFBzU
         E+h1lS5ZXbctPwv+4ZVp2D5ALBB93jEKqRDx/P5ewxYOX35tUQyDwgIJe0VgFNJKVp
         zmLReASNKUT/YXfM1mf9fT39vhYbyUIYZZ4UOt0KzjvGpa68LnrtS1NtVjLA7wfSga
         QYqIv+6DUwKkmm3nzoALvl/dP3DQtXUxkpbzFG07+yqS9InmJpTO3VPlUAilKFqsHC
         ZapXQCrrL1coBa3jKq8t2UoNNwRha1QvGifw6TO9N0QSR45GAeIxOmACT+Oj5Lcb6I
         nQGWew8E32dIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2AF8E8DBDA;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] jme: remove an unnecessary indirection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001485.16316.5005076195079463150.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:14 +0000
References: <20220504163939.551231-1-kuba@kernel.org>
In-Reply-To: <20220504163939.551231-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, cooldavid@cooldavid.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 09:39:39 -0700 you wrote:
> Remove a define which looks like a OS abstraction layer
> and makes spatch conversions on this driver problematic.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: cooldavid@cooldavid.org
> 
> [...]

Here is the summary with links:
  - [net-next] jme: remove an unnecessary indirection
    https://git.kernel.org/netdev/net-next/c/fd49f8e61cd3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


