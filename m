Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29BB5BEA87
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiITPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiITPuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F78474FD
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C72CB82AE9
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4556EC433B5;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689016;
        bh=Bnipi9Rtk5aXjDPFo4H/M2c0xp036ub0Hw/3LVR8jNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eji5gDr274WlookZa/4/jFbe8TkPErokIH5HB3Izwu/DJsfDZprGkJKVOkfxyFrYI
         eDi7AfT3JnZV5FP368q5YB44MigvCsj+mH3nFObVkxKLibGhjMo/vjI1Cfd4812sfo
         bm/gFHjMS5B7ha2cn90zIB910z4ZinjmZFyLrPB5wOkMb3OIT+3ulqtndTxHQSqdj5
         INxEqnuvm5EYTLJszU8HoMc6HQ+U6Zxsl7jkh6tnD4ve0fcwsH+AcJDjKlqRh1MRKn
         t5DaEEu10ldKXcdBDgFlxm2KfHQA2IcCApS1heOE3Hwq2ZLsmlEFb5viz5i9ia6mT1
         GMMNxjTxgRbRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BF33C43141;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 1/3] net: mdio: mux-meson-g12a: Switch to use
 dev_err_probe() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368901617.16825.15395049886003774132.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:50:16 +0000
References: <20220915065043.665138-1-yangyingliang@huawei.com>
In-Reply-To: <20220915065043.665138-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 14:50:41 +0800 you wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/mdio/mdio-mux-meson-g12a.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)

Here is the summary with links:
  - [-next,1/3] net: mdio: mux-meson-g12a: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/de0665c871b7
  - [-next,2/3] net: mdio: mux-mmioreg: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/770aac8dc05d
  - [-next,3/3] net: mdio: mux-multiplexer: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/4633b39183c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


