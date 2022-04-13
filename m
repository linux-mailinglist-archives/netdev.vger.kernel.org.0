Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86E34FF7A5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiDMNcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiDMNck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CDF1B786;
        Wed, 13 Apr 2022 06:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA84B824AF;
        Wed, 13 Apr 2022 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC7DFC385A8;
        Wed, 13 Apr 2022 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649856616;
        bh=85lID7Y8b/51FkWR0s29xGJVseeMIQt5vDZECBrzLy4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AAsb8InHwtqgg6vNgBUIAYWq8UQE3mExKtGlt5tSJ/CWECeF6ZB1h+jJeaik4xk5S
         06SFsgz+4q3qRspsApWN1DQ1uv+7lXHZQn6ikaXMbE637OGssEFpouAAilcohYvWOu
         0s5ERTyol+pvljKf0M/qvHiOwvvXPmm/YAj/gMLUI51RwWxOc/jg1fWSCqwdlQZhfT
         u6e3vCs8wx/iJwrtIZgWd+YTVAB0Fs0aA+JMv52OibMDU0TMtMx6aUR0KrbHdX7+Kd
         OPWnwb+NoACSzmBObWJ82WfWQXkInY6PhW7854KhyzWDTnz6S3VSz6vtlbV/JrhLWE
         0263kB3W4LZrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3B62E8DD5E;
        Wed, 13 Apr 2022 13:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: ip: add skb drop reasons to ip ingress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985661586.7515.1894293980770406853.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:30:15 +0000
References: <20220413081600.187339-1-imagedong@tencent.com>
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Wed, 13 Apr 2022 16:15:51 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the series "net: use kfree_skb_reason() for ip/udp packet receive",
> skb drop reasons are added to the basic ingress path of IPv4. And in
> the series "net: use kfree_skb_reason() for ip/neighbour", the egress
> paths of IPv4 and IPv6 are handled. Related links:
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] skb: add some helpers for skb drop reasons
    https://git.kernel.org/netdev/net-next/c/d6d3146ce532
  - [net-next,2/9] net: ipv4: add skb drop reasons to ip_error()
    https://git.kernel.org/netdev/net-next/c/c4eb664191b4
  - [net-next,3/9] net: ipv6: add skb drop reasons to ip6_pkt_drop()
    https://git.kernel.org/netdev/net-next/c/3ae42cc8092b
  - [net-next,4/9] net: ip: add skb drop reasons to ip forwarding
    https://git.kernel.org/netdev/net-next/c/2edc1a383fda
  - [net-next,5/9] net: icmp: introduce function icmpv6_param_prob_reason()
    https://git.kernel.org/netdev/net-next/c/1ad6d548e2a4
  - [net-next,6/9] net: ipv6: remove redundant statistics in ipv6_hop_jumbo()
    https://git.kernel.org/netdev/net-next/c/bba98083499f
  - [net-next,7/9] net: ipv6: add skb drop reasons to TLV parse
    https://git.kernel.org/netdev/net-next/c/7d9dbdfbfdc5
  - [net-next,8/9] net: ipv6: add skb drop reasons to ip6_rcv_core()
    https://git.kernel.org/netdev/net-next/c/4daf841a2ef3
  - [net-next,9/9] net: ipv6: add skb drop reasons to ip6_protocol_deliver_rcu()
    https://git.kernel.org/netdev/net-next/c/eeab7e7ff43e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


