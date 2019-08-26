Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5639F9CC89
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfHZJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 05:25:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:59153 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbfHZJZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 05:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566811473;
        bh=WPm8X1ChJ0p/RZOC+rkk0PdvK8NnGje9cQ3dIxTdJIc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SxbLIwR5cB4Cnp/Peqdd1D7ppiU0h1VWCMGDT9kWiwjFScV4QyPLPxaCuJuMYcVi0
         VlXstiUA0+OSvDhWir8vlpyGrv1nCrxqWad0eJv6Z1GTH/jMEhXssX+tTqelJRJE6L
         A0JoPWsokLnp8fXbo0Qd9mK54ZxXTx/4/2eQiNXg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.75.74.250] ([185.75.74.250]) by web-mail.gmx.net
 (3c-app-gmx-bs57.server.lan [172.19.170.141]) (via HTTP); Mon, 26 Aug 2019
 11:24:32 +0200
MIME-Version: 1.0
Message-ID: <trinity-6b3ee2ed-957b-405d-83db-84d7bccf2fb9-1566811472863@3c-app-gmx-bs57>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>
Cc:     "John Crispin" <john@phrozen.org>,
        "Sean Wang" <sean.wang@mediatek.com>,
        "Nelson Chang" <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        "Russell King" <linux@armlinux.org.uk>,
        "Stefan Roese" <sr@denx.de>,
        =?UTF-8?Q?=22Ren=C3=A9_van_Dorst=22?= <opensource@vdorst.com>
Subject: Aw: [PATCH net-next v4 0/3] net: ethernet: mediatek: convert to
 PHYLINK
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 26 Aug 2019 11:24:32 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20190825174341.20750-1-opensource@vdorst.com>
References: <20190825174341.20750-1-opensource@vdorst.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:86Ct19xn0B1fqyZ7orUtEMSW3w64xKQU3Hnx+X8RdbwRpEVO6B/9KE3Ek2J6+1swlTVPe
 deEKC8gY2MDrQuaj8ONAP9FIivSj+XSiawtQfyu1Tu3r5octtCP3D9DoNA2gB03XdyKlRmc1kILu
 ETDmLKNl5GPmGlvhnD5kRF31vJK+A7aC2MBPV0n32YJlJyQvnf8AojevyQVJfjzGjChHIYGgf6vJ
 Twx8seQGwwANm/LHCQBeM/D/cTElxvT1wR6GwObYgFUtNhc1yCzNlD8DslfpMLeMtvY6EIytfHw8
 Jw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:T3D1PvKgRWo=:EoSCKcOlaQEGzHM2Ytsthg
 4f0qLEOIGzMqI8bjUfKMtYNWpHR+B3i8eqICHnexdvv/kCsX/cs43Dr2V9DYKgcCNcPChH5yi
 siGW/VLviBu1u+f875CxHS9Hm9E07v2NPV4GQOMMdJ4kCL7wMc45Ei9dtduQx7hEkke+yXiat
 B77YwJ7qTmLIAmQdO+fJByWIQ2moUU/cXMm0R7S1e/JSmwkssbzZCpUiNwvGQOoEJxDNj1zgQ
 NmTpk57NZ8GuLhtY+Qs00XUfjl42fXIWrrlhw3i99MsjM+k8GN2DYVol1X1awtSly/bJf0+e4
 trlfZbXvJdzHKfNBsQ2GHvhhgXRHYrSQN8/eGMgQ1XIJos+mzkSNTeGIPhiLtsyWWtqOvHDo2
 frlaK3AKk4C8BU5j2luIutrkvVqwEBroDOo35htrrqBi8E4KsrUGTUfu+vZSOoXekOlSmHuLt
 ik1RASajtTlqWDzoO6mreg7HAIj2HUOIGTwOI1rJqx1eA6Abanm4Oy285H3Rq/+O3yJWbwFPu
 aZbxyADTQRJZ9izUAzTTWYw9pq7jNEenjhWe3gkvc2X0xLREGAjI0YtNlO+3VxzB5HdQa7t/1
 NUqGmJ2GU5e59HhAloupT/ZG3tP18WpDlz3jfJPpe7KD3GTcZv3RVkkrJwQPiCHhtdz83Gr88
 FJ8Y+n99kx6CzYVtnqsNXaa55KyapZoYzMFtkZ365rk3JGA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on Bananapi-R2 (mt7623+mt7530) and Bananapi-R64 v0.1 (mt7622+rtl8367)

Tested-by: Frank Wunderlich <frank-w@public-files.de>

regards Frank

