Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9968B4BB92B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiBRMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:30:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiBRMa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8473192F;
        Fri, 18 Feb 2022 04:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E3C961F7C;
        Fri, 18 Feb 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9DDDC340ED;
        Fri, 18 Feb 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645187409;
        bh=7TkBnTKCtjACB5HwO0CqoOG0HQYKb1/UgHZIn0NmGkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LLvZvuN3NkfX4k5hr5apRNXCzA5jSdi2e2yJC30olk4fdiNRIqhNz08avPMZXHvrf
         jTOYYAH4W/r+zvxsjURKXLZ4PGYh1o6GY5ymYg8Fx/qk8ngUI9iCdQLwWtRlFxUXsl
         xecFFaVy2XjVmG9Ws2mqqFYws1FU/KACfVQjJpUHFUz6qL1D1yuDp2AUdyO17JAWXz
         7lThiCeE187EJmrxmrY9mmCwNEdKXj8mBivjP+CnbEg08M2TJo5l3O8JiFXtjhKMqx
         c1MbWvpz9CvTZcFGZ5vYDZF5tBrCaZN9um3w4BtsXjloDk4yqvonR0hpaIK9VVuK/x
         NCY+4TWnoy2SA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98EEFE6BBD2;
        Fri, 18 Feb 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ll_temac: check the return value of devm_kmalloc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518740962.31566.15528927954028529401.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 12:30:09 +0000
References: <tencent_CC2F97870384A231BC4689E51F04C4985905@qq.com>
In-Reply-To: <tencent_CC2F97870384A231BC4689E51F04C4985905@qq.com>
To:     Xiaoke Wang <xkernel.wang@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Feb 2022 10:19:39 +0800 you wrote:
> From: Xiaoke Wang <xkernel.wang@foxmail.com>
> 
> devm_kmalloc() returns a pointer to allocated memory on success, NULL
> on failure. While lp->indirect_lock is allocated by devm_kmalloc()
> without proper check. It is better to check the value of it to
> prevent potential wrong memory access.
> 
> [...]

Here is the summary with links:
  - [v2] net: ll_temac: check the return value of devm_kmalloc()
    https://git.kernel.org/netdev/net/c/b352c3465bb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


