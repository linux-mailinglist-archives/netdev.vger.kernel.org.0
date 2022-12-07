Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498C6645829
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLGKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLGKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2DA30573;
        Wed,  7 Dec 2022 02:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFE47B81CB5;
        Wed,  7 Dec 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8651AC43470;
        Wed,  7 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670410216;
        bh=/kW6445rwnuRwZcjoCo1LqYjESGpH/B/P3RLt7ACfOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9z3faDxo1iWhfmFDP5e1pCFwfqEoMe+KldBJZ3fh64uRR/ZSCHJeRL82KeLpQ4LI
         +5lQppGkB1ZtVOMjH4osrZWOt4JPNRXOz5OJqbfei5gc4RWxOapz9g/RecBSh5Ym7v
         6n3uqbiMUQcLuLyjaAjd3Ob9BYhKwxr3vAnjPn2KRXD4ZlMBfOErLRra67XgpxS7zq
         qIw1uJspUy1iiWvUjkKX+jkl/5G0LbZZ+Ico/pWJkoDI2/JbbLYrE0Eu4E0YBjgcKP
         4nUG1McgtzkV/rm3SXB85Jt0TX1mwjgRxks9H7IU2nl2tW0RL0CFJ+PxQpOy7mEC9n
         iq8lzhyaAqAnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 644E6C5C7C6;
        Wed,  7 Dec 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethernet: aeroflex: fix potential skb leak in
 greth_init_rings()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041021640.1929.15406391616891179214.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 10:50:16 +0000
References: <1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     andreas@gaisler.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kristoffer@gaisler.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 4 Dec 2022 14:09:08 +0800 you wrote:
> The greth_init_rings() function won't free the newly allocated skb when
> dma_mapping_error() returns error, so add dev_kfree_skb() to fix it.
> 
> Compile tested only.
> 
> Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] ethernet: aeroflex: fix potential skb leak in greth_init_rings()
    https://git.kernel.org/netdev/net/c/063a932b64db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


