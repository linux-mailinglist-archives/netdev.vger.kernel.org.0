Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB14BE82F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357066AbiBUMBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:01:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357071AbiBUMAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF51E2018A;
        Mon, 21 Feb 2022 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E78AB81056;
        Mon, 21 Feb 2022 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18C19C340EC;
        Mon, 21 Feb 2022 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645444811;
        bh=Vam9wWZj8LQZ6Nv1ppZ2K4w1k8nQUsAlzQwHpXQc45w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u68DlhkHy9iImrFUKxpYU5RYska8tkmQFCHjDF3tOMBza5UIu6LoEMLKxZk1S2gHZ
         GOLJEMa6wB9HjhlLgfELwu4DzYbjOYAkF+wG1GkvKH9GRuXpoVB1PK7IqTrfbfnZF2
         AwgKQU5lOP5XTOfWq3EU6H+mYx2+x2azjCp1mAvhLyoxBhpx4SDAWwqPKXUJWsw6MW
         hNmzb8Yk6AUfG6GifE8BmL5lpHCKtu6+m+WgXPwYn76WKQPN3BpoDEcS/L1KdTS+Ak
         uvmlnXHyMuC/O1/EiNaCzGlnOMssk1pcML7f4Vuc6E4Rjs7gSl5hZnt9I/FHYyK0VM
         sM3x4O9lUQowA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F313CE5CF96;
        Mon, 21 Feb 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: core: Use csum_replace_by_diff() and
 csum_sub() instead of opencoding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544481099.22815.13035451971894621849.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 12:00:10 +0000
References: <491e9d549dd6b5d1b50e4540536f4fa4ce4e968f.1645171288.git.christophe.leroy@csgroup.eu>
In-Reply-To: <491e9d549dd6b5d1b50e4540536f4fa4ce4e968f.1645171288.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Feb 2022 09:03:48 +0100 you wrote:
> Open coded calculation can be avoided and replaced by the
> equivalent csum_replace_by_diff() and csum_sub().
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
> v2: Dropped the change in nft_csum_replace() as it would
> require nasty casts.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: core: Use csum_replace_by_diff() and csum_sub() instead of opencoding
    https://git.kernel.org/netdev/net-next/c/0f6938eb2ecc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


