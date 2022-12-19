Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40297650A5F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiLSKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLSKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78179592;
        Mon, 19 Dec 2022 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7182FB80D6F;
        Mon, 19 Dec 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 119D4C433D2;
        Mon, 19 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671447016;
        bh=/TM29bq8epKg+lGf9zZ1cjGedliSnCMo8M6GpK1ZhUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ShIiiDXxcMVt4+h0XLONbWsFuP+vLyJ0yylmF6IdWdpnCcKCsdQjnqnysnw90/3eB
         Ml4ctSvLTiAAlVSbqCTNXPVvcSQEzk1X1z7v5h5/kkIzq5HrbIBLHZqK0woFTjJ51U
         86AKarYz1nQg2ToPJC/iD1EMK0VrgDyF0OZbxAdBYjEk3F7OyIJyRqJTpwjAUTfVzE
         rCtznYrFz5zxB7nM6bq7nPOsAIky6bjq8Afv3LbQ/3qhfwHVXQ6cQeidNcv99j0AAi
         pfd34AbdGh19VXHJFMDFWgsE/jomEhbZGcnFKS14B/ypL6AyiVDMD/+XAm7ZpZK67A
         T8dZovvollaww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E468FE21EEE;
        Mon, 19 Dec 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: Fix documentation for
 unregister_netdevice_notifier_net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167144701593.11987.7838332375815964417.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 10:50:15 +0000
References: <20221218130957.3584727-1-linmq006@gmail.com>
In-Reply-To: <20221218130957.3584727-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com, netdev@vger.kernel.org,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 18 Dec 2022 17:09:54 +0400 you wrote:
> unregister_netdevice_notifier_net() is used for unregister a notifier
> registered by register_netdevice_notifier_net(). Also s/into/from/.
> 
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
> changes in v2:
> - s/into/from/ as pointed out by Petr Machata.
> changes in v3:
> - remove fixes tag as pointed out by Jiri Pirko.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: Fix documentation for unregister_netdevice_notifier_net
    https://git.kernel.org/netdev/net-next/c/9054b41c4e1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


