Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6B4DBCFC
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353176AbiCQCb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiCQCb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614241F60E;
        Wed, 16 Mar 2022 19:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8D661453;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D922C36AE2;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484211;
        bh=DthGAFxRpwu9O54IY8kiDXV1+eY8XnZy/zpwFAUMToc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QNqQecePs3gVuwUUzppmX0PdsZXkDV80oNKcAyW3z6IZzY79+oAa0LKgzNbpxJnqU
         wq/b/PjfmSKTytEuU1s2RCDu5XBRF6Md4XTMoW+M3a+XLHkOT7OSRnvAO9NyUMYAGy
         VJKnbP77RjYliKcSrIH8LnqAtJYegADVnLXhAmYpfaD6O8hDZhHN0xbDXuZ1mBPKAZ
         49dNR+SFyXPPOuJM8nV7hhjsWnyMjiCUKH6HggG3rGUJPwBRwNLBpo+RQum+RdmXfK
         WSorjHv5lndwsDBe+EXyfgmEpbc67OxB7ieH619qBlbQn0hbfafSX+TakSQ1JDO0c/
         E9Ex2iBUb8bJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2160BF03846;
        Thu, 17 Mar 2022 02:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v4] net: ksz884x: optimize netdev_open flow and
 remove static variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748421112.27087.5960135287716168511.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:30:11 +0000
References: <20220315122857.78601-1-wudaemon@163.com>
In-Reply-To: <20220315122857.78601-1-wudaemon@163.com>
To:     wujunwen <wudaemon@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, m.grzeschik@pengutronix.de,
        chenhao288@hisilicon.com, arnd@arndb.de, pabeni@redhat.com,
        shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 12:28:57 +0000 you wrote:
> remove the static next_jiffies variable, and reinitialize next_jiffies
> to simplify netdev_open
> 
> Signed-off-by: wujunwen <wudaemon@163.com>
> ---
>  drivers/net/ethernet/micrel/ksz884x.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next,v4] net: ksz884x: optimize netdev_open flow and remove static variable
    https://git.kernel.org/netdev/net-next/c/af1147b236da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


