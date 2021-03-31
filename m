Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7534FFC3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbhCaLyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:54:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58009 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbhCaLyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 07:54:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E86F05C0183;
        Wed, 31 Mar 2021 07:54:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 31 Mar 2021 07:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nq3wri
        Pu4wg4vXI4Z+dTxpGYTkw/DAfDUToPgXGcT64=; b=LDu7ZqoeQFWlYrV/bbWXJv
        UCB4lHeI05bF8R1pTFcVq3IAUBRsUM54bXLPeehqdQepvZwHk29pjJ3KUaCyMS0R
        aWpJo+bCFuQbmGmTOrziXs1mJV/MSTtzJvWEmtgBBrFMDRZ1utsHG+8CvGFoyiaw
        FilLOUQOamJlZ82xB4d5hUTuw2XprbC/bvlM53G50GXl66EGzt0n+cO9v2fkXi4I
        SvqUS/sPwd9mbIghQdCEl3KhLoDT7YpyZvm4TiHLVdWpzvowLi3NxJrSdmixqgoj
        fgvwtf0t3y3kHOYON5Yp8aVx2CWqCrXsU08KDXNPmao82/y0Ze7vWS+IcmvuIhRQ
        ==
X-ME-Sender: <xms:2GJkYLT6RV2AfszPod4i7m7gXeBhpbBXELEFW_XFZUiRXuWPLF7pJA>
    <xme:2GJkYMyS7xPPq6TvGYg-ovgzDP3aWEUqwfWifYgEFnB7YLiIZkkJeLJEif1iIjXcx
    iffLSGwqWbWW_Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeivddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2GJkYA0hVe7L02Cf_N6V6Wh7bq1dXHtWPlAz35sT9Q7sZ-9kRZ7znw>
    <xmx:2GJkYLAs0PhyTImhAKN30OZuuIPA7TnziHNMHsiWSNrOMUyVx3Iwpg>
    <xmx:2GJkYEjrTAdXTPMDrMOlZZf7ynLCT1IAylWFAVDrCkQaN2_j5_4TbQ>
    <xmx:2GJkYCfTTrlZp4F3M39l-1xerTJMW3ffxshIVTwpKQawwnR-scsYuQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C1B21080054;
        Wed, 31 Mar 2021 07:53:59 -0400 (EDT)
Date:   Wed, 31 Mar 2021 14:53:54 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Chunmei Xu <xuchunmei@linux.alibaba.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ip-nexthop: support flush by id
Message-ID: <YGRi0oimvPC/FSRT@shredder.lan>
References: <20210331022234.52977-1-xuchunmei@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331022234.52977-1-xuchunmei@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:22:34AM +0800, Chunmei Xu wrote:
> add id to struct filter to record the 'id',
> filter id only when id is set, otherwise flush all. 
> 
> Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>
> ---
>  ip/ipnexthop.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 22c66491..fd759140 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -21,6 +21,7 @@ static struct {
>  	unsigned int master;
>  	unsigned int proto;
>  	unsigned int fdb;
> +	unsigned int id;
>  } filter;
>  
>  enum {
> @@ -124,6 +125,9 @@ static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
>  	if (tb[NHA_ID])
>  		id = rta_getattr_u32(tb[NHA_ID]);
>  
> +	if (filter.id && filter.id != id)
> +		return 0;
> +
>  	if (id && !delete_nexthop(id))
>  		filter.flushed++;
>  
> @@ -491,7 +495,10 @@ static int ipnh_list_flush(int argc, char **argv, int action)
>  			NEXT_ARG();
>  			if (get_unsigned(&id, *argv, 0))
>  				invarg("invalid id value", *argv);
> -			return ipnh_get_id(id);
> +			if (action == IPNH_FLUSH)
> +				filter.id = id;
> +			else
> +				return ipnh_get_id(id);

I think it's quite weird to ask for a dump of all nexthops only to
delete a specific one. How about this:

```
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 0263307c49df..09a3076231aa 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -765,8 +765,16 @@ static int ipnh_list_flush(int argc, char **argv, int action)
                        if (!filter.master)
                                invarg("VRF does not exist\n", *argv);
                } else if (!strcmp(*argv, "id")) {
-                       NEXT_ARG();
-                       return ipnh_get_id(ipnh_parse_id(*argv));
+                       /* When 'id' is specified with 'flush' / 'list' we do
+                        * not need to perform a dump.
+                        */
+                       if (action == IPNH_LIST) {
+                               NEXT_ARG();
+                               return ipnh_get_id(ipnh_parse_id(*argv));
+                       } else {
+                               return ipnh_modify(RTM_DELNEXTHOP, 0, argc,
+                                                  argv);
+                       }
                } else if (!matches(*argv, "protocol")) {
                        __u32 proto;
```


>  		} else if (!matches(*argv, "protocol")) {
>  			__u32 proto;
>  
> -- 
> 2.27.0
> 
