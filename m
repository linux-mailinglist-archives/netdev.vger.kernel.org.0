Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAF15F2FD1
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJCLuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiJCLuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9712A70D;
        Mon,  3 Oct 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56BB2B80DBB;
        Mon,  3 Oct 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFB01C433B5;
        Mon,  3 Oct 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664797815;
        bh=RKe2/MWWa5TuT5NtGudLweBRLgCrZOYBXJIUblYYRFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DxRijofrGd38Ko7otc8bgX4eq7HE1rSlivch/Teb10eAbXrDUI6tGGnOGGPYKDpxz
         woOUrQe5r4GxKC7/UhA1ANlqPIJB3uKJIZSymD2qWjqQRohUbd4uhcTQ9MgT3dIkKl
         5tNFeiiTckbwwoZ+IK8QK8ZwXtia0nm+2m0OTOB+Roqzac65EWTxzcnXkdjgEekKmg
         U5K06VARKXhICHSWtNXibcsa/MHsMuy6rOhMXCsPAjExDeYUIac0Z39+daUVHRCyys
         A8mSck+Ci8f/8a13PZQdMFo/1lTng9pNjs2C06hR9NRkA+wMccvQNXFDmqLGrorUCQ
         WHj+OU594iyiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5A19E49FA3;
        Mon,  3 Oct 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] eth: sp7021: fix use after free bug in
 spl2sw_nvmem_get_mac_address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479781487.26331.6113299728662548549.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 11:50:14 +0000
References: <20220930175725.2548233-1-zyytlz.wz@163.com>
In-Reply-To: <20220930175725.2548233-1-zyytlz.wz@163.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     netdev@vger.kernel.org, wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        alex000young@gmail.com, security@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

On Sat,  1 Oct 2022 01:57:25 +0800 you wrote:
> This frees "mac" and tries to display its address as part of the error
> message on the next line.  Swap the order.
> 
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/net/ethernet/sunplus/spl2sw_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
    https://git.kernel.org/netdev/net/c/12aece8b0150

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


