Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947C94FB856
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbiDKJyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344948AbiDKJxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:53:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0BC41618;
        Mon, 11 Apr 2022 02:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF34CB811CF;
        Mon, 11 Apr 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8445DC385AD;
        Mon, 11 Apr 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649670612;
        bh=TqRy/2gYy2v7KE9B1nAZrSGCHM8o3LIRywUfjnn7Sj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OSN052LfKtOzHJDXQgMBgIdgGZat8s6rPKg2CK2+6ilbQVXQdSG/6F/b4JXcrcUho
         SVqmnX29JTxr9duRhlHU48DAId6/edEhU1FXblrQnYRQFwSX5GEwYIlTdamt+3h1h7
         saG2dwiHBXudE8DRSysZJHOi0+LwicGLaa6sIz8dQoXyELwG/fBGVLOv9yNuPI0+U6
         hU/V/7f4hpz/PO2Snv7fF2tbrq1l5CgbxdhIg7k+MJ7VlN0cg1pjuvTlQgrnG01VC2
         fa684sa8inyLQ/+ll1hbR33KNfj1nB/2yvV13DWOwdUEKlRd/xOw2IOmmIJD+Jk8DC
         aST0gOrF2McJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68CBBE7399B;
        Mon, 11 Apr 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ethernet: mtk_eth_soc: fix return value check in
 mtk_wed_add_hw()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967061242.14330.11429373282379564824.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 09:50:12 +0000
References: <20220408032246.3089403-1-yangyingliang@huawei.com>
In-Reply-To: <20220408032246.3089403-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, nbd@nbd.name,
        davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 8 Apr 2022 11:22:46 +0800 you wrote:
> If syscon_regmap_lookup_by_phandle() fails, it never return NULL pointer,
> change the check to IS_ERR().
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: ethernet: mtk_eth_soc: fix return value check in mtk_wed_add_hw()
    https://git.kernel.org/netdev/net-next/c/b559edfaf3f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


