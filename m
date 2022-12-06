Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA76442D5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiLFMD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiLFMDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:03:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B48A2C657
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C2C5B819D0
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC172C43148;
        Tue,  6 Dec 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670328015;
        bh=3mTSVRnWJULSRVPkSlSXubRboIcBQ6kwlQdr1J2CcmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSnH29p6EAcBqhSqi56gO6f5nqV+iLi0xWHW/8ZMHYLnthlmGRLXSxKStSSHAnLYB
         V8dGT8tQmOmAecgiFriMFuLOCitOz615fz5m9aQmgBp4Do2QtqcYGRTYEzgqQZAcju
         gpbUfsrnXuJ6IgO0LAK6ait8UvBm8PMP/jayB7jkRUkn3DqYQAxm3zNaEpGffx45qY
         6DFTu/meSiETgkfzpFk2hEo6ufi3aI7qocWvccLdgWoHgPQrbxy4f7dTW3aQr4IL7e
         tBeTh8+JkVX5Ttkjn+kYV7VoPAvjQTO7itZ/4rmcE3unRtU3KjOhNDz4ca77+Ia96Q
         OL2NBJdBFFf2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 952C2C395E5;
        Tue,  6 Dec 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hisilicon: Fix potential use-after-free in
 hix5hd2_rx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032801560.16172.3745332827059392233.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 12:00:15 +0000
References: <20221203094240.1240211-2-liujian56@huawei.com>
In-Reply-To: <20221203094240.1240211-2-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zhangfei.gao@linaro.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 17:42:40 +0800 you wrote:
> The skb is delivered to napi_gro_receive() which may free it, after
> calling this, dereferencing skb may trigger use-after-free.
> 
> Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: hisilicon: Fix potential use-after-free in hix5hd2_rx()
    https://git.kernel.org/netdev/net/c/433c07a13f59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


