Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF445F9A48
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiJJHoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiJJHnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0081E3FA20
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 00:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9078F60E15
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8FDBC433D6;
        Mon, 10 Oct 2022 07:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665387614;
        bh=0xVPmeM08vUL9IQLEQhfNFRRFAKupF+u+OquJP7Zq4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XdDCu8gQ0LkHVmDCMSy8vzF2BSO8krFXTjWAUBRkpAuXBz1z9zVhEsaWkEx/dQJdk
         hBnMSHVM3aYgkl85xihTm+hirDxmicx8cbBoLCE5Eadv3PBvz4Sal1DTjHqKfy2Xh3
         kSCGdSiaocdAebeSDa/RHv04qVXxps+DYIWYWa0F3CKzDvYR7Lxc2ZFmMMjhMm44Kv
         I0jh/oj/A0vQ/BJ/2gpf14hxdOE3lclpxHJzZg+AjLUUugh0Og7muWULGQ7TENavEL
         naqi8S+FUcVGYaK7caR4ql2MrALWhwP1ee7Dp2uV2jrw6IchC2zVY2v2+1B3LJAgiw
         lw4QHiWmMfQiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D04C6E50D9C;
        Mon, 10 Oct 2022 07:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: cn10k: mcs: Fix error return code in
 mcs_register_interrupts()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166538761484.497.1769879705240212519.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Oct 2022 07:40:14 +0000
References: <20221009015126.4131090-1-yangyingliang@huawei.com>
In-Reply-To: <20221009015126.4131090-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, gakula@marvell.com, vattunuru@marvell.com,
        sgoutham@marvell.com, sbhatta@marvell.com, davem@davemloft.net
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
by David S. Miller <davem@davemloft.net>:

On Sun, 9 Oct 2022 09:51:26 +0800 you wrote:
> If alloc_mem() fails in mcs_register_interrupts(), it should return error
> code.
> 
> Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] octeontx2-af: cn10k: mcs: Fix error return code in mcs_register_interrupts()
    https://git.kernel.org/netdev/net/c/b2cf5d902ec1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


