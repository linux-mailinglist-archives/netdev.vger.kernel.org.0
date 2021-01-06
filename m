Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC92EBC3E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbhAFKTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:19:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:43005 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAFKTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 05:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1609928292;
        bh=tdZ65+PGR1ZV2YBCiZpcKQLMScIe1719cL23lykHDqI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=bY0S9DK9lQrgczUCvVptKeIo/Hu5nDExxEZ2+uiSF+/eAgboovH1PhZpM3CrfOnXB
         i5yTJFPnDye7IR3DBRqhbV2EAl1itkxTyIMKqXqIS5DBh/+RJbl51G46NPWP0YQLCu
         ZUyKqW61jLnEVnXEdxGbSfwuFQEgrrn3VU8pZdo0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from E480.localdomain ([84.61.118.33]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAfUe-1kqWJI1wDY-00B2l0; Wed, 06
 Jan 2021 11:18:12 +0100
From:   Zhi Han <z.han@gmx.net>
To:     netdev@vger.kernel.org
Cc:     Zhi Han <z.han@gmx.net>
Subject: [PATCH] Incorrect filename in drivers/net/phy/Makefile
Date:   Wed,  6 Jan 2021 11:17:12 +0100
Message-Id: <20210106101712.6360-1-z.han@gmx.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IZaOTCKuufLMwpsUS344iMorkehbeUnR/eTe/3euWNnmXVnW8Iy
 P/RuHuuV97RTkoak715q43oVguJcy8eZUBxfHDbORN7gfiwesH4Ld+fVDk5Akqpo1BjDn3y
 dFx/gUmP2ZidiZRZ3GE9rj7551d/eZ0QxsIsnHCuhJNnuT/YDPVDiaKN1rElWtC+UBuN7oQ
 FIY9X4/QWBD4aPBl7X3Jw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iSrCivwrKF0=:mLuqx9P6RGi25mqlJfjOvW
 d2qMcPHRMvpYyOZU0NQqdxV2sS+lf/x8EO83hUjFY06OAVESh2PcIl4XojExRog0uEjrKcbd9
 bpZDVxmJuBbjMXh9Z9svsvSynRJbycQFabtF1XV7513Hq5AOs3JqKfKwr/WL9+T5+oWnBzg6p
 /2GnkmqYMrR85UIWIpOs+GMfhb6SkaVA4kzSBkfOwJS1zxdVAUsdKNsgU8NGBOlgShcfp7Zn8
 sPnoIzIHeiExmbnQjzvQbvl8vdxD+1cy2kbsyx4oQUHAN8cUHWe+/jgUAt3xx2wy+qdzD1FW1
 5wLtVugFtlk+FkPoDpTQx9q5yUjQfCo+n/y9DUgPKQNQf3iLi/w4/YyRsoXhB+aNfWeort4Ye
 /+UtXMj0udaEieMOxZqos0lWNV2CSPiGK9G2ClZNbB4UV7l8xCq/IQunblJwlC/SqWz8fjAQ8
 c1CScVQsL1jDkHngN97HKGjoP+FBTiOtmTwESfnph8Cl77W23pGfkEkVrL9Pv8p7JsR53qr8N
 htV2OXLviU6d84J8d44pV9SgGx5dwbZBgtyQUChgLMJYPsO0wZuTipM27iMSUgjvYpAdCnyNE
 yz4vmLy0t5t1IscawqcoCljtujBhY/6Bn5FcRYaIZZwIjxphLyILNg+i5fk2WQBLsjfUtrrGl
 mnwBGBk7La8yKTqdQ0uPFcyOQPNxNXytPsSF0VRXg9Ay/Mi7tu1F0GZwKVDQHdDsvHDerUt1s
 nZcm82LJMNtjV//sxfqC02/SMWKQXoDNq/t/eRsZ5UFgX+ym7vRl/tUQ2xw9y7Tr9pBajsN5G
 Zvw2qFe3OzYQKAaMS53N8T0TqpCZYlTUV75zjckdQ7/f10zgFS409TvyIFOUne+NmGZPvRXHY
 /ejBbfSwr+aqmXxe1Idg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be a typing error ('-' instead of '_'), as no mdio-bus.c but
just mdio_bus.c exists.

Just find it when inspecting these code. Tried to compile to test, but
failed to construct an applicable .config file for that. Maybe someone
can do that more skillfully, glad to know how.

Signed-off-by: Zhi Han <z.han@gmx.net>
=2D--
 drivers/net/phy/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..0840e9055b5a 100644
=2D-- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -15,7 +15,7 @@ endif
 ifdef CONFIG_PHYLIB
 libphy-y			+=3D $(mdio-bus-y)
 else
-obj-$(CONFIG_MDIO_DEVICE)	+=3D mdio-bus.o
+obj-$(CONFIG_MDIO_DEVICE)	+=3D mdio_bus.o
 endif
 obj-$(CONFIG_MDIO_DEVRES)	+=3D mdio_devres.o
 libphy-$(CONFIG_SWPHY)		+=3D swphy.o
=2D-
2.25.1

