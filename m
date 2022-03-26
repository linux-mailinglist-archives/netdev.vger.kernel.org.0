Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6A4E838F
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiCZSvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiCZSvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:51:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E25836B42;
        Sat, 26 Mar 2022 11:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E743B80B62;
        Sat, 26 Mar 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAC5BC34100;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648320610;
        bh=O472JlvnQA8JnZoBwCaY5bBYhzerKOAsSju1d4d8O8I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SKXthjNL3jvu/Elwa6CgqNl74Y9zAurz6MXJh7GFweySKwCitgdm/253XO0rWgmHx
         f/I/S8+mPtnWl9Q9FXqnb0SQBA59G8d5zqVs7PM2iLlHdNekjjCVS66tZGq7PiI3pF
         AtSrZwUgWzG71lxuJwrlSKdju+k3lAqCCvic3qI9SxPnC/x12/NfnoDgGicDMTXhsQ
         SC9/WBBBHttUB8yg6a5ud7cMf/Qwfvl+qhU4yXjUBEOKRJUYcqhKHCQPpl61hENuGz
         CDLuf+jlwaBjqLcgTf49Bj5f7NRCMmliNvnSvDVJNnoIpya44GEGEQD8cX+J+Rcdg/
         H6hCFpotpUUmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 919ABF03848;
        Sat, 26 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: switchdev: fix possible NULL pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164832061059.28772.15281468495699037087.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 18:50:10 +0000
References: <20220326081239.9168-1-zhengyongjun3@huawei.com>
In-Reply-To: <20220326081239.9168-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 26 Mar 2022 08:12:39 +0000 you wrote:
> As the possible failure of the allocation, devm_kzalloc() may return NULL
> pointer.
> Therefore, it should be better to check the 'db' in order to prevent
> the dereference of NULL pointer.
> 
> Fixes: 10615907e9b51 ("net: sparx5: switchdev: adding frame DMA functionality")
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: sparx5: switchdev: fix possible NULL pointer dereference
    https://git.kernel.org/netdev/net/c/0906f3a3df07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


