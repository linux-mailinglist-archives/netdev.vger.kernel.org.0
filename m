Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CA2764B4
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIWXuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWXuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 19:50:12 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3054FC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 16:50:12 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id c18so1474623qtw.5
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 16:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rfZkQquYQAYvDLWHpIfQmNas6QeWYjzX2SfUisqykVI=;
        b=hqZIEqckaH2ynvjVKXDIYOQ5vqqWrwkKr+h6bRrFwnXP5kAEAG0Gwnc1zwkwOv7anz
         JJ0c/gIJ9UHy7gSqKMeoaI42LBw69HD5cvXo6Z/pjreVv0soyraoGVdohoQjuvOQ/Q/J
         NVG/Ee7cwnj9C3KOWkx2ahJgNHIzzLMH3mbqlNogaIRG/i+A1s+Ouk75X6S3ZmB7E6K+
         OSinL2qW+H4bOo2gTXn/NEQwvB09ai+TDt+5Za07VYTYAzz3LvnDfif4ml8Ca8JFezqc
         8IJ3Qwhhoo49j3UGxtFquDozw6ilW+JYF1rdmgNF2EhtFOGnTMYchsaCwH9PY3y/0+9g
         PeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rfZkQquYQAYvDLWHpIfQmNas6QeWYjzX2SfUisqykVI=;
        b=fPfMRa5VPhV7SNL4WYq0vc9PtBxIKc3Uaiic1k9aNa85Ux5N2V46pb8Os4my1/+na6
         SqfVE8F/jwybemDZtYbIGJJki4560MyLyQIXORzngQHqJEXHQcfJUa7uihyJJfnBMsuq
         WKOHzFzX6Cy9tEkbCzOF+bS/qtlH/epTOI0b39hBtF14AtsU7w1blNksRzjWDrtUTEkQ
         PV8tlZxmtrAXsbyNQpH6m0YFfoGWhDoL3yGNkFtyo6oj1lKwK4ktPXUf8W0jkjDw5SiF
         9L89WIsO3h1cLdB8gntLwCmOh1cwLxuUDgHQfT8FGzKQlpOVnbTrUtmeaiIjBhOpOQrk
         E0YQ==
X-Gm-Message-State: AOAM5305YgU5pRTnJ8voD4qRmXqjQ6K1gkrkG8zl/sSSFgqbmTJpIxDY
        mk51gusmbSL0g/z2gRsv1Q==
X-Google-Smtp-Source: ABdhPJyyyKIR0cVdQeTb/MP7cadNV0Ulw9/uBP1SWeI9q4tqUYJZsG7GF4XJZyF5oImHCvuV8QalpQ==
X-Received: by 2002:aed:2fc5:: with SMTP id m63mr2660068qtd.313.1600905011314;
        Wed, 23 Sep 2020 16:50:11 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id 10sm1045638qkk.88.2020.09.23.16.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 16:50:10 -0700 (PDT)
Date:   Wed, 23 Sep 2020 19:50:02 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: ip rule iif oif and vrf
Message-ID: <20200923235002.GA25818@ICIPI.localdomain>
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 22, 2020 at 09:39:36AM -0600, David Ahern wrote:
> > 
> > We have a use case where there are multiple user VRFs being leak routed
> > to and from tunnels that are on the core VRF. Traffic from user VRF to a
> > tunnel can be done the normal way by specifying the netdev directly on
> > the route entry on the user VRF route table:
> > 
> > ip route add <prefix> via <tunnel_end_point_addr> dev <tunnel_netdev>
> > 
> > But traffic received on the tunnel must be leak routed directly to the
> > respective a specific user VRF because multiple user VRFs can have
> > duplicate address spaces. I am thinking of using ip rule but when the
> > iif is an enslaved device, the rule doesn't get matched because the
> > ifindex in the skb is the master.
> > 
> > My question is: is this a bug, or is there anything else that can be
> > done to make sure that traffic from a tunnel being routed directly to a
> > user VRF? If it is the later, I can work on a patch.
> > 

Is there a better way to implement this use case? Seems that it's a
common one for VRFs.

> 
> Might be a side effect of the skb dev change. I would like to remove
> that but it is going to be challenge at this point.
> 
> take a look at:
> perf record -a -e fib:* -g
> <packets through the tunnel>
> <Ctrl-C>
> perf script
> 
> What does it say for the lookups - input arguments, table, etc?
> 
> Any chance you can re-recreate this using namespaces as the different nodes?

I have a reproducer using namespaces attached in this email (gre_setup.sh).
A ping is initiated from h0:

