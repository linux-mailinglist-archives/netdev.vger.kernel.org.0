Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5531876499
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfGZLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:32:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfGZLcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OuafK/TTQcFkrbP+suIfTDa/h6nPmDJ0gGHTBNIInGY=; b=bdXD4iNcznYpRIDy+A6+1cNPrh
        cV+a+fbj4fYJ2Mg+9eyczrEI2wWXXZTikDxJeLis7Y2vV/8BCmFckYIL7TCyk5M1UlhUv6eR0U/+h
        HADLDxuO1Q1CF//PiXXy0UDgcevCFLZ3asloJtgzcFkgQmVi7C0JHTCA41LhbF69P6sC6/YUdHbYm
        vr8rpNRfDH9dQWEAeOOqCB7xoWDgGnMbkTAJdXAALiYFU+WirA1kBnPgwfDhk4IAO74wPC5VozQrO
        jMgKffk5q0vLdNtCiNftcTQw4rkeTh1nUc6iunzfA4KkG3jbvCm6cK/h2pCh1bEIzKYaBgeblz8ex
        tKsbR5fg==;
Received: from [179.95.31.157] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqyRb-0005vN-Ss; Fri, 26 Jul 2019 11:31:28 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hqyRZ-0008Eq-NT; Fri, 26 Jul 2019 08:31:25 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-sh@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH v2 10/10] docs: remove extra conf.py files
Date:   Fri, 26 Jul 2019 08:31:24 -0300
Message-Id: <4b04d4e7df9b638de0919417da31af491833400f.1564139914.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1564139914.git.mchehab+samsung@kernel.org>
References: <cover.1564139914.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the latex_documents are handled automatically, we can
remove those extra conf.py files.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/admin-guide/conf.py      | 10 ----------
 Documentation/core-api/conf.py         | 10 ----------
 Documentation/crypto/conf.py           | 10 ----------
 Documentation/dev-tools/conf.py        | 10 ----------
 Documentation/doc-guide/conf.py        | 10 ----------
 Documentation/driver-api/80211/conf.py | 10 ----------
 Documentation/driver-api/conf.py       | 10 ----------
 Documentation/driver-api/pm/conf.py    | 10 ----------
 Documentation/filesystems/conf.py      | 10 ----------
 Documentation/gpu/conf.py              | 10 ----------
 Documentation/input/conf.py            | 10 ----------
 Documentation/kernel-hacking/conf.py   | 10 ----------
 Documentation/maintainer/conf.py       | 10 ----------
 Documentation/media/conf.py            | 12 ------------
 Documentation/networking/conf.py       | 10 ----------
 Documentation/process/conf.py          | 10 ----------
 Documentation/sh/conf.py               | 10 ----------
 Documentation/sound/conf.py            | 10 ----------
 Documentation/userspace-api/conf.py    | 10 ----------
 Documentation/vm/conf.py               | 10 ----------
 Documentation/x86/conf.py              | 10 ----------
 21 files changed, 212 deletions(-)
 delete mode 100644 Documentation/admin-guide/conf.py
 delete mode 100644 Documentation/core-api/conf.py
 delete mode 100644 Documentation/crypto/conf.py
 delete mode 100644 Documentation/dev-tools/conf.py
 delete mode 100644 Documentation/doc-guide/conf.py
 delete mode 100644 Documentation/driver-api/80211/conf.py
 delete mode 100644 Documentation/driver-api/conf.py
 delete mode 100644 Documentation/driver-api/pm/conf.py
 delete mode 100644 Documentation/filesystems/conf.py
 delete mode 100644 Documentation/gpu/conf.py
 delete mode 100644 Documentation/input/conf.py
 delete mode 100644 Documentation/kernel-hacking/conf.py
 delete mode 100644 Documentation/maintainer/conf.py
 delete mode 100644 Documentation/media/conf.py
 delete mode 100644 Documentation/networking/conf.py
 delete mode 100644 Documentation/process/conf.py
 delete mode 100644 Documentation/sh/conf.py
 delete mode 100644 Documentation/sound/conf.py
 delete mode 100644 Documentation/userspace-api/conf.py
 delete mode 100644 Documentation/vm/conf.py
 delete mode 100644 Documentation/x86/conf.py

