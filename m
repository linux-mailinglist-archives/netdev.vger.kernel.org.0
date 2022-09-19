Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6005BD662
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiISVaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiISVaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07212A712;
        Mon, 19 Sep 2022 14:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63055B820FE;
        Mon, 19 Sep 2022 21:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 173B6C43140;
        Mon, 19 Sep 2022 21:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663623015;
        bh=MngFdnjKmIdrX0tcpylQpKHs77nVEBjiVQCBTwf7VTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c9kKUgflA8vw4EZjnKzaifY5WiuW6KG0vezCELQ/9MQQ90M577jiFhMb+hw6zOjL3
         iRWKL+r4Lebn9NOl79alk/CFiagoNz5CxQp6rmxz1I4f8OTXPyKZI3gwK+vdNAUn+A
         apJk8sQ5jb4yQj3tvJl7a2S2Z8Mul7Nez8kaQhbFzD+uBBuBjzSmV8x3yxYc+h03Lu
         gHkRCoFLwyB1BukA2n6WrRDvAmv1uJaonNvs4sNCch0vuusTFEQlm2VXas01/ECND8
         tN8apzn3VbusXvbcjcGh5PjCtsaBuhnlcnhko6/5U6Mtjla8fb1x2g/sk9LOzrFRxf
         kJ6p4sK02JKFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF2EEE52536;
        Mon, 19 Sep 2022 21:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: microchip: lan937x: fix reference count leak in
 lan937x_mdio_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166362301497.9084.2139476336627725965.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Sep 2022 21:30:14 +0000
References: <20220908040226.871690-1-sunke32@huawei.com>
In-Reply-To: <20220908040226.871690-1-sunke32@huawei.com>
To:     Sun Ke <sunke32@huawei.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 8 Sep 2022 12:02:26 +0800 you wrote:
> This node pointer is returned by of_find_compatible_node() with
> refcount incremented in this function. of_node_put() on it before
> exitting this function.
> 
> Fixes: c9cd961c0d43 ("net: dsa: microchip: lan937x: add interrupt support for port phy link")
> Signed-off-by: Sun Ke <sunke32@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: microchip: lan937x: fix reference count leak in lan937x_mdio_register()
    https://git.kernel.org/netdev/net-next/c/2f8a786f4724

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


