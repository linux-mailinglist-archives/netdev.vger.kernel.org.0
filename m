Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB04649BC2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiLLKLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiLLKLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:11:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0987E0BF
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3EF60F8F
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D01BCC4339B;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839816;
        bh=quzCDsNNo/0w8eRx/6y6wtgHypJf05DyKq9Ldhg7BGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aU32pJieqrpWufctVi7DHYOFEu0x4WVt/6hKc9AlnR1Ujqt6oAD0Pfbm1tat4g2vs
         rk0t5zmVxy+5Wpn4h/9X70KVqLomaIedtyDSqP4PwuGqMRwjasu3BuSzmXEzEMg9Yg
         YLIf2uEg9KSLqst5UpqV3VEOfPSSyht5maIjaQEVwx5LP60kxGqLiFoEiz7ufFoDtr
         DKhM+wo4aeugxIdI4XImsmx2G8TBRg4T92/mCRNaorOLQsAE9xnxEtO3shTjZrdoJT
         3tjgoCSpt7njH8enK6ZOgw9TAdl9RntAfL5prQxO8WmiYwPrALZD9Ug20gfyPgtYWD
         Q0wTfX5M2d7Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFCFFE270E3;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: call proto_unregister() in the error path in
 af_unix_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083981671.16910.10344562069155056515.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:10:16 +0000
References: <20221208150158.2396166-1-yangyingliang@huawei.com>
In-Reply-To: <20221208150158.2396166-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jiang.wang@bytedance.com,
        john.fastabend@gmail.com, jakub@cloudflare.com, andrii@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 23:01:58 +0800 you wrote:
> If register unix_stream_proto returns error, unix_dgram_proto needs
> be unregistered.
> 
> Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/unix/af_unix.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] af_unix: call proto_unregister() in the error path in af_unix_init()
    https://git.kernel.org/netdev/net/c/73e341e0281a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


