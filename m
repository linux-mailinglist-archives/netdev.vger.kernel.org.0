Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2AD6A233D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBXUpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBXUpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:45:06 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6453C1ACDE
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 12:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677271484; i=frank-w@public-files.de;
        bh=wthtJOdfw4t4NZ0k9LubCewah4ayljQ11lJdfs0xjOg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=iZVJe3To7EDkqyvVICrVRTkOWOCU2wj3QM3IQz9XfnlStkjoSHWQPNNAlEM0PsL3G
         0ErtMNy9BSjDUP25gwt5MHtyLtmxSn9dnXz+xL1BWIFfdnTTJejsSngAyXJyquMdKO
         6FkAOMRqIrgBSbs6ZvyUospWezC6lK220GNuRZyfva6G5mKZBfPDOWLlzkYrsGOJ8A
         UE9dw1dj5o9nsquDOJWlqKs8C0HK8yshrlhGP/yDO+FoQN+bSbmYLLIqdU0Mpi0thg
         tNqS55BQNP4Tudh70+98S/lqgE8e/52jEHnXlEqEKiUYq9Llws3cOS7kJhTYuhGAvD
         66wkWIyX6J5GQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.225.28] ([157.180.225.28]) by web-mail.gmx.net
 (3c-app-gmx-bap70.server.lan [172.19.172.170]) (via HTTP); Fri, 24 Feb 2023
 21:44:43 +0100
MIME-Version: 1.0
Message-ID: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
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
Date:   Fri, 24 Feb 2023 21:44:43 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:lNVzpFqSgMDgoZetW5tn2dqATD7vt7rGvouCnjDTuahDGoWixIwQsf9SP3PyPz99NKJUe
 I+dCeK2XgwH73JvJzqAPIRNbRWM/+GX1nfpgOVLIzTExbvYAPwtfzy4s2qmcHsGXbE9ENV1VzMSm
 6SmQiWf9ftfhDTSzuot77x8A0pSqB1SWD2UbCyDjGS2YA0HJnMtMSZpYtskwUgRCN6pFm1Alv9SA
 fAk7sOIMyD77gmatGreBdJGr1B1dWvE8CKEHwTho9ERegpjyMF8ZCuYA91T3Ds08CecPXCUrxSxK
 t0=
UI-OutboundReport: notjunk:1;M01:P0:pughvl/ippE=;Phz2FCH61NJ/JdDqDdISEnuH6WX
 nTVEn32BEaRyvziLX53LpNvX99NrVP1x0ERsQPsdrH5l3/jNiGriA7O7aX96Nq8mGPU3yehwU
 125A/lLsC/C1edHAFThGvAai9m1e911AM5+OSWCTuywlLNWRi1daurspsNaxvZ5qCVYoXKYaz
 WGa4ixIkEXrIw1QnTc76Pni+E60uJO8Y+k6NdqcU9rwTEDHU8KtN1R2xiPSqPX+uxLIalUWJe
 Ym3GKk7pqOjE6IrItiIVrrBRh1g9fs4sf8BbdR+f5N5GKaHQ4TmT9nDwWEWJo7Ng2v+NrAE6A
 NavRs19dmMRxBJgCa/rTx4yjQ5FlDXN5vErq4qvq7NiYesI/76irlp1irSrSRbE/87UzXAol+
 LUgzBzZmmA7G8Z2/XBGibo1e34ILSDnnM+4XipL5I9ZHFz+XJlr6f5tEamiehk7+iacukru13
 m86OhlH0tIPCzlszhfyB+t5x4WyNT+1t6eajlCHJ4D9M57ZnsVyuu+DNqzhAlgKPwNx+sxcKd
 a5UlvHxBQSCMMA5MfVFIfxIG1cPaCbER/vbzKEsLkBMMTvsifL2GvhsLYcVsbXQzJLXfIk0d9
 eMtu9aqSQNtGh7uT4+uPTr3xdBpNmH22SyQCJT9rZWkaF9sMIGaEe92SB641M85sv2Fpv/4Up
 DU+nQOlQ12LPd0LEUPvXfmtDP28zWJ1Jb3yypA/8s4W7GwDE8aBugcKncMe6LW5p8crGPiaEG
 4wW2W3PtWXArUq5aqcvrluNRGETlwgGRFSYKNawxck0JAykB/2V7G4Rwi9/ynXE7Jf4+wxbiQ
 /Oqf8L2URjx8ZNgaJIGgbTz8sZIItNJDqSxtBlKRW+NkM=
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



> mhm...tried again with port5 disabled (pause enabled again) and got same=
 result, so this seems not to be the cause > as i thought (but have now ot=
her patches in like core-clock dropped and RX fix).

6.1.12 is clean and i get 940 Mbit/s over gmac0/port6

root@bpi-r2:~# iperf3 -c 192.168.0.21
Connecting to host 192.168.0.21, port 5201
[  5] local 192.168.0.11 port 44876 connected to 192.168.0.21 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   950 Mbits/sec    0    464 KBytes
[  5]   1.00-2.00   sec   112 MBytes   939 Mbits/sec    0    485 KBytes
[  5]   2.00-3.00   sec   112 MBytes   940 Mbits/sec    0    485 KBytes
[  5]   3.00-4.00   sec   112 MBytes   938 Mbits/sec    0    485 KBytes
[  5]   4.00-5.00   sec   112 MBytes   937 Mbits/sec    0    485 KBytes
[  5]   5.00-6.00   sec   112 MBytes   941 Mbits/sec    0    485 KBytes
[  5]   6.00-7.00   sec   112 MBytes   940 Mbits/sec    0    485 KBytes
[  5]   7.00-8.00   sec   112 MBytes   937 Mbits/sec    0    485 KBytes
[  5]   8.00-9.00   sec   112 MBytes   942 Mbits/sec    0    485 KBytes
[  5]   9.00-10.00  sec   112 MBytes   936 Mbits/sec    0    485 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec    0             send=
er
[  5]   0.00-10.05  sec  1.09 GBytes   935 Mbits/sec                  rece=
iver

6.2.0 is not...so something else in 6.2 has caused the speed drop

regards Frank

