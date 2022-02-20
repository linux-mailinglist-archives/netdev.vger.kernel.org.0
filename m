Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E54BCEE7
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243976AbiBTOag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:30:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBTOaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B94240E41;
        Sun, 20 Feb 2022 06:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED69B80D44;
        Sun, 20 Feb 2022 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1704C340F0;
        Sun, 20 Feb 2022 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645367411;
        bh=HeZrcKR/lgSNS+/4ZyVGZPY0lkICBDxbcqGF2W7KZyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RiQABvqen/itqZyLL/Pj80FCA5Rxm1u4oh2Fym1aq79VNsSKT+iyWhhOQvnmCIsrG
         MBOPtN+PT85nVeb+iTULnZpS4e/xIfJx7vtBkOaaC1xAAxXTb/Q5SMHdxZXahq1HPu
         vlAdWSiVUrF7vPRHMIGUZe1RDiixqxym25761SVkHetcKdKDwUiIXNeNqITRsVxTMZ
         W1ds95++hNzMNk5DnP2Uk5LFxHzsx9g6WheEIA41IDe+Ul1C8dCLblbMkt48M0V33H
         xZenHTYFXK9ZhmIcqXa0vayn+c2D+SPht13/3ZLEZGj2AG7r2Sp8VA2ID13nX5AJp+
         vF11qOuCDlBNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 910A3E7BB19;
        Sun, 20 Feb 2022 14:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/9] net: add skb drop reasons to TCP packet
 receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164536741158.13103.3993205016299229625.git-patchwork-notify@kernel.org>
Date:   Sun, 20 Feb 2022 14:30:11 +0000
References: <20220220070637.162720-1-imagedong@tencent.com>
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, flyingpeng@tencent.com, mengensun@tencent.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 20 Feb 2022 15:06:28 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> we added the support of reporting the reasons of skb drops to kfree_skb
> tracepoint. And in this series patches, reasons for skb drops are added
> to TCP layer (both TCPv4 and TCPv6 are considered).
> Following functions are processed:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/9] net: tcp: introduce tcp_drop_reason()
    https://git.kernel.org/netdev/net-next/c/082116ffcb74
  - [net-next,v3,2/9] net: tcp: add skb drop reasons to tcp_v4_rcv()
    https://git.kernel.org/netdev/net-next/c/255f9034d305
  - [net-next,v3,3/9] net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
    https://git.kernel.org/netdev/net-next/c/c0e3154d9c88
  - [net-next,v3,4/9] net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
    https://git.kernel.org/netdev/net-next/c/643b622b51f1
  - [net-next,v3,5/9] net: tcp: add skb drop reasons to tcp_add_backlog()
    https://git.kernel.org/netdev/net-next/c/7a26dc9e7b43
  - [net-next,v3,6/9] net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
    https://git.kernel.org/netdev/net-next/c/8eba65fa5f06
  - [net-next,v3,7/9] net: tcp: use tcp_drop_reason() for tcp_rcv_established()
    https://git.kernel.org/netdev/net-next/c/2a968ef60e1f
  - [net-next,v3,8/9] net: tcp: use tcp_drop_reason() for tcp_data_queue()
    https://git.kernel.org/netdev/net-next/c/a7ec381049c0
  - [net-next,v3,9/9] net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
    https://git.kernel.org/netdev/net-next/c/d25e481be0c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


