Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57C425E698
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgIEIqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:46:37 -0400
Received: from mout.gmx.net ([212.227.17.20]:46537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbgIEIqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 04:46:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599295555;
        bh=eix5yRMvEp6sJh7Rs0RgjDhlP2OHRcoVgdliMP0dXoE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SICGyzFZzBt8eAG6IBdOujo+77f0mR9q9triWlN0duEh8aKrsoZeup0fORhW5MwQu
         SXiEFVCl22duHHMfq4M7BByUsSgDNRs+LtVdy+/YnBmu9zD2/h+yGFLylB+ESluLGG
         Gnkt0uiAKOVE4jaBFYwwwGa4O1Nm7VKDve6q1a4U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.76.98.35] ([185.76.98.35]) by web-mail.gmx.net
 (3c-app-gmx-bap15.server.lan [172.19.172.85]) (via HTTP); Sat, 5 Sep 2020
 10:45:54 +0200
MIME-Version: 1.0
Message-ID: <trinity-03089c68-65a5-4572-95c3-c75b9f7e330a-1599295554893@3c-app-gmx-bap15>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        opensource@vdorst.com, dqfext@gmail.com,
        Landen Chao <landen.chao@mediatek.com>
Subject: Aw: [PATCH net-next v3 0/6] net-next: dsa: mt7530: add support for
 MT7531
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 5 Sep 2020 10:45:54 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <cover.1599228079.git.landen.chao@mediatek.com>
References: <cover.1599228079.git.landen.chao@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:MMt5CpznMQ6UwycKDY4nf8k4bJDTcA9TPyAL5cJ4hZazWapBftjA95dt/HPJGwzEahN66
 oWrPR3jwRP8mU4AAiDQnJJLY7m0uC0+fRTItnuV5exivHEEvVPkI2xxo/FVi4T45cgXGW4F40+D9
 1rRqURX+4M7x4G7YJ/LDZfTvw6nNvCiCs0882yDk/J1D9l3iD+Wuu4l8sGGeXeVxlbUPUiaIfnnF
 E3JeEECHuEDd2743H+pyJiSFr0HEbIy1iX1R404LpXTW/uP6LG1QpaKPAaY6ocZGFe/NWJ3KAKK/
 qc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6yCDQ4p7V2Y=:JuebgaHEhNUX3hAMYwU2gF
 d8uHh70z8sfSWNUbe432CyizKB9xZiWabYmF/7zgDcRrt6W+QF5iE4JwyrGtGrNIktpwSdVD8
 xldm8vNQHqW70vvMEnvrB4tnvgQWZAjD8D8eWKp4Bd6dzFuSKd3rwo+j7XaR3NbIDuL6PJK4U
 WnJbg08OJoNb7Ba4UVsZNA44JguMMfc64yapCKLwRHbBfHoVXeEn2HEnZu6ocF1+B82DaDtEV
 nVk8MFBQjNr0DMVjcNKJPu5G6O8wHPObSgbe63jTw2ICc3a/iMQYu0AFsXj/8cixUirvQNgeM
 SwN/BB635DM/s5f081c7Z6kqKmvnUGlnGMidwtRsmjSgNW1G3qqzODg0tQ6NMGTlGxPMZepXb
 LXJnr5EnSUjpZWA/peV305xuJN2x7SpXFoijPMtZVcE0uFMyNpLqargnFHKj0h+b32aESbAia
 wdnmzShB6ZiLkJL1GZSWEV51DBok5ldQD8RxczczSWWL45Sc82XER1cRLX5E1luVHIbil0bK5
 OiYHnYp7g9W8szLqN8azU28h1/hnkzGRB+IGO74zpy6vG6uk8FBaY3C/nfKNAEQEEXMzDkbOZ
 27t+ze5DIuLH7YRY48dVeUfqgpnQ/FlDdtX7lJD/7ZiCESziQmNjQgLKmuLXS9RRh1Nld8LG1
 5rbxDWRUv6crPBqzFWN2PnZ2UgBdz5zX9Iw/q6BWVTc1cJGfkPWrqQ/YoWC8IuPCSF2I=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tested full series on Bananapi-r64 (mt7531) running iperf3-server

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec    0             send=
er
[  5]   0.00-10.01  sec  1.09 GBytes   935 Mbits/sec                  rece=
iver

reverse mode (-R)
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec  1.10 GBytes   941 Mbits/sec    0             send=
er
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec                  rece=
iver

similar to bananapi-r2 (mt7530)

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   938 Mbits/sec    0             send=
er
[  5]   0.00-10.01  sec  1.09 GBytes   936 Mbits/sec                  rece=
iver

reverse-mode:

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec  1.05 GBytes   905 Mbits/sec  14533             se=
nder <<<<<<<<<<<
[  5]   0.00-10.00  sec  1.05 GBytes   905 Mbits/sec                  rece=
iver

on last test i see iperf3 has ~30%cpu load and also ksoftirqd (using debia=
n buster), so i tried opening server on my Laptop and running iperf -c on =
BPI-R2 with similar result

[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.03 GBytes   886 Mbits/sec  13990             se=
nder
[  5]   0.00-10.00  sec  1.03 GBytes   885 Mbits/sec                  rece=
iver

in dmesg of both devices only DSA-Messages (nonfatal error -95 setting MTU=
 on port) because of missing port_change_mtu callback. here i got a patch,=
 but had not yet time to setup environment for testing jumbo-frames too. B=
ut this just as side-note

regards Frank