ip netns exec h0 ping -c 1 11.0.0.2

As I have seen on our target platform, the iif is the VRF device. In
this case it is the core VRF. Thus, the ip rule with iif equals to the
GRE tunnel doesn't get hit.

This is I think is the relevant perf script output. All the outputs are
in the attached perf_script.txt.

ksoftirqd/0     9 [000]  2933.555444: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 10.0.0.2/0 -> 11.0.0.2/0 tos 0 scope 0 flags 4 ==> dev - gw 0.0.0.0/:: err -113
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffbd989bce gro_cell_poll+0x5e ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

The r1 namespace has these netdevs:

sudo ip netns exec r1 ip link show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/gre 0.0.0.0 brd 0.0.0.0
3: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
4: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
5: vrf_r1t: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ba:76:0d:e4:3b:93 brd ff:ff:ff:ff:ff:ff
6: vrf_r1c: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 82:90:68:d3:e1:ff brd ff:ff:ff:ff:ff:ff
7: gre10@vrf_r1c: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 65511 qdisc noqueue master vrf_r1c state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 1.1.1.2 peer 1.1.1.1
26: r1_v10@if27: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vrf_r1c state UP mode DEFAULT group default qlen 1000
    link/ether 12:00:73:33:bc:f2 brd ff:ff:ff:ff:ff:ff link-netns r0
29: r1_v11@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vrf_r1t state UP mode DEFAULT group default qlen 1000
    link/ether 8a:ff:65:ff:ba:58 brd ff:ff:ff:ff:ff:ff link-netns h1

The iif when the fib is being looked up is the vrf_r1c (6). There is
another error in the perf_script where the iif is the lo device and the
oif is vrf_r1c.

ping  4343 [000]  2933.554428: fib:fib_table_lookup: table 100 oif 6 iif 1 proto 1 10.0.0.2/0 -> 11.0.0.2/0 tos 0 scope 0 flags 4 ==> dev - gw 0.0.0.0/:: err -113

Thanks.

--mP3DRpeJDSE+ciuQ
Content-Type: application/x-sh
Content-Disposition: attachment; filename="gre_setup.sh"
Content-Transfer-Encoding: quoted-printable

# +-------+     +----------+   +----------+   +-------+=0A# | h0    |     |=
    r0    |   |    r1    |   |    h1 |=0A# |    v00+-----+v00    v01+---+v1=
0    v11+---+v11    |=0A# |       |     |          |   |          |   |    =
   |=0A# +-------+     +----------+   +----------+   +-------+=0A#         =
         |    <=3D=3D=3Dgre=3D=3D=3D>    |=0A#                  | gre01    =
   gre10 |=0A#                  |                   |=0A#          vrf_r0t =
| vrf_r0c   vrf_r1c | vrf_r1t=0A#         (tenant)        (core)         (t=
enant)=0A#=0A# h0_v00 10.0.0.2/24     r0_v00 10.0.0.1/24=0A# r0_v01 1.1.1.1=
/24      r1_v10 1.1.1.2/24=0A# h1_v11 11.0.0.2/24     r1_v11 11.0.0.1/24=0A=
# gre01 2.2.2.1/30       gre10 2.2.2.2/30=0A=0Aip netns add h0=0Aip netns a=
dd r0=0Aip netns add h1=0Aip netns add r1=0A=0Aip link add h0_v00 type veth=
 peer name r0_v00=0Aip link set h0_v00 netns h0=0Aip link set r0_v00 netns =
r0=0Aip link add r0_v01 type veth peer name r1_v10=0Aip link set r0_v01 net=
ns r0=0Aip link set r1_v10 netns r1=0Aip link add r1_v11 type veth peer nam=
e h1_v11=0Aip link set r1_v11 netns r1=0Aip link set h1_v11 netns h1=0A=0Ai=
p netns exec r0 ip link add vrf_r0t type vrf table 10=0Aip netns exec r0 ip=
 addr add 127.0.0.1/8 dev vrf_r0t=0Aip netns exec r0 ip link set vrf_r0t up=
