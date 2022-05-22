Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF0530593
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350908AbiEVTuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 15:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348159AbiEVTuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 15:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326CE3A18C;
        Sun, 22 May 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B97B80D25;
        Sun, 22 May 2022 19:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DD85C385B8;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=NMie+zMjgUFb9xem6aAKU2aPrYNhijlFAIdYLUDVvfs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pgc5v3WQ3mBMiTqZHt2rGzMY5QOIcO/m3b978zudjP1fzG/QxSMoK/ScELm2WBFXi
         u5d4hvGhnwL6VUNwB1s52byYH5++7Bi3a6D4cz1APGGGfU2N6kJ6M+o4JWR/vuquVQ
         zgHpOv7ptFTAgrl3Jfhi7aH2IG0rZW/lny2kEOikfVAkA1YT1kuTvBL0cwl04RCNRj
         Zkudr1COp2lwBbg70dNbWiR6XoP4qxyFe7jzKLxZvtoWdDXlSQl7ZlS3ASFsjlm0sQ
         Po0gT4SQXh8X0MlsD7Nnx+Gp85buhBnSjOEgliUM5+tPrtnrCuXxyEA22T1Deuqty3
         lnLNXOd7HYfrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5344AF03941;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: fix typos in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901233.28407.5447916136960718691.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-78-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-78-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     aelior@marvell.com, kernel-janitors@vger.kernel.org,
        manishc@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:11:28 +0200 you wrote:
> Spelling mistakes (triple letters) in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h |    2 +-
>  drivers/net/ethernet/qlogic/qed/qed_vf.h      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - qed: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/60f243ad1426

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


