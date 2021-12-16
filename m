Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9718477118
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhLPLu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:50:59 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57930 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhLPLu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:50:58 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E156A625D0;
        Thu, 16 Dec 2021 12:48:28 +0100 (CET)
Date:   Thu, 16 Dec 2021 12:50:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 2/2] netfilter: nf_nat_masquerade: add netns
 refcount tracker to masq_dev_work
Message-ID: <YbsoHv2w3mV5Fn6r@salvia>
References: <20211213164000.3241266-1-eric.dumazet@gmail.com>
 <20211213164000.3241266-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213164000.3241266-2-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 08:40:00AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
> using put_net_track() in iterate_cleanup_work()
> and netns_tracker_alloc() in nf_nat_masq_schedule()
> might help us finding netns refcount imbalances.

Also applied, thanks
