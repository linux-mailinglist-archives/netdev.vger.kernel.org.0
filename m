Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE956987B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiGGDAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiGGDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648382FFC4;
        Wed,  6 Jul 2022 20:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5B5C62162;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12327C341D2;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162815;
        bh=eQg95j9MS8oSrF+FZix091yuv4/xQ7WMtBdaRKbDzXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ke7l0Kv8+4CE63vq9BphytQ61Yqjj2/2+DiAXkLc3AZ3HDk3NcpN4jfG4Eva07L3q
         VN193mKLwp8ngETbp07HWChhQV3+nHzhKen6bA4WJNbgaIbutmlPoPE8ncqyAFmOv6
         Q21eeW/mjGpzOxvpwq3/vkxkuZ+Zbh5nSpXcab6/9baW+ikoF1oW23sJv21qo0zXVb
         m/ZikDsSQ+QUb7w7iddwIqcaWyGnvYtQdBYlfgp6mK8f5wxZmrcvEVceHh3RJeKLuM
         v5B+8Jq0RGkMi4ZNhI/lF03354QZ10YE3p15tccSxaXsg0Mso2438TWH0C8HOW4PPv
         wqVfYfqxxUbJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDDBBE45BE1;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc/siena: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281497.11165.11472596147049333164.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:14 +0000
References: <717ba530215f4d7ce9fedcc73d98dba1f70d7f71.1657049636.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <717ba530215f4d7ce9fedcc73d98dba1f70d7f71.1657049636.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 21:34:08 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/sfc/siena/farch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - sfc/siena: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/820aceb53c75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


