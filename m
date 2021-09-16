Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA03B40D546
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhIPJBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235539AbhIPJBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 812126138D;
        Thu, 16 Sep 2021 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631782803;
        bh=ubcjMpwWSL9cbm1RAy/fLFvcAW1TEdBEgtDxfkNApEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCz2zFDmW9kkPtgGJjpzFSBQRLuQNLGRoSCBKgyu5LcT2kz23xjaVNJyR1L56YdNY
         ZvME8Lp48RX89q5tQ3p5dmMzTu2WQU/Wbobs4k7I3+jk6BdkVWOz3hXKhe6dn1arC9
         1is6GTz/bm4hUyvHUo2V//6odKTmC7hReY0uL8l50WX3pdRSYOn3Ef+X+65wjvd2OB
         G0qmmja0nE82xnH/y39qccuHPyJMZ6HKX+gBaJAE3/Gi+lD59lTWwJ5183XRpTXtDR
         nRvGoqkmGuLeV9JuGLpvdBkcfSPFrlYUSkpoJmawdnF2h39aYBpJ8aHx5M4Giz6dNH
         jViDqTaONfYIw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQnFR-001qlT-LB; Thu, 16 Sep 2021 11:00:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 29/30] ABI: sysfs-ptp: use wildcards on What definitions
Date:   Thu, 16 Sep 2021 10:59:56 +0200
Message-Id: <03dcf9985244f8f9d8202af1ba203abb1f405e7d.1631782432.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631782432.git.mchehab+huawei@kernel.org>
References: <cover.1631782432.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An "N" upper letter is not a wildcard, nor can easily be identified
by script, specially since the USB sysfs define things like.
bNumInterfaces. Use, instead, <N>, in order to let script/get_abi.pl
to convert it into a Regex.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/ABI/testing/sysfs-ptp | 30 ++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index d378f57c1b73..9c317ac7c47a 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -6,7 +6,7 @@ Description:
 		providing a standardized interface to the ancillary
 		features of PTP hardware clocks.
 
-What:		/sys/class/ptp/ptpN/
+What:		/sys/class/ptp/ptp<N>/
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -14,7 +14,7 @@ Description:
 		hardware clock registered into the PTP class driver
 		subsystem.
 
-What:		/sys/class/ptp/ptpN/clock_name
+What:		/sys/class/ptp/ptp<N>/clock_name
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -25,7 +25,7 @@ Description:
 		MAC based ones. The string does not necessarily have
 		to be any kind of unique id.
 
-What:		/sys/class/ptp/ptpN/max_adjustment
+What:		/sys/class/ptp/ptp<N>/max_adjustment
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -33,42 +33,42 @@ Description:
 		frequency adjustment value (a positive integer) in
 		parts per billion.
 
-What:		/sys/class/ptp/ptpN/max_vclocks
+What:		/sys/class/ptp/ptp<N>/max_vclocks
 Date:		May 2021
 Contact:	Yangbo Lu <yangbo.lu@nxp.com>
 Description:
 		This file contains the maximum number of ptp vclocks.
 		Write integer to re-configure it.
 
-What:		/sys/class/ptp/ptpN/n_alarms
+What:		/sys/class/ptp/ptp<N>/n_alarms
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
 		This file contains the number of periodic or one shot
 		alarms offer by the PTP hardware clock.
 
-What:		/sys/class/ptp/ptpN/n_external_timestamps
+What:		/sys/class/ptp/ptp<N>/n_external_timestamps
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
 		This file contains the number of external timestamp
 		channels offered by the PTP hardware clock.
 
-What:		/sys/class/ptp/ptpN/n_periodic_outputs
+What:		/sys/class/ptp/ptp<N>/n_periodic_outputs
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
 		This file contains the number of programmable periodic
 		output channels offered by the PTP hardware clock.
 
-What:		/sys/class/ptp/ptpN/n_pins
+What:		/sys/class/ptp/ptp<N>/n_pins
 Date:		March 2014
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
 		This file contains the number of programmable pins
 		offered by the PTP hardware clock.
 
-What:		/sys/class/ptp/ptpN/n_vclocks
+What:		/sys/class/ptp/ptp<N>/n_vclocks
 Date:		May 2021
 Contact:	Yangbo Lu <yangbo.lu@nxp.com>
 Description:
@@ -81,7 +81,7 @@ Description:
 		switches the physical clock back to normal, adjustable
 		operation.
 
-What:		/sys/class/ptp/ptpN/pins
+What:		/sys/class/ptp/ptp<N>/pins
 Date:		March 2014
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -94,7 +94,7 @@ Description:
 		assignment may be changed by two writing numbers into
 		the file.
 
-What:		/sys/class/ptp/ptpN/pps_available
+What:		/sys/class/ptp/ptp<N>/pps_available
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -103,7 +103,7 @@ Description:
 		"1" means that the PPS is supported, while "0" means
 		not supported.
 
-What:		/sys/class/ptp/ptpN/extts_enable
+What:		/sys/class/ptp/ptp<N>/extts_enable
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -113,7 +113,7 @@ Description:
 		To disable external timestamps, write the channel
 		index followed by a "0" into the file.
 
-What:		/sys/class/ptp/ptpN/fifo
+What:		/sys/class/ptp/ptp<N>/fifo
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -121,7 +121,7 @@ Description:
 		the form of three integers: channel index, seconds,
 		and nanoseconds.
 
-What:		/sys/class/ptp/ptpN/period
+What:		/sys/class/ptp/ptp<N>/period
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
@@ -132,7 +132,7 @@ Description:
 		period nanoseconds. To disable a periodic output, set
 		all the seconds and nanoseconds values to zero.
 
-What:		/sys/class/ptp/ptpN/pps_enable
+What:		/sys/class/ptp/ptp<N>/pps_enable
 Date:		September 2010
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
-- 
2.31.1

