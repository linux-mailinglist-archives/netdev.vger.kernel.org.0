Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D55575FC7
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiGOLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiGOLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9105A2C5;
        Fri, 15 Jul 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C83A0B82B95;
        Fri, 15 Jul 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38627C341C0;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657883414;
        bh=bYss9+IYFtH0EOHDF6cy1lmziErLN5zYyjAmLqu85aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gFF+NAfTyD6hec1jrepB5/zNWpfpG/y/BUiJDal2f523u8Ub/rZXdVNLeOHIbu45A
         xnSVLHFutbETYyVFzldOwYURvuIlRFmiE6PaFqbi/kERjdP56W7bmJeoVfkynm9t1b
         6HDzvKiol66T0KqZS3KCXNPZ3u9G9BE9EEM9R13fzChG2otJ7tO9Y/uiKwXmil9AcQ
         dbyZaWAzthFWv7YfRmR0rCLPNLhlpAYsW5jry4OJNI31Lj+5u26uWiKGx7rJeOznwS
         Ndy2zFL5iXHjGk+zkmT3N5lZf0saoGs+SRJvFho6f2Drv6HYYh/Rah5vigh6/2460F
         14thP0BFqcwFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BF64E45227;
        Fri, 15 Jul 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Set NIX link credits based on max LMAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788341410.15583.7509275884955373301.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:10:14 +0000
References: <20220714053555.5119-1-gakula@marvell.com>
In-Reply-To: <20220714053555.5119-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, sgoutham@marvell.com, ndabilpuram@marvell.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Jul 2022 11:05:55 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> When number of LMACs active on a CGX/RPM are 3, then
> current NIX link credit config based on per lmac fifo
> length which inturn  is calculated as
> 'lmac_fifo_len = total_fifo_len / 3', is incorrect. In HW
> one of the LMAC gets half of the FIFO and rest gets 1/4th.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Set NIX link credits based on max LMAC
    https://git.kernel.org/netdev/net-next/c/459f326e995c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


