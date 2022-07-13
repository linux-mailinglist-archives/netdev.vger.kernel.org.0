Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A826C573743
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiGMNUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiGMNUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A2FF40
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 06:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C53CAB81A5F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89AADC3411E;
        Wed, 13 Jul 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657718413;
        bh=v2oI4b102Uk+mbLk4T2r/fHRFqoJJe0mDB9UaN35mg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eu9Z5iwpgThIekWNKsth9HlkUKmcQaHAg9bNe+yOBXpPtLiN8Z2Vr0RliKTqZq9xY
         Czw4NeReCL6LUfABYcA0JfCBOFeRwFQnfJEidIG3uYuIZOl06YPp4ozkd4c2e0J6Kp
         +Px3p693Cm17CBriCuPJnsUYYH7Eq8DR4arFk1XKH1ol9+dEucFU5MVU95RrKxryYN
         BT01gERa7M2VYENJiJu5bDOjmp+hQUImTau0eCpgpunKo/Fj3arZOUem6CXRk3owJn
         6Kf+CLn/4j6AFPQZet7CLioACUHDO/YZViyPwOs8lYQXIV/I4MePKZfEfnvIQfzn0E
         euaotQOH62Wzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D990E45227;
        Wed, 13 Jul 2022 13:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: ftgmac100: Hold reference returned by
  of_get_child_by_name()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771841344.24696.13836170564158202924.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 13:20:13 +0000
References: <20220712061417.363145-1-windhl@126.com>
In-Reply-To: <20220712061417.363145-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 12 Jul 2022 14:14:17 +0800 you wrote:
> In ftgmac100_probe(), we should hold the refernece returned by
> of_get_child_by_name() and use it to call of_node_put() for
> reference balance.
> 
> Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> Signed-off-by: Liang He <windhl@126.com>
> 
> [...]

Here is the summary with links:
  - [v3] net: ftgmac100: Hold reference returned by of_get_child_by_name()
    https://git.kernel.org/netdev/net/c/49b9f431ff0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


