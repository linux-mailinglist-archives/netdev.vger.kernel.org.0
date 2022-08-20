Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11C259A9B2
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244205AbiHTAAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiHTAAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F51106F92
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3876C618D5
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0160C43470;
        Sat, 20 Aug 2022 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660953616;
        bh=iw4oOzRvNC/wKJVItIieKG8dAsjM47re54ttA9ZV3qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ShxT8oAm9oSxPhLNlXwF0nC8xGQHpz/iJ1MUwCS87O7ZHHG/1z+5ArhbO7g8B/pTw
         FVlM85J2Y/BqPEqFNtDpF/IXBt5k8x3NSVnapQrMKUnQW6xUMc60gjIvMevOr9xQWU
         E02X9kVp2bWGgeKTrTtkRu8LkLEyZGu75pc5ydEZa/HQIoH1cU9nzTB6IrNE5cwJwR
         2uJV4ar6scdhbcPD8ATF8mVqUrMWosA6/QPNpvZEln16WpoP9eKUOmDfFsUV18h7Vv
         JZAyqwDIDqbl1ckphXIF6RHWVb4tyRUSbxFoga3+IkQOlc/CkdlZvmwAsNDABX8b22
         bBX6b1KJmlD1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CC3DE2A05E;
        Sat, 20 Aug 2022 00:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: macsec: update SCI upon MAC address change."
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166095361657.16371.15471584965629338713.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Aug 2022 00:00:16 +0000
References: <9b1a9d28327e7eb54550a92eebda45d25e54dd0d.1660667033.git.sd@queasysnail.net>
In-Reply-To: <9b1a9d28327e7eb54550a92eebda45d25e54dd0d.1660667033.git.sd@queasysnail.net>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 14:54:36 +0200 you wrote:
> This reverts commit 6fc498bc82929ee23aa2f35a828c6178dfd3f823.
> 
> Commit 6fc498bc8292 states:
> 
>     SCI should be updated, because it contains MAC in its first 6
>     octets.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: macsec: update SCI upon MAC address change."
    https://git.kernel.org/netdev/net/c/e82c649e851c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


