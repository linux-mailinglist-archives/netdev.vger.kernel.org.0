Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63CA502828
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352235AbiDOKXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352283AbiDOKWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA840AC05A;
        Fri, 15 Apr 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 888BEB82DEE;
        Fri, 15 Apr 2022 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46B35C385A6;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018014;
        bh=PaY/ntdZ5Yibo6BVXe7E+AX6IN9dt5+Gh5e51jh8ERw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tndsMcdHLKiFPAx2otn6O6h3Tu+35qdwnNuW8KGghrc2B0593Md1rOwzNsCZUOVXJ
         9KeIsdjodzOqljxz6ZJiFDgbSZE6SRy2NFDOOg4KmjVAWPKmaWyZCscJvOAHPk6Bwu
         acgkuCFbpVFZie32MJmGRYtHoGbtJc94a5UnmDPClk/ZFPilEmxIhg999/TNXgcoxP
         /R7WEV76DcwEcQJyzMpTEnZDiUFJQg8B0UBvZ2SXUCnEw32xbtvqqGi1VVEH29ZSLk
         ffbbJwPp9YIDLmClNvFZN520L5BfK/47QzjF/6E2p7vz1FpG1o/OuQ/fisxDlKNe0s
         7t/zemAu9yqzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F0F0E8DBD4;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeon_ep: Fix spelling mistake "inerrupts" ->
 "interrupts"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801418.12692.17059813313427087802.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:14 +0000
References: <20220414080834.290840-1-colin.i.king@gmail.com>
In-Reply-To: <20220414080834.290840-1-colin.i.king@gmail.com>
To:     Colin King (gmail) <colin.i.king@gmail.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 14 Apr 2022 09:08:34 +0100 you wrote:
> There is a spelling mistake in a dev_info message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] octeon_ep: Fix spelling mistake "inerrupts" -> "interrupts"
    https://git.kernel.org/netdev/net-next/c/bb578430d05b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


