Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C481F18E02F
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgCULe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:34:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38490 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgCULe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:34:57 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFcOR-0001zT-Eh; Sat, 21 Mar 2020 12:34:19 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 74A94FFBBF;
        Sat, 21 Mar 2020 12:34:18 +0100 (CET)
Message-Id: <20200321113241.246190285@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 21 Mar 2020 12:25:49 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [patch V3 05/20] acpi: Remove header dependency
References: <20200321112544.878032781@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

In order to avoid future header hell, remove the inclusion of
proc_fs.h from acpi_bus.h. All it needs is a forward declaration of a
struct.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/platform/x86/dell-smo8800.c                      |    1 +
 drivers/platform/x86/wmi.c                               |    1 +
 drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c |    1 +
 include/acpi/acpi_bus.h                                  |    2 +-
 4 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/dell-smo8800.c
+++ b/drivers/platform/x86/dell-smo8800.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/miscdevice.h>
 #include <linux/uaccess.h>
+#include <linux/fs.h>
 
 struct smo8800_device {
 	u32 irq;                     /* acpi device irq */
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -29,6 +29,7 @@
 #include <linux/uaccess.h>
 #include <linux/uuid.h>
 #include <linux/wmi.h>
+#include <linux/fs.h>
 #include <uapi/linux/wmi.h>
 
 ACPI_MODULE_NAME("wmi");
--- a/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
+++ b/drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c
@@ -19,6 +19,7 @@
 #include <linux/acpi.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
+#include <linux/fs.h>
 #include "acpi_thermal_rel.h"
 
 static acpi_handle acpi_thermal_rel_handle;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -80,7 +80,7 @@ bool acpi_dev_present(const char *hid, c
 
 #ifdef CONFIG_ACPI
 
-#include <linux/proc_fs.h>
+struct proc_dir_entry;
 
 #define ACPI_BUS_FILE_ROOT	"acpi"
 extern struct proc_dir_entry *acpi_root_dir;


