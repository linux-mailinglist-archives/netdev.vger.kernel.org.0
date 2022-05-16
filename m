Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C93528292
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbiEPKuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbiEPKuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA94275F3;
        Mon, 16 May 2022 03:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4534B60F75;
        Mon, 16 May 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9106C34116;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652698212;
        bh=wRNyfCK/WPWxXzFGZ/xTULv4XtjZo+urdccl0BTZEcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qvk7CoITCK8k6Rvv66oS0vJI1OIpt1jvBuZoIOTP6hwbrAJaX62v7VqUP37uqcKuK
         TNSDpoOAS4RdJj6noC4/1yQVWURPhJPI2vfe9D4RtYcQAdpcQ/ql8iae04RFWlm9DH
         aSjzaTxEH+j1sxF6am6C4hGfr004nbEIUHANMIPbAU6ZZnT2yPsIk+OGSGHcILz018
         0OfZ2T93ywBsFSzJD5my1DRk0mbQeoVlG1frCVeItnUuY4/IppRA5wYp89arYav4Q2
         1nKceOJbgCwjHfZiqpd6LIHcTp40UKU5ZMZ9aIAC/A43n015blz3fKDiI+KValUC4o
         FjGak9qWh+azQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9446EF03935;
        Mon, 16 May 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeon_ep: delete unnecessary NULL check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269821259.15644.6055083761195107529.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:50:12 +0000
References: <20220513072928.3713739-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220513072928.3713739-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 May 2022 15:29:28 +0800 you wrote:
> vfree(NULL) is safe. NULL check before vfree() is not needed.
> Delete them to simplify the code.
> 
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 3 +--
>  drivers/net/ethernet/marvell/octeon_ep/octep_rx.c   | 3 +--
>  drivers/net/ethernet/marvell/octeon_ep/octep_tx.c   | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] octeon_ep: delete unnecessary NULL check
    https://git.kernel.org/netdev/net-next/c/1dee43c2c6f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


