Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146B769F9D5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 18:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbjBVRSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 12:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjBVRSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 12:18:06 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D751EBC6
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 09:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677086262; i=frank-w@public-files.de;
        bh=+cRYhL5ZzaTT0bC+9Lut029Yltb13JMSnLcAE6TyfCg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZkNukEIcsZdlHDmoOlYcZNEsHcGpDAtAs7T2R7dM+eRK8BgpvlLHr7bIPyu3zwVLw
         d4kpUUnhKE5FJDD00AAFkKoAf/K3Z/hu1VmfXOnq65DXQnpdKS7e5X3njXs5CaHHcI
         +PM7O0Y207LHHKuS1pn9uNq6d+/xHvfPWQw/wS95U61RhaLIAU4txP7HstbtjGxGQ/
         HlRelVrqwmM+DSE+nWVqD+SyqxCEukLRF3t3T8Ya45PqSWpW8G9TnqK4SnV2610Vg5
         TbeZHLvu5nwQR27lTPehQ4GitGNc88rEOr5IQieOokF+M53xe0naePnqTeKuGhqSXj
         VpAHAjLDLc6FQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [80.245.74.129] ([80.245.74.129]) by web-mail.gmx.net
 (3c-app-gmx-bs54.server.lan [172.19.170.138]) (via HTTP); Wed, 22 Feb 2023
 18:17:42 +0100
MIME-Version: 1.0
Message-ID: <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 22 Feb 2023 18:17:42 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230221002713.qdsabxy7y74jpbm4@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:+TqGljfiDnMj1yyqWLMOCaZT7qo2xb3jjBYJnTm9fi6C2+shO+OvmBpigZ8p0UJGHsmT9
 Og/nFE0MpoErtuVgt/jl3kpRgBCDkLdV0bqNIaKLHiqBJE0wOFqulTMF9J6X6QK7jDCMvO3R7dOs
 rZs4OpwXEs0KpO00l1KSZfgaGydfd3wRDEUpRRhjHmBPLbGrz2X9HIlrHREawaxgCMPcou28qxu1
 vfYhchcWbxNV9TT0lXkUTt8YCQHL3dzEDZGX/l0rQcNVpaYPwfF7f1WC5TLkFO6eL1vqNvGb26LI
 WM=
UI-OutboundReport: notjunk:1;M01:P0:Eoq6tXeZkdM=;yRLM48UTFIgZOEGXs/PQ4l4zbT/
 H2nu1ohNiS5C7gouiJVwL0hBa+O/nYpQkY8D8m6Cokk5iKidVLYas7t5FtSMqGPWn7RoSPWnW
 xiA2zGOg4lGOejYYLblDjkkB6dobr+GJHl8vErEBrQx2eAz1nSLX5ET4raZOAZZ6+kIWCA6gw
 8SOIO67smPTxawaHc4kFhbb6bZ7GiP5nuB7NKhBQAT4uA+EPA6z6Vfe2BclvhDtqkpxlfAnyC
 jty0gsBYIV/WCd+q0QX4O046c24cQttlqeAodMaSm/b6nWcBnca+f5hjqxv4n4u6kcQBuyjcf
 pKLPdEDL3Z4nNz675oVNafNmObwzU45RB2HlGkTBfhxmWmRv2dr+2gIKgTVOSKN3UJ3O8OPhB
 30x7ttHWDr5kxzAZwTxiGZ/O7TAFv8fAATOP4NXyJMAWk9iBipQeScTAe6NM9tYEDXE85qNJM
 TuGaDGL5tI/u76RB8xu1AI9BXjwn0/FprhKHwVMt+l/Ysc6m+tFRulRi7NJWAGMAe2Jd33hTN
 sQ8X7ua46mRz/npDP79CfHTSugsGiVY29wdN4QyPZmPa1iZaj1/GC4bePd0fBFEUwjUgmAiHp
 hLBpHtUjoZFCmNhwcoeLfiD0CHGdj1DNeafs1TNul8mqbqDAs6CT6Eqc8Vaqd4M6lf/GAymFx
 mXFtXc6I/Gh95B/A+lti297kIjoNvk7b3KQDxfbxSnWJ968gOBowMIJFm7RiGAIjLgAahg10c
 CAs1QPtzcofmuCkQ57HtXhovPjGKZlO9x4+JPOu+i8yajuBdouWbnGAEbxL2vyuQssAVl+2D9
 Zd0z3LPQBQ8ZKHVa4Gbs74G7pi5FuUEQOKaVX2kkbgt6E=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

