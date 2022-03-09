Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C64D315E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiCIPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiCIPBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:01:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2364C150439
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 07:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC312611E6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 15:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EA4DC36AE3;
        Wed,  9 Mar 2022 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838014;
        bh=jzAgT3PDjSaLYHaY9wMs65yGSwPSppndZ8pN9Eoi4v4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C/yHdUeO589jcjnNFofZ+yh8BI066TrUxcB6a5MnN9LrUlpccjOE2jzoi+Atps39r
         7XP92nPYNC/2l1zR4pcEU323E8FJ65CgE9W2+DQvwszx+wnJE/5dfSnFceQhseM3Ms
         pZXJM3G6sPdQH33WCtmyImXk36IKGFftDhBbLejiCXGzQwKlZSdhnh0nIi9cDOk1Zw
         Z8pvA06//eY5GDpz5h/xymdx1PXoGiIuycNh2bU9URUezfNL22rFXQQU0mDaXpS1PI
         5Efj8PzwUNh9ZXds5OzyqSKNsBagpVs0BL6eFaIlFE8gOCnCJNkRgFcP97/pTBi2Z8
         VPH72Nd29tkkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6033E73C2D;
        Wed,  9 Mar 2022 15:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/5] xfrm: fix tunnel model fragmentation behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164683801393.7970.13456903491887925542.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 15:00:13 +0000
References: <20220309130839.3263912-2-steffen.klassert@secunet.com>
In-Reply-To: <20220309130839.3263912-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 9 Mar 2022 14:08:35 +0100 you wrote:
> From: Lina Wang <lina.wang@mediatek.com>
> 
> in tunnel mode, if outer interface(ipv4) is less, it is easily to let
> inner IPV6 mtu be less than 1280. If so, a Packet Too Big ICMPV6 message
> is received. When send again, packets are fragmentized with 1280, they
> are still rejected with ICMPV6(Packet Too Big) by xfrmi_xmit2().
> 
> [...]

Here is the summary with links:
  - [1/5] xfrm: fix tunnel model fragmentation behavior
    https://git.kernel.org/netdev/net/c/4ff2980b6bd2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


