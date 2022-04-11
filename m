Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9332C4FB882
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344782AbiDKJyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344943AbiDKJw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963D24160F;
        Mon, 11 Apr 2022 02:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D90611FA;
        Mon, 11 Apr 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75C93C385AA;
        Mon, 11 Apr 2022 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649670612;
        bh=GuJFG53Lyt1GJWIAIkP2ZLP4k7bednAsSosnxkzKEvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ljqi4+aVEpo3l/6vai2pbhlpFy33dAC8X2BpoABkMlf11n6IzWB24DyD4xic06plD
         ejHSzGsPA43MD8YKB22E1BS8mEBZ8FY1l/gcADMHj8XGrPYUNNAOTqciakUeFcqZ/V
         VC+iv46S+m4LxTapSin1UNtCGtwufLp6GurKNI95BiDpHiIDLcw5JX7eIktiRIBySB
         trnyEEB5C+heli5zKeKx1n5kv9sxCsQuotCzC81um1BPFPx7whsCU5tUEyonEgVI2a
         GzISkVu6DS7xUMBdg1duJFqEreWaul4oe69o7yn2u0H2+UqNx9qLXAI3nxB9J8yNRF
         Uqv4vQ0mQjo/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C63AE85B76;
        Mon, 11 Apr 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next v5 0/4] net: icmp: add skb drop reasons to
 icmp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967061237.14330.9593328118973073943.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 09:50:12 +0000
References: <20220407062052.15907-1-imagedong@tencent.com>
In-Reply-To: <20220407062052.15907-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
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

On Thu,  7 Apr 2022 14:20:48 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> we added the support of reporting the reasons of skb drops to kfree_skb
> tracepoint. And in this series patches, reasons for skb drops are added
> to ICMP protocol.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,v5,1/4] net: sock: introduce sock_queue_rcv_skb_reason()
    https://git.kernel.org/netdev/net-next/c/c1b8a56755ee
  - [RESEND,net-next,v5,2/4] net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
    https://git.kernel.org/netdev/net-next/c/9f8ed577c288
  - [RESEND,net-next,v5,3/4] net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
    https://git.kernel.org/netdev/net-next/c/41a95a00ebef
  - [RESEND,net-next,v5,4/4] net: icmp: add skb drop reasons to icmp protocol
    https://git.kernel.org/netdev/net-next/c/b384c95a861e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