=0Aip netns exec r0 ip link add vrf_r0c type vrf table 100=0Aip netns exec =
r0 ip addr add 127.0.0.1/8 dev vrf_r0c=0Aip netns exec r0 ip link set vrf_r=
0c up=0Aip netns exec r1 ip link add vrf_r1t type vrf table 10=0Aip netns e=
xec r1 ip addr add 127.0.0.1/8 dev vrf_r1t=0Aip netns exec r1 ip link set v=
rf_r1t up=0Aip netns exec r1 ip link add vrf_r1c type vrf table 100=0Aip ne=
tns exec r1 ip addr add 127.0.0.1/8 dev vrf_r1c=0Aip netns exec r1 ip link =
set vrf_r1c up=0A=0Aip netns exec r0 ip link set dev r0_v00 master vrf_r0t=
=0Aip netns exec r0 ip link set dev r0_v01 master vrf_r0c=0Aip netns exec r=
1 ip link set dev r1_v11 master vrf_r1t=0Aip netns exec r1 ip link set dev =
r1_v10 master vrf_r1c=0A=0Aip netns exec h0 ip addr add 10.0.0.2/24 dev h0_=
v00=0Aip netns exec r0 ip addr add 10.0.0.1/24 dev r0_v00=0Aip netns exec r=
0 ip addr add 1.1.1.1/24 dev r0_v01=0Aip netns exec r1 ip addr add 1.1.1.2/=
24 dev r1_v10=0Aip netns exec r1 ip addr add 11.0.0.1/24 dev r1_v11=0Aip ne=
tns exec h1 ip addr add 11.0.0.2/24 dev h1_v11=0A=0Aip netns exec r0 ip tun=
nel add gre01 mode gre local 1.1.1.1 remote 1.1.1.2 dev vrf_r0c=0Aip netns =
exec r0 ip link set dev gre01 master vrf_r0c=0Aip netns exec r0 ip addr add=
 2.2.2.1/24 dev gre01=0Aip netns exec r1 ip tunnel add gre10 mode gre local=
 1.1.1.2 remote 1.1.1.1 dev vrf_r1c=0Aip netns exec r1 ip link set dev gre1=
0 master vrf_r1c=0Aip netns exec r1 ip addr add 2.2.2.2/24 dev gre10=0A=0Ai=
p netns exec h0 ip link set dev h0_v00 up=0Aip netns exec r0 ip link set de=
v r0_v00 up=0Aip netns exec r0 ip link set dev r0_v01 up=0Aip netns exec r0=
 ip link set dev gre01 up=0Aip netns exec r1 ip link set dev r1_v10 up=0Aip=
 netns exec r1 ip link set dev r1_v11 up=0Aip netns exec r1 ip link set dev=
 gre10 up=0Aip netns exec h1 ip link set dev h1_v11 up=0A=0Aip netns exec r=
0 sysctl -w net.ipv4.ip_forward=3D1 > /dev/null=0Aip netns exec r1 sysctl -=
w net.ipv4.ip_forward=3D1 > /dev/null=0A=0Aip netns exec h0 ip route add de=
fault via 10.0.0.1=0Aip netns exec h1 ip route add default via 11.0.0.1=0A=
=0Aip netns exec r0 ip route add unreachable default metric 8192 table 10=
=0Aip netns exec r0 ip route add unreachable default metric 8192 table 100=
=0Aip netns exec r1 ip route add unreachable default metric 8192 table 10=
=0Aip netns exec r1 ip route add unreachable default metric 8192 table 100=
=0A=0Aip netns exec r0 ip route add 11.0.0.0/24 via 2.2.2.2 dev gre01 table=
 10=0Aip netns exec r1 ip route add 10.0.0.0/24 via 2.2.2.1 dev gre10 table=
 10=0A=0A# do this to match the config on the target platform=0Asudo ip net=
ns exec r0 ip rule delete from all lookup local=0Asudo ip netns exec r0 ip =
rule add from all lookup local pref 32765=0Asudo ip netns exec r1 ip rule d=
elete from all lookup local=0Asudo ip netns exec r1 ip rule add from all lo=
okup local pref 32765=0A=0A# packets out of the core vrf tunnel are leak-ro=
uted to the tenant vrf=0Aip netns exec r0 ip rule add iif gre01 table 10 pr=
ef 999=0Aip netns exec r1 ip rule add iif gre10 table 10 pref 999=0A
--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="perf_script.txt"

ping  4343 [000]  2933.541770: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 17 0.0.0.0/52259 -> 11.0.0.2/1025 tos 0 scope 0 flags 0 ==> dev h0_v00 gw 10.0.0.1/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9e2e1d __ip4_datagram_connect+0x24d ([kernel.kallsyms])
        ffffffffbd9e2f1d ip4_datagram_connect+0x2d ([kernel.kallsyms])
        ffffffffbd9f4c4f inet_dgram_connect+0x3f ([kernel.kallsyms])
        ffffffffbd910ac1 __sys_connect+0xf1 ([kernel.kallsyms])
        ffffffffbd910b1a __x64_sys_connect+0x1a ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b27177 __libc_connect+0x17 (/lib/x86_64-linux-gnu/libc-2.31.so)

