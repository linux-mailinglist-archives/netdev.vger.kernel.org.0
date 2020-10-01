Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273A827F7F3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgJACXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgJACXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 22:23:54 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08847C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 19:23:54 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id j3so2124626qvi.7
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 19:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GQy53KQGVo9s9Qi70vRCqrNFtySzhamAuU+VZ7Y7aJs=;
        b=Yp9pKzJCMCVAmXMK/O/dk9zEcpA48TwhHGELyUeStftfjD5L9wBVVkPVV917U8iDKg
         FVbc9yqWPmVhYlchsWd9aLTMSIVwajgItuVPnCi8Kl+7TSmw1PSB1nK81nu7kuZaXgYf
         TkQgmQY2BFfe82L+EXW+XKXLg562lxfP+l1kTcb3vQ8RNYy10mi6OhYa0LpW3zKp/nZm
         J7Axt6RR7EEd82Y6VTtf7TiELijQ43QdGqmI4iwPt4c706yjk+zF2B/QZ26ADbfo3Vp7
         lI0NfXpZGR0/omj7ruhHLot98o2dbfBR5Ebj5J7F+YsNu9LxbjzOhzpTB0cIrpKljQOP
         c7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GQy53KQGVo9s9Qi70vRCqrNFtySzhamAuU+VZ7Y7aJs=;
        b=L/O4QOSXm0oRLTdKr3JDO651NJDYaQTekbJTEpyyYRP5S8MRjucOH24tAOh0bRVvO3
         jXo01ErPMzYmES3m+5a9TKC5/wrLqTRB3xYJJn4OQ8f5IEbwGkapKZZ2p6QVeWyezR1R
         N2z+ZkX0ytsSa0b23IgmgX2rpiV49uLSuyWtM6hRMmwNkwY4USfUnZih9fPLkYvoUsJx
         PWVfLnFe6oRNdfIoryDs2s0+j/xr/xC/l78mGg3bsrs5lZbr/HCjpOo6GmyD106pRGGN
         bq+H7iuy6l3C6MURdF5EM/ZjVPMLaDoS5O8Np7ruLJS9G22qSnWV6xWknbeU4vGxZukl
         OAvg==
X-Gm-Message-State: AOAM531f3kUUJGestLqdNlmNpIo6yOCeX2HGScQQT5FtA18uZtGnZA+Z
        RbEp9ffGdbx0vNVKrl4J3Q==
X-Google-Smtp-Source: ABdhPJzxT0S1VJsf10yEXUwXvIk1feqzJwaCvIJ+HXTa6rcVjOSau3PyrnnxOiBuSgIo8uRcGIdIJA==
X-Received: by 2002:a0c:8d82:: with SMTP id t2mr5556929qvb.62.1601519032995;
        Wed, 30 Sep 2020 19:23:52 -0700 (PDT)
Received: from vmserver ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id f8sm4534524qkb.123.2020.09.30.19.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 19:23:52 -0700 (PDT)
Date:   Wed, 30 Sep 2020 22:23:45 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: ip rule iif oif and vrf
Message-ID: <20201001022345.GA3527@vmserver>
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
 <20200923235002.GA25818@ICIPI.localdomain>
 <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
 <20200924134845.GA3688@ICIPI.localdomain>
 <97ce9942-2115-ed3a-75ea-8b58aa799ceb@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <97ce9942-2115-ed3a-75ea-8b58aa799ceb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 24, 2020 at 08:41:54AM -0600, David Ahern wrote:
