Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24CF69D7D0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjBUBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjBUBAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B31E3A5;
        Mon, 20 Feb 2023 17:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B4D60F6E;
        Tue, 21 Feb 2023 01:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5713DC4339C;
        Tue, 21 Feb 2023 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676941218;
        bh=065DrksKqsRtAhTuC4ZOK2pbc8WlZqEqqhG74pjkaBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KZ9vFZeJLzAc4h6eVJDEUIqeIL1TZVtaYdFQqtEOVhU5+/2dp/ZIqG30i/3v6Dt8D
         nbOlNy+ecW3ycWxBz+dMPzecHRAmVKf1f1UGx/LXpXV7r60It8bj/0l/F/3cb8mrTO
         1zXfKnUiBeA/MVSR4/OQKgwJk4/zrIuc1oUrqa3c1XZLfWxKLXRTCa7xuplFRtBf8J
         X53j8nyTQUoM9PFvuJ3oaqn7ag5fT8OL4iqiR15Y5hdkxc5vjuXdJ8o9162XiVE/5v
         Q/u46rw+mRQMxKAjU5x2qUcryzv9le8XwIQbe3aCXikPirIR8FHcpyJMLnTX7DVykl
         uT126X/rufIPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 386FDC43161;
        Tue, 21 Feb 2023 01:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Fix possible deadlock inside PTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694121822.14671.18322619396868545125.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 01:00:18 +0000
References: <20230217210917.2649365-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230217210917.2649365-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 17 Feb 2023 22:09:17 +0100 you wrote:
> When doing timestamping in lan966x and having PROVE_LOCKING
> enabled the following warning is shown.
> 
> ========================================================
> WARNING: possible irq lock inversion dependency detected
> 6.2.0-rc7-01749-gc54e1f7f7e36 #2786 Tainted: G                 N
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: Fix possible deadlock inside PTP
    https://git.kernel.org/netdev/net/c/3a70e0d4c9d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


