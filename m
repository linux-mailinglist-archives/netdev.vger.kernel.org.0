Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA8337AAB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhCKRXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:23:05 -0500
Received: from mout.gmx.net ([212.227.17.20]:58463 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhCKRW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615483363;
        bh=WhOe5KnvPWYxb9Bi+2Zstm68we1vlo0d48PEY9VRvcc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Nctrc0My1en6w1WlaPhxN/PdRY+hWH0UjRrMMsMRN9Qq0TEJ75ZnbmXkzpLfa9S7I
         wBvlf5ZrcmPlPSFqdMsLNoSnrTtLqEr4JrszcZk5OUj74UFAvh0fK4tKEOePeTHwOE
         UlNXt6CQut5hWSRdX10UVG9FKXaPHsOvdNfPsBhE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([37.201.215.134]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MhU9j-1lxqVc2drn-00efjs; Thu, 11
 Mar 2021 18:22:43 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: phy: Improve placement of parenthesis
Date:   Thu, 11 Mar 2021 18:22:34 +0100
Message-Id: <20210311172234.1812323-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4EQBIBSkgsHfHhBnB/oo8npiCpJeENXBEaY9yog56vdX9GPkNse
 joUi2khkrZJ624oS9pq6fQtC617v0BsOmxFNosum+iKqdpp0YJzhhSFlxDq0a8/VI9bmOne
 MxAvOuORIORa0I+9JqNsC1CVDrlTxgBp8dUwGK+fUKjUPU0j4SrQ6Kp9fthzPkTKjGrFs0D
 3l+bN8fWFONl9/ih9T6yw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bVWiX8V1yOI=:YYfPg1iTcw5jsv3X8xGaFM
 MyVH9CEq02F4LyTkPGe3zrNfp4Ju9CJOmMugyhnSG8OGKC8P3VVHDSu2QcXCUgW8D3BaT2iwy
 eSO9Svwy0abg3UuxSQ2Ch+miNfjsX5GT4Rge6x2byjsw6LdDOpJIO88q2hmPqlZLsO0oqfJgo
 WysWJUnjxkvh+msROAHFY5Rjrr2k0aowRLEEGoqQZZtyUwPcS5I7t7vtjiQqQasrxutwSFYhq
 BEBFLAGGA7of2WY5kM3Q/VBtdx15u2ctIQEZaWX2TK9ZX2BPvbD3ERmVG6WgvbdN6sWKutZik
 aTjSeWP0u0wBk+TiEctwik090inFOI0Ip5is6xHNuGB62dy/D8TVO7DQgfXGhu9j7KJ0my+T3
 Vzq51KzgHZHZtHP9fvkn4EnX+BDrfZekJ6xDODfh7D3jZgmfxSl9r0/pPNhaBKGXUcmqiJbOA
 V2SEzVAQEmAQE1dgRJeOlloSf6xx3V2YQDS2n5cdAvCGnmjZpghcEnM0mK7l3nKN4AezV8bGL
 qx35L1rDTjwAC2D/BIjwu/LMAgPzro5mvyDthHlIV76WBWl/5llXeP2vZoJU2vDEmslvD7NPO
 MC2wlvFk5j/LEcrXfnimgYpNgQSI1q6eztA/i6oSVunGAA4F/8KP71q1pc+qOyS3SnP+sP5vJ
 YNyQEooCbEL9PEOni/wd2Y6nFTYBg6+aQYUcDbbzhOBVSFD1Y84qJOI4GKTPkDPgj/n7/iwY0
 GZfnXlErWBuBu+xby38m0ltNEC6GFY54UIiC39Y6cftjpBL+fFotbyXRjFzY4IPBtFZYqU2jE
 tGfw36QtmhRaF221J/zk8NxRkqSwPR4BYvk+0Lbk9/gos5JCaLTmkcvFa+End6LNuDJweGpOC
 91TRYIv1EgCaRxFS29wA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"either" is outside the parentheses, so the matching "or" should be too.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/phy.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/p=
hy.rst
index 06adfc2afcf02..3f05d50ecd6e9 100644
=2D-- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -80,8 +80,8 @@ values of phy_interface_t must be understood from the pe=
rspective of the PHY
 device itself, leading to the following:

 * PHY_INTERFACE_MODE_RGMII: the PHY is not responsible for inserting any
-  internal delay by itself, it assumes that either the Ethernet MAC (if c=
apable
-  or the PCB traces) insert the correct 1.5-2ns delay
+  internal delay by itself, it assumes that either the Ethernet MAC (if c=
apable)
+  or the PCB traces insert the correct 1.5-2ns delay

 * PHY_INTERFACE_MODE_RGMII_TXID: the PHY should insert an internal delay
   for the transmit data lines (TXD[3:0]) processed by the PHY device
=2D-
2.30.1

