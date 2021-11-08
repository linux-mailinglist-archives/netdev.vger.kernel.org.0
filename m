Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C42447E3D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhKHKtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:49:40 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46924 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbhKHKtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:49:39 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 518B76063C;
        Mon,  8 Nov 2021 11:44:55 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:46:49 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     yangxingwu <xingwu.yang@gmail.com>, ja@ssi.bg,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net, Chuanqi Liu <legend050709@qq.com>
Subject: Re: [PATCH nf-next v6] netfilter: ipvs: Fix reuse connection if RS
 weight is 0
Message-ID: <YYkAGcPu0yIQ6WnN@salvia>
References: <20211104031029.157366-1-xingwu.yang@gmail.com>
 <20211104140401.GA16560@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211104140401.GA16560@vergenet.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 03:04:04PM +0100, Simon Horman wrote:
> On Thu, Nov 04, 2021 at 11:10:29AM +0800, yangxingwu wrote:
> > We are changing expire_nodest_conn to work even for reused connections when
> > conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
> > Fix reuse connection if real server is dead").
> > 
> > For controlled and persistent connections, the new connection will get the
> > needed real server depending on the rules in ip_vs_check_template().
> > 
> > Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port reuse is detected")
> > Co-developed-by: Chuanqi Liu <legend050709@qq.com>
> > Signed-off-by: Chuanqi Liu <legend050709@qq.com>
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> (v5 was acked by Julian, probably that can be propagated here)
> 
> Pablo, please consider this for nf-next at your convenience.

Applied this fix to nf, thanks.