> > We have multiple options on the table right now. One that can be done
> > without writing any code is to use an nft prerouting rule to mark
> > the packet with iif equals the tunnel and use ip rule fwmark to lookup
> > the right table.
> > 
> > ip netns exec r0 nft add table ip c2t
> > ip netns exec r0 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
> > ip netns exec r0 nft rule ip c2t prerouting iif gre01 mark set 101 counter
> > ip netns exec r0 ip rule add fwmark 101 table 10 pref 999
> > 
> > ip netns exec r1 nft add table ip c2t
> > ip netns exec r1 nft add chain ip c2t prerouting '{ type filter hook prerouting priority 0; policy accept; }'
> > ip netns exec r1 nft rule ip c2t prerouting iif gre10 mark set 101 counter
> > ip netns exec r1 ip rule add fwmark 101 table 10 pref 999
> > 
> > But this doesn't seem to work on my Ubuntu VM with the namespaces
> > script, i.e. pinging from h0 to h1. The packet doesn't egress r1_v11. It
> > does work on our target, based on 4.14 kernel.
> 
> add debugs to net/core/fib_rules.c, fib_rule_match() to see if
> flowi_mark is getting set properly. There could easily be places that
> are missed. Or if it works on one setup, but not another compare sysctl
> settings for net.core and net.ipv4

Sorry, I got side-tracked. Coming back to this: I made a mistake in the
ip rule fwmark pref in the script. I have fixed it and the script is
attached (gre_setup_nft.sh). It has the nft and ip rule commands above.
The ping between h0 and h1 works.

> > We also notice though in on the target platform that the ip rule fwmark
> > doesn't seem to change the skb->dev to the vrf of the lookup table.
> 
> not following that statement. fwmark should be marking the skb, not
> changing the skb->dev.

Yes and it causes the ping between h0 and r1 r1_v11 to not work, e.g.:

ip netns exec h0 ping -c 1 11.0.0.1

Similarly, ping between r0_v00 and r1_v11 also does not work:

ip netns exec r0 ip vrf exec vrf_r0t ping -c 1 -I 10.0.0.1 11.0.0.1

> > E.g., ping from 10.0.0.1 to 11.0.0.1. With net.ipv4.fwmark_reflect set,
> > the reply is generated but the originating ping application doesn't get
> > the packet.  I suspect it is caused by the socket is bound to the tenant
> > vrf. I haven't been able to repro this because of the problem with the
> > nft approach above.

To illustrate my statements above, this is what I did:
ip netns exec r1 sysctl -w net.ipv4.fwmark_reflect=1
ip netns exec h0 ping -c 1 11.0.0.1
PING 11.0.0.1 (11.0.0.1) 56(84) bytes of data.
64 bytes from 11.0.0.1: icmp_seq=1 ttl=63 time=0.079 ms

The ping between h0 and r1 r1_v11 works, but it still doesn't work for this:
ip netns exec r0 ip vrf exec vrf_r0t ping -c 1 -I 10.0.0.1 11.0.0.1

eventhough the reply is received by gre01:
ip netns exec r0 tcpdump -nexi gre01
22:10:57.173680 Out ethertype IPv4 (0x0800), length 100: 10.0.0.1 > 11.0.0.1: ICMP echo request, id 3803, seq 1, length 64
	0x0000:  4500 0054 1d2a 4000 4001 087e 0a00 0001
	0x0010:  0b00 0001 0800 a410 0edb 0001 b13a 755f
	0x0020:  0000 0000 5da6 0200 0000 0000 1011 1213
	0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
	0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
	0x0050:  3435 3637
22:10:57.173724  In ethertype IPv4 (0x0800), length 100: 11.0.0.1 > 10.0.0.1: ICMP echo reply, id 3803, seq 1, length 64
	0x0000:  4500 0054 c709 0000 4001 9e9e 0b00 0001
	0x0010:  0a00 0001 0000 ac10 0edb 0001 b13a 755f
	0x0020:  0000 0000 5da6 0200 0000 0000 1011 1213
	0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
	0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
	0x0050:  3435 3637

In summary the question is: should ip rule with action FR_ACT_TO_TBL
also change the skb->dev to the right l3mdev?

Thank you,

Stephen.

