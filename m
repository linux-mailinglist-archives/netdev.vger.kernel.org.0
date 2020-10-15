Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14A28F906
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbgJOTAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgJOTAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:00:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602788403;
        bh=N55ccZ/rzJou2YLouFwZZjyjuBas/nLYIIQnYzpFMwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XBzTUie2lal3skDMsX8FmMi5npfO2uwXgZbcz5hnlA3Lp9snfxrcVWhOjaLGDqASK
         xezKyQYAEwlhPKAjg/d/yTnZmqQ/I7Q9rzgeLA+aU/ZEScq3k9mdX4h7pETr5PkS7D
         9Oj4J2S2PuJLln9viaV6C6Yq/SLXFUPKd3/Z1AG8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netfilter: nftables: allow re-computing sctp CRC-32C
 in 'payload' statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160278840371.31870.4457528335122262441.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Oct 2020 19:00:03 +0000
References: <20201015163927.28730-1-pablo@netfilter.org>
In-Reply-To: <20201015163927.28730-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Oct 2020 18:39:27 +0200 you wrote:
> From: Davide Caratti <dcaratti@redhat.com>
> 
> nftables payload statements are used to mangle SCTP headers, but they can
> only replace the Internet Checksum. As a consequence, nftables rules that
> mangle sport/dport/vtag in SCTP headers potentially generate packets that
> are discarded by the receiver, unless the CRC-32C is "offloaded" (e.g the
> rule mangles a skb having 'ip_summed' equal to 'CHECKSUM_PARTIAL'.
> 
> [...]

Here is the summary with links:
  - [net-next] netfilter: nftables: allow re-computing sctp CRC-32C in 'payload' statements
    https://git.kernel.org/netdev/net-next/c/346e320cb210

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


