Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF8A5F0AE5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiI3Lp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiI3Lor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7DE9A9F0;
        Fri, 30 Sep 2022 04:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A61EFB82841;
        Fri, 30 Sep 2022 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E233C43148;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538018;
        bh=IKQvAUjVVe1ZMOX9oFnDoAiO//gd9z/bUiOy6VuwVMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4q2PYnk3qFvWGMO03ERrMA2N7PbBSOzQWTXSGGfXf0dNcY8321kG7c5Whw+tM5T+
         0glNm18fb0CqmiF+MszPH3lQudGn3ZvDqbt4OQB5FHAsVh42kQrDYS4TdWpj2gcIau
         0ENfhNFUI8pWUQDQJQ5taP0YN7LnWlr7flXZ7FYvyy/zzlopC0z1p0tFzqmn/H7kip
         lc8I2ShMw3TaENFA+MEVjLhW3FbPSYDgiak8Gah1MggHhfyo1LJSz67PKHtFEifUFH
         zI5unapzBJdxgjP3rW3Ie2tWu+XSKtwDOD8yJzNM+VotXUXA7mDagxKUDrUAOmN5mS
         VL8ryoDJptKwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A2D5C04E59;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: assign path_cost for 2.5G and 5G link
 speed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801829.4225.8647161065788331137.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:18 +0000
References: <20220928175758.2106806-1-steven.hsieh@broadcom.com>
In-Reply-To: <20220928175758.2106806-1-steven.hsieh@broadcom.com>
To:     Steven Hsieh <steven.hsieh@broadcom.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        razor@blackwall.org, pabeni@redhat.com, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 10:57:58 -0700 you wrote:
> As 2.5G, 5G ethernet ports are more common and affordable,
> these ports are being used in LAN bridge devices.
> STP port_cost() is missing path_cost assignment for these link speeds,
> causes highest cost 100 being used.
> This result in lower speed port being picked
> when there is loop between 5G and 1G ports.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: assign path_cost for 2.5G and 5G link speed
    https://git.kernel.org/netdev/net-next/c/bd1393815319

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


