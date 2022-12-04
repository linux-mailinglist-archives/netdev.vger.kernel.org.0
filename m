Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6806641E27
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLDRKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLDRKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4F012A87
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 09:10:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894A360EAC
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 17:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8351C43470;
        Sun,  4 Dec 2022 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670173828;
        bh=t0wlbb4es+EFa1xB2fULtRPMV9Kkm4DM/GnT71zuIiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NeeZBwt8QI8VcMnz0eSaoAMc5XM8CMy92qd6xcErawDxR0lwKzSsQzifKhH/ac8bQ
         90Vv/bwEW6fVLWoItrvoHjw4v8TtQnrTaTEWJbXHyZGJOohGgvKryTbC1A2urztDPj
         f7vzjBaCloGesX+wXXTnurTyGuLn82FGomg3wLEcKhBi77n7L8I/+WlrWgDEzOC3jQ
         MQP8eEZqsPzFL3Oz45vz6phdel0umdIq1mSLVaHva6TIDmV87OOJ0MbmGgQBJVNc2s
         Aq7tsv3WONGBM0Z2UqhVvGVNeTXpDonoJYhswc7EoFbSMem8UFgqWITICWZUdxvrTY
         L4P0g7P2mE+6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D80A0C395EE;
        Sun,  4 Dec 2022 17:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next] linkstate: report the number of hard link flaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167017382888.10380.8244067910513150515.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Dec 2022 17:10:28 +0000
References: <20221130013736.90875-1-kuba@kernel.org>
In-Reply-To: <20221130013736.90875-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (next)
by Michal Kubecek <mkubecek@suse.cz>:

On Tue, 29 Nov 2022 17:37:36 -0800 you wrote:
> Print the recently added link down event statistics when
> present. We need to query the netlink policy to know if
> the stats are supported.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  netlink/settings.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [ethtool-next] linkstate: report the number of hard link flaps
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=c179c6e997eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


