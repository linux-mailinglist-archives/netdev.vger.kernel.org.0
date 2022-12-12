Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B5C64A91D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiLLVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiLLVBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DE119035;
        Mon, 12 Dec 2022 13:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1614461228;
        Mon, 12 Dec 2022 21:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69CA3C4339B;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670878816;
        bh=YRd0tagvi9BC26uw6x2m0UsaWZT0o6bEr0lMaqUgtfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J3weV9Tbfg3+i0T2i/gD9bP7ZSz+UFtFLtcatrB20cYkH6NHR0QbcKhkk96zLmD36
         k5USjBYx+M2WnEMYVyOYbjkmBQWPgXS0GMEXiLywW2css6MdySWlhqAkYsiPxSzL5s
         MP86Jjzv22falC87oJ6AUdy71Z7k3ZhgDRsGqYvruiy9rX1DKYEZH9ymnLgUQAgdpK
         E27+3tnWHPFJ9R8KcT+ZHkulF6K/7781OXVeEP6JXfLWRw/eVpv5VR8aTFscHO274i
         DPxTWD5bsDSyc2JwF6I79ywKoD9/b/+7enP4TruL8O/F1hssNEzosCfIRVKu4YHjgl
         xWJlZgS7mkvtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 563CCC41606;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ntb_netdev: Use dev_kfree_skb_any() in interrupt context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087881634.21711.12961648575460625809.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:00:16 +0000
References: <20221209000659.8318-1-epilmore@gigaio.com>
In-Reply-To: <20221209000659.8318-1-epilmore@gigaio.com>
To:     Eric Pilmore (GigaIO) <epilmore@gigaio.com>
Cc:     netdev@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, ntb@lists.linux.dev,
        allenbh@gmail.com, dave.jiang@intel.com, jdmason@kudzu.us
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Dec 2022 16:06:59 -0800 you wrote:
> From: Eric Pilmore <epilmore@gigaio.com>
> 
> TX/RX callback handlers (ntb_netdev_tx_handler(),
> ntb_netdev_rx_handler()) can be called in interrupt
> context via the DMA framework when the respective
> DMA operations have completed. As such, any calls
> by these routines to free skb's, should use the
> interrupt context safe dev_kfree_skb_any() function.
> 
> [...]

Here is the summary with links:
  - [v2] ntb_netdev: Use dev_kfree_skb_any() in interrupt context
    https://git.kernel.org/netdev/net/c/5f7d78b2b12a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


