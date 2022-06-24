Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE8559AA5
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiFXNuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiFXNuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 09:50:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB694BFED;
        Fri, 24 Jun 2022 06:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9367DCE29B8;
        Fri, 24 Jun 2022 13:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7554C3411C;
        Fri, 24 Jun 2022 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656078613;
        bh=3UkPy7STqFRs8CQ0EKjj66l2bP7z9nK2keUVGhK0LJE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oshD4W5FRHMmpHpTdoXitxwhEiDe7BtTr8iuzsTS/3iwgcceu4wAKmSpKPZ1eObKa
         srI8U8xL29RCRhZDJAM/dpkGAfKenzzjVlbAFKTu5S4oftLMKQ+uCzkcWKRJ2dsQh4
         jGoiIh4zorBzQyNr/ljQ7/kdyRjkHjvk42MoaObdI2DRzQF4Jp0InTzd2vz1/Ent/Y
         b7ZtoCD4xJlIG62W2IFEj8ZbBx84TbkDmbGDCAVIxmo8JReqiN0fYDjmxRLHTCMOL2
         6taBAUeZjUdyGti5MscwJ/S+SgJJzKnhRNPD4WGhb41ALwjGyOB9qc/zn3nCpqTLno
         tLth+AOdlVkFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AEA1E85DBE;
        Fri, 24 Jun 2022 13:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Replace 0 with BPF_K
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165607861356.799.9349241350259159003.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 13:50:13 +0000
References: <20220622031923.65692-1-wangchuanguo@inspur.com>
In-Reply-To: <20220622031923.65692-1-wangchuanguo@inspur.com>
To:     Simon wang <wangchuanguo@inspur.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
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

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 21 Jun 2022 23:19:23 -0400 you wrote:
> From: Simon Wang <wangchuanguo@inspur.com>
> 
> Enhance readability.
> 
> Signed-off-by: Simon Wang <wangchuanguo@inspur.com>
> ---
>  kernel/bpf/verifier.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bpf: Replace 0 with BPF_K
    https://git.kernel.org/bpf/bpf-next/c/395e942d34a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