ping  4343 [000]  2933.543615: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 17 10.0.0.2/52259 -> 11.0.0.2/1025 tos 0 scope 0 flags 0 ==> dev h0_v00 gw 10.0.0.1/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9ad60f ip_route_output_flow+0x1f ([kernel.kallsyms])
        ffffffffbd9e2d2b __ip4_datagram_connect+0x15b ([kernel.kallsyms])
        ffffffffbd9e2f1d ip4_datagram_connect+0x2d ([kernel.kallsyms])
        ffffffffbd9f4c4f inet_dgram_connect+0x3f ([kernel.kallsyms])
        ffffffffbd910ac1 __sys_connect+0xf1 ([kernel.kallsyms])
        ffffffffbd910b1a __x64_sys_connect+0x1a ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b27177 __libc_connect+0x17 (/lib/x86_64-linux-gnu/libc-2.31.so)

ping  4343 [000]  2933.552438: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 1 0.0.0.0/0 -> 11.0.0.2/0 tos 0 scope 0 flags 0 ==> dev h0_v00 gw 10.0.0.1/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9ad60f ip_route_output_flow+0x1f ([kernel.kallsyms])
        ffffffffbd9e450f raw_sendmsg+0x2cf ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ping  4343 [000]  2933.553178: fib:fib_table_lookup: table 10 oif 0 iif 5 proto 0 10.0.0.2/0 -> 11.0.0.2/0 tos 0 scope 0 flags 4 ==> dev gre01 gw 2.2.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbdc00f2a do_softirq_own_stack+0x2a ([kernel.kallsyms])
        ffffffffbd0a7d16 do_softirq.part.0+0x46 ([kernel.kallsyms])
        ffffffffbd0a7d70 __local_bh_enable_ip+0x50 ([kernel.kallsyms])
        ffffffffbd9b382f ip_finish_output2+0x1af ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b4d9d ip_local_out+0x3d ([kernel.kallsyms])
        ffffffffbd9b6019 ip_send_skb+0x19 ([kernel.kallsyms])
        ffffffffbd9b6073 ip_push_pending_frames+0x33 ([kernel.kallsyms])
        ffffffffbd9e485c raw_sendmsg+0x61c ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ping  4343 [000]  2933.553402: fib:fib_table_lookup: table 10 oif 0 iif 5 proto 0 11.0.0.2/0 -> 10.0.0.2/0 tos 0 scope 0 flags 4 ==> dev r0_v00 gw 2.2.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9fd45d __fib_validate_source+0x32d ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9abecd ip_route_input_slow+0x37d ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbdc00f2a do_softirq_own_stack+0x2a ([kernel.kallsyms])
        ffffffffbd0a7d16 do_softirq.part.0+0x46 ([kernel.kallsyms])
        ffffffffbd0a7d70 __local_bh_enable_ip+0x50 ([kernel.kallsyms])
        ffffffffbd9b382f ip_finish_output2+0x1af ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b4d9d ip_local_out+0x3d ([kernel.kallsyms])
        ffffffffbd9b6019 ip_send_skb+0x19 ([kernel.kallsyms])
        ffffffffbd9b6073 ip_push_pending_frames+0x33 ([kernel.kallsyms])
        ffffffffbd9e485c raw_sendmsg+0x61c ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ping  4343 [000]  2933.554428: fib:fib_table_lookup: table 100 oif 6 iif 1 proto 1 10.0.0.2/0 -> 11.0.0.2/0 tos 0 scope 0 flags 4 ==> dev - gw 0.0.0.0/:: err -113
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9aa6c6 __ip_rt_update_pmtu+0x1a6 ([kernel.kallsyms])
        ffffffffbd9aa764 ip_rt_update_pmtu+0x84 ([kernel.kallsyms])
        ffffffffc07bf69e drm_add_modes_noedid+0x53 ([kernel.kallsyms])
        ffffffffc07c0195 do_established_modes+0x3a ([kernel.kallsyms])
        ffffffffc07c73f1 drm_atomic_private_obj_init+0x36 ([kernel.kallsyms])
        ffffffffc07c82b2 drm_atomic_check_only+0x27 ([kernel.kallsyms])
        ffffffffbd934311 dev_hard_start_xmit+0x91 ([kernel.kallsyms])
        ffffffffbd934c40 __dev_queue_xmit+0x720 ([kernel.kallsyms])
        ffffffffbd934e10 dev_queue_xmit+0x10 ([kernel.kallsyms])
        ffffffffbd942831 neigh_direct_output+0x11 ([kernel.kallsyms])
        ffffffffbd9b381b ip_finish_output2+0x19b ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b0b98 ip_forward_finish+0x58 ([kernel.kallsyms])
        ffffffffbd9b0f6e ip_forward+0x39e ([kernel.kallsyms])
        ffffffffbd9aefe5 ip_rcv_finish+0x85 ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbdc00f2a do_softirq_own_stack+0x2a ([kernel.kallsyms])
        ffffffffbd0a7d16 do_softirq.part.0+0x46 ([kernel.kallsyms])
        ffffffffbd0a7d70 __local_bh_enable_ip+0x50 ([kernel.kallsyms])
        ffffffffbd9b382f ip_finish_output2+0x1af ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b4d9d ip_local_out+0x3d ([kernel.kallsyms])
        ffffffffbd9b6019 ip_send_skb+0x19 ([kernel.kallsyms])
        ffffffffbd9b6073 ip_push_pending_frames+0x33 ([kernel.kallsyms])
        ffffffffbd9e485c raw_sendmsg+0x61c ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ping  4343 [000]  2933.554969: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 1.1.1.1/0 -> 1.1.1.2/0 tos 0 scope 0 flags 4 ==> dev r1_v10 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbdc00f2a do_softirq_own_stack+0x2a ([kernel.kallsyms])
        ffffffffbd0a7d16 do_softirq.part.0+0x46 ([kernel.kallsyms])
        ffffffffbd0a7d70 __local_bh_enable_ip+0x50 ([kernel.kallsyms])
        ffffffffbd9b382f ip_finish_output2+0x1af ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b4d9d ip_local_out+0x3d ([kernel.kallsyms])
        ffffffffbd9b6019 ip_send_skb+0x19 ([kernel.kallsyms])
        ffffffffbd9b6073 ip_push_pending_frames+0x33 ([kernel.kallsyms])
        ffffffffbd9e485c raw_sendmsg+0x61c ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ping  4343 [000]  2933.555005: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 1.1.1.2/0 -> 1.1.1.1/0 tos 0 scope 0 flags 4 ==> dev r1_v10 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9fd45d __fib_validate_source+0x32d ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbdc00f2a do_softirq_own_stack+0x2a ([kernel.kallsyms])
        ffffffffbd0a7d16 do_softirq.part.0+0x46 ([kernel.kallsyms])
        ffffffffbd0a7d70 __local_bh_enable_ip+0x50 ([kernel.kallsyms])
        ffffffffbd9b382f ip_finish_output2+0x1af ([kernel.kallsyms])
        ffffffffbd9b3ccf __ip_finish_output+0xbf ([kernel.kallsyms])
        ffffffffbd9b3e0d ip_finish_output+0x2d ([kernel.kallsyms])
        ffffffffbd9b56c5 ip_output+0x75 ([kernel.kallsyms])
        ffffffffbd9b4d9d ip_local_out+0x3d ([kernel.kallsyms])
        ffffffffbd9b6019 ip_send_skb+0x19 ([kernel.kallsyms])
        ffffffffbd9b6073 ip_push_pending_frames+0x33 ([kernel.kallsyms])
        ffffffffbd9e485c raw_sendmsg+0x61c ([kernel.kallsyms])
        ffffffffbd9f66dc inet_sendmsg+0x6c ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fbbe2b2765a __libc_sendto+0x1a (/lib/x86_64-linux-gnu/libc-2.31.so)
                5f6bd133 [unknown] ([unknown])

