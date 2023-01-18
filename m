Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9263567120B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjARDkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARDkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B7C53564
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8221461627
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C706BC433F0;
        Wed, 18 Jan 2023 03:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013218;
        bh=gnuxYmxdC0tZPGx08dNZkTSgVLdmf7UYPOhv3qeUB1g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MtWVzP/qNJ7e1jZnTf3ehOdnc2pd31dejLZ8dKYVACcuSnZH3jCYcuI5VMz0kF3qf
         S/rbnMxnJeuptS2ccIfnr2/HK4+OCenPxh5SBdRW1ZZ4UWQ3GanyVTwxEukJxNid2I
         38IaFpkLIkJXx3S3d8edtA6VT/9aQveENaanQCsPRaw8rSOXiVT4t1eMDymqLLJLQg
         59IEKTVsfPZ43Tss5FmiOGNDA5aTNcCjv7tjXrYnKPzk9oo+VIYVh8qNqAkwLqbQ6+
         JPI0C2eRH7LwFha4CVYuV85BnPLTTKNSNq+mX4Qj+XxaGzT5y1SsP1Sr/am2xr7yCf
         Dsv38nqWwoA4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE969C43147;
        Wed, 18 Jan 2023 03:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wangxun: clean up the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401321871.20942.10182326807574959942.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:40:18 +0000
References: <20230116103839.84087-1-mengyuanlou@net-swift.com>
In-Reply-To: <20230116103839.84087-1-mengyuanlou@net-swift.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 Jan 2023 18:38:39 +0800 you wrote:
> Convert various mult-bit fields to be defined using GENMASK/FIELD_PREP.
> Simplify the code with the ternary operator.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 22 ++++++++-----------
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  | 15 +++++++------
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  8 ++-----
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 12 +++++-----
>  4 files changed, 24 insertions(+), 33 deletions(-)

Here is the summary with links:
  - [net-next] net: wangxun: clean up the code
    https://git.kernel.org/netdev/net-next/c/860edff562e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


