Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC2A6724B5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjARRUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjARRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25B125AB
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65DBF61903
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDC91C433F0;
        Wed, 18 Jan 2023 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674062416;
        bh=0YGblyLc9pGWb42myA5rRU3ik3f5JrLF5cRxa6ThrNk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nPGiqVJJRyrjiAr4wFpPCIhxjlNMuoOehxovh692sFfV9oazpxZio4SpA6/MIpuGr
         U1bVsxlDNrV6i86msMpINlSoETQbH5Sl+pnQfkgzTaHbxeTcdIqPnCSpT4OKnTgNt0
         iKL/U1i/EDx2yNqCMquFnOfDnPEq+MzgXZfiOYMhERHo6IM6lmJzj1nPpma/Y6Soq8
         xg4EgiK31iMXLNDk6/2UUTc2HLVUWl4QdPfADelPrpCfVEk3PtaAVdf+5VFS4//7z1
         zDhpFqR3Ne9Mi3jwbNTFtq33knxD823+3aAVeFXp6ri5goFvO1sR7YLPKmC4kV0ArC
         VB+XN1Sd43PVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A38CFE54D2B;
        Wed, 18 Jan 2023 17:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH iproute2] man: ip-link.8: Fix formatting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167406241666.16450.5537119764924588915.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 17:20:16 +0000
References: <e59c7cdf-9c54-00e3-bc9b-22fa471bd5ab@shellforce.org>
In-Reply-To: <e59c7cdf-9c54-00e3-bc9b-22fa471bd5ab@shellforce.org>
To:     Stefan Pietsch <stefan+linux@shellforce.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
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

On Mon, 16 Jan 2023 20:41:42 +0000 you wrote:
> Signed-off-by: Stefan Pietsch <stefan+linux@shellforce.org>
> ---
>  man/man8/ip-link.8.in | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [RESEND,iproute2] man: ip-link.8: Fix formatting
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d7f81def8401

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


