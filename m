Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE8C37AFEE
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 22:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEKUGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 16:06:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33403 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhEKUGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 16:06:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 625435C013A;
        Tue, 11 May 2021 16:05:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 May 2021 16:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XJPdyZ
        zUM7Tt3ff2AlXV371B+kXaSUl3aCrtOe5Y+hk=; b=ABFbb/oxD3LngaVPUCLPBz
        l5dWpXbz4WvLmEn9ex86hXtwurZzdoGQacQ/R66WAFu5XfM/piU/G/ypQzezxhzf
        jGxb9MUWKz9V2onIugjiMWyuvH3Z5UsV6m8pjCwirx4/OvXC5YToXyunG2lP/FGF
        sI7Nkir1vzW1pX0QJDxaOAszB8SNysBb96mR7QF6GNRLHZX/wrZnYX5TRwV7Ua3/
        8nI1Birg0CUW2EhubGz62O2PJUpfgHSn3WSDzVJl0QOpcl7zmqhSCizY6ncxoUQr
        rO4Auzzz4GAIsAzrSVIyVyAJ9Avg7vJ9BUgZwg1H+/AkE2sX9fMyNQJ09DBgaCMw
        ==
X-ME-Sender: <xms:hOOaYAKzAhwhQCJgRQDYJnwPnwBumK2fEvjHI0GEMjNimebElrhxqw>
    <xme:hOOaYAIgyGM0TQ2OI7a3JXBGnBSTAn9ohQkqm8ZfYzrei5SRg1WlYKXe5gbg6bBuF
    Od9F7nZbYCxLh0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehtddgudegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hOOaYAvFL371mHPUsXoNxHAi6qt6qpkSjlPuGnMO0b3JYM_jUYBueg>
    <xmx:hOOaYNYzZhrLY13d8bt5tKwhkA36fBwP5_7NczS8-H3XbH3LLNIBxQ>
    <xmx:hOOaYHYaoqkwCkVCQaktHYvjSwNLQwqQU-mU2zazdVliLCr2pmyzDw>
    <xmx:hOOaYMPcaqrDtpXhQg0HDJh7fpdIgCHd7SIRrXRs8zzhaueUvUVa7w>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 11 May 2021 16:05:23 -0400 (EDT)
Date:   Tue, 11 May 2021 23:05:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control
 multipath hash fields
Message-ID: <YJrjf7yj3+Xj5KhO@shredder>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-3-idosch@idosch.org>
 <95516cbb-1fa3-566c-62f9-ae6adcbf8fe9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95516cbb-1fa3-566c-62f9-ae6adcbf8fe9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 09:49:30AM -0600, David Ahern wrote:
> On 5/9/21 9:16 AM, Ido Schimmel wrote:
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index a62934b9f15a..da627c4d633a 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -19,6 +19,7 @@
> >  #include <net/snmp.h>
> >  #include <net/icmp.h>
> >  #include <net/ip.h>
> > +#include <net/ip_fib.h>
> >  #include <net/route.h>
> >  #include <net/tcp.h>
> >  #include <net/udp.h>
> > @@ -48,6 +49,8 @@ static int ip_ping_group_range_min[] = { 0, 0 };
> >  static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
> >  static u32 u32_max_div_HZ = UINT_MAX / HZ;
> >  static int one_day_secs = 24 * 3600;
> > +static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
> > +	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
> >  
> >  /* obsolete */
> >  static int sysctl_tcp_low_latency __read_mostly;
> > @@ -1052,6 +1055,14 @@ static struct ctl_table ipv4_net_table[] = {
> >  		.extra1		= SYSCTL_ZERO,
> >  		.extra2		= &two,
> >  	},
> > +	{
> > +		.procname	= "fib_multipath_hash_fields",
> > +		.data		= &init_net.ipv4.sysctl_fib_multipath_hash_fields,
> > +		.maxlen		= sizeof(u32),
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_douintvec_minmax,
> > +		.extra2		= &fib_multipath_hash_fields_all_mask,
> 
> no .extra1 means 0 is allowed which effectively disables hashing and
> multipath selection; only the first leg will be used. Is that intended?

I didn't see any reason to forbid it, but I don't see any reason to use
it with '0' either. With this patch:

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 81343037de06..4fa77f182dcb 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1078,6 +1078,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u32),
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_fields,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= &fib_multipath_hash_fields_all_mask,
 	},
 #endif

We get:

# sysctl -w net.ipv4.fib_multipath_hash_fields=0
sysctl: setting key "net.ipv4.fib_multipath_hash_fields": Invalid argument

I assume you want to see this change in the next version (and for IPv6)?

> 
> 
> 
> > +	},
> >  #endif
> >  	{
> >  		.procname	= "ip_unprivileged_port_start",
> > 
> 
