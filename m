Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFD41EFCE7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgFEPqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:46:44 -0400
Received: from smtp.asem.it ([151.1.184.197]:51435 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgFEPqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 11:46:42 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 11:46:34 EDT
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000300870.MSG 
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
Subject: [PATCH 4/9] net: wireless: atmel: fix wiki website url
Date:   Fri, 5 Jun 2020 17:41:07 +0200
Message-ID: <20200605154112.16277-5-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605154112.16277-1-f.suligoi@asem.it>
References: <20200605154112.16277-1-f.suligoi@asem.it>
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090215.5EDA67A9.0053,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In at76c50x-usb.c the wiki url is still the old
"wireless.kernel.org" instead of the new
"wireless.wiki.kernel.org"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 3b2680772f03..a63b5c2f1e17 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -17,7 +17,7 @@
  *
  * TODO list is at the wiki:
  *
- * http://wireless.kernel.org/en/users/Drivers/at76c50x-usb#TODO
+ * https://wireless.wiki.kernel.org/en/users/Drivers/at76c50x-usb#TODO
  */
 
 #include <linux/init.h>
-- 
2.17.1

