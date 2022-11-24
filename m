Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8E637470
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiKXIuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKXIuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54723CFA47
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 150BAB826E2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABEF0C433D6;
        Thu, 24 Nov 2022 08:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669279816;
        bh=rN6lYpGR4hfGZqKJBXgNgvEij7tmj9gxLS6jiQFHzAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G/AuN604yGUTsdNfzFX4g/+3/Q4UUXpT3KlFwKqXQzqoEnheWSmdg/FqG7OMxuz+3
         mgA2ooygtNgS0vv0KI/AGcBFlEXVpmPAlUtmmn037qhIhm0KXcoFktOvvy74on8AtS
         EWd+igmkG0IkBrPeyjneHtxXWFIAdiykZbe6QqA+EPVIEXY9zZHBLnQuxPy4T853/H
         JtWhOMNuj1lzQ+kXvEqOw2I1Mm3ri3QVEO7llL4BNo5JdRIU0+N9rX8bn13E6Y2ofb
         ocbbnQZ/yvpl6wwKhHApasBhkfLKdo9I2i+QLLS+cfhwWzjW0WwEI33fY5sRHkhRgX
         vCcpBVwuB8TyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9985EC5C7C6;
        Thu, 24 Nov 2022 08:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: altera_tse: release phylink resources in
 tse_shutdown()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166927981662.5759.16238482370653534273.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 08:50:16 +0000
References: <20221123011617.332302-1-liujian56@huawei.com>
In-Reply-To: <20221123011617.332302-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org
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

On Wed, 23 Nov 2022 09:16:17 +0800 you wrote:
> Call phylink_disconnect_phy() in tse_shutdown() to release the
> resources occupied by phylink_of_phy_connect() in the tse_open().
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> Compile tested only.
>  drivers/net/ethernet/altera/altera_tse_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: altera_tse: release phylink resources in tse_shutdown()
    https://git.kernel.org/netdev/net/c/6aae1bcb41c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