--3V7upXqbjpZ4EhLz
Content-Type: application/x-sh
Content-Disposition: attachment; filename="gre_setup_nft.sh"
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
# gre01 2.2.2.1/30       gre10 2.2.2.2/30=0A=0A# start=0Aip netns add h0=0A=
ip netns add r0=0Aip netns add h1=0Aip netns add r1=0A=0A# disable v6=0Aip =
netns exec h0 sysctl -w net.ipv6.conf.all.disable_ipv6=3D1=0Aip netns exec =
h0 sysctl -w net.ipv6.conf.default.disable_ipv6=3D1=0Aip netns exec h0 sysc=
tl -w net.ipv6.conf.lo.disable_ipv6=3D1=0Aip netns exec r0 sysctl -w net.ip=
v6.conf.all.disable_ipv6=3D1=0Aip netns exec r0 sysctl -w net.ipv6.conf.def=
ault.disable_ipv6=3D1=0Aip netns exec r0 sysctl -w net.ipv6.conf.lo.disable=
_ipv6=3D1=0Aip netns exec r1 sysctl -w net.ipv6.conf.all.disable_ipv6=3D1=
=0Aip netns exec r1 sysctl -w net.ipv6.conf.default.disable_ipv6=3D1=0Aip n=
etns exec r1 sysctl -w net.ipv6.conf.lo.disable_ipv6=3D1=0Aip netns exec h1=
 sysctl -w net.ipv6.conf.all.disable_ipv6=3D1=0Aip netns exec h1 sysctl -w =
net.ipv6.conf.default.disable_ipv6=3D1=0Aip netns exec h1 sysctl -w net.ipv=
6.conf.lo.disable_ipv6=3D1=0A=0A# setup topology=0Aip link add h0_v00 type =
veth peer name r0_v00=0Aip link set h0_v00 netns h0=0Aip link set r0_v00 ne=
tns r0=0Aip link add r0_v01 type veth peer name r1_v10=0Aip link set r0_v01=
 netns r0=0Aip link set r1_v10 netns r1=0Aip link add r1_v11 type veth peer=
 name h1_v11=0Aip link set r1_v11 netns r1=0Aip link set h1_v11 netns h1=0A=
=0Aip netns exec r0 ip link add vrf_r0t type vrf table 10=0Aip netns exec r=
0 ip addr add 127.0.0.1/8 dev vrf_r0t=0Aip netns exec r0 ip link set vrf_r0=
t up=0Aip netns exec r0 ip link add vrf_r0c type vrf table 100=0Aip netns e=
xec r0 ip addr add 127.0.0.1/8 dev vrf_r0c=0Aip netns exec r0 ip link set v=
rf_r0c up=0Aip netns exec r1 ip link add vrf_r1t type vrf table 10=0Aip net=
ns exec r1 ip addr add 127.0.0.1/8 dev vrf_r1t=0Aip netns exec r1 ip link s=
et vrf_r1t up=0Aip netns exec r1 ip link add vrf_r1c type vrf table 100=0Ai=
p netns exec r1 ip addr add 127.0.0.1/8 dev vrf_r1c=0Aip netns exec r1 ip l=
ink set vrf_r1c up=0A=0Aip netns exec r0 ip link set dev r0_v00 master vrf_=
r0t=0Aip netns exec r0 ip link set dev r0_v01 master vrf_r0c=0Aip netns exe=
c r1 ip link set dev r1_v11 master vrf_r1t=0Aip netns exec r1 ip link set d=
ev r1_v10 master vrf_r1c=0A=0Aip netns exec h0 ip addr add 10.0.0.2/24 dev =
h0_v00=0Aip netns exec r0 ip addr add 10.0.0.1/24 dev r0_v00=0Aip netns exe=
c r0 ip addr add 1.1.1.1/24 dev r0_v01=0Aip netns exec r1 ip addr add 1.1.1=
=2E2/24 dev r1_v10=0Aip netns exec r1 ip addr add 11.0.0.1/24 dev r1_v11=0A=
ip netns exec h1 ip addr add 11.0.0.2/24 dev h1_v11=0A=0Aip netns exec r0 i=
p tunnel add gre01 mode gre local 1.1.1.1 remote 1.1.1.2 dev vrf_r0c=0Aip n=
etns exec r0 ip link set dev gre01 master vrf_r0c=0Aip netns exec r0 ip add=
r add 2.2.2.1/30 dev gre01=0Aip netns exec r1 ip tunnel add gre10 mode gre =
local 1.1.1.2 remote 1.1.1.1 dev vrf_r1c=0Aip netns exec r1 ip link set dev=
 gre10 master vrf_r1c=0Aip netns exec r1 ip addr add 2.2.2.2/30 dev gre10=
