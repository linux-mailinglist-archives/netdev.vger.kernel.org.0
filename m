Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235D8566893
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiGEKuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiGEKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913CC1571A;
        Tue,  5 Jul 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4D4AB817A4;
        Tue,  5 Jul 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64E86C341CE;
        Tue,  5 Jul 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657018213;
        bh=Zju8PgWdr7J2dERf9vdpnSRo6wsOxov7rQt6c/MOlSA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P5F47ZOfJ2bwK3QVtwpDCr/kwh/YFQgrKuA40mRGMD0YnBU8Mka0kqUSpd1kbSEEa
         26T+2m46IBW2sB3fnl1hNfKdCsoiN34dU7AG33x35oJ5ETqBt5+gYE8fVrf/yhD9cN
         DwDEbWXMxMYqci6vUfWX/47vya2C6Pd/0jHikH0DuUz38c/JtGxWHbH/B4vUFxWHVy
         3LGj0V4MbpypJo47OJHJU8MVjvAFzZJm8bIdlvrB5vbf7FhOe+mFgLCDWXlzDRJOGl
         NkJDG7qEjdcWyOPDVWaBuFvmNFL9Bs4zaxfnDgPzeX+7I112RYL5SatDNfxcoqe42M
         ZW0MTDDqYlH3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49DF1E45BDD;
        Tue,  5 Jul 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701821329.25151.17504921483027163278.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:50:13 +0000
References: <8a2168ef9871bd9c4f1cf19b8d5f7530662a5d15.1656866770.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <8a2168ef9871bd9c4f1cf19b8d5f7530662a5d15.1656866770.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  3 Jul 2022 18:46:36 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> While at it, remove a useless bitmap_zero(). The bitmap is already zeroed
> when allocated.
> 
> [...]

Here is the summary with links:
  - cxgb4: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/ec53d77ae3d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


