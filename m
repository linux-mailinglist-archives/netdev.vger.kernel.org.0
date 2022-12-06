Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560CC6442F7
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiLFMKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiLFMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C671328707;
        Tue,  6 Dec 2022 04:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68353B819F3;
        Tue,  6 Dec 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20B21C433B5;
        Tue,  6 Dec 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670328616;
        bh=ETGnmd1O9+aniN78yXCjXGkWtlEBHjIXa79cICgB08A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vLHNcdfNG8ZOuzPxcx5cWd3vUXKVbSYtrwlsLOO+6lPuEgd3PEW9MUXyPoxV4Ngki
         erBWErMKjJ8xW4cpRR9C3Ht/WrDF9/rhQf4QnIi8UmJnZ04v+Igx0r0nIuniX+EBhJ
         rnvnB4FXBQWj3zPi8QX4/4ffzCukwaE3mFF+DyKDs+Fcktv9Vs7zCrswHv5UaQrqHo
         j/ReDUaib3rwaL42rZ+RU31eI6TXoWKU2A7k3TghLienTWE0Ua4MvfO2Voq6Ck9ZAn
         zD9r/tX1EbZ55NiZ4WCK1JUx7tS0gexad8KLs82ryZMwUkoh6hNnyXSPGxXxtYKiQp
         9W590rm0RluiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 029BDC395E5;
        Tue,  6 Dec 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: Fix potential OOB in tipc_link_proto_rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032861600.21886.17007946309136879304.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 12:10:16 +0000
References: <20221203094635.29024-1-yuehaibing@huawei.com>
In-Reply-To: <20221203094635.29024-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
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

On Sat, 3 Dec 2022 17:46:35 +0800 you wrote:
> Fix the potential risk of OOB if skb_linearize() fails in
> tipc_link_proto_rcv().
> 
> Fixes: 5cbb28a4bf65 ("tipc: linearize arriving NAME_DISTR and LINK_PROTO buffers")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/tipc/link.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] tipc: Fix potential OOB in tipc_link_proto_rcv()
    https://git.kernel.org/netdev/net/c/743117a997bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


