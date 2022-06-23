Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6A556F95
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242642AbiFWAkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359870AbiFWAkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF90D41990;
        Wed, 22 Jun 2022 17:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A87461C03;
        Thu, 23 Jun 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6F13C341CC;
        Thu, 23 Jun 2022 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655944812;
        bh=A1EGORw9vDUlCxlFuop/1wJEsKGoSa+8gC8JZqhc/z0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JsecQMgyW1KZ3Ogc4zNxDhiJn31OykCJYokSPGpvmc+Hqx+5PjYiYCkJSeJAkNKDf
         ZPIj8Ccm6HKgs37HdRWg1tSbIiIXIsD+mY36AtwR7WaNu44+skoejJtq1jRDw5N0TA
         3yW0S0vMvsNuPTGlhGbXvgio+XTFDR5qljL/Eqnft/FsS681s4bcQaTTnXHSU3toff
         2QSWcHVmnxdRZ4E0PX/bNKNjuR8kHepzUV+EfaFlAx2nu4jZN/BqEzBWvLwXWjWR7d
         j9m334Yy8slzssxaTsAuegMfGmZmmfW/avcYg71yjFAHFM4bVfZ0pS0qBVacrvR6nT
         FlHDO7QOG693g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F8DBE574DA;
        Thu, 23 Jun 2022 00:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amt: remove unnecessary (void*) conversions.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594481258.674.15645489866175080516.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 00:40:12 +0000
References: <20220621021648.2544-1-yuzhe@nfschina.com>
In-Reply-To: <20220621021648.2544-1-yuzhe@nfschina.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com
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

On Tue, 21 Jun 2022 10:16:48 +0800 you wrote:
> remove unnecessary void* type castings.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  drivers/net/amt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - amt: remove unnecessary (void*) conversions.
    https://git.kernel.org/netdev/net-next/c/d13a3205a717

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


