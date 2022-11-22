Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C00633489
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiKVEuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiKVEuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144B27B19;
        Mon, 21 Nov 2022 20:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B87B61552;
        Tue, 22 Nov 2022 04:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5291C43470;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669092616;
        bh=aIHyIO7Mb7Op0kIlPC6qfh3YvIEI+gbuw1PEjGmDY64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ECnuvu0/zigi7LmiP2bmuLRkffmS8JsmWoE35LkM8cfM07+xqG/rFacfLhOYyJzY1
         kMMHiOWEHkBuKd268HWvFZwqso/QKuIigkRY23xbiw7ZCsn8FwvdSvF25A3wOE3Lgn
         nJYnvbVNavpKZidx/uIkb51htCQ54iLVkTMuErRZs27zGJQRs6qbeDoh6xnFocQGrI
         I1njWyyFGpxYzscbumYuuyDIPoNF2JpUa0klERCi6nRMQD3q+Rf4DqvO8DeDenIkqE
         pZebuZ27rMGkOLunHMIGPY0UpEitPjgAklVzVp1fWVJrWtZa/xD1ffaIExOOn3n9Pa
         rhml/lYLxTGRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAAD2E270CF;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: fix uninitialized variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909261582.32298.17891541863341490595.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 04:50:15 +0000
References: <Y3eg9Ml/LmLR3L3C@kili>
In-Reply-To: <Y3eg9Ml/LmLR3L3C@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     davem@davemloft.net, steen.hegelund@microchip.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, casper.casan@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 18:12:52 +0300 you wrote:
> Smatch complains that "err" can be uninitialized on these paths.  Also
> it's just nicer to "return 0;" instead of "return err;"
> 
> Fixes: 3a344f99bb55 ("net: microchip: sparx5: Add support for TC flower ARP dissector")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: microchip: sparx5: fix uninitialized variables
    https://git.kernel.org/netdev/net-next/c/4e9a61394dc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


