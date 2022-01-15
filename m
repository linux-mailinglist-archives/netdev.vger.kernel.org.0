Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB948F74F
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 15:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiAOOjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 09:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiAOOjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 09:39:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2FC061574;
        Sat, 15 Jan 2022 06:39:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n8kDK-00065G-2Z; Sat, 15 Jan 2022 15:39:30 +0100
Date:   Sat, 15 Jan 2022 15:39:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: conntrack: mark UDP zero checksum as
 CHECKSUM_UNNECESSARY
Message-ID: <20220115143930.GA23292@breakpoint.cc>
References: <20220115040050.187972-1-kevmitch@arista.com>
 <20220115040050.187972-2-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220115040050.187972-2-kevmitch@arista.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Mitchell <kevmitch@arista.com> wrote:
> The udp_error function verifies the checksum of incoming UDP packets if
> one is set. This has the desirable side effect of setting skb->ip_summed
> to CHECKSUM_COMPLETE, signalling that this verification need not be
> repeated further up the stack.

Acked-by: Florian Westphal <fw@strlen.de>
