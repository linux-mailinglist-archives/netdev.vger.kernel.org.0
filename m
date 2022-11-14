Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E966E627AFA
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiKNKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiKNKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D644C1005F;
        Mon, 14 Nov 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94B9EB80DD6;
        Mon, 14 Nov 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3699AC433D6;
        Mon, 14 Nov 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668423015;
        bh=nx5eBV3rNRIeLHpm43mXqcDUvx6/sJUHdrGEJ1zVbHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JWBgSpjYhyY2OnIrZCmFJUbXWNKH3/7L/YwkY9nWeOKHZ+PjSsY31ThVfepqZII1f
         i7c44hYgeW8HCkV8gLuh35ZhAFahtmo/5XVrgWEzkfMy1p+CmMkoac+dyN9vOcLllB
         eMV3Ldh14sTm94QTvIoWiaaGgRRQlFFUfDIcCONHTW0xkVzVeV56vajoQM6uSCYla6
         JGRn13ZUD3tnQUfbajqccmmOq+pmb8n6KLGbZR2NSAu/3SE1dmWOAIecotnOBKE2/U
         KC/2b8xRTTfDSapqrIv6c+swlG/53ONZNXf32CPUJZ9sZNh2Cm4WsDTk7g+r5rZovG
         cTjMnD6Qu6R1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26374E4D021;
        Mon, 14 Nov 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: fix misuse of put_device() in mISDN_register_device()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842301515.7392.13590494848484176935.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 10:50:15 +0000
References: <20221110113823.167822-1-bobo.shaobowang@huawei.com>
In-Reply-To: <20221110113823.167822-1-bobo.shaobowang@huawei.com>
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, netdev@vger.kernel.org,
        liwei391@huawei.com, linux-kernel@vger.kernel.org
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

On Thu, 10 Nov 2022 19:38:23 +0800 you wrote:
> We should not release reference by put_device() before calling device_initialize().
> 
> Fixes: e7d1d4d9ac0d ("mISDN: fix possible memory leak in mISDN_register_device()")
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> ---
>  drivers/isdn/mISDN/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - mISDN: fix misuse of put_device() in mISDN_register_device()
    https://git.kernel.org/netdev/net/c/2d25107e111a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


