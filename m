Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0B4D2EF5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiCIMVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiCIMVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:21:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C2117582C;
        Wed,  9 Mar 2022 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E900B81FE8;
        Wed,  9 Mar 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 010FDC340EE;
        Wed,  9 Mar 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646828411;
        bh=iQq+kf4QEqu6rI439qE6mhUdtukttTeH6DcB2IE3W7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ya+niBttaBjVgi4suNpRKzPFKt1v9Kv2XMHAnzN6ZXN81Qj69dRifOF6f72aKcswx
         ey/mxQ7B2FKLyfDx7zIjKRsdwopdXcOYNGpBvZxm/zpYEQyOiVicgvSvN2u9p8AD8K
         Nxzyp80LCgkyjo6ayMpSqnHiTJx/nGPtmW57GWEzjY/CjJKTNKpIT9QOGDFLbMt+NZ
         +QmtOe96yExdmv6womhmGbLzAUyBb0MFxPYlZZHW8Pe1FinVW1xz209bzTkBChaSg1
         okFStG5BQrdxN0ELbhR1S/0wwuXKCN/MnednWdhrAfeDHrXG2tOz0+jS/GPQTMKF6V
         3pm7cmM1Iizvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6DEAE8DD5B;
        Wed,  9 Mar 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: prestera: Add missing of_node_put() in
 prestera_switch_set_base_mac_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682841087.19405.7856886662835018273.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 12:20:10 +0000
References: <20220308074247.26332-1-linmq006@gmail.com>
In-Reply-To: <20220308074247.26332-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        serhiy.pshyk@plvision.eu, andrii.savka@plvision.eu,
        oleksandr.mazur@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 07:42:47 +0000 you wrote:
> This node pointer is returned by of_find_compatible_node() with
> refcount incremented. Calling of_node_put() to aovid the refcount leak.
> 
> Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: marvell: prestera: Add missing of_node_put() in prestera_switch_set_base_mac_addr
    https://git.kernel.org/netdev/net/c/c9ffa3e2bc45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