ksoftirqd/0     9 [000]  2933.555444: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 10.0.0.2/0 -> 11.0.0.2/0 tos 0 scope 0 flags 4 ==> dev - gw 0.0.0.0/:: err -113
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffbd989bce gro_cell_poll+0x5e ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ksoftirqd/0     9 [000]  2933.557020: fib:fib_table_lookup: table 100 oif 6 iif 1 proto 1 0.0.0.0/0 -> 10.0.0.2/0 tos 0 scope 0 flags 4 ==> dev - gw 0.0.0.0/:: err -113
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda04f2e fib_table_lookup+0x4ce ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9acf86 ip_route_output_key_hash_rcu+0x5f6 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9eef6e icmp_route_lookup.constprop.0+0xde ([kernel.kallsyms])
        ffffffffbd9efa68 __icmp_send+0x428 ([kernel.kallsyms])
        ffffffffbd9a89f8 ip_error+0x188 ([kernel.kallsyms])
        ffffffffbd9aefe5 ip_rcv_finish+0x85 ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffbd989bce gro_cell_poll+0x5e ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ksoftirqd/0     9 [000]  2938.674612: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 1.1.1.1/0 -> 1.1.1.2/0 tos 0 scope 0 flags 4 ==> dev r1_v10 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9edb9a arp_process+0x49a ([kernel.kallsyms])
        ffffffffbd9ee11a arp_rcv+0x18a ([kernel.kallsyms])
        ffffffffbd935d7f __netif_receive_skb_one_core+0x8f ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ksoftirqd/0     9 [000]  2938.674703: fib:fib_table_lookup: table 100 oif 0 iif 6 proto 0 1.1.1.2/0 -> 1.1.1.1/0 tos 0 scope 0 flags 4 ==> dev r1_v10 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9fd45d __fib_validate_source+0x32d ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9edb9a arp_process+0x49a ([kernel.kallsyms])
        ffffffffbd9ee11a arp_rcv+0x18a ([kernel.kallsyms])
        ffffffffbd935d7f __netif_receive_skb_one_core+0x8f ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ksoftirqd/0     9 [000]  2938.674869: fib:fib_table_lookup: table 10 oif 0 iif 5 proto 0 10.0.0.2/0 -> 10.0.0.1/0 tos 0 scope 0 flags 4 ==> dev r0_v00 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9ac4de ip_route_input_slow+0x98e ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9edb9a arp_process+0x49a ([kernel.kallsyms])
        ffffffffbd9ee11a arp_rcv+0x18a ([kernel.kallsyms])
        ffffffffbd935d7f __netif_receive_skb_one_core+0x8f ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ksoftirqd/0     9 [000]  2938.674904: fib:fib_table_lookup: table 10 oif 0 iif 5 proto 0 10.0.0.1/0 -> 10.0.0.2/0 tos 0 scope 0 flags 4 ==> dev r0_v00 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda0fbd6 fib4_rule_action+0x66 ([kernel.kallsyms])
        ffffffffbd96cde3 fib_rules_lookup+0x133 ([kernel.kallsyms])
        ffffffffbda0f6ea __fib_lookup+0x6a ([kernel.kallsyms])
        ffffffffbd9fd45d __fib_validate_source+0x32d ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9edb9a arp_process+0x49a ([kernel.kallsyms])
        ffffffffbd9ee11a arp_rcv+0x18a ([kernel.kallsyms])
        ffffffffbd935d7f __netif_receive_skb_one_core+0x8f ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd936021 process_backlog+0xa1 ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a809b run_ksoftirqd+0x2b ([kernel.kallsyms])
        ffffffffbd0cf420 smpboot_thread_fn+0xd0 ([kernel.kallsyms])
        ffffffffbd0c84a4 kthread+0x104 ([kernel.kallsyms])
        ffffffffbdc00202 ret_from_fork+0x22 ([kernel.kallsyms])

