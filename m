Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E3C5F0AE3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiI3LpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiI3Loq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F997B0A;
        Fri, 30 Sep 2022 04:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC1B622F0;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 545F6C43146;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538018;
        bh=HsvH0qhigQTeALvxiMjsw/7hodkJsvDkmd4/t/Md1So=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WEq3Mi7F1q2l4m3BKlA+jbpQGE74Pv+uWLMzM/UsDLyOrZWKLfBBzCIDnidhiWYVH
         r+wTkUsbLI2FSQhq8NPNhLVKHobCI+yMErJFmGPspVAVZ2IJzCA94fF7J12VfGmBJk
         ZwzgxlT3GwUOykAQw17lbvYwIZAc9ZuGf+nr8IAeJ16xZdbYPIcwuYkltvwYC9Zj0z
         BwdpL6ZQ9ksPOaS3XKz4dzYOts0LYOpBLocUPs9YdGbaCpDOooO8xAfnOSkDLHgjek
         xFdbTYsAqGYq+A2rqhc0WHiMeaB9LA9+sAU/V0+lBqVBY5oVTtXAskeUeTINb3mPbz
         hJCSjp6qhGTUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CCE8E49FA9;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-next: skbuff: refactor pskb_pull
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801824.4225.1578250985659181646.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:18 +0000
References: <20220928125522.GA100793@debian>
In-Reply-To: <20220928125522.GA100793@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        johannes@sipsolutions.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, imagedong@tencent.com, kafai@fb.com,
        asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
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

On Wed, 28 Sep 2022 14:55:31 +0200 you wrote:
> pskb_may_pull already contains all of the checks performed by
> pskb_pull.
> Use pskb_may_pull for validation in pskb_pull, eliminating the
> duplication and making __pskb_pull obsolete.
> Replace __pskb_pull with pskb_pull where applicable.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> 
> [...]

Here is the summary with links:
  - net-next: skbuff: refactor pskb_pull
    https://git.kernel.org/netdev/net-next/c/d427c8999b07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


