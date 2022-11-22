Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22420633A66
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiKVKpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiKVKoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:44:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E56A5B85F;
        Tue, 22 Nov 2022 02:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B90961646;
        Tue, 22 Nov 2022 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74B13C433D6;
        Tue, 22 Nov 2022 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669113615;
        bh=osBC7Z5YRphvaJSdnfcdOZwiJstgqENo54xMsRdyETQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N6Oh0hr2rM9xnEvgMM6FPMe5oH//7u7OH1TuECIJKJbUqUwWMrrmSACZ1M8wpjkaA
         8mLHy566n7YZI8ukqjOWYz8V4jg5eclEsJOwoD/aIjwn+zFvi6zZfIhIVyTNNbrjPm
         QIjATY8NBVRJsVl3Qj6nLSciNwqKPsTaxeEg+r/0oU83Bxq5W8IDB5QciHlym5WqaZ
         npYa2yL93Z0DQyB8LbWW+SWkcJn29QXNh1KPYOY0EYqUE1WjS6qblOPILZvuJYGFla
         Ou9/6hwU+iDKTUD0/rsdWJyH3wWoG3xI1/oqAcGmRcd6mFY8u0yCVFMhOFZhToJwNl
         2OG3DVgfZDSVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B82AE29F42;
        Tue, 22 Nov 2022 10:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix potential memleak in __ef100_hard_start_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166911361537.19076.11841669774400713563.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 10:40:15 +0000
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 17 Nov 2022 15:50:09 +0800 you wrote:
> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> in error handling case, add dev_kfree_skb_any() to fix it.
> 
> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] sfc: fix potential memleak in __ef100_hard_start_xmit()
    https://git.kernel.org/netdev/net/c/aad98abd5cb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


