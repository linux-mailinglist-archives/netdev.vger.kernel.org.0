Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2981D560FE5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiF3EKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3EKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F94F2FE5D;
        Wed, 29 Jun 2022 21:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5B8620B1;
        Thu, 30 Jun 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05526C3411E;
        Thu, 30 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656562213;
        bh=fXYvZPfyns1J5WvNPNDAvFk8usO3hW6ZIh7KRpxP3ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qcnZad6CmCgeVY9+V/qJuNgnEnb3/obn7yaUc1I1HwrHUnVqdKBCBxvCFB6atDEv1
         sET2pkhlETjsCc3Knp2CT7IpTZd6e3YaIG1q5uAc3gKpas9diB91B8kXD6uqQoxzj4
         yKrA3fO5VQvdW/KsvJbtpeCz58I4ZFvXK0C6GyybOmCizBE101s7oyVtwtfEApGo+f
         U0lcU84TvcUmYBhMcjBRNPHrqm31BVCCHnIvGdyeM8CQMy3aLqszVk/dli7hiFWEt3
         QrD1u4hg3RJkdNyI1a2MPjAdDssjYMAOMa43FLZCfBJiQese6gK2SMx6kVpUqhvqb7
         HhPUPW/bWRz8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAEEEE49BBF;
        Thu, 30 Jun 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: rzn1-a5psw: fix a NULL vs IS_ERR() check in
 a5psw_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656221289.5522.9931632695235942870.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:10:12 +0000
References: <20220628130920.49493-1-wupeng58@huawei.com>
In-Reply-To: <20220628130920.49493-1-wupeng58@huawei.com>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     clement.leger@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liwei391@huawei.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 13:09:20 +0000 you wrote:
> The devm_platform_ioremap_resource() function never returns NULL.
> It returns error pointers.
> 
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: dsa: rzn1-a5psw: fix a NULL vs IS_ERR() check in a5psw_probe()
    https://git.kernel.org/netdev/net-next/c/626af58bad58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


