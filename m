Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35FF56C639
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiGIDU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGIDUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8F6709AA;
        Fri,  8 Jul 2022 20:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 586416262A;
        Sat,  9 Jul 2022 03:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8CB9C341CD;
        Sat,  9 Jul 2022 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657336813;
        bh=R6/iHOnE0zXysXfw2xxqdGSoLFEc9csQJn0sIpDa4P4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lCX+BvaViT6PDQ+wBmO+o+hB0Bz3T63My10hh0k5hM3TGAifqPA27vECA2Avl0uOW
         /SYk+eiIscsAOCVNkwSTd4NykVlp97lncKnwGtI2qJuaE8D8sK+7FVNLg79tJBQg9I
         /x4v5biGHfWFeAY8uyRCU2ML4FVOrW6urhtIaN1u1o6TYMR9yOwnwwg37qu7sbT3AE
         vCPit1coAvd3HE121pOMMkEsGExuYwqDSFUPCc7/Tj8ovRl1sW5xNQzdl9kWnxUbcv
         fPTCJi7/eHiKnDIFL549TIhZMPu5IfQZrDMVzkJBVaGmZ+EX8Vk/lP3avY9dXGlPPj
         iSPdSH1d6+TAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9278CE45BE1;
        Sat,  9 Jul 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: rxrpc: fix clang -Wformat warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165733681359.2987.15825451624202428901.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 03:20:13 +0000
References: <20220707182052.769989-1-justinstitt@google.com>
In-Reply-To: <20220707182052.769989-1-justinstitt@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        marc.dionne@auristor.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        trix@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  7 Jul 2022 11:20:52 -0700 you wrote:
> When building with Clang we encounter this warning:
> | net/rxrpc/rxkad.c:434:33: error: format specifies type 'unsigned short'
> | but the argument has type 'u32' (aka 'unsigned int') [-Werror,-Wformat]
> | _leave(" = %d [set %hx]", ret, y);
> 
> y is a u32 but the format specifier is `%hx`. Going from unsigned int to
> short int results in a loss of data. This is surely not intended
> behavior. If it is intended, the warning should be suppressed through
> other means.
> 
> [...]

Here is the summary with links:
  - [v2] net: rxrpc: fix clang -Wformat warning
    https://git.kernel.org/netdev/net-next/c/5b47d2364652

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


