Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEA528250
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbiEPKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242710AbiEPKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED923BFC;
        Mon, 16 May 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D0BB81095;
        Mon, 16 May 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18AB2C34116;
        Mon, 16 May 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652697614;
        bh=Y6hxtYOR0XmRhsmlJDZ1vs1lnO++NYaI1tisxd71by8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pkSoOexawVRnmAg30AS9iRwT3Dxx/oVtp4QAt6D+HAVZIX9sIc8xTZQLtdiM7rQ5V
         /DSRPWhJdo86gO7qiZ5HNvX74eEzwzF202ATYTSy66UjgxeSNpCU2umxCZxfDPDrK6
         3cAKGJWn5dsROw1w0fuAJjOkxF9P4lzaqt/UlLssZQmJSmzwqSS31gtTtdGl3dy/3o
         rNZj78zcGz1NLW2YXGplf49zKUqr2HhjETOGnSWhDPjuQ8r5N8kfMXKT+zXUDu93Rz
         OyrA3A3p/nKeif8b3xF9pLJwE+C04bQWZX9GVTpVnZaOUodUcbRM5atg2+RMeFd/f5
         S3evtcMXF5moA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA577F0392C;
        Mon, 16 May 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 -next] octeon_ep: add missing destroy_workqueue in
 octep_init_module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269761395.8728.8751910697744909015.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:40:13 +0000
References: <20220513071018.3279210-1-zhengbin13@huawei.com>
In-Reply-To: <20220513071018.3279210-1-zhengbin13@huawei.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gaochao49@huawei.com
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

On Fri, 13 May 2022 15:10:18 +0800 you wrote:
> octep_init_module misses destroy_workqueue in error path,
> this patch fixes that.
> 
> Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
> v1->v2: add Fixes tag
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> [...]

Here is the summary with links:
  - [v2,-next] octeon_ep: add missing destroy_workqueue in octep_init_module
    https://git.kernel.org/netdev/net-next/c/e68372efb9fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


