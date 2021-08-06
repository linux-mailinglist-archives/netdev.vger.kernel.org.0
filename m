Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6B63E31D0
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbhHFWeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhHFWeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4661861181;
        Fri,  6 Aug 2021 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628289237;
        bh=8CvfS4Q4Yg/v3TtJJHxNOOwDp7fwO9outeVvtTPZVQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fBvPw75amq4qR6hdFg7tPvAxyowzWuqKw9mt/abiyEFKJNPYh7z3VqDySAO7Ac0BV
         t3FKOcMExq/6pxSOA0tctpCEp1ja9G9CrvS3aIhM/6tFMHvbrG4oWuksBMR/Xs3l9o
         i/2zyrKe1kyhSPDCdjxxPFG4p4zF+e2tSdiPPFc/a58V77usCbKi8DdJ+BI/iv8weO
         zqgqsGxNcgwX7wDbRKsj4Op55yXpb2grAkUpCATsRuI8lmF8nl++ePTco/YTL7CZ8a
         +7N0rwKxTb8S6OHnq5bCIO0Tne9QlWqrq8QNOYneDdnbfaHe1DW2wlWwESDCJgmoq2
         VznOn8s2aDAPA==
Date:   Fri, 6 Aug 2021 15:33:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/9,v2] Netfilter fixes for net
Message-ID: <20210806153356.1d045a3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Aug 2021 17:11:40 +0200 Pablo Neira Ayuso wrote:
> 1) Restrict range element expansion in ipset to avoid soft lockup,
>    from Jozsef Kadlecsik.
> 
> 2) Memleak in error path for nf_conntrack_bridge for IPv4 packets,
>    from Yajun Deng.
> 
> 3) Simplify conntrack garbage collection strategy to avoid frequent
>    wake-ups, from Florian Westphal.
> 
> 4) Fix NFNLA_HOOK_FUNCTION_NAME string, do not include module name.
> 
> 5) Missing chain family netlink attribute in chain description
>    in nfnetlink_hook.
> 
> 6) Incorrect sequence number on nfnetlink_hook dumps.
> 
> 7) Use netlink request family in reply message for consistency.
> 
> 8) Remove offload_pickup sysctl, use conntrack for established state
>    instead, from Florian Westphal.
> 
> 9) Translate NFPROTO_INET/ingress to NFPROTO_NETDEV/ingress, since
>    NFPROTO_INET is not exposed through nfnetlink_hook.

Looks like the bot doesn't want to respond :S

Pulled in the morning already, thanks!
