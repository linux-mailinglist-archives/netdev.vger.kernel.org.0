Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63FE1CC3F7
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgEITPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:15:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42209 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbgEITPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:15:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E56BF5C007D;
        Sat,  9 May 2020 15:15:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 15:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=rUzjb5xfKF4SA0Ct1KFrhz8tWolZtJQfDZUfRvWwI
        V8=; b=k48VK1ZjCDpvYz523C21XWM1KwEefB5493bPKSlYGUkgxgVf0cDRLqPzD
        zSfIfROLPThnNMKrFoQELkuiP0QdNqG71HxNGHhlUDw0o342J6GRzRYo6qFxK1AH
        5xrlk6Mcl+nv0kMVqJ1zISxNEGXKrvTM1MADw+pNrL0P+3gnogxxPYZ8Wu1gQeKQ
        w0XIZcb4cyKs3Mccex5zVwK8DtpQdgdBLESQelM6wIYFXv62u3Ju/xUqWEQHocbQ
        Z09KMIcpDd6rLngHYvnZcsvzJe3xVq3FDtIieBbD1/sdT4ssemqnUvM+fsDrMJnE
        F0otMk/Zc16k4C0jZFyOocuBykVow==
X-ME-Sender: <xms:WwG3XsqYxKATy9rFOHMZ6D9Uh0DSLvEuHIEv78UcWDJZaltR1UndIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepieeukefgkeekfeetffeifefhhfevudekgeegfeffueehvdethfeviedtueek
    tdehnecuffhomhgrihhnpehshihsthgvmhgurdhiohdpihhpvhegrdhpihhnghdpughotg
    hkvghrrdgtohhmnecukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthh
    drohhrgh
X-ME-Proxy: <xmx:WwG3Xl6x3UfBVz3puQTEI-Bco_5M3jTTt02Who7ZmM1mh0rrjjQVug>
    <xmx:WwG3XlRl9tbPa_X2f2FFgTdgIHloUr2X_0NuAm8ftyTQ3u0aLUa_mg>
    <xmx:WwG3Xt7X7e_uOA2kjAn1H2RBlonfENfqw9la16efYwpoFs4mwmc3PQ>
    <xmx:WwG3Xp-yI1GVxZPY1H7fF9h15kClB-5kb4fjER_NOKG28I4wj_LXKQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDA0A306623C;
        Sat,  9 May 2020 15:15:38 -0400 (EDT)
Date:   Sat, 9 May 2020 22:15:36 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        dsahern@gmail.com
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
Message-ID: <20200509191536.GA370521@splinter>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200508234223.118254-1-zenczykowski@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 04:42:23PM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This makes 'ping' 'ping6' and icmp based traceroute no longer
> require any suid or file capabilities.
> 
> These sockets have baked long enough that the restriction
> to make them unusable by default is no longer necessary.
> 
> The concerns were around exploits.  However there are now
> major distros that default to enabling this.
> 
> This is already the default on Fedora 31:
>   [root@f31vm ~]# cat /proc/sys/net/ipv4/ping_group_range
>   0       2147483647
>   [root@f31vm ~]# cat /usr/lib/sysctl.d/50-default.conf | egrep -B6 ping_group_range
>   # ping(8) without CAP_NET_ADMIN and CAP_NET_RAW
>   # The upper limit is set to 2^31-1. Values greater than that get rejected by
>   # the kernel because of this definition in linux/include/net/ping.h:
>   #   #define GID_T_MAX (((gid_t)~0U) >> 1)
>   # That's not so bad because values between 2^31 and 2^32-1 are reserved on
>   # systemd-based systems anyway: https://systemd.io/UIDS-GIDS.html#summary
>   -net.ipv4.ping_group_range = 0 2147483647
> 
> And in general is super useful for any network namespace container
> based setup.  See for example: https://docs.docker.com/engine/security/rootless/
> 
> This is one less thing you need to configure when you creare a new network
> namespace.
> 
> Before:
>   vm:~# unshare -n
>   vm:~# cat /proc/sys/net/ipv4/ping_group_range
>   1       0
> 
> After:
>   vm:~# unshare -n
>   vm:~# cat /proc/sys/net/ipv4/ping_group_range
>   0       2147483647
> 
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

This will unfortunately cause regressions with VRFs because they don't
work correctly with ping sockets. Simple example:

ip link add name vrf-red up type vrf table 10
ip link add name vrf-blue up type vrf table 20
ip rule add pref 32765 table local
ip rule del pref 0

ip link add name veth-red type veth peer name veth-blue
ip link set dev veth-red up master vrf-red
ip link set dev veth-blue up master vrf-red
ip address add 192.0.2.1/24 dev veth-red
ip address add 192.0.2.2/24 dev veth-blue

ip vrf exec vrf-red ping -I 192.0.2.1 192.0.2.2 -c 1 -w 1

Before the patch:

PING 192.0.2.2 (192.0.2.2) from 192.0.2.1 : 56(84) bytes of data.
64 bytes from 192.0.2.2: icmp_seq=1 ttl=64 time=0.053 ms

After the patch:

bind: Cannot assign requested address

This specific test case is fixed by following patch, but at least a
similar change is needed for IPv6. Other changes might also be required.
Sorry for not providing a complete solution, but I'm busy with other
tasks at the moment. :/

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 535427292194..8463b0e9e811 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -297,6 +297,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
        struct net *net = sock_net(sk);
        if (sk->sk_family == AF_INET) {
                struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+               u32 tb_id = RT_TABLE_LOCAL;
                int chk_addr_ret;
 
                if (addr_len < sizeof(*addr))
@@ -310,7 +311,15 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
                pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
                         sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-               chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+               if (sk->sk_bound_dev_if) {
+                       tb_id = l3mdev_fib_table_by_index(net,
+                                                         sk->sk_bound_dev_if);
+                       if (!tb_id)
+                               tb_id = RT_TABLE_LOCAL;
+               }
+
+               chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr,
+                                                   tb_id);
 
                if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
                        chk_addr_ret = RTN_LOCAL;

> ---
>  net/ipv4/af_inet.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index cf58e29cf746..1a8cb6f3ee38 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1819,12 +1819,8 @@ static __net_init int inet_init_net(struct net *net)
>  	net->ipv4.ip_local_ports.range[1] =  60999;
>  
>  	seqlock_init(&net->ipv4.ping_group_range.lock);
> -	/*
> -	 * Sane defaults - nobody may create ping sockets.
> -	 * Boot scripts should set this to distro-specific group.
> -	 */
> -	net->ipv4.ping_group_range.range[0] = make_kgid(&init_user_ns, 1);
> -	net->ipv4.ping_group_range.range[1] = make_kgid(&init_user_ns, 0);
> +	net->ipv4.ping_group_range.range[0] = GLOBAL_ROOT_GID;
> +	net->ipv4.ping_group_range.range[1] = KGIDT_INIT(0x7FFFFFFF);
>  
>  	/* Default values for sysctl-controlled parameters.
>  	 * We set them here, in case sysctl is not compiled.
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 
