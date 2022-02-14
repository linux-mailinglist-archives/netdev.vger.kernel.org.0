Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF714B4F4A
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351410AbiBNLsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:48:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352099AbiBNLjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:39:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A15E13E37
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7ABFCCE1312
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C00C9C340EF;
        Mon, 14 Feb 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644838210;
        bh=E5hykxI78J1EPZO4H+AMHNENP7C1uz58N9JmNABAZB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cqzKULIsvo+OVZkaW/yxYc3MuIud0Q0FNa0fFEpKPv4fq8vtIgKk1v/z2BYmdWwAP
         qx4H74MD51OqNs5/XLRYlHUPFGSIp434x8tkPRheU3OGleYh65iF2xsY085P53DgDA
         cRv8GZYkQmy+z2z7+sO4ylZBeS65QGKnzEor+7/dx2IG7KwcbgKQPwCQPFgLrwbPK2
         KVVM28U1+HNmRjHkFuieFy5zCb/kT+vxIbb7vW8Q7NQ0rgJSBZ4yQTsvi/jii78ZZP
         tdRdR4y/a2AuSfGrVtd3nZY6MFDAoomnYeaAfM8Nq+aAVxO7B6hj4Y14WvYHPHEhOx
         tsnMxN0WT47Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB39CE6D447;
        Mon, 14 Feb 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: Add reasons for skb drops to __udp6_lib_rcv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483821069.17157.13234288267291322928.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:30:10 +0000
References: <20220211171507.3969-1-dsahern@kernel.org>
In-Reply-To: <20220211171507.3969-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        menglong8.dong@gmail.com, edumazet@google.com, willemb@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 09:15:07 -0800 you wrote:
> Add reasons to __udp6_lib_rcv for skb drops. The only twist is that the
> NO_SOCKET takes precedence over the CSUM or other counters for that
> path (motivation behind this patch - csum counter was misleading).
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv6/udp.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] ipv6: Add reasons for skb drops to __udp6_lib_rcv
    https://git.kernel.org/netdev/net-next/c/4cf91f825b27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


