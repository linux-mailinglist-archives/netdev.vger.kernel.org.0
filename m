Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E77F52AF60
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiERAuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiERAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEEF4F473;
        Tue, 17 May 2022 17:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E6F0B81D9E;
        Wed, 18 May 2022 00:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D05D5C34116;
        Wed, 18 May 2022 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652835011;
        bh=jsiL5avFp8i3OqPabbhTHKKKZ+7l1rs3LYu3KC/SPjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XiBZ0lqHis3ataO5ucJJGXTDvLuhHHsNej+sVtyeKSGWK0yk1YeIMvk1p6+4eeNBz
         N3XBFm95N+gmc15Rq8hXL3gtns3BQS0K00hQfwfm3sDuTIDj33RC420I1TPBOPf9jt
         JI604WOgQy6fEY5Eblrpmf5cQyfyC2iLseYin56uguiYpeEaBIkljhpE3iBRHg1nzf
         IuUmvFJeS3VXLoEUHbl97kOvBOnoqEQFThlSj7OLl7/de0g6A3z2+sZGspwicUVVnA
         EuA8/w4lZyI4bRVfKPfwxQSE1puMY1R69+o40iYve6mLUdn7EHLnIbBnBRw9sKypVH
         rvf4smyz87vhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAB62F0383D;
        Wed, 18 May 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: thunderx: remove null check after call container_of()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283501169.24421.7370839747235239114.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 00:50:11 +0000
References: <1652696212-17516-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1652696212-17516-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 May 2022 18:16:52 +0800 you wrote:
> container_of() will never return NULL, so remove useless code.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - net: thunderx: remove null check after call container_of()
    https://git.kernel.org/netdev/net-next/c/ab4d6357c95f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


