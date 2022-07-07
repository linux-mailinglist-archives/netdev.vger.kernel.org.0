Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6949569881
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiGGDAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiGGDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60052A965;
        Wed,  6 Jul 2022 20:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 529C5B81FF0;
        Thu,  7 Jul 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF119C341CB;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162815;
        bh=odRgIWvrDMydZj1zXqpnhJanbUfaj1HRM7ILJa/0z80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j5D+I6kHOlEmipnGACrX+hPdTH/xsyHhzA4/NZb/9lekxunutJ28Cfjg5tU9LpEHl
         rr0W1ML4sGPsD+Ooot4DeKA5FS/wlQRV3k1mFOxEfQ0GJQ3F+VNv01uBxk3tuSoXEZ
         tTGtMFFL0dNQoqvsA28U9Aw7Fnie2FnuZf1jxkUVDb4Dh1gkyIWL13xJZtUJsgoyGb
         Pv8zVhRYmhvaicEqKtdXu9n8GC7Sci7gWUrICWrkopNgG+7p4vYXAyUkpc6PpLFZpW
         O6bVM1eaKQnk3X0lw2PXSyifb16C9phq3Vpf40+NfzL5+OpUyW00zmlKK/YsBRYfIS
         ebBym7nVROcCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6F15E45BE0;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cnic: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281487.11165.4392215303964464060.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:14 +0000
References: <521bd2a49be5d88e493bcfb63505d3df91a1c2d2.1657052743.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <521bd2a49be5d88e493bcfb63505d3df91a1c2d2.1657052743.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Jul 2022 22:25:58 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/broadcom/cnic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - cnic: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/76d3c114706f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


