Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50E36132BB
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJaJaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJaJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8534DE8D;
        Mon, 31 Oct 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACAB7B812A4;
        Mon, 31 Oct 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60162C433B5;
        Mon, 31 Oct 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208616;
        bh=2hirn8oZToaPOo0zJF6+I7mD28CkBLy+ib/GNfmyPpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OHSqXBoFM5oIKe8gpAqgjpIbMANpYAfSjNAmA6AUUpllHmIwYtKK2nrneGaUAqys0
         mYJK+tg8mHW9Oa9D13b634mXvbpVweYdmBqbf42smPTFLVklEc9INDaDnGowuHMnI7
         ZeE5RbksG4xlO/Ya3HiXBJyqjr9+Uktj79lwrEk7cEVaZN55M7+l2fITvLxk+RdlY+
         T4x0Wi6zxutFyCsbRa30y9xV0SlVVbG7jmzq1UUfA2ijFCpTPwa1hRbms4gAyMRTRy
         +C6f7MIdu/D1xJ1TpaQiTaqNa7+gwth4GC9JzudYnRvFgQJVqiF55/hlGvRKEhHEXL
         sM+umoTnlpCDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39D9DC41621;
        Mon, 31 Oct 2022 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fec: fix improper use of NETDEV_TX_BUSY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720861622.19318.350956641724128666.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:30:16 +0000
References: <1666922951-1645-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1666922951-1645-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, B38611@freescale.com,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 10:09:11 +0800 you wrote:
> The ndo_start_xmit() method must not free skb when returning
> NETDEV_TX_BUSY, since caller is going to requeue freed skb.
> 
> Fix it by returning NETDEV_TX_OK in case of dma_map_single() fails.
> 
> Fixes: 79f339125ea3 ("net: fec: Add software TSO support")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: fec: fix improper use of NETDEV_TX_BUSY
    https://git.kernel.org/netdev/net/c/06a4df5863f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


