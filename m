Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9821F6CC7
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgFKRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgFKRbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 13:31:24 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2641020870;
        Thu, 11 Jun 2020 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591896683;
        bh=/mFlL/Z9F0k71yFgIYeX5H/nR/PB8r5bOtOK9Fvoevc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3q9tZdYAO4S7X3RJBma6RjkwTN7il1T2ckoBv7rfLYrdqfxwZjv2K5WNSfBkWvmT
         hUII8Sa1oWUTP+1CuwlLzol7fRPDFnmubQKELoy3fzVM4EhtrwXJQaPQ2PB04DiVzC
         Edt9K5hIsu7xdI1qlH21BjoMLs483nYgvSIHHIWA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, t.sailer@alumni.ethz.ch
Subject: [RFC 3/8] docs: networking: move baycom to the hw driver section
Date:   Thu, 11 Jun 2020 10:30:05 -0700
Message-Id: <20200611173010.474475-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611173010.474475-1-kuba@kernel.org>
References: <20200611173010.474475-1-kuba@kernel.org>
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
index 6aaca62940d0..8e63afc8a2e6 100644
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