ntpd  1175 [000]  2942.573115: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 17 10.0.2.15/123 -> 104.236.116.147/123 tos 24 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9ad60f ip_route_output_flow+0x1f ([kernel.kallsyms])
        ffffffffbd9e696c udp_sendmsg+0x95c ([kernel.kallsyms])
        ffffffffbd9f66d5 inet_sendmsg+0x65 ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fec109ae844 __libc_sendto+0x74 (/lib/x86_64-linux-gnu/libpthread-2.31.so)

ntpd  1175 [000]  2942.573943: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 17 10.0.2.15/123 -> 173.255.192.10/123 tos 24 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9ad60f ip_route_output_flow+0x1f ([kernel.kallsyms])
        ffffffffbd9e696c udp_sendmsg+0x95c ([kernel.kallsyms])
        ffffffffbd9f66d5 inet_sendmsg+0x65 ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fec109ae844 __libc_sendto+0x74 (/lib/x86_64-linux-gnu/libpthread-2.31.so)

swapper     0 [000]  2942.591383: fib:fib_table_lookup: table 254 oif 0 iif 2 proto 0 104.236.116.147/0 -> 10.0.2.15/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 0.0.0.0/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9abda5 ip_route_input_slow+0x255 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbdad564e native_safe_halt+0xe ([kernel.kallsyms])
        ffffffffbd03dd55 arch_cpu_idle+0x15 ([kernel.kallsyms])
        ffffffffbdad57f3 default_idle_call+0x23 ([kernel.kallsyms])
        ffffffffbd0e006b do_idle+0x1fb ([kernel.kallsyms])
        ffffffffbd0e0270 cpu_startup_entry+0x20 ([kernel.kallsyms])
        ffffffffbdac82ae rest_init+0xae ([kernel.kallsyms])
        ffffffffbe89cc77 arch_call_rest_init+0xe ([kernel.kallsyms])
        ffffffffbe89d1e3 start_kernel+0x549 ([kernel.kallsyms])
        ffffffffbe89c44a x86_64_start_reservations+0x24 ([kernel.kallsyms])
        ffffffffbe89c4c1 x86_64_start_kernel+0x75 ([kernel.kallsyms])
        ffffffffbd0000d4 secondary_startup_64+0xa4 ([kernel.kallsyms])

