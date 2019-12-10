Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B156A118686
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfLJLiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:38:21 -0500
Received: from mout.gmx.net ([212.227.15.15]:39033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfLJLhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 06:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1575977828;
        bh=He5CmkAr29FB4eRkHCWB5ZuYfLynVAdGIaPMEFclt6s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DYqzdHVF3y06fAIXaE34SiDAOXxtMS0iMf4tbr1NeEs2LTBwlLeLZU1UnvRoNYZww
         p5qEgZyz8GYP9B7mBKQoLECKd85cU+Ydm//VbFwzzwZ2BRS/MQacS1jWkp8niWsGj6
         4lzXDmK9bdKNTGVlshtPgFE61gIVkJtAFfVI1JdM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.53.43.95] ([185.53.43.95]) by web-mail.gmx.net
 (3c-app-gmx-bs14.server.lan [172.19.170.66]) (via HTTP); Tue, 10 Dec 2019
 12:37:08 +0100
MIME-Version: 1.0
Message-ID: <trinity-be64e2d4-f70d-4bd8-82aa-fb5b07de0149-1575977828752@3c-app-gmx-bs14>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     "Landen Chao" <landen.chao@mediatek.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        "Landen Chao" <landen.chao@mediatek.com>
Subject: Aw: [PATCH net-next 0/6] net-next: dsa: mt7530: add support for
 MT7531
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 10 Dec 2019 12:37:08 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <cover.1575914275.git.landen.chao@mediatek.com>
References: <cover.1575914275.git.landen.chao@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:4r71h9Id7lIxLvhWGaanz8HzVDn2EN4RDfdcEk93knYE5eLJt3mSN3keYSRt852HP3ezg
 dBD8EAohBV7/z3Y8L50s6x5trisCsEm6WrRDoVWkLUFLmAGr3SvqFvfvqV16qZptKs7OhfEkt1Sz
 CQoqy0ysdmK0EJJq9zNF+DEcPm2gfIXsZtClhWjqR8iEdZtNUbr25JKrrlOLilkTkONwxoDzuLHA
 Y8oGaZngiKm8j8U8UI9maT/CVxDsGfaTyb1PD1kGDS0RghX7ngay1cM+xlKnsfZ7a+1P+WaxaPDs
 84=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y+zfh0Nni9M=:d1BklLbL735ejs8j88j0bC
 mpbX9pJBwfbOSVwp4/Bishz6v3EBsAU68LYy+DejDCXgRBUODaqznRkE6gafuko9FT5rhQ89z
 6CVr7ZfYWtHIJ87rlcCwkxZB3xZnyL4SS7nctqsOS6W4Vs+VfChBOXhta1UvEjIdyzxn3Eww3
 grYrGOhh5F5jdlWrgCKws7kVbFZqXndDhKHLgIbBso0nm3Kd9u2RG88Jx2lNnrPc61Ibe8VUz
 THLjI6IVcGDARMHSJXKicoghxd0NjJaW625vZahyqr+Jhxtx9S7KOCNE6rYbh4arVnY8JvtHD
 Fpuh0OxLyldsAwhIBIGsiYm1ZD0OI2jIKAKuYgQ/1Z6lyJQdgnIM5CstNNgssoBZrlSjW1Y/a
 AxpHrfoB2W8RowBd5H3l1y0VreRKuDNqqtS6Pe/rBrN9PTw6b6ZyLJ4YXoLNQBjw/aE9hmaQm
 bTfXsL83vCcBAhOSlqdT78pJ0iPVjbF8ntMYxUBV+nJxp5Ck1a4CJWRmH+W/eZpqrhuVeGtfV
 ymxyiR+9Gi8t/oRhwoBqXqACKgkw/nZEuF+0WcftL6SQvQc1cRcn9sh2BMiWJPzIMH+Sro6fp
 Gfrm1FMebISZYVCIcGhZmXnqdyfHKtpMhJgoIGqiU0Dy04dck/X/RX4Eb8ZJgT1Ag7aQGApaN
 wjmIBkZAioBxyr5MYv0J7q31pbvBdZuMhNIqGUkaoMEaMpCIRWK7MAo8tV42PhudlRCE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

