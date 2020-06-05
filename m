Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B131EFCE6
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgFEPqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:46:42 -0400
Received: from smtp.asem.it ([151.1.184.197]:51435 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgFEPql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 11:46:41 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 11:46:34 EDT
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000300869.MSG 
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 17:41:29 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 5 Jun
 2020 17:41:28 +0200
Received: from flavio-x.asem.intra (172.16.17.208) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 5 Jun 2020 17:41:28 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johan Hovold <johan@kernel.org>,
        Saurav Girepunje <saurav.girepunje@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
Subject: [PATCH 3/9] net: wireless: ath: fix wiki website url
Date:   Fri, 5 Jun 2020 17:41:06 +0200
Message-ID: <20200605154112.16277-4-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605154112.16277-1-f.suligoi@asem.it>
References: <20200605154112.16277-1-f.suligoi@asem.it>
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090215.5EDA67A9.0030,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some ath files, the wiki url is still the old
"wireless.kernel.org" instead of the new
"wireless.wiki.kernel.org"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/wireless/ath/Kconfig          | 4 ++--
 drivers/net/wireless/ath/ath9k/Kconfig    | 5 +++--
 drivers/net/wireless/ath/ath9k/hw.c       | 2 +-
 drivers/net/wireless/ath/carl9170/Kconfig | 2 +-
 drivers/net/wireless/ath/carl9170/usb.c   | 2 +-
 drivers/net/wireless/ath/wil6210/Kconfig  | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index b10972b6cba4..0138d415f4e1 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -15,11 +15,11 @@ config WLAN_VENDOR_ATH
 
 	  For more information and documentation on this module you can visit:
 
-	  http://wireless.kernel.org/en/users/Drivers/ath
+	  https://wireless.wiki.kernel.org/en/users/Drivers/ath
 
 	  For information on all Atheros wireless drivers visit:
 
-	  http://wireless.kernel.org/en/users/Drivers/Atheros
+	  https://wireless.wiki.kernel.org/en/users/Drivers/Atheros
 
 if WLAN_VENDOR_ATH
 
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 78620c6b64a2..28b46ca9ee3b 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -34,7 +34,7 @@ config ATH9K
 	  APs that come with these cards refer to ath9k wiki
 	  products page:
 
-	  http://wireless.kernel.org/en/users/Drivers/ath9k/products
+	  https://wireless.wiki.kernel.org/en/users/Drivers/ath9k/products
 
 	  If you choose to build a module, it'll be called ath9k.
 
@@ -185,7 +185,8 @@ config ATH9K_HTC
 	  Support for Atheros HTC based cards.
 	  Chipsets supported: AR9271
 
-	  For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc
+	  For more information:
+	  https://wireless.wiki.kernel.org/en/users/Drivers/ath9k_htc
 
 	  The built module will be ath9k_htc.
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 052deffb4c9d..8c97db73e34c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2410,7 +2410,7 @@ static u8 fixup_chainmask(u8 chip_chainmask, u8 eeprom_chainmask)
  * of tests. The testing requirements are going to be documented. Desired
  * test requirements are documented at:
  *
- * http://wireless.kernel.org/en/users/Drivers/ath9k/dfs
+ * https://wireless.wiki.kernel.org/en/users/Drivers/ath9k/dfs
  *
  * Once a new chipset gets properly tested an individual commit can be used
  * to document the testing for DFS for that chipset.
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index b1bce7aad399..b2d760873992 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -10,7 +10,7 @@ config CARL9170
 
 	  It needs a special firmware (carl9170-1.fw), which can be downloaded
 	  from our wiki here:
-	  <http://wireless.kernel.org/en/users/Drivers/carl9170>
+	  <https://wireless.wiki.kernel.org/en/users/Drivers/carl9170>
 
 	  If you choose to build a module, it'll be called carl9170.
 
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 486957a04bd1..ead79335823a 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -61,7 +61,7 @@ MODULE_ALIAS("arusb_lnx");
  * Note:
  *
  * Always update our wiki's device list (located at:
- * http://wireless.kernel.org/en/users/Drivers/ar9170/devices ),
+ * https://wireless.wiki.kernel.org/en/users/Drivers/ar9170/devices ),
  * whenever you add a new device.
  */
 static const struct usb_device_id carl9170_usb_ids[] = {
diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index 0d1a8dab30ed..8c9dd673b9e7 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -10,7 +10,7 @@ config WIL6210
 	  wil6210 chip by Wilocity. It supports operation on the
 	  60 GHz band, covered by the IEEE802.11ad standard.
 
-	  http://wireless.kernel.org/en/users/Drivers/wil6210
+	  https://wireless.wiki.kernel.org/en/users/Drivers/wil6210
 
 	  If you choose to build it as a module, it will be called
 	  wil6210
-- 
2.17.1

