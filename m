Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472B927B86B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgI1Xp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:45:29 -0400
Received: from mout.gmx.net ([212.227.17.22]:37909 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgI1Xp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601336727;
        bh=w55UlXI07kH9hha6PWBzjBrxrl0lM5ywHgCvZ6J4m1s=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=a8T2c2yhbO1gSeDSwCFEhexqxpuynbLtnBKi26UpQtfxY8Xe51Jr8O87WSKKR8Lcu
         ESE6zBiPbR9ELAq4PAxdyoxC+PAUWJHouJWkhWfytTkXhtv1R9qYMxzZmgMBLT36u1
         GwHesF43GIz1iiTwn+hYgnf4+xRaxPZuSZFRnBEw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1Mlw7f-1knJbC48VX-00j3f7; Tue, 29 Sep 2020 00:01:10 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net 3/4] via-rhine: New device driver maintainer
Date:   Mon, 28 Sep 2020 15:00:40 -0700
Message-Id: <20200928220041.6654-4-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928220041.6654-1-kevinbrace@gmx.com>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:z7rqrHIxsndfJcI7Auymk5QQjVYek2+cGoh2HF4qqu9aofYD05j
 4M8hP7YtkvK02aU4e0h6cj/HVSLRAOBMAqLFSXuyrHUFZdQghQzoiMJjuqPDxTVGcDmWgk/
 QUPLSBDLORpzuUG5f0J1UVmn8NCDOJmNs32ROItTWUTuQMiXGWdaTIkZByCnSNT6lCyExme
 UsOKtHvTYINzmTBeUaSlQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Pp2UT3mLEJ8=:ljKanotRK776qeXvE+i+Of
 ft5JlNYaAhX0LHrLy2clcR9Lb6xkCZXivRUALW6D/uDKlHOa02YCd6m5YE0oITaLmrAjpuWOF
 e/ARClmrcStIyJXDFlSy3t//7aZ+pvxE5X9XJTg5YaFsY9eMdZ0rl+nVUnDR/lK9KSCIrrDFK
 u0dUVjPdXReqQRAwNuXr1CwS443ce8ZmiH9fFSAx5yQRuaIsep7462YcQBXXhmvPdam6xgPkJ
 eDtmWXWAxR3WsMbMSFGFKlSM+C0fELwyDSxC/DvYU2LtaRYqm6oSUEBKS4QjtuA25ShdzI5iP
 ehIn5Ft8in+OwuBZ0a/GNRY3aUuJm96AXP0YqZjXd4eWuEEqyd+xbkAZACZr72x6cMX9UXWO4
 RYgvNhiDMnTvXwqqbHpzBdT8T9aNIrYxPMWGQSAx02QpoJcFj3ar0PhO1utQA0PDaRvjNNE93
 NOrzkcOpuTEp78u3nPmE+AX7EjYfoxWYhrOEc/K4pPYJH0qc7pvm8i0t25XVkoT7F/aNRVO/j
 2JpPcAC3yI1R5vf5MbodDhzyUpWU8BR6NQcXLZm9FB4IRXnp9iH1qyR8akUCmnomInjqaePdk
 wNSovBaRSb6h6EFIgUSvmzT4t4WPDrXBE3ZsTne18/lgr54SuyEmHc4lQ/2f5AEpaq8meeN8a
 FXKS0lBmxqWY13iTf7An9j/b+sy6IaOWCcA1A29jj8/mcpe/aNmtXk93MF2FFz4XM6Lf7cGiY
 SKc8lz9Vc+ezuKTTGhhbdEaiuk3eSvEKCfGUKiF32BKLZznJkJYptJqYfeCcp4sE9FURRXTld
 b57JfLkPda2CRfcm/mMGEa5kELy2/Zc6nShJOSTQRyDiihNHe22VYvnvfq5UXN/20erGA2jYb
 N267hQcTZo3k8ZvWI4FZJBkKrxWggi4eLObbT3/uGf0c9ZS/516omgCuQVj43tdm1DqCaQAQs
 djBjNUWdtqUX67W/nDjX8aoPJn3O8EEe/J/1QDDBmR01VPkSFj5yXXxraMJ2V4maPF3v6VGeJ
 1VElKp5lOunCCohkfYR8pAfsFvkCwB8wHqAPuMKZ2YRBHQ6GNmAjxBk5VHQud4UkkM8td4Ad9
 isdw2sI+9M1YNjIf80PSFUEa42dFMrSIYrNuoUnVGcvfwOE27yy30OB9JonHEf0xJCZLgHToR
 jpjRq2CqiOULrVB5656cRsML1qAGATkJnAn8oh7eTRylOsgQhrY9NnqXX3Gm3DC2tjQoJk7uC
 xZ0UrPdWhsYWYPYEYpQn6kGv8eidaCQ+WgBtnNg==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 MAINTAINERS                          | 3 ++-
 drivers/net/ethernet/via/via-rhine.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 153f7b3419c8..3e5ae3185847 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18058,7 +18058,8 @@ F:	drivers/gpu/vga/vga_switcheroo.c
 F:	include/linux/vga_switcheroo.h

 VIA RHINE NETWORK DRIVER
-S:	Orphan
+S:	Maintained
+M:	Kevin Brace <kevinbrace@bracecomputerlab.com>
 F:	drivers/net/ethernet/via/via-rhine.c

 VIA SD/MMC CARD CONTROLLER DRIVER
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index d3a2be2e75d0..f2ac55172b09 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -2,7 +2,7 @@
 /*
 	Written 1998-2001 by Donald Becker.

-	Current Maintainer: Roger Luethi <rl@hellgate.ch>
+	Current Maintainer: Kevin Brace <kevinbrace@bracecomputerlab.com>

 	This software may be used and distributed according to the terms of
 	the GNU General Public License (GPL), incorporated herein by reference.
=2D-
2.17.1

