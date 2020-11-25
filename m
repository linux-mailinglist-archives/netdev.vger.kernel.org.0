Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9C92C41D2
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgKYOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgKYOJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 09:09:16 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6356C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 06:09:16 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id b8so2197480ila.13
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 06:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k9M8gDmBzDwN1yxdddX7hP9bn2/LcAhpHtbsP5SuYqc=;
        b=dWR7wus1UDnPtNy35eIzvQBT38UaiUmUKkbrZoC+6+64Dfvlv5JYMRWsl01F9yfXMl
         NQSsQswfqEJqnM1vd4MR3Fvppxh2e4gLRyPCymVUR/2/GXPf5pVHTlaSZLnej6w4mO42
         KCAezUq3R5sGUYFn6VaB36TfqiPvk8evC+gwGXsN51uBUnSZ68vc9XG/QkSyTgcm7gQ6
         QfXw1HUdpvvNPzHAF+IjwLZRs5eX+Vgd8W6qo3p8A1EoBibG05eLFKpZuOwKuERmKkBk
         /PW3eKeaaijAeTLGoCtvCpbiAt085jsNYzhPpHnah/+i9XcUxGryKsTQ4oMXcQkmbnxw
         Omtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k9M8gDmBzDwN1yxdddX7hP9bn2/LcAhpHtbsP5SuYqc=;
        b=eoOvOgbGr81j50zTDvuzrMIJ4gqDDGcDEAQOM/i9kNmLjETEWL9XubPMmdAMaK3ac9
         dq+tNljWG9ihPZnfzzzoHMZKigyDSz7fjMb5Luxlz2TqYpz7I0p4H1j+Mki9Lw+AUkm7
         euGRJ1znd1CpsWtzDGbt2zQ+6cKPk8czRRcNzKV6vCak7gNjH/TO7sz69N1nESOBkQUf
         uYgwyNPPsggFSR/yNZaIshBsfzM0huJgmJuNhG1Wiu0JlNKUlyomlqQA6bKaqLHaRV1F
         ZZaGhSADb0P/tq3pugHc9yrAWO+IVQtljcIaWu1AoKNA66u3/CtQVXntCddXngIAU8H+
         gRjg==
X-Gm-Message-State: AOAM531wgqLXCEE2C3woC2a9RCkuitdz1rkwFaXVyT0uCJX48nWAXxQC
        3aL12Vh8rH10LTna7nRMniXEkxH1thOH+4YnY0UWlbtzxCc=
X-Google-Smtp-Source: ABdhPJzyJUIBlL4Tvg+u24nyHBXEz71+7C3qNf8Pj18/02Hmn/GjG8tN4iw+bvuKLeRop3XWIEvvD+ZzrnvYCxs1PwI=
X-Received: by 2002:a92:6e0d:: with SMTP id j13mr3223877ilc.254.1606313355980;
 Wed, 25 Nov 2020 06:09:15 -0800 (PST)
MIME-Version: 1.0
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch> <20201001062107.GA2592@fido.de.innominate.com>
In-Reply-To: <20201001062107.GA2592@fido.de.innominate.com>
From:   Peter Vollmer <peter.vollmer@gmail.com>
Date:   Wed, 25 Nov 2020 15:09:04 +0100
Message-ID: <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I am still investigating the leaking packets problem we are having
with a setup of an armada-3720 SOC and a 88E6341 switch ( connected
via cpu port 5 , SGMII ,C_MODE=0xB, 2500 BASE-x). I now jumped to the
net-next kernel (5.10.0-rc4) and can now use the nice mv88e6xxx_dump
tool for switch register dumping.

The described packet leaking still occurs, in a setup of ports
lan0-lan3 (switch ports 1-4)  joined in a bridge br0.

Here is my setup, ports lan0-3 are DSA ports coming in through eth1,
eth0 is a single 88E1512 phy connected to RGMII
root@DUT:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.fafb2fbbd4c6       no              lan0
                                                        lan1
                                                        lan2
                                                        lan3
