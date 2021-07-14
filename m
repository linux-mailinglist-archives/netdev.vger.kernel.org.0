Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519B23C88AB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhGNQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 12:33:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53457 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235671AbhGNQdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 12:33:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C7E15C019E;
        Wed, 14 Jul 2021 12:30:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 14 Jul 2021 12:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=BgiIoHudRiHbXUXOtUn6RzwEHNeWRPsicjI23iYfL
        qM=; b=JW/nWqj0y1Zc+FGeId3QCUZ6hkROczgyMtyANHA1anWXz5T/4Icz3eJYw
        B90lE9Tnx3Q3/SITJp+Us+sOZ5ja1UFQCDuKZPK50Cbc6pxJoGZDWeSjxwxLFALa
        sYMssfLP0Y3+lqjwADrcddEBUSVD4ixdD1mIy3I6zzgnhcAOtVnoIzErXMkOaaj6
        5FcXreD6qWB6/GoVoat5HY5fQ1aLMSVQ0Q0udvQo+Dna6OSaymg0yh1jDtQXVM1d
        WErpuh5VFRLqrUvoiS/BYptHskisr16QsrIhKBwZEPART/cvrCzkrhJCWkkxhinu
        fE1aN7bExIeeylmUTxSPsxJaaTLNg==
X-ME-Sender: <xms:NBHvYDMgeWkNGomcnMKDucUm0pJNHkEvHrYu9MFTUJNvkuUcMTLSbg>
    <xme:NBHvYN-jeuwt_GpSh93ioFLoyU0-LNYSGShQMtThWKJkcuqQHiufmJkyWJ_A9nKmJ
    -vkCUohTPq96t8>
X-ME-Received: <xmr:NBHvYCR4ZkqpOT3TZ6F_zHkpD7hNveWgFoOHx8sSNu4_MQdbL1_GaMebUnwm9LEC0ifHCQuSc5R6N2PDc--W631iOTfWOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejhedtvefhkeegfeelffffueefvdfhgeffjeethfekheefgfekveeukedvueff
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NBHvYHvrpPvCbny5kP_z_oyvFJDmH4_H7iV9PXwOjlFTJ_JoLmL_Fw>
    <xmx:NBHvYLeJcEw4h1hFu0bRpJt63EgAMUwUO1duyRH6gBK4EKMRoS01cA>
    <xmx:NBHvYD2pP8_u1A_A494HtM_GEvqg_SvqfkB1vh-g2-PsHXvtaWMBHQ>
    <xmx:NRHvYLn1VB3HCvaXj-ZKNjE72sF57d6cgoUQM1OO0_akpXcLB8TMJQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Jul 2021 12:30:44 -0400 (EDT)
Date:   Wed, 14 Jul 2021 19:30:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Fw: [Bug 213729] New: PMTUD failure with ECMP.
Message-ID: <YO8RMnknR0oniZ/R@shredder>
References: <20210714081318.40500a1b@hermes.local>
 <76039c52-5637-23a1-6ad8-36b16204ae29@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76039c52-5637-23a1-6ad8-36b16204ae29@novek.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:11:45PM +0100, Vadim Fedorenko wrote:
