Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77E47664D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhLOXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:04:38 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56386 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLOXEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:04:38 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14968625E9;
        Thu, 16 Dec 2021 00:02:09 +0100 (CET)
Date:   Thu, 16 Dec 2021 00:04:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nfnetlink: add netns refcount
 tracker to struct nfulnl_instance
Message-ID: <Ybp0gwrYnkqfOdD2@salvia>
References: <20211213164000.3241266-1-eric.dumazet@gmail.com>
 <Ybp0PBlE33giU8+a@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ybp0PBlE33giU8+a@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:03:27AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 13, 2021 at 08:39:59AM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
> > using put_net_track() in nfulnl_instance_free_rcu()
> > and get_net_track() in instance_create()
> > might help us finding netns refcount imbalances.
> 
> Applied to nf-next, thanks

Hm, actually I cannot, nf-next is still behing net-next and it does
not have this symbols.

I'll send a pull request and pick up these patches asap.

Thanks.
