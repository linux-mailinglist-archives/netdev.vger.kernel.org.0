Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0F760D97B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiJZDAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiJZDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ECE37190;
        Tue, 25 Oct 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD16461B7C;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A42BC43145;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753217;
        bh=WcCEEDuWDo+3I1p80kZYPBeOxTWxJ6XBqqFDLgXbj9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dQXwb9vZ2tkW2LJ5yWLZh8APZCfwU0E9mLyb1MO4rXiE5yJdP2LhhoswXKXKJMGPK
         JAxReLzH9n209+UqO2l3b9xgJ3rtdntjjG5j/sDvoBrHE6QyPe3fdxCeOzBWzZUFCb
         PO7Fq2Fyq/9ZM9g78H1u1OMNuCS7DP1pQ/3sKKmI7HDxsh3GDnyJgldFnDC5SAkbTb
         nU2eYSYqNL2dV8qhlfNcZ/HkiHXWRRFOum/LPmZftVjkD1FvppwSAp1ZJtut3YiqTc
         LC4vxzyemzU1vMdsXtCsi4Pdvpfz27L5UWpgl/5CEheM9Szb4jmib2LjayhOSZSdEm
         xWgvfQIPyFTXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06C96E451B2;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dl2k: remove variable tx_use
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675321702.7735.7412985831622250762.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 03:00:17 +0000
References: <20221024143501.2163720-1-colin.i.king@gmail.com>
In-Reply-To: <20221024143501.2163720-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 24 Oct 2022 15:35:01 +0100 you wrote:
> Variable tx_use is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/dlink/dl2k.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - net: dl2k: remove variable tx_use
    https://git.kernel.org/netdev/net-next/c/d0217284cea7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


