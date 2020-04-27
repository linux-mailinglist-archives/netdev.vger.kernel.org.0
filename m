Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F21BB14C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD0WFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828DC21BE5;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=Emi2yoocs4hV5xnVSqpHUmvmCGjZo8W2zvoib32QGkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/3QhxJ9FaZVq+QqESOYha1vU32VTfaKA8teo8JxjeKSYPFASAftlZc+VVowzVgPt
         CJoYwRfxE3eq1WSbVGbqop8zzGgJBd8EvOxrvwPpZXIjNSQ9lnAByZxM0UlmcJbt1d
         X7WvDjD7N147NfVJAasRKjsAx5GzNGseJslQ8wKo=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Iob-QQ; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 12/38] docs: networking: convert cxacru.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:27 +0200
Message-Id: <de1ca06ed67d07d81ee7daac8a130aef6f2f335c.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
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
index 7b596810d479..4c8e896490e0 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -47,6 +47,7 @@ Contents:
    bonding
    cdc_mbim
    cops
+   cxacru
 
 .. only::  subproject and html
 
-- 
2.25.4

