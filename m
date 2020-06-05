Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE51EFCEB
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgFEPqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:46:51 -0400
Received: from smtp.asem.it ([151.1.184.197]:51435 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbgFEPqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 11:46:49 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 11:46:34 EDT
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000300873.MSG 
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 17:41:32 +0200S
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
Subject: [PATCH 7/9] net: wireless: intersil: fix wiki website url
Date:   Fri, 5 Jun 2020 17:41:10 +0200
Message-ID: <20200605154112.16277-8-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605154112.16277-1-f.suligoi@asem.it>
References: <20200605154112.16277-1-f.suligoi@asem.it>
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090215.5EDA67AA.0041,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some Intesil files, the wiki url is still the old
"wireless.kernel.org" instead of the new
"wireless.wiki.kernel.org"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/wireless/intersil/Kconfig                  | 2 +-
 drivers/net/wireless/intersil/p54/Kconfig              | 6 +++---
 drivers/net/wireless/intersil/p54/fwio.c               | 5 +++--
 drivers/net/wireless/intersil/p54/p54usb.c             | 2 +-
 drivers/net/wireless/intersil/prism54/islpci_hotplug.c | 3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/Kconfig b/drivers/net/wireless/intersil/Kconfig
index 4e968912e27c..527604c13687 100644
--- a/drivers/net/wireless/intersil/Kconfig
+++ b/drivers/net/wireless/intersil/Kconfig
@@ -30,7 +30,7 @@ config PRISM54
 
 	  For more information refer to the p54 wiki:
 
-	  http://wireless.kernel.org/en/users/Drivers/p54
+	  https://wireless.wiki.kernel.org/en/users/Drivers/p54
 
 	  Note: You need a motherboard with DMA support to use any of these cards
 
diff --git a/drivers/net/wireless/intersil/p54/Kconfig b/drivers/net/wireless/intersil/p54/Kconfig
index 26cd80732afa..67651164190a 100644
--- a/drivers/net/wireless/intersil/p54/Kconfig
+++ b/drivers/net/wireless/intersil/p54/Kconfig
@@ -10,7 +10,7 @@ config P54_COMMON
 	  also need to be enabled in order to support any devices.
 
 	  These devices require softmac firmware which can be found at
-	  <http://wireless.kernel.org/en/users/Drivers/p54>
+	  <https://wireless.wiki.kernel.org/en/users/Drivers/p54>
 
 	  If you choose to build a module, it'll be called p54common.
 
@@ -22,7 +22,7 @@ config P54_USB
 	  This driver is for USB isl38xx based wireless cards.
 
 	  These devices require softmac firmware which can be found at
-	  <http://wireless.kernel.org/en/users/Drivers/p54>
+	  <https://wireless.wiki.kernel.org/en/users/Drivers/p54>
 
 	  If you choose to build a module, it'll be called p54usb.
 
@@ -36,7 +36,7 @@ config P54_PCI
 	  supported by the fullmac driver/firmware.
 
 	  This driver requires softmac firmware which can be found at
-	  <http://wireless.kernel.org/en/users/Drivers/p54>
+	  <https://wireless.wiki.kernel.org/en/users/Drivers/p54>
 
 	  If you choose to build a module, it'll be called p54pci.
 
diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index a5afcc865196..7f973bed792f 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -132,8 +132,9 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 	if (priv->fw_var < 0x500)
 		wiphy_info(priv->hw->wiphy,
 			   "you are using an obsolete firmware. "
-			   "visit http://wireless.kernel.org/en/users/Drivers/p54 "
-			   "and grab one for \"kernel >= 2.6.28\"!\n");
+			   "visit https://wireless.wiki.kernel.org/en/users/"
+			   "Drivers/p54 and grab one "
+			   "for \"kernel >= 2.6.28\"!\n");
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
diff --git a/drivers/net/wireless/intersil/p54/p54usb.c b/drivers/net/wireless/intersil/p54/p54usb.c
index ff0e30c0c14c..f09d95c5d7d4 100644
--- a/drivers/net/wireless/intersil/p54/p54usb.c
+++ b/drivers/net/wireless/intersil/p54/p54usb.c
@@ -36,7 +36,7 @@ static struct usb_driver p54u_driver;
  * Note:
  *
  * Always update our wiki's device list (located at:
- * http://wireless.kernel.org/en/users/Drivers/p54/devices ),
+ * https://wireless.wiki.kernel.org/en/users/Drivers/p54/devices ),
  * whenever you add a new device.
  */
 
diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
index 20291c0d962d..0e42242a4b68 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
@@ -26,7 +26,8 @@ module_param(init_pcitm, int, 0);
 /* In this order: vendor, device, subvendor, subdevice, class, class_mask,
  * driver_data
  * If you have an update for this please contact prism54-devel@prism54.org
- * The latest list can be found at http://wireless.kernel.org/en/users/Drivers/p54 */
+ * The latest list can be found at:
+ * https://wireless.wiki.kernel.org/en/users/Drivers/p54
+ */
 static const struct pci_device_id prism54_id_tbl[] = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
 	{
-- 
2.17.1

