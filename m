Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6B55D649
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiF0LAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiF0LAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0EC6417
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94B961361
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57AB6C341CD;
        Mon, 27 Jun 2022 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656327618;
        bh=kPyh8XLtGWlMOzJ3304Vh6mb2pl1arOS5ApigtrXImA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ekgyiz5EoIu+nQ5dItE9pA4Wq/AyG+w+8raaZ9Sl7ySXvUSUyvK+36dMikFIoCrWl
         zCpw9XF/kET3DaPUAA5RLO6ucIUQoPpOJgTXycZEoi70yysTfA06uH9czuFu8LNbxt
         5q6pt+OsdUnrtIb1pDGwzdWxb7+FeBv+HS9m7T6jKKF9Kwt1D2sKDp6x2sBqW5EK03
         qhqovVlohRP1YoVOSLpuDiG5z36Qofq1w8q76O97FBDC/mvrtvtVSHpMvlEZ0TuoEi
         1kFwPVM/jvDge55xouWKJYX/IpxKa05cImLd6d8gfiKnZTFfxuLPhTgYtEppawMJOv
         SnybvELdVVC8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DF5BE49BBA;
        Mon, 27 Jun 2022 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: Print hashed skb addresses for all net and
 qdisc events
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632761825.13770.14445875022543413232.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 11:00:18 +0000
References: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
In-Reply-To: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        quic_jzenner@quicinc.com, cong.wang@bytedance.com,
        qitao.xu@bytedance.com, bigeasy@linutronix.de, rostedt@goodmis.org,
        mingo@redhat.com, quic_stranche@quicinc.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 24 Jun 2022 15:34:25 -0600 you wrote:
> The following commits added support for printing the real address-
> 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
> 70713dddf3d2 ("net_sched: introduce tracepoint trace_qdisc_enqueue()")
> 851f36e40962 ("net_sched: use %px to print skb address in trace_qdisc_dequeue()")
> 
> However, tracing the packet traversal shows a mix of hashes and real
> addresses. Pasting a sample trace for reference-
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: Print hashed skb addresses for all net and qdisc events
    https://git.kernel.org/netdev/net-next/c/6deb209dc6b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


