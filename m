Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1750A4B05BE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiBJFuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:50:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiBJFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:50:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583EA1109;
        Wed,  9 Feb 2022 21:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 257EECE2321;
        Thu, 10 Feb 2022 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4695AC340E5;
        Thu, 10 Feb 2022 05:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644472212;
        bh=ldJp31AQ+gVj+gHSA2uNN9GtCrz5+WNNYYEDX2IAX3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IBTDOQX9To8q6u4c+Gm/NRIipi/Y2q4dwbu6B0kUsJ/S8D9DQRSrtLcjWuvjr0VID
         VD6Ct3GT1qrXQjPMKhPNSkkPMLqDSyeEVU7IYgBEniI2JoCHbnbp2J+kFMx5G0Co/+
         2ispj/Evvcmb8f82GzQVS1A1fz2BpyoCW6zOCk7w8J2xSZDTop5DGwLCtZwcI7JSXK
         9/62ONWF38lyujQvt6tR+LrV5ivwVQ+La7q2tgTAO65wgGudIMzWQ3IIhKcLZe3InQ
         b/OGt2ZZvoZc/Z5OQClpJnvUGYHnaqlsgzE0ork6TJRjGP0e9I3a7r4BlLGgezzUDL
         XS0uNekSl1n+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34FC3E5D084;
        Thu, 10 Feb 2022 05:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero checksum
 as CHECKSUM_UNNECESSARY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164447221221.5409.13974552264063226951.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 05:50:12 +0000
References: <20220209133616.165104-2-pablo@netfilter.org>
In-Reply-To: <20220209133616.165104-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  9 Feb 2022 14:36:03 +0100 you wrote:
> From: Kevin Mitchell <kevmitch@arista.com>
> 
> The udp_error function verifies the checksum of incoming UDP packets if
> one is set. This has the desirable side effect of setting skb->ip_summed
> to CHECKSUM_COMPLETE, signalling that this verification need not be
> repeated further up the stack.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY
    https://git.kernel.org/netdev/net-next/c/5bed9f3f63f8
  - [net-next,02/14] netfilter: nfqueue: enable to get skb->priority
    https://git.kernel.org/netdev/net-next/c/8b5413647262
  - [net-next,03/14] netfilter: conntrack: make all extensions 8-byte alignned
    https://git.kernel.org/netdev/net-next/c/bb62a765b1b5
  - [net-next,04/14] netfilter: conntrack: move extension sizes into core
    https://git.kernel.org/netdev/net-next/c/5f31edc0676b
  - [net-next,05/14] netfilter: conntrack: handle ->destroy hook via nat_ops instead
    https://git.kernel.org/netdev/net-next/c/1bc91a5ddf3e
  - [net-next,06/14] netfilter: conntrack: remove extension register api
    https://git.kernel.org/netdev/net-next/c/1015c3de23ee
  - [net-next,07/14] netfilter: conntrack: pptp: use single option structure
    https://git.kernel.org/netdev/net-next/c/20ff32024624
  - [net-next,08/14] netfilter: exthdr: add support for tcp option removal
    https://git.kernel.org/netdev/net-next/c/7890cbea66e7
  - [net-next,09/14] netfilter: nft_compat: suppress comment match
    https://git.kernel.org/netdev/net-next/c/c828414ac935
  - [net-next,10/14] netfilter: ecache: don't use nf_conn spinlock
    https://git.kernel.org/netdev/net-next/c/8dd8678e42b5
  - [net-next,11/14] netfilter: cttimeout: use option structure
    https://git.kernel.org/netdev/net-next/c/7afa38831aee
  - [net-next,12/14] netfilter: nft_cmp: optimize comparison for 16-bytes
    https://git.kernel.org/netdev/net-next/c/23f68d462984
  - [net-next,13/14] nfqueue: enable to set skb->priority
    https://git.kernel.org/netdev/net-next/c/98eee88b8dec
  - [net-next,14/14] netfilter: ctnetlink: use dump structure instead of raw args
    https://git.kernel.org/netdev/net-next/c/5948ed297eef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


