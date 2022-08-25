Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95B15A1A56
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiHYUaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242966AbiHYUaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC4A4B03;
        Thu, 25 Aug 2022 13:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F7861950;
        Thu, 25 Aug 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F5CAC433C1;
        Thu, 25 Aug 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661459415;
        bh=CMYQBReLM5r+YLqaOB0k8lRI1ZRkAozpKI+rDmosxog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d33+GJiNocZLiwOdXC8r484rR5hsk3VzTCunLrIjZ/ABxcdRnPLU7ODwGc+IHfU5K
         oXk2gdimYLUjPOCdOQ1sPqW0rBZ2YEHeDklEFWemqfGUHHqCHy+EcAw78A79llMSS0
         LHKDZ431hhswRC5PVQEPHeK7TdOLFhwm2RxjZcS9JVDrlZrjUlADLnlhNW1azGNOy9
         ClsqLhvqqxYTviavygcjPtr0+ygthCA1++pxYBpxtQ/YrXUj0xcP7HZu9yx5XfGDGH
         Lu4O0cZ/uyeW0w9pQ7cUD9RYg24wSl1mHm+cKXXDx+nsXiSVoQx6wK60F3vJErI4TE
         xPk7aPNR2DMJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 116EEE2A03C;
        Thu, 25 Aug 2022 20:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] Fix reinitialization of TEST_PROGS in net self tests.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145941506.19511.11363974197717306541.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:30:15 +0000
References: <20220824184351.3759862-1-adel.abushaev@gmail.com>
In-Reply-To: <20220824184351.3759862-1-adel.abushaev@gmail.com>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 11:43:51 -0700 you wrote:
> Fix reinitialization of TEST_PROGS in net self tests.
> 
> Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] Fix reinitialization of TEST_PROGS in net self tests.
    https://git.kernel.org/netdev/net-next/c/88e500affe72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


