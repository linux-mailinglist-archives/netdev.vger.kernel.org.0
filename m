Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567155BD983
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiITBkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiITBkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161BE40549;
        Mon, 19 Sep 2022 18:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B14B82359;
        Tue, 20 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 589DEC43146;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638017;
        bh=u9W3fdoscHgbg5TvvtpI4ZjaHwqqptzFexgfaG4RsCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=USIO+utqY5AmZmJa64+EKAna2bIbuHR/ui19O5dlscnLrIKqcbDC+jgVAncE9xXO5
         GMoD0827qF9RPaI9Sho9JEm0c/pZI+CSdLqt/Vj5QyjxulAKTFAksn9jS7mWH35cBD
         e17MyYc8NE3dGR3jNTd/OJDyuwptOAm1lvYFD1pDV5YsJjcohjznY04VxvHCYE62+E
         uYUMdnrY5EowuiKBjpa1sQw8Tpa8jR4oiVoVOrzS40oDT8vBxMbbYucHBCqJxvIlEu
         yHqoK0EfxwQbmJXZdxOjVICEJMrH5fKrUtOgq1+/+Voxf84FzdgjS2pC4ucR+niBM8
         IuDRyCKHQFtnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3FB55C43141;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: litex: Fix return type of liteeth_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363801725.6857.8934442480549905772.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:40:17 +0000
References: <20220912195307.812229-1-nhuck@google.com>
In-Reply-To: <20220912195307.812229-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     error27@gmail.com, llvm@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kgugala@antmicro.com, mholenko@antmicro.com, gsomlo@gmail.com,
        joel@jms.id.au, nathan@kernel.org, ndesaulniers@google.com,
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

On Mon, 12 Sep 2022 12:53:07 -0700 you wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of liteeth_start_xmit should be changed from int to
> netdev_tx_t.
> 
> [...]

Here is the summary with links:
  - net: ethernet: litex: Fix return type of liteeth_start_xmit
    https://git.kernel.org/netdev/net-next/c/40662333dd7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