swapper     0 [000]  2942.591979: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 0 10.0.2.15/0 -> 104.236.116.147/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9fd299 __fib_validate_source+0x169 ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbdad564e native_safe_halt+0xe ([kernel.kallsyms])
        ffffffffbd03dd55 arch_cpu_idle+0x15 ([kernel.kallsyms])
        ffffffffbdad57f3 default_idle_call+0x23 ([kernel.kallsyms])
        ffffffffbd0e006b do_idle+0x1fb ([kernel.kallsyms])
        ffffffffbd0e0270 cpu_startup_entry+0x20 ([kernel.kallsyms])
        ffffffffbdac82ae rest_init+0xae ([kernel.kallsyms])
        ffffffffbe89cc77 arch_call_rest_init+0xe ([kernel.kallsyms])
        ffffffffbe89d1e3 start_kernel+0x549 ([kernel.kallsyms])
        ffffffffbe89c44a x86_64_start_reservations+0x24 ([kernel.kallsyms])
        ffffffffbe89c4c1 x86_64_start_kernel+0x75 ([kernel.kallsyms])
        ffffffffbd0000d4 secondary_startup_64+0xa4 ([kernel.kallsyms])

ntpd  1175 [000]  2942.623071: fib:fib_table_lookup: table 254 oif 0 iif 2 proto 0 173.255.192.10/0 -> 10.0.2.15/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9abda5 ip_route_input_slow+0x255 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbd2ea9a7 path_init+0x107 ([kernel.kallsyms])
        ffffffffbd2ee99a path_openat+0x7a ([kernel.kallsyms])
        ffffffffbd2f0021 do_filp_open+0x91 ([kernel.kallsyms])
        ffffffffbd2d98be do_sys_open+0x17e ([kernel.kallsyms])
        ffffffffbd2d9a50 __x64_sys_openat+0x20 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fec108b8d94 __GI___libc_open+0xd4 (/lib/x86_64-linux-gnu/libc-2.31.so)
        617473706f6f6c2f [unknown] ([unknown])

ntpd  1175 [000]  2942.623206: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 0 10.0.2.15/0 -> 173.255.192.10/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9fd299 __fib_validate_source+0x169 ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbd2ea9a7 path_init+0x107 ([kernel.kallsyms])
        ffffffffbd2ee99a path_openat+0x7a ([kernel.kallsyms])
        ffffffffbd2f0021 do_filp_open+0x91 ([kernel.kallsyms])
        ffffffffbd2d98be do_sys_open+0x17e ([kernel.kallsyms])
        ffffffffbd2d9a50 __x64_sys_openat+0x20 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fec108b8d94 __GI___libc_open+0xd4 (/lib/x86_64-linux-gnu/libc-2.31.so)
        617473706f6f6c2f [unknown] ([unknown])

ntpd  1175 [000]  2944.573207: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 17 10.0.2.15/123 -> 50.205.244.23/123 tos 24 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9acd54 ip_route_output_key_hash_rcu+0x3c4 ([kernel.kallsyms])
        ffffffffbd9ad292 ip_route_output_key_hash+0x62 ([kernel.kallsyms])
        ffffffffbd9ad60f ip_route_output_flow+0x1f ([kernel.kallsyms])
        ffffffffbd9e696c udp_sendmsg+0x95c ([kernel.kallsyms])
        ffffffffbd9f66d5 inet_sendmsg+0x65 ([kernel.kallsyms])
        ffffffffbd90eefe sock_sendmsg+0x5e ([kernel.kallsyms])
        ffffffffbd910e93 __sys_sendto+0x113 ([kernel.kallsyms])
        ffffffffbd910f39 __x64_sys_sendto+0x29 ([kernel.kallsyms])
        ffffffffbd0044c7 do_syscall_64+0x57 ([kernel.kallsyms])
        ffffffffbdc0008c entry_SYSCALL_64_after_hwframe+0x44 ([kernel.kallsyms])
            7fec109ae844 __libc_sendto+0x74 (/lib/x86_64-linux-gnu/libpthread-2.31.so)

