Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC07E49C056
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiAZAvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:51:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46010 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiAZAvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:51:52 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9719B60254;
        Wed, 26 Jan 2022 01:48:47 +0100 (CET)
Date:   Wed, 26 Jan 2022 01:51:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: Re: [PATCH net-next 1/6] net: netfilter: use kfree_drop_reason() for
 NF_DROP
Message-ID: <YfCbIWlhgAxCX1qp@salvia>
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-2-imagedong@tencent.com>
 <20220125153214.180d2c09@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220125153214.180d2c09@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 03:32:14PM -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 21:15:33 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> > 
> > Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
> > skb is dropped by reason of NF_DROP.
> 
> Netfilter folks, does this look good enough to you?
> 
> Do you prefer to take the netfilter changes via your tree? I'm asking
> because enum skb_drop_reason is probably going to be pretty hot so if
> the patch is simple enough maybe no point dealing with merge conflicts.

I also think it's easier if you take it through net.git.

Thanks for asking.
