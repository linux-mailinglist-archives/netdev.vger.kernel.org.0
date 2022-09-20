Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C45BD982
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiITBk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiITBkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242A03AE75;
        Mon, 19 Sep 2022 18:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B514C621C1;
        Tue, 20 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 850EAC4314E;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638017;
        bh=Re6QNnxF7MInUcVeqTbYE1nN5Lo3NNrpKn4mnmdQ7U0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGxaWnvHmhykG8AcOOOMBf2wJeGuBEnrr4GH8N9pNcknOgwd3V5VJoRBHbYJ0r+bp
         a43Dc4/crTJEMSzfPiZVfZmTFOQDH6fauy0TDU0j/n079ABeWmrwQRQyuomwUX7P//
         zx8mI4K4VAbZ+bZuW48l0UIPK+3Cs6iLEkx4x15yQUaGz6EuMnbZMDrteKICN7XC0M
         tYA6V12JGRjsGk1ZMizDUd3qCEgK/v2DGXI13uJCG8z1Q4pGU94d2XohR4nAKpHu3I
         ET4v+uhv+fGtea2pzw7fnMyRdyS4Tt+ZHVltuVB9s6L1w+/WpcWjhGNRy53Dl//tHv
         MBNDDsxm94RmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E02AE52536;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: Fix return type of ipc_wwan_link_transmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363801743.6857.5852475511162302721.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:40:17 +0000
References: <20220912214455.929028-1-nhuck@google.com>
In-Reply-To: <20220912214455.929028-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     error27@gmail.com, llvm@lists.linux.dev, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Sep 2022 14:44:55 -0700 you wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of ipc_wwan_link_transmit should be changed from int to
> netdev_tx_t.
> 
> [...]

Here is the summary with links:
  - net: wwan: iosm: Fix return type of ipc_wwan_link_transmit
    https://git.kernel.org/netdev/net-next/c/0c9441c43010

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


