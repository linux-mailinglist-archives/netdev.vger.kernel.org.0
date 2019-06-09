Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCB3A30B
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfFIC1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:27:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfFIC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:27:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ek1YxZXqpgW8Xkg9VWvB5QFV11VlpBzdQZNl/oIX+Jg=; b=gpvQ1kevvOeZ2zA4DOoPyXzyaD
        B54Gm6Y5ILc+AX7uWrosU2qvC0LKQLbXyKzk+D+Y8705eVD6autmgxwcKHC0+xwxs2ohhMqKTzk7h
        ojkI7pGkZmWvYJ8GBvbFqxuEccn68NcN5+xPn9wFJRwlAxhndrRnzYKjXAbZ2JF+wGg4vKhYy+Ax+
        N4JFj/zUiUHYElYcdQNrKirLycJ27vxW9eNlBVRluny9eW9FnsggUJlDQTIxSXDPU/Pdfciq7oc7r
        AplKCJWY4JBGyybo2mWnQAgZGOfurFz92odD6qIF1vNaRLfJH+/IhgnuAkvDSED2GmhdZohkY9ng3
        L3caq9DQ==;
Received: from 179.176.115.133.dynamic.adsl.gvt.net.br ([179.176.115.133] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZnYS-0001n0-Dj; Sun, 09 Jun 2019 02:27:32 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hZnYL-0000Jx-Eo; Sat, 08 Jun 2019 23:27:25 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 23/33] docs: ptp.txt: convert to ReST and move to driver-api
Date:   Sat,  8 Jun 2019 23:27:13 -0300
Message-Id: <1736539355fdee1effe3b332cf3d93124394672b.1560045490.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560045490.git.mchehab+samsung@kernel.org>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion is trivial: just adjust title markups.

In order to avoid conflicts, let's add an :orphan: tag
to it, to be removed when this file gets added to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../{ptp/ptp.txt => driver-api/ptp.rst}       | 26 +++++++++++++------
 Documentation/networking/timestamping.txt     |  2 +-
 MAINTAINERS                                   |  2 +-
 3 files changed, 20 insertions(+), 10 deletions(-)
 rename Documentation/{ptp/ptp.txt => driver-api/ptp.rst} (88%)

diff --git a/Documentation/ptp/ptp.txt b/Documentation/driver-api/ptp.rst
similarity index 88%
rename from Documentation/ptp/ptp.txt
rename to Documentation/driver-api/ptp.rst
index 11e904ee073f..b6e65d66d37a 100644
--- a/Documentation/ptp/ptp.txt
+++ b/Documentation/driver-api/ptp.rst
@@ -1,5 +1,8 @@
+:orphan:
 
-* PTP hardware clock infrastructure for Linux
+===========================================
+PTP hardware clock infrastructure for Linux
+===========================================
 
   This patch set introduces support for IEEE 1588 PTP clocks in
   Linux. Together with the SO_TIMESTAMPING socket options, this
@@ -22,7 +25,8 @@
     - Period output signals configurable from user space
     - Synchronization of the Linux system time via the PPS subsystem
 
-** PTP hardware clock kernel API
+PTP hardware clock kernel API
+=============================
 
    A PTP clock driver registers itself with the class driver. The
    class driver handles all of the dealings with user space. The
@@ -36,7 +40,8 @@
    development, it can be useful to have more than one clock in a
    single system, in order to allow performance comparisons.
 
-** PTP hardware clock user space API
+PTP hardware clock user space API
+=================================
 
    The class driver also creates a character device for each
    registered clock. User space can use an open file descriptor from
@@ -49,7 +54,8 @@
    ancillary clock features. User space can receive time stamped
    events via blocking read() and poll().
 
-** Writing clock drivers
+Writing clock drivers
+=====================
 
    Clock drivers include include/linux/ptp_clock_kernel.h and register
    themselves by presenting a 'struct ptp_clock_info' to the
@@ -66,14 +72,17 @@
    class driver, since the lock may also be needed by the clock
    driver's interrupt service routine.
 
-** Supported hardware
+Supported hardware
+==================
+
+   * Freescale eTSEC gianfar
 
-   + Freescale eTSEC gianfar
      - 2 Time stamp external triggers, programmable polarity (opt. interrupt)
      - 2 Alarm registers (optional interrupt)
      - 3 Periodic signals (optional interrupt)
 
-   + National DP83640
+   * National DP83640
+
      - 6 GPIOs programmable as inputs or outputs
      - 6 GPIOs with dedicated functions (LED/JTAG/clock) can also be
        used as general inputs or outputs
@@ -81,6 +90,7 @@
      - GPIO outputs can produce periodic signals
      - 1 interrupt pin
 
-   + Intel IXP465
+   * Intel IXP465
+
      - Auxiliary Slave/Master Mode Snapshot (optional interrupt)
      - Target Time (optional interrupt)
diff --git a/Documentation/networking/timestamping.txt b/Documentation/networking/timestamping.txt
index bbdaf8990031..8dd6333c3270 100644
--- a/Documentation/networking/timestamping.txt
+++ b/Documentation/networking/timestamping.txt
@@ -368,7 +368,7 @@ ts[1] used to hold hardware timestamps converted to system time.
 Instead, expose the hardware clock device on the NIC directly as
 a HW PTP clock source, to allow time conversion in userspace and
 optionally synchronize system time with a userspace PTP stack such
-as linuxptp. For the PTP clock API, see Documentation/ptp/ptp.txt.
+as linuxptp. For the PTP clock API, see Documentation/driver-api/ptp.rst.
 
 Note that if the SO_TIMESTAMP or SO_TIMESTAMPNS option is enabled
 together with SO_TIMESTAMPING using SOF_TIMESTAMPING_SOFTWARE, a false
diff --git a/MAINTAINERS b/MAINTAINERS
index b982622ea7ee..72d1e5da0779 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12795,7 +12795,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 W:	http://linuxptp.sourceforge.net/
 F:	Documentation/ABI/testing/sysfs-ptp
-F:	Documentation/ptp/*
+F:	Documentation/driver-api/ptp.rst
 F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
-- 
2.21.0

