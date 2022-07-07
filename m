Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFC7569880
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiGGDA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiGGDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3692F3BF;
        Wed,  6 Jul 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B368DB81FF1;
        Thu,  7 Jul 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 144EEC341D4;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162815;
        bh=i48NrE/vFNFSuqXPKlsGMWYna9TAb9tFN3I8/qt+QcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BDtSXzYvWFM9aYhF/+tWuSfrJPX2LboOM9P11f24OmrWS2CWFTgfKL0WGjhHXD53N
         uLMzxGdy4eg6tj9qk0ekCoEzlYbjrpt7HdDq/Ygmd6F8gTB8jU//3A2Nnp29EQei2a
         Sq/tJnjkFxFVnVyou8495Yxziwfb1gP6vk4+N2sYpdLtyNrMHo1TlSEZVJsjQObanr
         bjKgaejSBI8fa4+xHO5paE6T4pbAfxQtqiIWRNzmIrvPShcXJG2NgHl51sjUJTWXo/
         0kuXFvJCGoAob3tRZN31AaFbeOCn6TJd6gYwGX2PgCGaXj8D+bgSr4SNy672Xvfadl
         wKVjttG7kB6qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6552E45BE2;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] qed: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281494.11165.14076578722724177412.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:14 +0000
References: <d61ec77ce0b92f7539c6a144106139f8d737ec29.1657053343.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d61ec77ce0b92f7539c6a144106139f8d737ec29.1657053343.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Jul 2022 22:36:16 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [1/2] qed: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/291dbea16c71
  - [2/2] qed: Use bitmap_empty()
    https://git.kernel.org/netdev/net-next/c/7ed5f2454acf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