=0A=0Aip netns exec h0 ip link set dev h0_v00 up=0Aip netns exec r0 ip link=
 set dev r0_v00 up=0Aip netns exec r0 ip link set dev r0_v01 up=0Aip netns =
exec r0 ip link set dev gre01 up=0Aip netns exec r1 ip link set dev r1_v10 =
up=0Aip netns exec r1 ip link set dev r1_v11 up=0Aip netns exec r1 ip link =
set dev gre10 up=0Aip netns exec h1 ip link set dev h1_v11 up=0A=0Aip netns=
 exec r0 sysctl -w net.ipv4.ip_forward=3D1 > /dev/null=0Aip netns exec r1 s=
ysctl -w net.ipv4.ip_forward=3D1 > /dev/null=0A=0Aip netns exec h0 ip route=
 add default via 10.0.0.1=0Aip netns exec h1 ip route add default via 11.0.=
0.1=0A=0Aip netns exec r0 ip route add 11.0.0.0/24 via 2.2.2.2 dev gre01 ta=
ble 10=0Aip netns exec r1 ip route add 10.0.0.0/24 via 2.2.2.1 dev gre10 ta=
ble 10=0A=0A# do these to match the config on the target platform=0Aip netn=
s exec r0 ip route add unreachable default metric 8192 table 10=0Aip netns =
exec r0 ip route add unreachable default metric 8192 table 100=0Aip netns e=
xec r1 ip route add unreachable default metric 8192 table 10=0Aip netns exe=
c r1 ip route add unreachable default metric 8192 table 100=0Aip netns exec=
 r0 ip rule delete from all lookup local=0Aip netns exec r0 ip rule add fro=
m all lookup local pref 32765=0Aip netns exec r1 ip rule delete from all lo=
okup local=0Aip netns exec r1 ip rule add from all lookup local pref 32765=
=0A=0A# packets out of the core vrf tunnel are leak-routed to the tenant vr=
f=0A# NOTE: This doesn't work=0A#ip netns exec r0 ip rule add iif gre01 tab=
le 10 pref 999=0A#ip netns exec r1 ip rule add iif gre10 table 10 pref 999=
=0A=0A# nft rules for tunnel to tenant routing/forwarding=0A# NOTE: make su=
re the rule is before the l3mdev all=0A#       this works for ping between =
h0 and h1 but not between vrf_r0t and vrf_r1t=0Aip netns exec r0 nft add ta=
ble ip c2t=0Aip netns exec r0 nft add chain ip c2t prerouting '{ type filte=
r hook prerouting priority 0; policy accept; }'=0Aip netns exec r0 nft rule=
 ip c2t prerouting iif gre01 mark set 101 counter=0Aip netns exec r0 ip rul=
e add fwmark 101 table 10 pref 999=0A=0Aip netns exec r1 nft add table ip c=
2t=0Aip netns exec r1 nft add chain ip c2t prerouting '{ type filter hook p=
rerouting priority 0; policy accept; }'=0Aip netns exec r1 nft rule ip c2t =
prerouting iif gre10 mark set 101 counter=0Aip netns exec r1 ip rule add fw=
mark 101 table 10 pref 999=0A
--3V7upXqbjpZ4EhLz--