thanks vladimir for the Patch, seems to work so far...
system now says dsa-ports are routed over eth0 and ethtool stats say it to=
o.

wonder why i get only 620Mbit on wan-port like over eth1.

root@bpi-r2:~# ip a s wan
5: wan@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue stat=
e UP group default qlen 1000
    link/ether 08:22:33:44:55:77 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.11/24 scope global wan
       valid_lft forever preferred_lft forever
    inet6 fe80::a22:33ff:fe44:5577/64 scope link
       valid_lft forever preferred_lft forever
root@bpi-r2:~# dmesg | grep eth0
[    3.309829] mtk_soc_eth 1b100000.ethernet eth0: mediatek frame engine a=
t 0xe09e0000, irq 213
[    4.883250] mtk_soc_eth 1b100000.ethernet eth0: entered promiscuous mod=
e
[  394.459951] mtk_soc_eth 1b100000.ethernet eth0: configuring for fixed/t=
rgmii link mode
[  394.468881] mtk_soc_eth 1b100000.ethernet eth0: Link is Up - 1Gbps/Full=
 - flow control rx/tx
[  394.477858] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
root@bpi-r2:~# ethtool -S eth0 | grep bytes
     tx_bytes: 819990532
     rx_bytes: 18465803
root@bpi-r2:~#
root@bpi-r2:~# ethtool -S eth1 | grep bytes
     tx_bytes: 0
     rx_bytes: 0
root@bpi-r2:~# iperf3 -c 192.168.0.21
Connecting to host 192.168.0.21, port 5201
[  5] local 192.168.0.11 port 60280 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  75.3 MBytes   631 Mbits/sec    0    358 KBytes
[  5]   1.00-2.00   sec  74.3 MBytes   623 Mbits/sec    0    376 KBytes
[  5]   2.00-3.00   sec  74.6 MBytes   626 Mbits/sec    0    376 KBytes
[  5]   3.00-4.00   sec  74.1 MBytes   622 Mbits/sec    0    376 KBytes
[  5]   4.00-5.00   sec  74.6 MBytes   626 Mbits/sec    0    376 KBytes
[  5]   5.00-6.00   sec  74.5 MBytes   625 Mbits/sec    0    376 KBytes
[  5]   6.00-7.00   sec  74.4 MBytes   625 Mbits/sec    0    411 KBytes
[  5]   7.00-8.00   sec  74.1 MBytes   622 Mbits/sec    0    411 KBytes
[  5]   8.00-9.00   sec  74.6 MBytes   626 Mbits/sec    0    411 KBytes
[  5]   9.00-10.00  sec  74.0 MBytes   621 Mbits/sec    0    411 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   744 MBytes   624 Mbits/sec    0             send=
er
[  5]   0.00-10.04  sec   744 MBytes   621 Mbits/sec                  rece=
iver

iperf Done.
root@bpi-r2:~# iperf3 -c 192.168.0.21 -R
Connecting to host 192.168.0.21, port 5201
Reverse mode, remote host 192.168.0.21 is sending
[  5] local 192.168.0.11 port 45834 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   112 MBytes   939 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   939 Mbits/sec
[  5]   2.00-3.00   sec   105 MBytes   881 Mbits/sec
[  5]   3.00-4.00   sec   105 MBytes   883 Mbits/sec
[  5]   4.00-5.00   sec   105 MBytes   883 Mbits/sec
[  5]   5.00-6.00   sec   105 MBytes   884 Mbits/sec
[  5]   6.00-7.00   sec   105 MBytes   884 Mbits/sec
[  5]   7.00-8.00   sec   105 MBytes   883 Mbits/sec
[  5]   8.00-9.00   sec   105 MBytes   878 Mbits/sec
[  5]   9.00-10.00  sec   105 MBytes   880 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.04  sec  1.04 GBytes   893 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.04 GBytes   893 Mbits/sec                  rece=
iver

iperf Done.

without Arincs Patch i got 940Mbit on gmac0, so something seems to affect =
the gmac when port5 is enabled.

I guess here we need mtk for more information, so i extended cc based on g=
et_maintainers-script (except generic maintainers and mainlinglists...can =
be added later if needed)

regards Frank
