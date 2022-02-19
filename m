Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452064BC95F
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbiBSQkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242635AbiBSQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776D31D3D9B;
        Sat, 19 Feb 2022 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 277E2B80BEA;
        Sat, 19 Feb 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4BEAC340F6;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=hKNyPY4HUZF+Y7CQUjY/REY3Z02I7KGlKj1izoSpSck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fwVV+VvV6zGKP0oPky75PTn2jveerS+IwJlTf/JiDXh8/GDaGPUxBF/9zQWjPWfNb
         7UCb8Oq8y/CH4t9XoTCNZznjaJUv+GT/ugnUgb80TOCdScqWTtjjbBSUCijzGgrqmR
         SReAimYc6f1SpteggebXL5PSlA7MdSWbnFlfv64VO+A8bk3iOX0iQK23eIFuSGoLnd
         BG8X/8J6EhscNQ4iAylye4Nq+k/NUQXkVlto4LwWOaKI/eLtQOgegwAewZmZADe21S
         5qoFRjg0127n68szpfmxnzwll0NpkCsQYOTTeLMXeAeomrfqY9Bi3UayiA1m941PBK
         6Gi/ayOCUYcoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A20CAE7BB1B;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: nicstar: Use kcalloc() to simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881165.6364.13367871092721954712.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <68ec8438f31b1034b37b21a6c1b6c3de195b8adf.1645206403.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <68ec8438f31b1034b37b21a6c1b6c3de195b8adf.1645206403.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     3chas3@gmail.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 18:46:51 +0100 you wrote:
> Use kcalloc() instead of kmalloc_array() and a loop to set all the values
> of the array to NULL.
> 
> While at it, remove a duplicated assignment to 'scq->num_entries'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - atm: nicstar: Use kcalloc() to simplify code
    https://git.kernel.org/netdev/net-next/c/92c54a65e6a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