swapper     0 [000]  2944.595636: fib:fib_table_lookup: table 254 oif 0 iif 2 proto 0 50.205.244.23/0 -> 10.0.2.15/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9abda5 ip_route_input_slow+0x255 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbdad564e native_safe_halt+0xe ([kernel.kallsyms])
        ffffffffbd03dd55 arch_cpu_idle+0x15 ([kernel.kallsyms])
        ffffffffbdad57f3 default_idle_call+0x23 ([kernel.kallsyms])
        ffffffffbd0e006b do_idle+0x1fb ([kernel.kallsyms])
        ffffffffbd0e0270 cpu_startup_entry+0x20 ([kernel.kallsyms])
        ffffffffbdac82ae rest_init+0xae ([kernel.kallsyms])
        ffffffffbe89cc77 arch_call_rest_init+0xe ([kernel.kallsyms])
        ffffffffbe89d1e3 start_kernel+0x549 ([kernel.kallsyms])
        ffffffffbe89c44a x86_64_start_reservations+0x24 ([kernel.kallsyms])
        ffffffffbe89c4c1 x86_64_start_kernel+0x75 ([kernel.kallsyms])
        ffffffffbd0000d4 secondary_startup_64+0xa4 ([kernel.kallsyms])

swapper     0 [000]  2944.595773: fib:fib_table_lookup: table 254 oif 0 iif 1 proto 0 10.0.2.15/0 -> 50.205.244.23/0 tos 0 scope 0 flags 0 ==> dev ens3 gw 10.0.2.2/:: err 0
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbda04e17 fib_table_lookup+0x3b7 ([kernel.kallsyms])
        ffffffffbd9fd299 __fib_validate_source+0x169 ([kernel.kallsyms])
        ffffffffbd9fda09 fib_validate_source+0x49 ([kernel.kallsyms])
        ffffffffbd9ac586 ip_route_input_slow+0xa36 ([kernel.kallsyms])
        ffffffffbd9ac81a ip_route_input_rcu+0x15a ([kernel.kallsyms])
        ffffffffbd9ac978 ip_route_input_noref+0x28 ([kernel.kallsyms])
        ffffffffbd9aec0b ip_rcv_finish_core.isra.0+0x6b ([kernel.kallsyms])
        ffffffffbd9aefcb ip_rcv_finish+0x6b ([kernel.kallsyms])
        ffffffffbd9af9fc ip_rcv+0xbc ([kernel.kallsyms])
        ffffffffbd935d78 __netif_receive_skb_one_core+0x88 ([kernel.kallsyms])
        ffffffffbd935dc8 __netif_receive_skb+0x18 ([kernel.kallsyms])
        ffffffffbd935e55 netif_receive_skb_internal+0x45 ([kernel.kallsyms])
        ffffffffbd9378af napi_gro_receive+0xff ([kernel.kallsyms])
        ffffffffc01bd5e0 receive_buf+0x190 ([kernel.kallsyms])
        ffffffffc01bdadf virtnet_poll+0x15f ([kernel.kallsyms])
        ffffffffbd936eda net_rx_action+0x13a ([kernel.kallsyms])
        ffffffffbde000e1 __softirqentry_text_start+0xe1 ([kernel.kallsyms])
        ffffffffbd0a81ce irq_exit+0xae ([kernel.kallsyms])
        ffffffffbdc01e7a do_IRQ+0x5a ([kernel.kallsyms])
        ffffffffbdc00a0f ret_from_intr+0x0 ([kernel.kallsyms])
        ffffffffbdad564e native_safe_halt+0xe ([kernel.kallsyms])
        ffffffffbd03dd55 arch_cpu_idle+0x15 ([kernel.kallsyms])
        ffffffffbdad57f3 default_idle_call+0x23 ([kernel.kallsyms])
        ffffffffbd0e006b do_idle+0x1fb ([kernel.kallsyms])
        ffffffffbd0e0270 cpu_startup_entry+0x20 ([kernel.kallsyms])
        ffffffffbdac82ae rest_init+0xae ([kernel.kallsyms])
        ffffffffbe89cc77 arch_call_rest_init+0xe ([kernel.kallsyms])
        ffffffffbe89d1e3 start_kernel+0x549 ([kernel.kallsyms])
        ffffffffbe89c44a x86_64_start_reservations+0x24 ([kernel.kallsyms])
        ffffffffbe89c4c1 x86_64_start_kernel+0x75 ([kernel.kallsyms])
        ffffffffbd0000d4 secondary_startup_64+0xa4 ([kernel.kallsyms])

--mP3DRpeJDSE+ciuQ--
