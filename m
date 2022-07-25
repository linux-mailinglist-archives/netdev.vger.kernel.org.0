Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C7657FD27
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiGYKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiGYKKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB32671;
        Mon, 25 Jul 2022 03:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB877B80E34;
        Mon, 25 Jul 2022 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95FD1C341D0;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658743813;
        bh=ncFxq4tIbXwnIS+prCi0WUX7PNfWViRc47pLNMsYLOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZTzN9LePjiEK3uglHWjRbwaIp7Te617+O9Hz9ixkts2Yo3HV/xOsV3wNa6jbSjli6
         1WP6sBmg3a65jYu40XmPeusgxiWgWhXgcYMcBmXG7q+2W925N2O0SsJB1QAiPPRSvB
         P+2txOcv6BhZfWerTgMqZLj89Kuhw5VmMTahWtBvYYQdYiKJ+N9Yf1G9l2Hy9H0TzC
         vo2bJrj10HxrRQ9QIHYZ/7U/bUXdStAcNGeaOKJ1HIBkCIq51jWeaGrqih91hWlxRB
         HKxltD9nMzjzkw/pGGfTgckGW73l5go1LQbO534upx/51OMSSbMxXL3r3XePelz9m8
         N3yAuyzNnk6EQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B1DCE450B4;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfp: bpf: Fix typo 'the the' in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874381350.12821.9673082406595708806.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 10:10:13 +0000
References: <20220722082027.74046-1-slark_xiao@163.com>
In-Reply-To: <20220722082027.74046-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     simon.horman@corigine.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 22 Jul 2022 16:20:27 +0800 you wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/net/ethernet/netronome/nfp/bpf/jit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - nfp: bpf: Fix typo 'the the' in comment
    https://git.kernel.org/netdev/net/c/af35f95aca69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


