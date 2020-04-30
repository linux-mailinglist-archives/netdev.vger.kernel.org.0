Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516AA1C014E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgD3QEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgD3QEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:37 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD98208CA;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=sFuN0vBK+JwBRLNPQc/i7o6rOqaphy84PmOAJvpLo7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY0oVDQIEQe0IOgIkcGS66w2Yi+puKEyzkMHYZ7arBix0cK6asc8NkbsCVqyROh4c
         pNT4G88lN11RiEj2Gu4rDqz6tmZAN2RmI3n5QoaAqWw/KpFiP7CncgcPBocbRXX4LW
         jSiZHgd3QsOiNMUgHUNLgmQr3H3GIJezV1CfckmM=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEN-2j; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/37] docs: networking: convert mac80211-injection.txt to ReST
Date:   Thu, 30 Apr 2020 18:03:59 +0200
Message-Id: <015916acf01942ca53453444aa48f70e7bfa5221.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 ...1-injection.txt => mac80211-injection.rst} | 39 ++++++++++++-------
 MAINTAINERS                                   |  2 +-
 net/mac80211/tx.c                             |  2 +-
 4 files changed, 27 insertions(+), 17 deletions(-)
 rename Documentation/networking/{mac80211-injection.txt => mac80211-injection.rst} (68%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b3608b177a8b..81c1834bfb57 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -77,6 +77,7 @@ Contents:
    l2tp
    lapb-module
    ltpc
+   mac80211-injection
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.rst
similarity index 68%
rename from Documentation/networking/mac80211-injection.txt
rename to Documentation/networking/mac80211-injection.rst
index d58d78df9ca2..75d4edcae852 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.rst
@@ -1,9 +1,12 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
 How to use packet injection with mac80211
 =========================================
 
 mac80211 now allows arbitrary packets to be injected down any Monitor Mode
 interface from userland.  The packet you inject needs to be composed in the
-following format:
+following format::
 
  [ radiotap header  ]
  [ ieee80211 header ]
@@ -18,15 +21,19 @@ radiotap headers and used to control injection:
 
  * IEEE80211_RADIOTAP_FLAGS
 
-   IEEE80211_RADIOTAP_F_FCS: FCS will be removed and recalculated
-   IEEE80211_RADIOTAP_F_WEP: frame will be encrypted if key available
-   IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
+   =========================  ===========================================
+   IEEE80211_RADIOTAP_F_FCS   FCS will be removed and recalculated
+   IEEE80211_RADIOTAP_F_WEP   frame will be encrypted if key available
+   IEEE80211_RADIOTAP_F_FRAG  frame will be fragmented if longer than the
 			      current fragmentation threshold.
+   =========================  ===========================================
 
  * IEEE80211_RADIOTAP_TX_FLAGS
 
-   IEEE80211_RADIOTAP_F_TX_NOACK: frame should be sent without waiting for
+   =============================  ========================================
+   IEEE80211_RADIOTAP_F_TX_NOACK  frame should be sent without waiting for
 				  an ACK even if it is a unicast frame
+   =============================  ========================================
 
  * IEEE80211_RADIOTAP_RATE
 
@@ -37,8 +44,10 @@ radiotap headers and used to control injection:
    HT rate for the transmission (only for devices without own rate control).
    Also some flags are parsed
 
-   IEEE80211_RADIOTAP_MCS_SGI: use short guard interval
-   IEEE80211_RADIOTAP_MCS_BW_40: send in HT40 mode
+   ============================  ========================
+   IEEE80211_RADIOTAP_MCS_SGI    use short guard interval
+   IEEE80211_RADIOTAP_MCS_BW_40  send in HT40 mode
+   ============================  ========================
 
  * IEEE80211_RADIOTAP_DATA_RETRIES
 
@@ -51,17 +60,17 @@ radiotap headers and used to control injection:
    without own rate control). Also other fields are parsed
 
    flags field
-   IEEE80211_RADIOTAP_VHT_FLAG_SGI: use short guard interval
+	IEEE80211_RADIOTAP_VHT_FLAG_SGI: use short guard interval
 
    bandwidth field
-   1: send using 40MHz channel width
-   4: send using 80MHz channel width
-   11: send using 160MHz channel width
+	* 1: send using 40MHz channel width
+	* 4: send using 80MHz channel width
+	* 11: send using 160MHz channel width
 
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
 
-Here is an example valid radiotap header defining some parameters
+Here is an example valid radiotap header defining some parameters::
 
 	0x00, 0x00, // <-- radiotap version
 	0x0b, 0x00, // <- radiotap header length
@@ -71,7 +80,7 @@ Here is an example valid radiotap header defining some parameters
 	0x01 //<-- antenna
 
 The ieee80211 header follows immediately afterwards, looking for example like
-this:
+this::
 
 	0x08, 0x01, 0x00, 0x00,
 	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
@@ -84,10 +93,10 @@ Then lastly there is the payload.
 After composing the packet contents, it is sent by send()-ing it to a logical
 mac80211 interface that is in Monitor mode.  Libpcap can also be used,
 (which is easier than doing the work to bind the socket to the right
-interface), along the following lines:
+interface), along the following lines:::
 
 	ppcap = pcap_open_live(szInterfaceName, 800, 1, 20, szErrbuf);
-...
+	...
 	r = pcap_inject(ppcap, u8aSendBuffer, nLength);
 
 You can also find a link to a complete inject application here:
diff --git a/MAINTAINERS b/MAINTAINERS
index 0db63acd07b0..1546ecb855b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10112,7 +10112,7 @@ S:	Maintained
 W:	https://wireless.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
-F:	Documentation/networking/mac80211-injection.txt
+F:	Documentation/networking/mac80211-injection.rst
 F:	Documentation/networking/mac80211_hwsim/mac80211_hwsim.rst
 F:	drivers/net/wireless/mac80211_hwsim.[ch]
 F:	include/net/mac80211.h
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6dad67eb60b2..47f460c8bd74 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2144,7 +2144,7 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 
 		/*
 		 * Please update the file
-		 * Documentation/networking/mac80211-injection.txt
+		 * Documentation/networking/mac80211-injection.rst
 		 * when parsing new fields here.
 		 */
 
-- 
2.25.4

