Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38614D8E39
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbiCNUbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245034AbiCNUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:31:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B595E39827;
        Mon, 14 Mar 2022 13:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94B1CB81026;
        Mon, 14 Mar 2022 20:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C4DEC36AE9;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647289811;
        bh=uLLNEo2KuqE/YxBYqDJGt2C9i0qNEgY7SPcUzgiznVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KSdJV0Nr6PH56dRvpyreK8Yv2TzppJmvm4v2HhSDZlhKT0LSad1hfJvJSpzZVcO9d
         zHJi6VvKrJAmS0T3joCqvHRXlFdKQlox2FOL5o22ch62xkW78NUj9CTUmjOfKaAzvY
         9wa3Li6Hhcj84nqdq5Zqw+FFIZAxg1ebLJNn+THcBi2aSLdI7JbUIrcFov90+OwV0Q
         zv85rGj50dgH9jUKb2sZlceYR38o+H9QNFXEhxQyuN0GgSQQXFG5YXFUz2YNqo6r/R
         WJCLtYJ2RD4vSP5TpCum1H/05+0bSavkIZaGcTXiNBVaTe+d3Tmg61eQY08Sc3iO2L
         gGS1F0tzOonqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2832EEAC095;
        Mon, 14 Mar 2022 20:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/6] use kzalloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164728981116.21494.4613160192240776648.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 20:30:11 +0000
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
In-Reply-To: <20220312102705.71413-1-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        alsa-devel@alsa-project.org, samba-technical@lists.samba.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, andreyknvl@gmail.com,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 12 Mar 2022 11:26:59 +0100 you wrote:
> Use kzalloc instead of kmalloc + memset.
> 
> ---
> 
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c |    3 +--
>  drivers/net/wireless/zydas/zd1201.c        |    3 +--
>  drivers/scsi/lpfc/lpfc_debugfs.c           |    9 ++-------
>  drivers/usb/gadget/legacy/raw_gadget.c     |    3 +--
>  fs/cifs/transport.c                        |    3 +--
>  sound/core/seq/oss/seq_oss_init.c          |    3 +--
>  6 files changed, 7 insertions(+), 17 deletions(-)

Here is the summary with links:
  - [2/6] net/mlx4_en: use kzalloc
    https://git.kernel.org/netdev/net-next/c/3c2dfb735b4a
  - [5/6] zd1201: use kzalloc
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