> On 14.07.2021 16:13, Stephen Hemminger wrote:
> > 
> > 
> > Begin forwarded message:
> > 
> > Date: Wed, 14 Jul 2021 13:43:51 +0000
> > From: bugzilla-daemon@bugzilla.kernel.org
> > To: stephen@networkplumber.org
> > Subject: [Bug 213729] New: PMTUD failure with ECMP.
> > 
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=213729
> > 
> >              Bug ID: 213729
> >             Summary: PMTUD failure with ECMP.
> >             Product: Networking
> >             Version: 2.5
> >      Kernel Version: 5.13.0-rc5
> >            Hardware: x86-64
> >                  OS: Linux
> >                Tree: Mainline
> >              Status: NEW
> >            Severity: normal
> >            Priority: P1
> >           Component: IPV4
> >            Assignee: stephen@networkplumber.org
> >            Reporter: skappen@mvista.com
> >          Regression: No
> > 
> > Created attachment 297849
> >    --> https://bugzilla.kernel.org/attachment.cgi?id=297849&action=edit
> > Ecmp pmtud test setup
> > 
> > PMTUD failure with ECMP.
> > 
> > We have observed failures when PMTUD and ECMP work together.
> > Ping fails either through gateway1 or gateway2 when using MTU greater than
> > 1500.
> > The Issue has been tested and reproduced on CentOS 8 and mainline kernels.
> > 
> > 
> > Kernel versions:
> > [root@localhost ~]# uname -a
> > Linux localhost.localdomain 4.18.0-305.3.1.el8.x86_64 #1 SMP Tue Jun 1 16:14:33
> > UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > [root@localhost skappen]# uname -a
> > Linux localhost.localdomain 5.13.0-rc5 #2 SMP Thu Jun 10 05:06:28 EDT 2021
> > x86_64 x86_64 x86_64 GNU/Linux
> > 
> > 
> > Static routes with ECMP are configured like this:
> > 
> > [root@localhost skappen]#ip route
> > default proto static
> >          nexthop via 192.168.0.11 dev enp0s3 weight 1
> >          nexthop via 192.168.0.12 dev enp0s3 weight 1
> > 192.168.0.0/24 dev enp0s3 proto kernel scope link src 192.168.0.4 metric 100
> > 
> > So the host would pick the first or the second nexthop depending on ECMP's
> > hashing algorithm.
> > 
> > When pinging the destination with MTU greater than 1500 it works through the
> > first gateway.
> > 
> > [root@localhost skappen]# ping -s1700 10.0.3.17
> > PING 10.0.3.17 (10.0.3.17) 1700(1728) bytes of data.
> >  From 192.168.0.11 icmp_seq=1 Frag needed and DF set (mtu = 1500)
> > 1708 bytes from 10.0.3.17: icmp_seq=2 ttl=63 time=0.880 ms
> > 1708 bytes from 10.0.3.17: icmp_seq=3 ttl=63 time=1.26 ms
> > ^C
> > --- 10.0.3.17 ping statistics ---
> > 3 packets transmitted, 2 received, +1 errors, 33.3333% packet loss, time 2003ms
> > rtt min/avg/max/mdev = 0.880/1.067/1.255/0.190 ms
> > 
> > The MTU also gets cached for this route as per rfc6754:
> > 
> > [root@localhost skappen]# ip route get 10.0.3.17
> > 10.0.3.17 via 192.168.0.11 dev enp0s3 src 192.168.0.4 uid 0
> >      cache expires 540sec mtu 1500
> > 
> > [root@localhost skappen]# tracepath -n 10.0.3.17
> >   1?: [LOCALHOST]                      pmtu 1500
> >   1:  192.168.0.11                                          1.475ms
> >   1:  192.168.0.11                                          0.995ms
> >   2:  192.168.0.11                                          1.075ms !H
> >       Resume: pmtu 1500
> > 
> > However when the second nexthop is picked PMTUD breaks. In this example I ping
> > a second interface configured on the same destination
> > from the same host, using the same routes and gateways. Based on ECMP's hashing
> > algorithm this host would pick the second nexthop (.2):
> > 
> > [root@localhost skappen]# ping -s1700 10.0.3.18
> > PING 10.0.3.18 (10.0.3.18) 1700(1728) bytes of data.
> >  From 192.168.0.12 icmp_seq=1 Frag needed and DF set (mtu = 1500)
> >  From 192.168.0.12 icmp_seq=2 Frag needed and DF set (mtu = 1500)
> >  From 192.168.0.12 icmp_seq=3 Frag needed and DF set (mtu = 1500)
> > ^C
> > --- 10.0.3.18 ping statistics ---
> > 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2062ms
> > [root@localhost skappen]# ip route get 10.0.3.18
> > 10.0.3.18 via 192.168.0.12 dev enp0s3 src 192.168.0.4 uid 0
> >      cache
> > 
> > [root@localhost skappen]# tracepath -n 10.0.3.18
> >   1?: [LOCALHOST]                      pmtu 9000
> >   1:  192.168.0.12                                          3.147ms
> >   1:  192.168.0.12                                          0.696ms
> >   2:  192.168.0.12                                          0.648ms pmtu 1500
> >   2:  192.168.0.12                                          0.761ms !H
> >       Resume: pmtu 1500
> > 
> > The ICMP frag needed reaches the host, but in this case it is ignored.
> > The MTU for this route does not get cached either.
> > 
> > 
> > It looks like mtu value from the next hop is not properly updated for some
> > reason.
> > 
> > 
> > Test Case:
> > Create 2 networks: Internal, External
> > Create 4 virtual machines: Client, GW-1, GW-2, Destination
> > 
> > Client
> > configure 1 NIC to internal with MTU 9000
> > configure static route with ECMP to GW-1 and GW-2 internal address
> > 
> > GW-1, GW-2
> > configure 2 NICs
> > - to internal with MTU 9000
> > - to external MTU 1500
> > - enable ip_forward
> > - enable packet forward
> > 
> > Target
> > configure 1 NIC to external MTU with 1500
> > configure multiple IP address(say IP1, IP2, IP3, IP4) on the same interface, so
> > ECMP's hashing algorithm would pick different routes
> > 
> > Test
> > ping from client to target with larger than 1500 bytes
> > ping the other addresses of the target so ECMP would use the other route too
> > 
> > Results observed:
> > Through GW-1 PMTUD works, after the first frag needed message the MTU is
> > lowered on the client side for this target. Through the GW-2 PMTUD does not,
> > all responses to ping are ICMP frag needed, which are not obeyed by the kernel.
> > In all failure cases mtu is not cashed on "ip route get".
> > 
> Looks like I'm in context of PMTU and also I'm working on implementing several
> new test cases for pmtu.sh test, so I will take care of this one too

Thanks

There was a similar report from around a year ago that might give you
more info:

https://lore.kernel.org/netdev/CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com/
