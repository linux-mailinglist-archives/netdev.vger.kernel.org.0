Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA84E3BEC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiCVJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiCVJvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBE71FA41;
        Tue, 22 Mar 2022 02:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77CF061693;
        Tue, 22 Mar 2022 09:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE20EC340EE;
        Tue, 22 Mar 2022 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647942610;
        bh=p/usoSYbsmz0Jijh/9aah7ymyeDbRBze0vsgWTZqz5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KosnwjP7goxB++402G2clmmDEql3S8ufYYUHatgjTJ3jIzTmCtT050fOfc+oSjaLm
         HESIH1k4mTysE5Aifj8OCxt7LnAcwalr80qLWcnnHb09uyfhx6bcVPHjKAFT05B/9T
         1NZSMPfvbdMnPXc5zvKIFZ2nYnPXr9/bseFw+Fv9HezwdJFDwk2rJvD5WWC1FoBbo7
         bsqbp9hda//foU1qHE/8evzxFo4OP8w77+EnJHlnEzDol/n4Ub2bsl7TyBGkGJVyA2
         Ia07RQYeJNEppRvjOTJUuUubsgnVpKYWTtQ5sWEOCqdVvqD7XoxA7kOwftfBL+hTsH
         HgoZlVD6h4fww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1CD1E6D402;
        Tue, 22 Mar 2022 09:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: truncate value to original sizing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164794261072.31108.16084505304692876635.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 09:50:10 +0000
References: <20220321023155.106066-1-morbo@google.com>
In-Reply-To: <20220321023155.106066-1-morbo@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 20 Mar 2022 19:31:55 -0700 you wrote:
> The original behavior was to print out unsigned short or unsigned char
> values. The change in commit d65aea8e8298 ("bnx2x: use correct format
> characters") prints out the whole value if not truncated. So truncate
> the value to an unsigned {short|char} to retain the original behavior.
> 
> Fixes: d65aea8e8298 ("bnx2x: use correct format characters")
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Bill Wendling <morbo@google.com>
> 
> [...]

Here is the summary with links:
  - bnx2x: truncate value to original sizing
    https://git.kernel.org/netdev/net-next/c/4723832fa63f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


