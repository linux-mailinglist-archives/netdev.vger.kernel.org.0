Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF22154796
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgBFPR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:17:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=59Rj5dPhY9QjBXLCWQNJNtM4PkBOcp2rHBZAfQ+2spU=; b=SuoPjsrrJHuiUwMiBOGH300RKT
        WSEdXNFijv4qI8mZTWYRDrsiLkIEv/dHJ8AYnKHwVfQe4EDAN3o1T+sflkxsKIo/KLLF2+JnqeKMG
        Se3sRTHeH5PFa2KnjtPf09RKbyp6/X/mZhlclphk0fwn+iVDPZTwdRz7yqrw2TrSfF0deMik/NyGq
        E4S9TQuLIJq+3E4mAMrGo8zWPsMuZJUddMoCDGp0gUq5+HansZaRBpBdBEg00+9jNytYmq9N89BZE
        vOj/bzV1a1655th3AvAyN7IV0f7KasTXCIewkjyqfdnKhODr7pt0EY15GP+qPQyPwX5+qm3ChBizf
        MgqIedmQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jW-N8; Thu, 06 Feb 2020 15:17:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVZ-9Y; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 13/28] docs: networking: convert cxacru.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:33 +0100
Message-Id: <cedfce80cf6e20877748b5b24c862fdfbc6e3413.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- mark code blocks and literals as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{cxacru.txt => cxacru.rst}     | 86 ++++++++++++-------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 54 insertions(+), 33 deletions(-)
 rename Documentation/networking/{cxacru.txt => cxacru.rst} (66%)

diff --git a/Documentation/networking/cxacru.txt b/Documentation/networking/cxacru.rst
similarity index 66%
rename from Documentation/networking/cxacru.txt
rename to Documentation/networking/cxacru.rst
index 2cce04457b4d..6088af2ffeda 100644
--- a/Documentation/networking/cxacru.txt
+++ b/Documentation/networking/cxacru.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================
+ATM cxacru device driver
+========================
+
 Firmware is required for this device: http://accessrunner.sourceforge.net/
 
 While it is capable of managing/maintaining the ADSL connection without the
@@ -19,29 +25,35 @@ several sysfs attribute files for retrieving device statistics:
 
 * adsl_headend
 * adsl_headend_environment
-	Information about the remote headend.
+
+	- Information about the remote headend.
 
 * adsl_config
-	Configuration writing interface.
-	Write parameters in hexadecimal format <index>=<value>,
-	separated by whitespace, e.g.:
+
+	- Configuration writing interface.
+	- Write parameters in hexadecimal format <index>=<value>,
+	  separated by whitespace, e.g.:
+
 		"1=0 a=5"
-	Up to 7 parameters at a time will be sent and the modem will restart
-	the ADSL connection when any value is set. These are logged for future
-	reference.
+
+	- Up to 7 parameters at a time will be sent and the modem will restart
+	  the ADSL connection when any value is set. These are logged for future
+	  reference.
 
 * downstream_attenuation (dB)
 * downstream_bits_per_frame
 * downstream_rate (kbps)
 * downstream_snr_margin (dB)
-	Downstream stats.
+
+	- Downstream stats.
 
 * upstream_attenuation (dB)
 * upstream_bits_per_frame
 * upstream_rate (kbps)
 * upstream_snr_margin (dB)
 * transmitter_power (dBm/Hz)
-	Upstream stats.
+
+	- Upstream stats.
 
 * downstream_crc_errors
 * downstream_fec_errors
@@ -49,48 +61,56 @@ several sysfs attribute files for retrieving device statistics:
 * upstream_crc_errors
 * upstream_fec_errors
 * upstream_hec_errors
-	Error counts.
+
+	- Error counts.
 
 * line_startable
-	Indicates that ADSL support on the device
-	is/can be enabled, see adsl_start.
+
+	- Indicates that ADSL support on the device
+	  is/can be enabled, see adsl_start.
 
 * line_status
-	"initialising"
-	"down"
-	"attempting to activate"
-	"training"
-	"channel analysis"
-	"exchange"
-	"waiting"
-	"up"
+
+	 - "initialising"
+	 - "down"
+	 - "attempting to activate"
+	 - "training"
+	 - "channel analysis"
+	 - "exchange"
+	 - "waiting"
+	 - "up"
 
 	Changes between "down" and "attempting to activate"
 	if there is no signal.
 
 * link_status
-	"not connected"
-	"connected"
-	"lost"
+
+	 - "not connected"
+	 - "connected"
+	 - "lost"
 
 * mac_address
 
 * modulation
-	"" (when not connected)
-	"ANSI T1.413"
-	"ITU-T G.992.1 (G.DMT)"
-	"ITU-T G.992.2 (G.LITE)"
+
+	 - "" (when not connected)
+	 - "ANSI T1.413"
+	 - "ITU-T G.992.1 (G.DMT)"
+	 - "ITU-T G.992.2 (G.LITE)"
 
 * startup_attempts
-	Count of total attempts to initialise ADSL.
+
+	- Count of total attempts to initialise ADSL.
 
 To enable/disable ADSL, the following can be written to the adsl_state file:
-	"start"
-	"stop
-	"restart" (stops, waits 1.5s, then starts)
-	"poll" (used to resume status polling if it was disabled due to failure)
 
-Changes in adsl/line state are reported via kernel log messages:
+	 - "start"
+	 - "stop
+	 - "restart" (stops, waits 1.5s, then starts)
+	 - "poll" (used to resume status polling if it was disabled due to failure)
+
+Changes in adsl/line state are reported via kernel log messages::
+
 	[4942145.150704] ATM dev 0: ADSL state: running
 	[4942243.663766] ATM dev 0: ADSL line: down
 	[4942249.665075] ATM dev 0: ADSL line: attempting to activate
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 2201f848d8f7..4f8dc5fd6b20 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -45,6 +45,7 @@ Contents:
    bonding
    cdc_mbim
    cops
+   cxacru
 
 .. only::  subproject and html
 
-- 
2.24.1

