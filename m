Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E6657E14F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiGVMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiGVMKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768BC120B0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1342C61EE7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63F57C341CA;
        Fri, 22 Jul 2022 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658491813;
        bh=2bzWjz/IXziUUjjXsFa/1Z4wUDIFy7afrY54d3dYBXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y7DNMxCmvQSGIC3ddbSB1i+Xry6ggp+nK+1OfxFwa47Ft3kQm4GML2LzKUkIQgay4
         IqKNHjOYmnk9JhB7LbohnxO2eXrzISh27qea3bXQlVZLHUTM4y8jfpnsBQ4Uci6wQC
         13X9fHFQm1E5s5pZwK5mz9gxwx+QY9zn2q5LHD/aTKSP2x6VWBL2fYtNty/Bir3LN/
         Wb9sPO8c9+rUeTQeBMjxVp2e0Qa6DhKYozwygaAookRq5JRhn13io9yhKEYudTRdHw
         g6cg1/ItxffXf0cMDocGORROblhBwDtGOy+5rY2is0S+W+9wPcxGoXAwzOqwXCO3ME
         xj8HQ22i6xuXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 434BFE451B3;
        Fri, 22 Jul 2022 12:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add missing includes and forward declarations
 under net/
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849181327.15716.14849150996894288516.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 12:10:13 +0000
References: <20220720235758.2373415-1-kuba@kernel.org>
In-Reply-To: <20220720235758.2373415-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Jul 2022 16:57:58 -0700 you wrote:
> This patch adds missing includes to headers under include/net.
> All these problems are currently masked by the existing users
> including the missing dependency before the broken header.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/lapb.h                |  5 +++++
>  include/net/af_vsock.h              |  1 +
>  include/net/amt.h                   |  3 +++
>  include/net/ax88796.h               |  2 ++
>  include/net/bond_options.h          |  8 ++++++++
>  include/net/codel_qdisc.h           |  1 +
>  include/net/datalink.h              |  7 +++++++
>  include/net/dcbevent.h              |  2 ++
>  include/net/dcbnl.h                 |  2 ++
>  include/net/dn_dev.h                |  1 +
>  include/net/dn_fib.h                |  2 ++
>  include/net/dn_neigh.h              |  2 ++
>  include/net/dn_nsp.h                |  6 ++++++
>  include/net/dn_route.h              |  3 +++
>  include/net/erspan.h                |  3 +++
>  include/net/esp.h                   |  1 +
>  include/net/ethoc.h                 |  3 +++
>  include/net/firewire.h              |  2 ++
>  include/net/fq.h                    |  4 ++++
>  include/net/garp.h                  |  2 ++
>  include/net/gtp.h                   |  4 ++++
>  include/net/gue.h                   |  3 +++
>  include/net/hwbm.h                  |  2 ++
>  include/net/ila.h                   |  2 ++
>  include/net/inet6_connection_sock.h |  2 ++
>  include/net/inet_common.h           |  6 ++++++
>  include/net/inet_frag.h             |  3 +++
>  include/net/ip6_route.h             | 20 ++++++++++----------
>  include/net/ipcomp.h                |  2 ++
>  include/net/ipconfig.h              |  2 ++
>  include/net/llc_c_ac.h              |  7 +++++++
>  include/net/llc_c_st.h              |  4 ++++
>  include/net/llc_s_ac.h              |  4 ++++
>  include/net/llc_s_ev.h              |  1 +
>  include/net/mpls_iptunnel.h         |  3 +++
>  include/net/mrp.h                   |  4 ++++
>  include/net/ncsi.h                  |  2 ++
>  include/net/netevent.h              |  1 +
>  include/net/netns/can.h             |  1 +
>  include/net/netns/core.h            |  2 ++
>  include/net/netns/generic.h         |  1 +
>  include/net/netns/ipv4.h            |  1 +
>  include/net/netns/mctp.h            |  1 +
>  include/net/netns/mpls.h            |  2 ++
>  include/net/netns/nexthop.h         |  1 +
>  include/net/netns/sctp.h            |  3 +++
>  include/net/netns/unix.h            |  2 ++
>  include/net/netrom.h                |  1 +
>  include/net/p8022.h                 |  5 +++++
>  include/net/phonet/pep.h            |  3 +++
>  include/net/phonet/phonet.h         |  4 ++++
>  include/net/phonet/pn_dev.h         |  5 +++++
>  include/net/pptp.h                  |  3 +++
>  include/net/psnap.h                 |  5 +++++
>  include/net/regulatory.h            |  3 +++
>  include/net/rose.h                  |  1 +
>  include/net/secure_seq.h            |  2 ++
>  include/net/smc.h                   |  7 +++++++
>  include/net/stp.h                   |  2 ++
>  include/net/transp_v6.h             |  2 ++
>  include/net/tun_proto.h             |  3 ++-
>  include/net/udplite.h               |  1 +
>  include/net/xdp_priv.h              |  1 +
>  63 files changed, 183 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: add missing includes and forward declarations under net/
    https://git.kernel.org/netdev/net-next/c/949d6b405e61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


