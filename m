Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C161EFCE9
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgFEPqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:46:46 -0400
Received: from smtp.asem.it ([151.1.184.197]:51435 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbgFEPqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 11:46:44 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 11:46:34 EDT
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000300871.MSG 
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 17:41:31 +0200S
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
Subject: [PATCH 5/9] net: wireless: broadcom: fix wiki website url
Date:   Fri, 5 Jun 2020 17:41:08 +0200
Message-ID: <20200605154112.16277-6-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605154112.16277-1-f.suligoi@asem.it>
References: <20200605154112.16277-1-f.suligoi@asem.it>
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090215.5EDA67AA.0011,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some b43 files, the wiki url is still the old
"wireless.kernel.org" instead of the new
"wireless.wiki.kernel.org"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/wireless/broadcom/b43/main.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 3ad94dad2d89..0c2ea12fca19 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -2164,7 +2164,7 @@ static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
 	const char text[] =
 		"You must go to " \
-		"http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware " \
+		"https://wireless.wiki.kernel.org/en/users/Drivers/b43#devicefirmware " \
 		"and download the correct firmware for this driver version. " \
 		"Please carefully read all instructions on this website.\n";
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 5208a39fd6f7..7bb6681fa882 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1477,8 +1477,8 @@ static void b43legacy_release_firmware(struct b43legacy_wldev *dev)
 
 static void b43legacy_print_fw_helptext(struct b43legacy_wl *wl)
 {
-	b43legacyerr(wl, "You must go to http://wireless.kernel.org/en/users/"
-		     "Drivers/b43#devicefirmware "
+	b43legacyerr(wl, "You must go to https://wireless.wiki.kernel.org/en/"
+		     "users/Drivers/b43#devicefirmware "
 		     "and download the correct firmware (version 3).\n");
 }
 
-- 
2.17.1

