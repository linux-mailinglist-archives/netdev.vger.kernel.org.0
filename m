Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887F26458D6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLGLVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiLGLUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A260F391D4
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD2A61510
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95627C43470;
        Wed,  7 Dec 2022 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670412016;
        bh=+72nWTn85/izLqXwpU34WCXWrEgmyKWFe0862Z77rBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RhG8unkovTyG7zBR4GqA7LGTcz5gXbaEFSynZS8JwzuASLh3c7VveuhFO6YDz2t8s
         3Bg3FK0IOp8stNBU0N7MpvVjOsY56ElpnJKzcvD5oW2XSROcfCK2KKSsRO3ZE5HryL
         gx09SJc5chOCyE58cPxLhhPMUYaZMIavwoUtt0hp6XMEMY7VO+Z+HgqNVuRE348g+8
         M+4/K9oo1Wu0MC3kjQ0cYBPhicyuPtqsrbRtdoRYH5iX9YfYYWYokzPJJyIWlW8Dgb
         FrbuH8D8abv04BaYGglLJ9d+KKHP3whnsGNt4Yt83b/ZBVqDUFuN9Adq7Ca792Nj0R
         ZigauXMlQx0Cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 792BDE4D02D;
        Wed,  7 Dec 2022 11:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add()
 and dpaa2_switch_acl_entry_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041201649.19214.12810270575196199146.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 11:20:16 +0000
References: <20221205061515.115012-1-yuancan@huawei.com>
In-Reply-To: <20221205061515.115012-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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

On Mon, 5 Dec 2022 06:15:15 +0000 you wrote:
> The cmd_buff needs to be freed when error happened in
> dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove().
> 
> Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - dpaa2-switch: Fix memory leak in dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
    https://git.kernel.org/netdev/net/c/4fad22a1281c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


