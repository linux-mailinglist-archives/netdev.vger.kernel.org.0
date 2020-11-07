Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A182AA831
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 23:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgKGWIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 17:08:55 -0500
Received: from mout.gmx.net ([212.227.15.18]:36849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbgKGWIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 17:08:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604786917;
        bh=TF4vJpy3So/YNKjCJQx0HVgrhoU+b2fBxFR5XNF+vyc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=C5jBAo17rMhVHNZy0Eck+dL2tCXphHu7RLiEkOR4ybP7ULkwu93YRvFL3dHdKzpSq
         1OQHszdhzmEaNFHVXyDSeBhZ4EJ1ztGdVNzpPt7bfMv4qmsZsq7aSEYquLO8Tpbqmw
         P9x/GA2mn3KlRsYTB9U3XfqO5GgLhudWrmP61/qI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([37.201.214.162]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M5fMe-1khXjj13Gs-007EeJ; Sat, 07
 Nov 2020 23:08:37 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: phy: s/2.5 times faster/2.5 times as fast/
Date:   Sat,  7 Nov 2020 23:08:21 +0100
Message-Id: <20201107220822.1291215-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O2nYx4PYNoWB2eYP3TXqgGVNd9IQqrzgS+yNNzOXFoTrpnBIF8p
 9Jz0UMgFSvFfKE2/HUANUfCBPRaIp9NxmUp5NBxfigsZY+ZEMwMqd5p+BFIrAIkc3mmoIdp
 90d+H+0rQiSQXBQ2rYtvEhMkMi/1SVmvaOl8MMDaMZ7vG+szDktMlXy6suHtaJGGFxGASuL
 SxbaaQQGkHtfOsGEtEJAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6N297bKMakU=:XuRQzdLUzawn5G9RMlrdeo
 3/PWnZciNBquLZ5xA6kvG0PdYqpW1W0S03SxnFmkmHjnd6yUIFj9kTa5Mp27kDY3lFHirsF1c
 9BDbAnG0mN217jXO6k6qGDVc2JHPYHT3TwDP+Gyceyv1pLTp0zXDgvEMtNh0J60SR/Z0y1a7l
 3Xy8410clETavfxIaDZk7gniUl/7mTaB73mQfUdN1LT+LRRwlsPTxrKcpdciZ4tirlldPn9Zq
 aWUqarsCXUs+w9oAkv9EMrgmtVzsou39+HmvLZS4AvkdMLwYgGlGK2P7uINt2CZyr4S4hd1BZ
 NP/qgHamOmE9CpMXnhzRxZccHR/5QAbzKBOfP6WEtl8fVirIldwM6sq6k8SNmHeHWMxJ9qyvH
 A/5/kACwWc8i4xMm3y+6bJM5PTZSCEWZlsV76wT8M9hKBB2QDM4Q3vLftBhLHTRsTbrzF0YUD
 wM/su20nLisVgNXbC5n/NdLi/hUl9htii1uta36Ntu7DMjA+l7BF+EJ45eOU8OR5qlMjVv4kM
 GvqLRXYuiTZ29o1xVbsx9YPEEH8HNvsm6Clp3imQOYRpFm44Oe2vLs66vCdsOLGfFTad3abCl
 vMumxtfxi4/ZXCI6DLcIDicM/lzcQRjxNXsSmgHv1sVoNnrlbLrop99Od8y/uzp8/Z8CUnhwe
 v/WLT3FZEtEGrGKqY6EE8KCHcJ3d874jxtiMDkZRdPRx7QFHxu2A3LenPmyGM/YNM8s2JBOnf
 MPy/GZeHOsivP9xyVj+iqbHr6/oujLHlsrxIC7YTat7ZxyeJfj57aRD41ksol/aWrQQ/w0wji
 NRwOxli4sBpxuJQXOA9xe37wXSWtiTD0Oico+fbdHEBEvU44aD6o42YHa/SmMwZPGa2+abrK9
 FkZGPVFRaMG4yPClrHsvehb7yGiyCVDGnG7GDM5ro=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2.5 times faster would be 3.5 Gbps (4.375 Gbaud after 8b/10b encoding).

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/phy.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/p=
hy.rst
index 256106054c8cb..b2f7ec794bc8b 100644
=2D-- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -247,8 +247,8 @@ Some of the interface modes are described below:
     speeds (see below.)

 ``PHY_INTERFACE_MODE_2500BASEX``
-    This defines a variant of 1000BASE-X which is clocked 2.5 times faste=
r,
-    than the 802.3 standard giving a fixed bit rate of 3.125Gbaud.
+    This defines a variant of 1000BASE-X which is clocked 2.5 times as fa=
st
+    as the 802.3 standard, giving a fixed bit rate of 3.125Gbaud.

 ``PHY_INTERFACE_MODE_SGMII``
     This is used for Cisco SGMII, which is a modification of 1000BASE-X
=2D-
2.28.0

