Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8545B47F074
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 18:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353354AbhLXRx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 12:53:27 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:44499 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239382AbhLXRx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 12:53:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 427253200B8B;
        Fri, 24 Dec 2021 12:53:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 24 Dec 2021 12:53:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GG1Rit
        L4molciScCodlUjFQUN/pf331CAmK5cSaQq4k=; b=biVAsxnhwZQjMYBkIjsqQA
        ipqt3iHHlwf7Il1o5cQ+Y73MOEayap+ntxGXyTRivNGV27z74GRYJqPOMtz7HaTO
        p3vxC6jkDDf03S2uBiTuvYRZ/trVOIJL+m/o2OOH6TZCoOdzoeHNtdPdOXlqePoi
        aHs6gG1mLAEFRQGiJBN8fI0/26T8HVKI+LBFL/feSSwuT7yDp5kR6vPev51zcPXg
        t7/4J2ICtdO+leH0/VemDV0ZzajcyE0ysey8YuY0IXE2T14FU1iaMFsJ6mVGKYSJ
        YfSlS3XbzTkE+XrznxQbASqzjfdBeTeoK6y6zg2qGM2hTcFW0+TPYWrRcsGylwgg
        ==
X-ME-Sender: <xms:FAnGYT_cITTmfjWDW5rDUEWRs1uC9kfFU2qZKsZxA20b6mnJekw3ig>
    <xme:FAnGYft8VZJBMui6lXTa1_uGvJTQzLIfKU152GNlbLl09AgvRockBtIo4j5rfNK9D
    t3heM-j6_Evj7k>
X-ME-Received: <xmr:FAnGYRARdPXx3QBn56Fe6z6yL4NUoLluQe4CrZKI9DF3W6VoaYLTM3SgBZM7StR5iSj5-s5-HzghkX-ExYc42tYvZ_gc6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddutddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgeevfeejleffhfdtffeitefhjeeuteffffekjeeggfdtkeeikedtueevtdeg
    hfevnecuffhomhgrihhnpehivghtfhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FAnGYfcPY6nwtZfLoz_1zbBSq3hJhMkuZO0T6RgL7yVu4YsYcLdGCQ>
    <xmx:FAnGYYN6fUWs9Sd1_KI-33Lc3nn2L35EMLIo-lksvNihRwcayqVRzA>
    <xmx:FAnGYRl4KV4-HTmfCE6wDvbWa_VBcygZy394Jg11sNu5RqlvYwuFGg>
    <xmx:FAnGYdpnNa02WHnvAzcZMEL6K5S_8QRjgobAxP_6Mxynb2bMOKhbqw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Dec 2021 12:53:23 -0500 (EST)
Date:   Fri, 24 Dec 2021 19:53:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
Message-ID: <YcYJD2trOaoc5y7Z@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224135000.9291-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 02:50:00PM +0100, Justin Iurman wrote:
> v2:
>  - Fix sparse warning (use rcu_dereference)
> 
> This patch adds support for the queue depth in IOAM trace data fields.
> 
> The draft [1] says the following:
> 
>    The "queue depth" field is a 4-octet unsigned integer field.  This
>    field indicates the current length of the egress interface queue of
>    the interface from where the packet is forwarded out.  The queue
>    depth is expressed as the current amount of memory buffers used by
>    the queue (a packet could consume one or more memory buffers,
>    depending on its size).
> 
> An existing function (i.e., qdisc_qstats_qlen_backlog) is used to
> retrieve the current queue length without reinventing the wheel.
> 
> Note: it was tested and qlen is increasing when an artificial delay is
> added on the egress with tc.
> 
>   [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.7
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  net/ipv6/ioam6.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> index 122a3d47424c..969a5adbaf5c 100644
> --- a/net/ipv6/ioam6.c
> +++ b/net/ipv6/ioam6.c
> @@ -13,10 +13,12 @@
>  #include <linux/ioam6.h>
>  #include <linux/ioam6_genl.h>
>  #include <linux/rhashtable.h>
> +#include <linux/netdevice.h>
>  
>  #include <net/addrconf.h>
>  #include <net/genetlink.h>
>  #include <net/ioam6.h>
> +#include <net/sch_generic.h>
>  
>  static void ioam6_ns_release(struct ioam6_namespace *ns)
>  {
> @@ -717,7 +719,19 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
>  
>  	/* queue depth */
>  	if (trace->type.bit6) {
> -		*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> +		struct netdev_queue *queue;
> +		struct Qdisc *qdisc;
> +		__u32 qlen, backlog;
> +
> +		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
> +			*(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> +		} else {
> +			queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
> +			qdisc = rcu_dereference(queue->qdisc);
> +			qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> +
> +			*(__be32 *)data = cpu_to_be32(qlen);

Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
seems that queue depth needs to take into account the size of the
enqueued packets, not only their number.

Did you check what other IOAM implementations (SW/HW) report for queue
depth? I would assume that they report bytes.

> +		}
>  		data += sizeof(__be32);
>  	}
>  
> -- 
> 2.25.1
> 