root@DUT:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
group default qlen 1024
    link/ether c2:49:bc:0d:a8:57 brd ff:ff:ff:ff:ff:ff
    inet 192.168.90.100/24 brd 192.168.90.255 scope global eth0
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc mq state UP
group default qlen 1024
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
4: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
5: lan0@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
master br0 state UP group default qlen 1000
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
6: lan1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
master br0 state UP group default qlen 1000
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
7: lan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
master br0 state UP group default qlen 1000
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
8: lan3@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue master br0 state LOWERLAYERDOWN group default qlen 1000
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
UP group default qlen 1000
    link/ether fa:fb:2f:bb:d4:c6 brd ff:ff:ff:ff:ff:ff
    inet 172.16.4.1/16 brd 172.16.4.255 scope global br0
       valid_lft forever preferred_lft forever

- pinging from client0 (connected to lan0 ) to the bridge IP, the ping
requests (only the requests) are also seen on client1 connected to
lan1

- the other effect looks more suspicious: when pinging from br0 to the
IP of client0 connected to port lan0, after ~280 seconds client1
connected to lan1 will also see the ping replies of client0 (only the
replies). And after another ~300seconds this stops again. This repeats
in a cycle .

I see these problems since at least kernel version 5.4.y, but not with
the old linux-marvel kernel sources
(https://github.com/MarvellEmbeddedProcessors/linux-marvell.git)
Can somebody using this switch in SGMII mode perhaps reproduce this ?

One thing I noticed is that due to .tag_protocol=DSA_TAG_PROTO_EDSA
for the 88E6341 switch, EgressMode (port control 0x4 , bit13:12) is
set to an unsupported value of 0x3 ("reserved for future use" in the
switch spec). See the value in row 04 Port control for port 5 = 0x373f
in the following dump:

root@mguard3:~# mv88e6xxx_dump --ports
Using device <mdio_bus/d0032004.mdio-mii:01>
                           0    1    2    3    4    5
00 Port status            0006 9e4f 9e4f 9e4f 100f 0f0b
01 Physical control       0003 0003 0003 0003 0003 20ff
02 Jamming control        ff00 0000 0000 0000 0000 0000
03 Switch ID              3410 3410 3410 3410 3410 3410
04 Port control           007c 043f 043f 043f 043c 373f
05 Port control 1         0000 0000 0000 0000 0000 0000
06 Port base VLAN map     007e 007c 007a 0076 006e 005f
07 Def VLAN ID & Prio     0001 0000 0000 0000 0000 0000
08 Port control 2         2080 0080 0080 0080 0080 0080
09 Egress rate control    0001 0001 0001 0001 0001 0001
0a Egress rate control 2  8000 0000 0000 0000 0000 0000
0b Port association vec   0001 0002 0004 0008 0010 0000
0c Port ATU control       0000 0000 0000 0000 0000 0000
0d Override               0000 0000 0000 0000 0000 0000
0e Policy control         0000 0000 0000 0000 0000 0000
0f Port ether type        9100 9100 9100 9100 9100 dada
10 Reserved               0000 0000 0000 0000 0000 0000
11 Reserved               0000 0000 0000 0000 0000 0000
12 Reserved               0000 0000 0000 0000 0000 0000
13 Reserved               0000 0000 0000 0000 0000 0000
14 Reserved               0000 0000 0000 0000 0000 0000
15 Reserved               0000 0000 0000 0000 0000 0000
16 LED control            0000 10eb 10eb 10eb 10eb 0000
17 Reserved               0000 0000 0000 0000 0000 0000
18 Tag remap low          3210 3210 3210 3210 3210 3210
19 Tag remap high         7654 7654 7654 7654 7654 7654
1a Reserved               0000 0000 0000 0000 5ea0 a100
1b Queue counters         8000 8000 8000 8000 8000 8000
1c Queue control          0000 0000 0000 0000 0000 0000
1d queue control 2        0000 0000 0000 0000 0000 0000
1e Cut through control    f000 f000 f000 f000 f000 f000
1f Debug counters         0000 0014 0015 0012 0000 0010

I tested setting .tag_protocol=DSA_TAG_PROTO_DSA for the 6341 switch
instead, resulting in a register setting of 04 Port control for port 5
= 0x053f (i.e. EgressMode=Unmodified mode, frames are transmitted
unmodified), which looks correct to me. It does not fix the above
problem, but the change seems to make sense anyhow. Should I send a
patch ?

Thanks and best regards
  Peter
