Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1F12DA6C
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 17:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLaQ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 11:59:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44600 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbfLaQ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 11:59:10 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1imKrM-0005zP-TX; Tue, 31 Dec 2019 16:59:08 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1imKrM-001Nr7-Fr; Tue, 31 Dec 2019 16:59:08 +0000
Date:   Tue, 31 Dec 2019 16:59:08 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-net-drivers@solarflare.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] sfc: Remove unnecessary dependencies on I2C
Message-ID: <20191231165908.GA329936@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Only the SFC4000 code, now moved to sfc-falcon, needed I2C.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/Kconfig      | 2 --
 drivers/net/ethernet/sfc/net_driver.h | 1 -
 drivers/net/ethernet/sfc/nic.h        | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kc=
onfig
index 5f36774bf4b8..ea5a9220196c 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -21,8 +21,6 @@ config SFC
 	depends on PCI
 	select MDIO
 	select CRC32
-	select I2C
-	select I2C_ALGOBIT
 	imply PTP_1588_CLOCK
 	---help---
 	  This driver supports 10/40-gigabit Ethernet cards based on
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/s=
fc/net_driver.h
index dfd5182d9e47..709172a6995e 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -24,7 +24,6 @@
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/vmalloc.h>
-#include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
 #include <net/busy_poll.h>
 #include <net/xdp.h>
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 1f7c5717de75..bf0bdb22cc64 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -9,7 +9,6 @@
 #define EFX_NIC_H
=20
 #include <linux/net_tstamp.h>
-#include <linux/i2c-algo-bit.h>
 #include "net_driver.h"
 #include "efx.h"
 #include "mcdi.h"

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4LflcACgkQ57/I7JWG
EQmIXBAAuVThM9CtRhXlj3Fv8RE42usm28kXeJQ1CJDPtdK02vIIuMvB4fyN6kCB
Br/GJXa8TkD5agbBiUyDF8Gc/mi8h2LIfcwqG/noR1jDGThYdjJXO/bO2NWyesc1
kfToPoqlIhhzT/DouWQYM6T8LGadh/dSdOGKgF8eOVMuLLFQnpTptZpTNhwYuovP
qsv74ym2DwSVcYIwN2XEmft4ojFDShIqXHcFVL3UKVV9Wo1o5xk7nDml/Zzj716k
qlfFgCR/Z0amkI8meyL1VkiaLSrZAQ15yGSr0EnmiY8gbYisNwJNAL2NniRFl0j3
50AXsvZirnNVBKVE5N/fq+Je/Ohy232bn3FwgrvWeVkq2d54C+Ibq91wQvkAKQW7
SUZao4ca47Ot2F1uh4ZzH4mmt8JTm8lxO0LkneXUWLKhOfueepjy7YTNPr0ZRsR7
kJEwNt+B4q7WQ2k+9VPIG/x9gro8Zs3v0nruSJHAG6igLEP6NwgMrH3ZXc2PczXu
WuuVHMjmut9Ld2oSzd73tMIEIotPiG8lGUcwPIPhVIs9+RfhrsCvHW5aYiefFOof
9E7Udo5tEpTe9uOXPrjITdkfDyS1FV8fExZSlI2YchqrXcnjE6cr0bU+X2TJWJ6B
D6ZSUgqZTsr2efO9Hc2ghoccvQjggw7Ab8VcahhpY6iG0XZyncM=
=WvjP
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
