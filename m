Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB0630B95
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiKSDyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiKSDxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D38C7222;
        Fri, 18 Nov 2022 19:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4D28B8265A;
        Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6588EC43145;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=/3vB+MjpaQEPocEwj9FUBz15cE7YrFfIcV9Z9MbOZNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fgE9XR0SYfI4x0cSj/kWNECsAZgJxslEweqixaJDt1Ddk2ddcE16uGAV07whKQaqP
         FARKK310Q6uQRQ7/7d34X2op1vDrbI2N8HtVaTPnxtg8zOmSQZSUxcRNDlDtpFttZ0
         g2Ic+iwoYFFJihbs6GEOUGqgyHZYBpscBq1s+e83HvU0XEEKSOY3eI69jILstEBuFK
         +U8+FX0NL0qTvbJwUgKMNMT6lpsvjo1uhFbSSu00PpcBWiNs9FbN6SAyA2GbbU/Dfd
         2GeZsb09r4nU6VAllfe0GZZ8weSQXheCohRver6iDLmwvE3UTser2KzrNuU62AwJ1H
         CW1HAIsaCfRYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37281E524E4;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/qla3xxx: fix potential memleak in ql3xxx_send()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981821.27279.9591346330132470955.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jeff@garzik.org, ron.mercer@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Nov 2022 16:50:38 +0800 you wrote:
> The ql3xxx_send() returns NETDEV_TX_OK without freeing skb in error
> handling case, add dev_kfree_skb_any() to fix it.
> 
> Fixes: bd36b0ac5d06 ("qla3xxx: Add support for Qlogic 4032 chip.")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qla3xxx.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net/qla3xxx: fix potential memleak in ql3xxx_send()
    https://git.kernel.org/netdev/net/c/62a7311fb96c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


