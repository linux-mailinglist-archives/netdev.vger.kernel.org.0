Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A408D644278
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiLFLu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbiLFLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF027DE9;
        Tue,  6 Dec 2022 03:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE8C0616D0;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37155C433D7;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670327416;
        bh=g0iiRpDFeldqd0FblsKlLaBWUTPZG9jnZwlisgPQLhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pvdNd2p2lMwZu+0DnVJS0u2fBcdzBySwlDnhp6IMDjKu8HQHRA0+301aST2hR2i6A
         R5tPsvxXtICQwU5k0UmSbKKbuL79gkNlzOskR6RNoDhDvawISjf/sxU4YnugK8+Dhy
         W7L/dhPha7bKJ8xp3g7QqNCDMpCS5U9y2ldMDvtxiDDqOnmfio5Aj4QRyM5wgp8wOW
         nrLwFpfVrS/loDbMYog98+qUYr9d962GqU9Y5LhGA8c/gKPSRh+UKQXlyLt7GudZEc
         5AP8YBELzjl4SMfcGAoct76WMe31abv5KdR3Hy0J9wPyXhdxWj9CU1hzVMJZ0IUL4D
         uEMg3RJ6MyBug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14C24E56AA2;
        Tue,  6 Dec 2022 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ravb: Fix potential use-after-free in ravb_rx_gbeth()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032741607.10641.2043445047483476004.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 11:50:16 +0000
References: <20221203092941.10880-1-yuehaibing@huawei.com>
In-Reply-To: <20221203092941.10880-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, phil.edworthy@renesas.com,
        biju.das.jz@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 17:29:41 +0800 you wrote:
> The skb is delivered to napi_gro_receive() which may free it, after calling this,
> dereferencing skb may trigger use-after-free.
> 
> Fixes: 1c59eb678cbd ("ravb: Fillup ravb_rx_gbeth() stub")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] ravb: Fix potential use-after-free in ravb_rx_gbeth()
    https://git.kernel.org/netdev/net/c/5a5a3e564de6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