thank you for the DSA-driver, works so far, but a bit to improve:

i got some retransmitts on RX (TX looks good)...i guess a clk/pll problem

Iperf3-Client (BPI-R64,192.168.0.19):

root@bpi-r64:~# iperf3 -c 192.168.0.21
Connecting to host 192.168.0.21, port 5201
[  5] local 192.168.0.19 port 56412 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   957 Mbits/sec    0   1003 KBytes
[  5]   1.00-2.00   sec   113 MBytes   944 Mbits/sec    0   1.08 MBytes
[  5]   2.00-3.00   sec   112 MBytes   941 Mbits/sec    0   1.08 MBytes
[  5]   3.00-4.00   sec   112 MBytes   941 Mbits/sec    0   1.08 MBytes
[  5]   4.00-5.00   sec   112 MBytes   942 Mbits/sec    0   1.08 MBytes
[  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec    0   1.21 MBytes
[  5]   6.00-7.00   sec   112 MBytes   944 Mbits/sec    0   1.27 MBytes
[  5]   7.00-8.00   sec   112 MBytes   943 Mbits/sec    0   1.27 MBytes
[  5]   8.00-9.00   sec   111 MBytes   934 Mbits/sec    0   1.27 MBytes
[  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    0   1.27 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   943 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.10 GBytes   941 Mbits/sec                  receiver

iperf Done.

root@bpi-r64:~# iperf3 -c 192.168.0.21 -R
Connecting to host 192.168.0.21, port 5201
Reverse mode, remote host 192.168.0.21 is sending
[  5] local 192.168.0.19 port 56420 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   112 MBytes   941 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   941 Mbits/sec
[  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec
[  5]   3.00-4.00   sec   112 MBytes   941 Mbits/sec
[  5]   4.00-5.00   sec   112 MBytes   937 Mbits/sec
[  5]   5.00-6.00   sec   112 MBytes   941 Mbits/sec
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec
[  5]   7.00-8.00   sec   112 MBytes   939 Mbits/sec
[  5]   8.00-9.00   sec   112 MBytes   936 Mbits/sec
[  5]   9.00-10.00  sec   112 MBytes   941 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec  605             sender
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec                  receiver

iperf Done.

Iperf3-Server (my Laptop,192.168.0.21, reverse mode only):

Accepted connection from 192.168.0.19, port 56418
[  5] local 192.168.0.21 port 5201 connected to 192.168.0.19 port 56420
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  5]   0.00-1.00   sec   115 MBytes   965 Mbits/sec    0    772 KBytes
[  5]   1.00-2.00   sec   112 MBytes   944 Mbits/sec    0    772 KBytes
[  5]   2.00-3.00   sec   111 MBytes   933 Mbits/sec  157    643 KBytes
[  5]   3.00-4.00   sec   112 MBytes   944 Mbits/sec    0    755 KBytes
[  5]   4.00-5.00   sec   111 MBytes   933 Mbits/sec  141    625 KBytes
[  5]   5.00-6.00   sec   112 MBytes   944 Mbits/sec    0    740 KBytes
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec  307    438 KBytes
[  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    585 KBytes
[  5]   8.00-9.00   sec   112 MBytes   944 Mbits/sec    0    700 KBytes
[  5]   9.00-10.00  sec   112 MBytes   944 Mbits/sec    0    803 KBytes
[  5]  10.00-10.00  sec  0.00 Bytes  0.00 bits/sec    0    803 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec  605             sender
[  5]   0.00-10.00  sec  0.00 Bytes  0.00 bits/sec                  receiver

regards Frank

[1] https://github.com/frank-w/BPI-R2-4.14/tree/5.5-r64-netnext
