Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D861450B40F
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446022AbiDVJdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446095AbiDVJdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90824EF6D;
        Fri, 22 Apr 2022 02:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47F1561D85;
        Fri, 22 Apr 2022 09:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A3ECC385B2;
        Fri, 22 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650619811;
        bh=WjCnC2hK5YuK62WCP5uln0bIWWDcgZw8lthlbKkhSYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C5+TTWZFI8IDAcBiBgdhVlj9YKV49QUAe7suZk71pV3g830O7qcxk78riv+q8wcLK
         ci9ym/eU8JsHpAnasuIrIQWNcfcH7i50cXu32j/1iapz8EOTF90JnB0WA0kBLVG7R1
         Ca+UoPAi0IdmqarBg3pnKRJ823u1ko9ABbQyBuYVIVNS0YmF8UPZrEzXOKqPqQzFA8
         P1D5EQNLEQ5Gf6u/6pcXJd/ydZCGvh/nxNYSYd+1nEy7NNjXgHsZG1DIqDo1Nv/CrC
         cLWBTFtvZBH0Gti06Qt75uWMdF+oTwCsGSGT/h+Y+wslxcWCNEogppTWwmmCWXS8oC
         rNh7zjiHyqGoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F2A8F0383D;
        Fri, 22 Apr 2022 09:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cdc-ncm:  Move spin_lock_bh() to spin_lock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165061981145.24106.3415684475453088972.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 09:30:11 +0000
References: <20220418141812.1241307-1-yuyunbo519@gmail.com>
In-Reply-To: <20220418141812.1241307-1-yuyunbo519@gmail.com>
To:     Yunbo Yu <yuyunbo519@gmail.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 18 Apr 2022 22:18:12 +0800 you wrote:
> It is unnecessary to call spin_lock_bh() for you are already in a tasklet.
> 
> Signed-off-by: Yunbo Yu <yuyunbo519@gmail.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: cdc-ncm: Move spin_lock_bh() to spin_lock()
    https://git.kernel.org/netdev/net-next/c/f1ed409fb1ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


