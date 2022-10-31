Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65806614162
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 00:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJaXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 19:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJaXKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 19:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3520A1573F;
        Mon, 31 Oct 2022 16:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDF80614E2;
        Mon, 31 Oct 2022 23:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18715C433B5;
        Mon, 31 Oct 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667257816;
        bh=+7JgGumB5ZTimtp+I3yCzX++H/Sbj/A/EzwFniHPKrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4TCWu2uHwzlNwX8oYsuM0Q6we8N8vIqJLbov1L3pnLatMeAW0QGXx0quYk53ZzHe
         HsVIe5t0DOnaMyCX3SKUs2tV/pNW4Ytbrx1AR50skYExjcnO2/XgLOctAcYMkKcub3
         bZ8CJBhGopwyOFGOd/3t50cSAmvO8pruuQcBxSERuSyh5E19Q9XgmMemS0bqH2PWd4
         OkWbOXrc0d8V/Y9MlKjkAepAVK9RR4nAF0Iz5QUAOuMa5fmOdwfqVM6QnIsM2t8yqd
         AIGfcs2AWUD2oA1uDAT8WzwNBfoKu/DZ5yq7anpIs1Uc+bemWyuoTpaT0i7BaP8rFZ
         okT80tjALlgtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE097C41621;
        Mon, 31 Oct 2022 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bluetooth: Use kzalloc instead of kmalloc/memset
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166725781597.15466.7988484635308964186.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 23:10:15 +0000
References: <20221029204541.20967-1-tegongkang@gmail.com>
In-Reply-To: <20221029204541.20967-1-tegongkang@gmail.com>
To:     Kang Minchul <tegongkang@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sun, 30 Oct 2022 05:45:41 +0900 you wrote:
> This commit replace kmalloc + memset to kzalloc
> for better code readability and simplicity.
> 
> Following messages are related cocci warnings.
> 
> WARNING: kzalloc should be used for d, instead of kmalloc/memset
> 
> [...]

Here is the summary with links:
  - net: bluetooth: Use kzalloc instead of kmalloc/memset
    https://git.kernel.org/bluetooth/bluetooth-next/c/214c507d87cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


