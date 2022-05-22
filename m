Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88A5305FC
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351471AbiEVUuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiEVUuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2732A70E;
        Sun, 22 May 2022 13:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA5E2B80DDF;
        Sun, 22 May 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C7DAC34117;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653252612;
        bh=ldi8O1qtRDuAXHyPh8pT4rq6MRpTr/ScwezZRlp4TSk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H9JTA4drh76PmwyrxuFsVHZ8RgypvxtG7AEs0iEdpid8I6SRA6Gf3TIZoWYMOhoha
         Q2ZH8IBxki/lokJ9dbHqjdg7Onqw1DTrt3AqI3xA5iSaYrGoHvvVzYG5qDdzKMbHDN
         yOulo664SFTMYu24+VWuGAbhcPgsJFTPCpujVQNYH/B5YugBWpAv+7YzXvgzBJcz3C
         zQTcXr9RYY2WY1pftDWaRTgup1UiCOFNr6q/xe+RAb7GcGrL486w72ObTFLAGVXQ+q
         dry/b6NL+RcgD03SZGrh1bWGqv35GVnulbAL9wNGAfqSf4Cim9AoriJJJkggbqrdi9
         5HPj/YeYlqaFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39572E8DBDA;
        Sun, 22 May 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: Avoid some over memory allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325261223.21066.1974036506521817731.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:50:12 +0000
References: <b9eb43e831e71b38d4d428dd7a8f4153608a4df6.1653114759.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b9eb43e831e71b38d4d428dd7a8f4153608a4df6.1653114759.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aviad.krawczyk@huawei.com, zhaochen6@huawei.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 08:33:01 +0200 you wrote:
> 'prod_idx' (atomic_t) is larger than 'shadow_idx' (u16), so some memory is
> over-allocated.
> 
> Fixes: b15a9f37be2b ("net-next/hinic: Add wq")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - hinic: Avoid some over memory allocation
    https://git.kernel.org/netdev/net/c/15d221d0c345

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


