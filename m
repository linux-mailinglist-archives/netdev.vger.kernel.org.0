Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2776CFAB1
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjC3FU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3FUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6749C5251;
        Wed, 29 Mar 2023 22:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8492EB825DD;
        Thu, 30 Mar 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D2DDC433A1;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680153620;
        bh=eLnX9C0HculASqIx67kDnzeJVhJKiMIKW1pdkdDty6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YDFQVgRkUS8jLcyNe6PTRXGArDGlx4wSStrEc0FcDhrwrtDT1cz9PwgbZQ9cWD+JV
         fRxQDSxXapaWIo4xB9303gJrFGe/IdgzyW7FCAqrLC74Id7pSlK70xQGEWY1eGUubE
         fiN9BlKJsGoUYydrd3Nr6Yj1DCL0xaYcj1LXnjaoSAUVYHspGummyeOWLVQSr0xmqu
         gd5IlBGQiwn6O4Z2DtJ24zunplTxoBhcYgPHi53ayi3Co/pQfuVQCF9CuR8J+OcD6o
         Ge07BUSQmE5g1K0J6w4SWCgdIWZ8uT4mfEKvyOWg7ByZFwcoighzjdWr1ere0UzDPO
         maoycg6a7zGsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B3BEE49FA8;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeon_ep: unlock the correct lock on error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015362010.23884.2577673628429781516.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 05:20:20 +0000
References: <251aa2a2-913e-4868-aac9-0a90fc3eeeda@kili.mountain>
In-Reply-To: <251aa2a2-913e-4868-aac9-0a90fc3eeeda@kili.mountain>
To:     Dan Carpenter <error27@gmail.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 09:51:37 +0300 you wrote:
> The h and the f letters are swapped so it unlocks the wrong lock.
> 
> Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> Thees vairable nmaes are terirble.  The huamn mnid deos not raed ervey
> lteter by istlef, but the wrod as a wlohe.
> 
> [...]

Here is the summary with links:
  - [net-next] octeon_ep: unlock the correct lock on error path
    https://git.kernel.org/netdev/net-next/c/765f3604641e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


