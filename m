Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895CE25F5A7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgIGIui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:50:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:44261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbgIGIuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 04:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599468599;
        bh=yIFXqy7te6Dvn3pYvMyPkuWrR4YLQ/+MWx//ZLlZYaY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bRo8iPrwMHC0DJe/haJ3kaxpNWARu+Ri/j9suBTgbTZ0RHtJjXSwlVqCmePSq/iZX
         ekUsSWyyf/38cfwUQqjR1VpJvU5yP5xyQlRtIEk6N74ctL2ARkQydFwimyEepkM3vL
         NdLKIXyAMkjvyLKQSsnShIFu4ySqg7A3QDr4f/9A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.76.97.104] ([185.76.97.104]) by web-mail.gmx.net
 (3c-app-gmx-bs77.server.lan [172.19.170.225]) (via HTTP); Mon, 7 Sep 2020
 10:49:59 +0200
MIME-Version: 1.0
Message-ID: <trinity-b698e161-35b7-44f9-bcec-836d9e5d0fb4-1599468599322@3c-app-gmx-bs77>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, dqfext@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, opensource@vdorst.com,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Aw: [PATCH net-next v3 0/6] net-next: dsa: mt7530: add support for
 MT7531
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 7 Sep 2020 10:49:59 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <trinity-03089c68-65a5-4572-95c3-c75b9f7e330a-1599295554893@3c-app-gmx-bap15>
References: <cover.1599228079.git.landen.chao@mediatek.com>
 <trinity-03089c68-65a5-4572-95c3-c75b9f7e330a-1599295554893@3c-app-gmx-bap15>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:5M30BJ8gJxoqt26/8TkrNWB7b+NM0kRlZhPhhBoI5O2cy17TFMaA3mzeqE2Si0IMOtAEq
 Yz28gdLhQIT/CnxJADDM7S3yER2A3ls5lzRhGXPDMMPUB4kwiXD7YqdE71sMTNHrvCtsCH4pKzse
 gc4k9Z6AFc2NuKA8yAN0jUeoZOINsxiEm2H6OtwllW2QNYVcLa7nmyfM00yYUU1lnH0qDj5VkPRi
 H3o0M+b+uHBZXEGActBnRvDg6GCh9zhj6JQaP1xD3yjQ5oI1CQ/714bUH8j9cNau9TO+Y4ErKuqF
 z8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mtESfRCsrx0=:U0gdxCOgB6lC8cs3snZAic
 uQrccbrevnkwZ/3MHYlHZiZZJhEcnzvP5Wm0RORcEs11npiY3NPS17Qed7VydsvDCLFvdvHG7
 6f1JEpkf7LM7P/bup6s1kEkb0tfm7jZM47NGrT6dWzPx4TN5cOQuQa/39iqXJVSpXscrq3tVS
 s20dYnyFWAE7d1F3UvgOT8XLl2WPmgOlYByKdaCcKwzTPg8bnO/QPvc0ydvQI1OHBd5XLLb3a
 Z55Fll+AbBq+4dnaIg6CO0sMNzkbGePwt1Ab85UMj/U9Sh24esFF6I8Nv2qMc1JNgUofRD0TI
 JJpODQma6JDKRKs9WRdYvw273DC9cw3VkzyaP3kWnbC/MgmYqAYIrn77r5docseWZMhHJK6tS
 68uaWlNTfRZtJ+6rVgrkBNmwxX/hZC1SQDGGEGNHVoKQmvvqnCysz4VIunkLVJMeMEuahUL9f
 nCGCUICkn7QHvFFY7smcp37LvrS5blNi4Vnv9OnN6z+mFjR7hkfAmz9CLIHdZwSg/WRjDRmBH
 5fpuhk7zomTx5e6zLoqjEziRflvCxv4wjpP5N0fpGp+ngGXV+P+YBEjyPmmOYgygF6Q2IHxhf
 rqTeIHK0MQuS7BUX+bGDXPM/0YGsnUBmwygI10uWAaN/tmXtIClAxa1G/4SAwAwOuoyFff3Xo
 egW/qOXvRKuLR2HwzMSbQt7jFPqCBaJ1/TfNUp/k2r/hToD56B9etzJhDWVT+FideUKQ=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Samstag, 05. September 2020 um 10:45 Uhr
> Von: "Frank Wunderlich" <frank-w@public-files.de>
> similar to bananapi-r2 (mt7530)
...
> reverse-mode:
>
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.01  sec  1.05 GBytes   905 Mbits/sec  14533             =
sender <<<<<<<<<<<
> [  5]   0.00-10.00  sec  1.05 GBytes   905 Mbits/sec                  re=
ceiver

these retransmitts are caused by missing pause-statement in devicetree of =
bananapi-r2. I got them with mainline driver too.

After fixing it [1], i got the expected results with these mt7531-Patches:

iperf3-client on r2

normal mode:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   943 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.10 GBytes   941 Mbits/sec                  rece=
iver

reverse mode:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.09 GBytes   937 Mbits/sec                  rece=
iver

Tested-By: Frank Wunderlich <frank-w@public-files.de>

[1] https://patchwork.kernel.org/patch/11760003/

regards Frank
