Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9774585B4
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbhKUR42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:56:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46849 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238020AbhKUR41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 12:56:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D6E35C0139;
        Sun, 21 Nov 2021 12:53:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 21 Nov 2021 12:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6Mc89N
        oAriY36kzos68v7N5vBRp7ppb7SCjYhtI95pA=; b=FE4ENgbQlReXsBNUDf9zck
        rt/6z13Odt3eFLIWeawfbHSZNQ0OteDaKHEp9hVFvMkLiRNBbzmJAXo/xWkQVixV
        eSGu7efiTQxNoMqkFRRpqV+Fl71VsQQoD9BkHIZje3/Cav6PP56WuGWZZfeiRwI4
        p9zxl1S+d4na9sy9v8M3hC5VnwgGER/C4JvUv0GeCyvBKYFIS0EI326SGq1DWC+V
        x4tfm8pR2z4gwu42j8CxYQf7qmriGy3dMW0YsjFfLF+m0X71RP5vSqTTAJjBx+Jt
        9FB2WbUEkI7w3M3Y3qeTWCh81EztkwCsD+VLzV5jKK6mffGZzuKNGddpD3/JEJBw
        ==
X-ME-Sender: <xms:koeaYahR2l4-CIqfRZd-j_YqB0kANGXICcvyDqPC_BHtoBgpEBV9bQ>
    <xme:koeaYbDQJ8dD1y9AZ4hH-Orx48mG8MiOKLlh5Pzn9aTH5ylaMKsjh6hTcrxxg-Cve
    nODgPB7MrevYQg>
X-ME-Received: <xmr:koeaYSFTEotAo__bLNQHnVxGP254chtC3SLwn60rtehrNaMEyxUI4ETwkao2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgedvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:koeaYTR3zDJgim_-Ik6kj_LLG4Qvy-n8AaUBAAc1jatDbViiKMfnfw>
    <xmx:koeaYXw9W4xtkGct6FLxKKrWsV9IaetRxK_rpTm0Un7hUz6ETnF3CQ>
    <xmx:koeaYR4yTXN9kYz3UDvyA87sTBurf2hf7BK6haMykSa1Vv6rm0ufSA>
    <xmx:koeaYX99EpWA9Y5a9apv6ycc9Kc27MW2u3s1FDJ7xq9zEqJkEvBpaQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Nov 2021 12:53:21 -0500 (EST)
Date:   Sun, 21 Nov 2021 19:53:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 3/3] selftests: net: fib_nexthops: add test for group
 refcount imbalance bug
Message-ID: <YZqHj5GFUdp7MEZU@shredder>
References: <20211121152453.2580051-1-razor@blackwall.org>
 <20211121152453.2580051-4-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121152453.2580051-4-razor@blackwall.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 05:24:53PM +0200, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> The new selftest runs a sequence which causes circular refcount
> dependency between deleted objects which cannot be released and results
> in a netdevice refcount imbalance.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 56 +++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index b5a69ad191b0..48d88a36ae27 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -629,6 +629,59 @@ ipv6_fcnal()
>  	log_test $? 0 "Nexthops removed on admin down"
>  }
>  
> +ipv6_grp_refs()
> +{
> +	run_cmd "$IP link set dev veth1 up"
> +	run_cmd "$IP link add veth1.10 link veth1 up type vlan id 10"
> +	run_cmd "$IP link add veth1.20 link veth1 up type vlan id 20"
> +	run_cmd "$IP -6 addr add 2001:db8:91::1/64 dev veth1.10"
> +	run_cmd "$IP -6 addr add 2001:db8:92::1/64 dev veth1.20"
> +	run_cmd "$IP -6 neigh add 2001:db8:91::2 lladdr 00:11:22:33:44:55 dev veth1.10"
> +	run_cmd "$IP -6 neigh add 2001:db8:92::2 lladdr 00:11:22:33:44:55 dev veth1.20"
> +	run_cmd "$IP nexthop add id 100 via 2001:db8:91::2 dev veth1.10"
> +	run_cmd "$IP nexthop add id 101 via 2001:db8:92::2 dev veth1.20"
> +	run_cmd "$IP nexthop add id 102 group 100"
> +	run_cmd "$IP route add 2001:db8:101::1/128 nhid 102"
> +
> +	# create per-cpu dsts through nh 100
> +	run_cmd "ip netns exec me mausezahn -6 veth1.10 -B 2001:db8:101::1 -A 2001:db8:91::1 -c 5 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1"

I see that other test cases in this file that are using mausezahn check
that it exists. See ipv4_torture() for example

> +
> +	# remove nh 100 from the group to delete the route potentially leaving
> +	# a stale per-cpu dst

Not sure I understand the comment. Maybe:

"Remove nh 100 from the group. If the bug described in the previous
commit is not fixed, the nexthop continues to cache a per-CPU dst entry
that holds a reference on the IPv6 route."

?

> +	run_cmd "$IP nexthop replace id 102 group 101"
> +	run_cmd "$IP route del 2001:db8:101::1/128"
> +
> +	# add both nexthops to the group so a reference is taken on them
> +	run_cmd "$IP nexthop replace id 102 group 100/101"
> +
> +	# if the bug exists at this point we have an unlinked IPv6 route

I would mention that by "the bug" you are referring to the bug described
in previous commit

> +	# (but not freed due to stale dst) with a reference over the group
> +	# so we delete the group which will again only unlink it due to the
> +	# route reference
> +	run_cmd "$IP nexthop del id 102"
> +
> +	# delete the nexthop with stale dst, since we have an unlinked
> +	# group with a ref to it and an unlinked IPv6 route with ref to the
> +	# group, the nh will only be unlinked and not freed so the stale dst
> +	# remains forever and we get a net device refcount imbalance
> +	run_cmd "$IP nexthop del id 100"
> +
> +	# if the bug exists this command will hang because the net device
> +	# cannot be removed
> +	timeout -s KILL 5 ip netns exec me ip link del veth1.10 >/dev/null 2>&1
> +
> +	# we can't cleanup if the command is hung trying to delete the netdev
> +	if [ $? -eq 137 ]; then
> +		return 1
> +	fi
> +
> +	# cleanup
> +	run_cmd "$IP link del veth1.20"
> +	run_cmd "$IP nexthop flush"
> +
> +	return 0
> +}
> +
>  ipv6_grp_fcnal()
>  {
>  	local rc
> @@ -734,6 +787,9 @@ ipv6_grp_fcnal()
>  
>  	run_cmd "$IP nexthop add id 108 group 31/24"
>  	log_test $? 2 "Nexthop group can not have a blackhole and another nexthop"
> +
> +	ipv6_grp_refs
> +	log_test $? 0 "Nexthop group replace refcounts"
>  }
>  
>  ipv6_res_grp_fcnal()
> -- 
> 2.31.1
> 
