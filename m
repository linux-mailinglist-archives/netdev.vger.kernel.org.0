Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E998A49E47E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbiA0OUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242294AbiA0OUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D5BC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 06:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 429B8B8226E
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14347C340E8;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643293213;
        bh=KoUKzqnngNZ0HwIs010CMMjFeAfCNMLciIu7nKEIFT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P/CPoq3ykCYslenY589sF36QTaXbaYA+X7Yh+gFObNPJhqUwDG092NygeGirJD2VT
         ESP3kDdAiUjk+IFbttGCauULdjFtS/R4jRLDnWTjnzYoDroIG8/W5CGVZZ65Dum4Aa
         qA36XrjOysUWFap63UOp91zppApnzxYBHw6CZC2ZmGHkjtWxK2XYmor3F8g1ZjHXxH
         +yZgZfZMmc6pX+YhhvHJbmb4fSO4ugJlmfbQSVPcMh6uHZPE6UyhGfyDemeArZp43f
         wNcMDirFs7CUcisGXen1sQ0kZ1A8oyxId2Mm7xv/1CbFWEcSW6I7xC20KfZaNDhAps
         V7rLTny8eigpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 050AEE5D08C;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: get rid of unused static inlines
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329321301.24382.1010946746599983156.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:20:13 +0000
References: <20220126191109.2822706-1-kuba@kernel.org>
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 11:10:54 -0800 you wrote:
> I noticed a couple of unused static inline functions reviewing
> net/sched patches so I run a grep thru all of include/ and net/
> to catch other cases. This set removes the cases which look like
> obvious dead code.
> 
> Jakub Kicinski (15):
>   mii: remove mii_lpa_to_linkmode_lpa_sgmii()
>   nfc: use *_set_vendor_cmds() helpers
>   net: remove net_invalid_timestamp()
>   net: remove linkmode_change_bit()
>   net: remove bond_slave_has_mac_rcu()
>   net: ax25: remove route refcount
>   hsr: remove get_prp_lan_id()
>   ipv6: remove inet6_rsk() and tcp_twsk_ipv6only()
>   dccp: remove max48()
>   udp: remove inner_udp_hdr()
>   udplite: remove udplite_csum_outgoing()
>   netlink: remove nl_set_extack_cookie_u32()
>   net: sched: remove psched_tdiff_bounded()
>   net: sched: remove qdisc_qlen_cpu()
>   net: tipc: remove unused static inlines
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] mii: remove mii_lpa_to_linkmode_lpa_sgmii()
    https://git.kernel.org/netdev/net-next/c/bd5daba2d024
  - [net-next,02/15] nfc: use *_set_vendor_cmds() helpers
    https://git.kernel.org/netdev/net-next/c/f7bfd110f168
  - [net-next,03/15] net: remove net_invalid_timestamp()
    https://git.kernel.org/netdev/net-next/c/b1755400b4be
  - [net-next,04/15] net: remove linkmode_change_bit()
    https://git.kernel.org/netdev/net-next/c/08dfa5a19e1f
  - [net-next,05/15] net: remove bond_slave_has_mac_rcu()
    https://git.kernel.org/netdev/net-next/c/8b0fdcdc3a7d
  - [net-next,06/15] net: ax25: remove route refcount
    https://git.kernel.org/netdev/net-next/c/560e08eda796
  - [net-next,07/15] hsr: remove get_prp_lan_id()
    https://git.kernel.org/netdev/net-next/c/0ab1e6d9a453
  - [net-next,08/15] ipv6: remove inet6_rsk() and tcp_twsk_ipv6only()
    https://git.kernel.org/netdev/net-next/c/8b2d546e23bb
  - [net-next,09/15] dccp: remove max48()
    https://git.kernel.org/netdev/net-next/c/1303f8f0df24
  - [net-next,10/15] udp: remove inner_udp_hdr()
    https://git.kernel.org/netdev/net-next/c/cc81df835c25
  - [net-next,11/15] udplite: remove udplite_csum_outgoing()
    https://git.kernel.org/netdev/net-next/c/937fca918aac
  - [net-next,12/15] netlink: remove nl_set_extack_cookie_u32()
    https://git.kernel.org/netdev/net-next/c/d59a67f2f3f3
  - [net-next,13/15] net: sched: remove psched_tdiff_bounded()
    https://git.kernel.org/netdev/net-next/c/98b608629746
  - [net-next,14/15] net: sched: remove qdisc_qlen_cpu()
    https://git.kernel.org/netdev/net-next/c/a459bc9a3a68
  - [net-next,15/15] net: tipc: remove unused static inlines
    https://git.kernel.org/netdev/net-next/c/5e4eca5d929a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


