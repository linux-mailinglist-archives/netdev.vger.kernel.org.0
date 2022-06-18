Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C146550269
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiFRDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383818AbiFRDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EB049F91;
        Fri, 17 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B032B61FA7;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12BA3C341C7;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522415;
        bh=8A09UC3fHY0+S2enUNXLDDZQY5tNVrodR5/L5d5mi6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QHq84dokHFJL/vxJuIvon2ouUddEPwbAYgLxY1B94qJdaac/exHePo7pcpRVBHfFw
         iiNGM3X3qXhjzpk8FhZ+iadu72KB5vboDyw7MPUVEEBKgy8Tq/5gT2Xlq1n6NxDWmf
         G+eLaiGor5cd7aS0cCKHN5B8KNz9Rkm3H4Dh1oi9l85BA2q90rxSJ3WcrX1Yk/rgKq
         jgHLRnwJRClzO9eiOj5JW2fwbMxCTy9URT2U693E4sykijJkgx/R04s8bpFUVTzJLt
         gR+aTp9WTMgbSUfmf9T998e3Cfp7mXcYu6tWo6AG7nf7LazDMB/DjqUtq5CVs2Qq38
         93847jzAs+blA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF96BE7387A;
        Sat, 18 Jun 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ppp: Fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552241497.3144.12035753445124943127.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:20:14 +0000
References: <20220616142624.3397-1-wangxiang@cdjrlc.com>
In-Reply-To: <20220616142624.3397-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     paulus@samba.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, 16 Jun 2022 22:26:24 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  drivers/net/ppp/ppp_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ppp: Fix typo in comment
    https://git.kernel.org/netdev/net-next/c/959edef6589d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