diff --git a/Documentation/admin-guide/conf.py b/Documentation/admin-guide/conf.py
deleted file mode 100644
index 86f738953799..000000000000
--- a/Documentation/admin-guide/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = 'Linux Kernel User Documentation'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'linux-user.tex', 'Linux Kernel User Documentation',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/core-api/conf.py b/Documentation/core-api/conf.py
deleted file mode 100644
index db1f7659f3da..000000000000
--- a/Documentation/core-api/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Core-API Documentation"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'core-api.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/crypto/conf.py b/Documentation/crypto/conf.py
deleted file mode 100644
index 4335d251ddf3..000000000000
--- a/Documentation/crypto/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = 'Linux Kernel Crypto API'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'crypto-api.tex', 'Linux Kernel Crypto API manual',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/dev-tools/conf.py b/Documentation/dev-tools/conf.py
deleted file mode 100644
index 7faafa3f7888..000000000000
--- a/Documentation/dev-tools/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Development tools for the kernel"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'dev-tools.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/doc-guide/conf.py b/Documentation/doc-guide/conf.py
deleted file mode 100644
index fd3731182d5a..000000000000
--- a/Documentation/doc-guide/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = 'Linux Kernel Documentation Guide'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'kernel-doc-guide.tex', 'Linux Kernel Documentation Guide',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/driver-api/80211/conf.py b/Documentation/driver-api/80211/conf.py
deleted file mode 100644
index 4424b4b0b9c3..000000000000
--- a/Documentation/driver-api/80211/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux 802.11 Driver Developer's Guide"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', '80211.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/driver-api/conf.py b/Documentation/driver-api/conf.py
deleted file mode 100644
index 202726d20088..000000000000
--- a/Documentation/driver-api/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "The Linux driver implementer's API guide"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'driver-api.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/driver-api/pm/conf.py b/Documentation/driver-api/pm/conf.py
deleted file mode 100644
index a89fac11272f..000000000000
--- a/Documentation/driver-api/pm/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Device Power Management"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'pm.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/filesystems/conf.py b/Documentation/filesystems/conf.py
deleted file mode 100644
index ea44172af5c4..000000000000
--- a/Documentation/filesystems/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux Filesystems API"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'filesystems.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/gpu/conf.py b/Documentation/gpu/conf.py
deleted file mode 100644
index 1757b040fb32..000000000000
--- a/Documentation/gpu/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux GPU Driver Developer's Guide"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'gpu.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/input/conf.py b/Documentation/input/conf.py
deleted file mode 100644
index d2352fdc92ed..000000000000
--- a/Documentation/input/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "The Linux input driver subsystem"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'linux-input.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/kernel-hacking/conf.py b/Documentation/kernel-hacking/conf.py
deleted file mode 100644
index 3d8acf0f33ad..000000000000
--- a/Documentation/kernel-hacking/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Kernel Hacking Guides"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'kernel-hacking.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/maintainer/conf.py b/Documentation/maintainer/conf.py
deleted file mode 100644
index 81e9eb7a7884..000000000000
--- a/Documentation/maintainer/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = 'Linux Kernel Development Documentation'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'maintainer.tex', 'Linux Kernel Development Documentation',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
deleted file mode 100644
index 1f194fcd2cae..000000000000
--- a/Documentation/media/conf.py
+++ /dev/null
@@ -1,12 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-# SPDX-License-Identifier: GPL-2.0
-
-project = 'Linux Media Subsystem Documentation'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'media.tex', 'Linux Media Subsystem Documentation',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/networking/conf.py b/Documentation/networking/conf.py
deleted file mode 100644
index 40f69e67a883..000000000000
--- a/Documentation/networking/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux Networking Documentation"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'networking.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/process/conf.py b/Documentation/process/conf.py
deleted file mode 100644
index 1b01a80ad9ce..000000000000
--- a/Documentation/process/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = 'Linux Kernel Development Documentation'
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'process.tex', 'Linux Kernel Development Documentation',
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/sh/conf.py b/Documentation/sh/conf.py
deleted file mode 100644
index 1eb684a13ac8..000000000000
--- a/Documentation/sh/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "SuperH architecture implementation manual"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'sh.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/sound/conf.py b/Documentation/sound/conf.py
deleted file mode 100644
index 3f1fc5e74e7b..000000000000
--- a/Documentation/sound/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux Sound Subsystem Documentation"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'sound.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/userspace-api/conf.py b/Documentation/userspace-api/conf.py
deleted file mode 100644
index 2eaf59f844e5..000000000000
--- a/Documentation/userspace-api/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "The Linux kernel user-space API guide"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'userspace-api.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/vm/conf.py b/Documentation/vm/conf.py
deleted file mode 100644
index 3b0b601af558..000000000000
--- a/Documentation/vm/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "Linux Memory Management Documentation"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'memory-management.tex', project,
-     'The kernel development community', 'manual'),
-]
diff --git a/Documentation/x86/conf.py b/Documentation/x86/conf.py
deleted file mode 100644
index 33c5c3142e20..000000000000
--- a/Documentation/x86/conf.py
+++ /dev/null
@@ -1,10 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-
-project = "X86 architecture specific documentation"
-
-tags.add("subproject")
-
-latex_documents = [
-    ('index', 'x86.tex', project,
-     'The kernel development community', 'manual'),
-]
-- 
2.21.0

