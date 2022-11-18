Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBD462EA20
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiKRAUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKRAUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:20:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F66065E76;
        Thu, 17 Nov 2022 16:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA4B622BE;
        Fri, 18 Nov 2022 00:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBFA8C433B5;
        Fri, 18 Nov 2022 00:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668730830;
        bh=QlpqTpq7N0MYY13FewCvFUnEVoJEbfjmNFTb/NEl4h0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cU+7Y5VgYjYb6B7Xl0xp9I9AhBSME7yRIEvUKA02pb0o7gjZe3/XiYgOKJJ5epEbo
         Wu+w07epYhswdo4aLmku0pRw7KmYsL4tKX88KBOiiv/jVHv+rYEt4eDpfC1LL8NxWX
         tV1zIaUiceM8R5fQ5j2Cgykhvo0Vn1OqIPMpvb7mcl5pIN5TuCE3045N7v1pUky/sS
         a0WGikUXxt7zv1qI263NlxavwQOxVKEq9p7eeKjfqB4y+zogt4OLTGhAi0gHKlNc+0
         n1OoRSJ2BvA+pwMCGNYkUHij/eHFTjKB0Vv+9tqBKgnS7Wi+e7Abf01JZoiO5lKHzW
         cQKhdr+y6GILg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9981EE21EFA;
        Fri, 18 Nov 2022 00:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 6.1-rc6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166873083062.21663.9245391934733865539.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 00:20:30 +0000
References: <20221117120017.26184-1-pabeni@redhat.com>
In-Reply-To: <20221117120017.26184-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 17 Nov 2022 13:00:17 +0100 you wrote:
> Hi Linus!
> 
> This is mostly NIC drivers related, with a notable tcp change that
> introduces a new int config knob. It asks for the user input at
> config-time but it's guarded by EXPERT, so I hope it's ok.
> 
> No new known outstanding regressions.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 6.1-rc6
    https://git.kernel.org/netdev/net/c/847ccab8fdcf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


