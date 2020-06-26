Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8D20B700
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgFZR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgFZR2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:28:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1025520DD4;
        Fri, 26 Jun 2020 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593192479;
        bh=AX/owPVLvRHcSHIs3G/74j/4V1Y6I2WK4+N71qd755U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFgLh/hfn4y//bZhvpgMX7NVT0T7OSOe1zzNyjc+S7UjuJ3h9peXQ76LoohTr1iwf
         wQ71qhOTC2T42blnvdixKgLWEgHDlzck3mPNoVQcPwVR6+/YekmUyzt3Rj+2pk2oj1
         7PDkFzQz+0xzSyED3wvcVWscsUtxzkTFRtXrlQEE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        t.sailer@alumni.ethz.ch
Subject: [PATCH net-next 3/8] docs: networking: move baycom to the hw driver section
Date:   Fri, 26 Jun 2020 10:27:26 -0700
Message-Id: <20200626172731.280133-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626172731.280133-1-kuba@kernel.org>
References: <20200626172731.280133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move baycom to hamradio.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: t.sailer@alumni.ethz.ch
---
 .../networking/{ => device_drivers/hamradio}/baycom.rst   | 0
 .../networking/device_drivers/hamradio/index.rst          | 1 +
 Documentation/networking/index.rst                        | 1 -
 drivers/net/hamradio/Kconfig                              | 8 ++++----
 4 files changed, 5 insertions(+), 5 deletions(-)
 rename Documentation/networking/{ => device_drivers/hamradio}/baycom.rst (100%)

diff --git a/Documentation/networking/baycom.rst b/Documentation/networking/device_drivers/hamradio/baycom.rst
similarity index 100%
rename from Documentation/networking/baycom.rst
rename to Documentation/networking/device_drivers/hamradio/baycom.rst
diff --git a/Documentation/networking/device_drivers/hamradio/index.rst b/Documentation/networking/device_drivers/hamradio/index.rst
index df03a5acbfa7..7e731732057b 100644
--- a/Documentation/networking/device_drivers/hamradio/index.rst
+++ b/Documentation/networking/device_drivers/hamradio/index.rst
@@ -8,6 +8,7 @@ Amateur Radio Device Drivers
 .. toctree::
    :maxdepth: 2
 
+   baycom
    z8530drv
 
 .. only::  subproject and html
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 718e04e3f7ed..76831e9d7c9a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -43,7 +43,6 @@ Linux Networking Documentation
    arcnet
    atm
    ax25
-   baycom
    bonding
    cdc_mbim
    cops
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index cde8b48e7bc7..f4843f9672c1 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -129,7 +129,7 @@ config BAYCOM_SER_FDX
 	  your serial interface chip. To configure the driver, use the sethdlc
 	  utility available in the standard ax25 utilities package. For
 	  information on the modems, see <http://www.baycom.de/> and
-	  <file:Documentation/networking/baycom.rst>.
+	  <file:Documentation/networking/device_drivers/hamradio/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_ser_fdx.  This is recommended.
@@ -147,7 +147,7 @@ config BAYCOM_SER_HDX
 	  the driver, use the sethdlc utility available in the standard ax25
 	  utilities package. For information on the modems, see
 	  <http://www.baycom.de/> and
-	  <file:Documentation/networking/baycom.rst>.
+	  <file:Documentation/networking/device_drivers/hamradio/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_ser_hdx.  This is recommended.
@@ -162,7 +162,7 @@ config BAYCOM_PAR
 	  par96 designs. To configure the driver, use the sethdlc utility
 	  available in the standard ax25 utilities package. For information on
 	  the modems, see <http://www.baycom.de/> and the file
-	  <file:Documentation/networking/baycom.rst>.
+	  <file:Documentation/networking/device_drivers/hamradio/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_par.  This is recommended.
@@ -177,7 +177,7 @@ config BAYCOM_EPP
 	  designs. To configure the driver, use the sethdlc utility available
 	  in the standard ax25 utilities package. For information on the
 	  modems, see <http://www.baycom.de/> and the file
-	  <file:Documentation/networking/baycom.rst>.
+	  <file:Documentation/networking/device_drivers/hamradio/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_epp.  This is recommended.
-- 
2.26.2

