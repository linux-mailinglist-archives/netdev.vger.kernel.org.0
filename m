Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B84A92B7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356785AbiBDDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356776AbiBDDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B38FC061714;
        Thu,  3 Feb 2022 19:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F98D61ADD;
        Fri,  4 Feb 2022 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 843E6C340F2;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944810;
        bh=4qQw+m7netDlJ1zlzAw6Zq8tGCpnv4Jmm4CL7Unbbdw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qGKvrquO4nOQ44xYb7nQIZnBgRda7xzob6nzFot2PnsqdDxr+PtrGEIA9x3DX1RNW
         rVFqYe8qLe8zOxvPAiT4J1b/tovwVaz2bl+ZPTOiVXAzi0CE9FQocI37ZtTsQial6S
         MVObFVg/m5nj45V7geeV7zegqlI3+kXRoOKYi5pG/MLvSe+qEASwqQPCG5ZvhVgbd4
         bRB2u0CuM5Jpbn6g/yeo4k+079Yhshy7zzXvJkJEihIbAJuBL34l68kGah5R58r6E3
         0CI9XVQXWKXOuh0fntFyo/t9nSdh6NKvL+di49CHNAPxP1pQ9P9nakhFlp8F0+gDKO
         5YLUgoW0VQ3lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 708ADE5869F;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: rtnetlink: Use more sensible tos values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164394481045.31803.6913798555291608482.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 03:20:10 +0000
References: <d61119e68d01ba7ef3ba50c1345a5123a11de123.1643815297.git.gnault@redhat.com>
In-Reply-To: <d61119e68d01ba7ef3ba50c1345a5123a11de123.1643815297.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Feb 2022 16:24:21 +0100 you wrote:
> Using tos 0x1 with 'ip route get <IPv4 address> ...' doesn't test much
> of the tos option handling: 0x1 just sets an ECN bit, which is cleared
> by inet_rtm_getroute() before doing the fib lookup. Let's use 0x10
> instead, which is actually taken into account in the route lookup (and
> is less surprising for the reader).
> 
> For consistency, use 0x10 for the IPv6 route lookup too (IPv6 currently
> doesn't clear ECN bits, but might do so in the future).
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: rtnetlink: Use more sensible tos values
    https://git.kernel.org/netdev/net-next/c/95eb6ef82b73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


