Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2164F59B20
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfF1Mb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:31:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfF1Maq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V/HBcP10AaKg9f7QXCB/xlHhS75hL4oliVjFK2WwiWw=; b=DJ/WCxxkcrYW8G3KYkrHJnkf2P
        jVRL0+UHsVSIf8VtGu+GJ+NK1gVs4f5L9BvDhdSkrkObRcuIcNwh2ckXwuFieia/rKgL36WvMuY9Z
        nT6Huh3yl0ut6x0Rf6Y6sz2cdaYXiy4rO0wROl5LruZdy9aIj8Om8dOt6vWBqldhQ8ZRGOC88ma64
        OFQp1WxYj3pk+dzTAvSUbFUgAbYZl7CWLsPeAzeYBMiW0VyvKiQQYnT4iHs9pYsGgFzLfwMG6XVwm
        MePcBZkCo2f+oz0eiS7lY82L4KICcgRa9NnZD/K3rytV4FuomrWxv11teHb5arzgZjfDBfeN8hU6i
        gjFHMc4Q==;
Received: from [186.213.242.156] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgq1W-00054w-6k; Fri, 28 Jun 2019 12:30:38 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hgq1S-0005Tu-Ta; Fri, 28 Jun 2019 09:30:34 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jens Axboe <axboe@kernel.dk>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Moritz Fischer <mdf@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [PATCH 37/39] docs: adds some directories to the main documentation index
Date:   Fri, 28 Jun 2019 09:30:30 -0300
Message-Id: <b26fc645cb2c81fe88ab13616c65664d2c3cead5.1561724493.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The contents of those directories were orphaned at the documentation
body.

While those directories could likely be moved to be inside some guide,
I'm opting to just adding their indexes to the main one, removing the
:orphan: and adding the SPDX header.

For the drivers, the rationale is that the documentation contains
a mix of Kernelspace, uAPI and admin-guide. So, better to keep them on
separate directories, as we've be doing with similar subsystem-specific
docs that were not split yet.

For the others, well... I'm too lazy to do the move. Also, it
seems to make sense to keep at least some of those at the main
dir (like kbuild, for example). In any case, a latter patch
could do the move.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/cdrom/index.rst           |  2 +-
 Documentation/fault-injection/index.rst |  2 +-
 Documentation/fb/index.rst              |  2 +-
 Documentation/fpga/index.rst            |  2 +-
 Documentation/ide/index.rst             |  2 +-
 Documentation/index.rst                 | 14 ++++++++++++++
 Documentation/kbuild/index.rst          |  2 +-
 Documentation/livepatch/index.rst       |  2 +-
 Documentation/netlabel/index.rst        |  2 +-
 Documentation/pcmcia/index.rst          |  2 +-
 Documentation/power/index.rst           |  2 +-
 Documentation/target/index.rst          |  2 +-
 Documentation/timers/index.rst          |  2 +-
 Documentation/watchdog/index.rst        |  2 +-
 14 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/Documentation/cdrom/index.rst b/Documentation/cdrom/index.rst
index efbd5d111825..338ad5f94e7c 100644
--- a/Documentation/cdrom/index.rst
+++ b/Documentation/cdrom/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 =====
 cdrom
diff --git a/Documentation/fault-injection/index.rst b/Documentation/fault-injection/index.rst
index 92b5639ed07a..8408a8a91b34 100644
--- a/Documentation/fault-injection/index.rst
+++ b/Documentation/fault-injection/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ===============
 fault-injection
diff --git a/Documentation/fb/index.rst b/Documentation/fb/index.rst
index d47313714635..baf02393d8ee 100644
--- a/Documentation/fb/index.rst
+++ b/Documentation/fb/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ============
 Frame Buffer
diff --git a/Documentation/fpga/index.rst b/Documentation/fpga/index.rst
index 2c87d1ea084f..f80f95667ca2 100644
--- a/Documentation/fpga/index.rst
+++ b/Documentation/fpga/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ====
 fpga
diff --git a/Documentation/ide/index.rst b/Documentation/ide/index.rst
index 45bc12d3957f..813dfe611a31 100644
--- a/Documentation/ide/index.rst
+++ b/Documentation/ide/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ==================================
 Integrated Drive Electronics (IDE)
diff --git a/Documentation/index.rst b/Documentation/index.rst
index e69d2fde7735..075c732501a2 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -35,6 +35,7 @@ trying to get it to work optimally on a given system.
    :maxdepth: 2
 
    admin-guide/index
+   kbuild/index
 
 Firmware-related documentation
 ------------------------------
@@ -77,6 +78,9 @@ merged much easier.
    kernel-hacking/index
    trace/index
    maintainer/index
+   fault-injection/index
+   livepatch/index
+
 
 Kernel API documentation
 ------------------------
@@ -94,12 +98,22 @@ needed).
    core-api/index
    accounting/index
    block/index
+   cdrom/index
+   ide/index
+   fb/index
+   fpga/index
    hid/index
    iio/index
    infiniband/index
    leds/index
    media/index
+   netlabel/index
    networking/index
+   pcmcia/index
+   power/index
+   target/index
+   timers/index
+   watchdog/index
    input/index
    hwmon/index
    gpu/index
diff --git a/Documentation/kbuild/index.rst b/Documentation/kbuild/index.rst
index 42d4cbe4460c..e323a3f2cc81 100644
--- a/Documentation/kbuild/index.rst
+++ b/Documentation/kbuild/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ===================
 Kernel Build System
diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index edd291d51847..17674a9e21b2 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ===================
 Kernel Livepatching
diff --git a/Documentation/netlabel/index.rst b/Documentation/netlabel/index.rst
index 47f1e0e5acd1..984e1b191b12 100644
--- a/Documentation/netlabel/index.rst
+++ b/Documentation/netlabel/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ========
 NetLabel
diff --git a/Documentation/pcmcia/index.rst b/Documentation/pcmcia/index.rst
index 779c8527109e..7ae1f62fca14 100644
--- a/Documentation/pcmcia/index.rst
+++ b/Documentation/pcmcia/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ======
 pcmcia
diff --git a/Documentation/power/index.rst b/Documentation/power/index.rst
index 20415f21e48a..002e42745263 100644
--- a/Documentation/power/index.rst
+++ b/Documentation/power/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ================
 Power Management
diff --git a/Documentation/target/index.rst b/Documentation/target/index.rst
index b68f48982392..4b24f81f747e 100644
--- a/Documentation/target/index.rst
+++ b/Documentation/target/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ==================
 TCM Virtual Device
diff --git a/Documentation/timers/index.rst b/Documentation/timers/index.rst
index 91f6f8263c48..df510ad0c989 100644
--- a/Documentation/timers/index.rst
+++ b/Documentation/timers/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ======
 timers
diff --git a/Documentation/watchdog/index.rst b/Documentation/watchdog/index.rst
index 33a0de631e84..c177645081d8 100644
--- a/Documentation/watchdog/index.rst
+++ b/Documentation/watchdog/index.rst
@@ -1,4 +1,4 @@
-:orphan:
+.. SPDX-License-Identifier: GPL-2.0
 
 ======================
 Linux Watchdog Support
-- 
2.21.0

