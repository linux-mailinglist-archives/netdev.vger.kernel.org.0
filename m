Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314A1EFCE3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 17:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgFEPqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 11:46:36 -0400
Received: from smtp.asem.it ([151.1.184.197]:51435 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgFEPqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 11:46:35 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2020 11:46:34 EDT
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000300866.MSG 
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 17:41:29 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 5 Jun
 2020 17:41:27 +0200
Received: from flavio-x.asem.intra (172.16.17.208) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 5 Jun 2020 17:41:27 +0200
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
Subject: [PATCH 0/9] net: wireless: fix wireless wiki website url
Date:   Fri, 5 Jun 2020 17:41:03 +0200
Message-ID: <20200605154112.16277-1-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090215.5EDA67A8.0060,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some files, related to the net wireless sub-system, the wireless wiki
URL is still the old "wireless.kernel.org" instead of the new
"wireless.wiki.kernel.org"


Flavio Suligoi (9):
  doc: networking: wireless: fix wiki website url
  net: wireless: fix wiki website url in main Kconfig
  net: wireless: ath: fix wiki website url
  net: wireless: atmel: fix wiki website url
  net: wireless: broadcom: fix wiki website url
  net: wireless: intel: fix wiki website url
  net: wireless: intersil: fix wiki website url
  include: fix wiki website url in netlink interface header
  net: fix wiki website url mac80211 and wireless files

 Documentation/networking/mac80211-injection.rst        | 2 +-
 Documentation/networking/regulatory.rst                | 6 +++---
 drivers/net/wireless/Kconfig                           | 2 +-
 drivers/net/wireless/ath/Kconfig                       | 4 ++--
 drivers/net/wireless/ath/ath9k/Kconfig                 | 5 +++--
 drivers/net/wireless/ath/ath9k/hw.c                    | 2 +-
 drivers/net/wireless/ath/carl9170/Kconfig              | 2 +-
 drivers/net/wireless/ath/carl9170/usb.c                | 2 +-
 drivers/net/wireless/ath/wil6210/Kconfig               | 2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c              | 2 +-
 drivers/net/wireless/broadcom/b43/main.c               | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c         | 4 ++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c         | 2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig             | 2 +-
 drivers/net/wireless/intersil/Kconfig                  | 2 +-
 drivers/net/wireless/intersil/p54/Kconfig              | 6 +++---
 drivers/net/wireless/intersil/p54/fwio.c               | 5 +++--
 drivers/net/wireless/intersil/p54/p54usb.c             | 2 +-
 drivers/net/wireless/intersil/prism54/islpci_hotplug.c | 3 ++-
 include/uapi/linux/nl80211.h                           | 2 +-
 net/mac80211/rx.c                                      | 2 +-
 net/wireless/Kconfig                                   | 2 +-
 22 files changed, 33 insertions(+), 30 deletions(-)

-- 
2.17.1

