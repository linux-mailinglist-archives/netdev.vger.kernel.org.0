Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C5F477116
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhLPLup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:50:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57910 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhLPLup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:50:45 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF146625D0;
        Thu, 16 Dec 2021 12:48:13 +0100 (CET)
Date:   Thu, 16 Dec 2021 12:50:39 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nfnetlink: add netns refcount
 tracker to struct nfulnl_instance
Message-ID: <YbsoDxxpTxavoFAl@salvia>
References: <20211213164000.3241266-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213164000.3241266-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 08:39:59AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
> using put_net_track() in nfulnl_instance_free_rcu()
> and get_net_track() in instance_create()
> might help us finding netns refcount imbalances.

Now applied to nf-next, thanks
