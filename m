Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF7455C6F1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244564AbiF1FkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiF1FkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2313F24;
        Mon, 27 Jun 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E281B6181B;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B674C341D4;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=FbqZikgJ6ANJsxawSOoKjUqMDWwUYx1FEWvzJxopyOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ngKiuC0ZH+AlEUt349rHOZktFizZax7iGmSXjIbsRg+Mavu0i8DYRH3eBLeMVj0El
         zZBNLpoQgtD8HBRZkpD/MdbwbtlvNP4tew5uR3TEhrCLGh5LwuZ7EyE5gJKNNv/UhQ
         JfG+EvCBMa3FxyixjIMKHUwMqiGtNWzm2pG9bDspll2J9CRjguzJa3e0kbJ3ORiKEg
         Z2FRzLQlWhcoMYSKcyhJprgXcE8HQ5LIJzGxZk7agL1Tq1gPgfZPQNettGgVEPMvD8
         Z82c1KKcvL8HtxxhethNSAWOC7kduYB4WBZ6HBHUy1/oOrz+Lz+KUUCd06QymJ05NG
         KeAJoAQRXg29w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E678E49FA5;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] agere:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481512.10558.4102540157487813093.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:15 +0000
References: <20220625065745.61464-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220625065745.61464-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mark.einon@gmail.com, jgg@ziepe.ca,
        arnd@arndb.de, christophe.jaillet@wanadoo.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 25 Jun 2022 14:57:45 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/agere/et131x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - agere:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/e3e2bad76a50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


