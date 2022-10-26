Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49A260D979
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiJZDAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiJZDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF77357DF;
        Tue, 25 Oct 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB43B61CA0;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DF33C43149;
        Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753217;
        bh=0CY50zjDA3c+3KmPfh8eQwxcrXoZ6EdJG87rSMYGAfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oI4w0sPbgypCeEF3wSxiayPLiIJXZiRDOW/AKHpe+cQaiVXm0L8KPC4Lc7WyHo79i
         S4RphdyV9WZf6MdfuCAaw83oxNgRB0JcQRwhnQH2OL/z6PV/HX+IAmLKBSxEFDzutP
         sWIcsULd5/UkLnn44Jo9Q0gXdZylv+e7C82DBLHfD/6CUlMF9AhdPB8Rs0CPoPXiG2
         XC7nF4PbawNkEGkRU39KUbCTGkowcTdWJ5N1oYlZYRJcWactAGY5OsqFK5ukg2BaQi
         YuIytt0/Y/hBXZkxqwjvkNRh8eyvZGlJLK0uJLZ9w5+5xix1tiMgEhLhgLwonOBY/c
         jYXa4eir9KCuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0437E270DD;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bna: remove variable num_entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675321698.7735.7831125574591565699.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 03:00:16 +0000
References: <20221024125951.2155434-1-colin.i.king@gmail.com>
In-Reply-To: <20221024125951.2155434-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 13:59:51 +0100 you wrote:
> Variable num_entries is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/brocade/bna/bfa_msgq.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - bna: remove variable num_entries
    https://git.kernel.org/netdev/net-next/c/bb214ac47e0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


