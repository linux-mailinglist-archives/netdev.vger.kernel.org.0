Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDF52B07A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 04:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiERCaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 22:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiERCaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 22:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0F65419F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 19:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57871B81E5B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3B22C34116;
        Wed, 18 May 2022 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652841012;
        bh=6mfJ2A74KXhSfL5oMzS3B5+TEaE3xSxG6vWx8xgLvMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nVpqCJ4Ix+VMzXQbNEQfjS1bhElxbi3k1AGQjRSUuGyDABebYaBBPPxA0Wb4DzCXg
         PfCIunmuQO9phMKGT0H8jzNrNZJgtDKPZ8llem/UrcqIrnJ+8vTKHZiuEgfY9FdD74
         iStKxrTnCp+IeEzXhLYuKSHrTp68/PQOVvy6Y9Yp8VHBCrGEU3MRuuQRQEMPBLlt6O
         MpOD1G5sud2fSOH28jF6uvPzoDFBYZluFV3RiLmTKHAWQA57rCAgldpC2eacf7/GoO
         ZxBzxpurfBMOd1WFpnZuNnVZE1k9K6CvKnQ0+51Z04LCx8wu/Glem+BFuje1oC3JaJ
         ys53RE3Vy6rJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8B83F03939;
        Wed, 18 May 2022 02:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH V3] octeontx2-pf: Add support for adaptive interrupt
 coalescing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165284101181.6734.13932418119941696594.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 02:30:11 +0000
References: <20220517044055.876158-1-sumang@marvell.com>
In-Reply-To: <20220517044055.876158-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        gakula@marvell.com, Sunil.Goutham@cavium.com, hkelam@marvell.com,
        colin.king@intel.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 17 May 2022 10:10:55 +0530 you wrote:
> Added support for adaptive IRQ coalescing. It uses net_dim
> algorithm to find the suitable delay/IRQ count based on the
> current packet rate.
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
> Changes since V2
> - Addressed review comments.
> 
> [...]

Here is the summary with links:
  - [net-next,V3] octeontx2-pf: Add support for adaptive interrupt coalescing
    https://git.kernel.org/netdev/net-next/c/6e144b47f560

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


