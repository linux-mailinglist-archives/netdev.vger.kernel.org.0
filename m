Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DBB442FD3
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhKBOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhKBOLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:11:18 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4237C061205;
        Tue,  2 Nov 2021 07:08:42 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8B19CC01C; Tue,  2 Nov 2021 15:08:41 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 48EDAC009;
        Tue,  2 Nov 2021 15:08:36 +0100 (CET)
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id efde8c5c;
        Tue, 2 Nov 2021 13:46:12 +0000 (UTC)
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 1/4] 9p: fix file headers
Date:   Tue,  2 Nov 2021 22:46:05 +0900
Message-Id: <20211102134608.1588018-2-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
References: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

- add missing SPDX-License-Identifier
- remove (sometimes incorrect) file name from file header

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/acl.c                | 10 +---------
 fs/9p/acl.h                | 10 +---------
 fs/9p/v9fs.c               |  2 --
 fs/9p/vfs_addr.c           |  2 --
 fs/9p/vfs_dentry.c         |  2 --
 fs/9p/vfs_dir.c            |  2 --
 fs/9p/vfs_file.c           |  2 --
 fs/9p/vfs_inode.c          |  2 --
 fs/9p/vfs_inode_dotl.c     |  2 --
 fs/9p/vfs_super.c          |  4 ----
 fs/9p/xattr.c              | 10 +---------
 fs/9p/xattr.h              | 10 +---------
 include/net/9p/9p.h        |  2 --
 include/net/9p/client.h    |  2 --
 include/net/9p/transport.h |  2 --
 net/9p/client.c            |  2 --
 net/9p/error.c             |  2 --
 net/9p/mod.c               |  2 --
 net/9p/protocol.c          |  2 --
 net/9p/protocol.h          |  2 --
 net/9p/trans_common.c      | 10 +---------
 net/9p/trans_common.h      | 10 +---------
 net/9p/trans_fd.c          |  2 --
 net/9p/trans_rdma.c        |  2 --
 net/9p/trans_xen.c         | 25 +------------------------
 25 files changed, 7 insertions(+), 116 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index c381499f5416..d2ce7b7be93f 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright IBM Corporation, 2010
  * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #include <linux/module.h>
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index d43c8949e807..cc741945c160 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -1,15 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright IBM Corporation, 2010
  * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 #ifndef FS_9P_ACL_H
 #define FS_9P_ACL_H
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index cf5eacbf4e2f..0973d7a3536b 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/v9fs.c
- *
  *  This file contains functions assisting in mapping VFS to 9P2000
  *
  *  Copyright (C) 2004-2008 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 2a2368d83868..fc8feb4f320e 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_addr.c
- *
  * This file contians vfs address (mmap) ops for 9P2000.
  *
  *  Copyright (C) 2005 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 4b4292123b3d..a0b660e47e46 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_dentry.c
- *
  * This file contians vfs dentry ops for the 9P2000 protocol.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 61b29bad6d9a..8c854d8cb0cd 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * linux/fs/9p/vfs_dir.c
- *
  * This file contains vfs directory ops for the 9P2000 protocol.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 8d5e0ef5518e..07aad7d6a09a 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_file.c
- *
  * This file contians vfs file ops for 9P2000.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 08f48b70a741..441f62d22064 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_inode.c
- *
  * This file contains vfs inode ops for the 9P2000 protocol.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 01b9e1281a29..272dddcbcde6 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_inode_dotl.c
- *
  * This file contains vfs inode ops for the 9P2000.L protocol.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 5fce6e30bc5a..c6028af51925 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -1,9 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/fs/9p/vfs_super.c
- *
- * This file contians superblock ops for 9P2000. It is intended that
- * you mount this file system on directories.
  *
  *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
  *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index ee331845e2c7..a824441b95a2 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright IBM Corporation, 2010
  * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #include <linux/module.h>
diff --git a/fs/9p/xattr.h b/fs/9p/xattr.h
index c63c3bea5de5..e097f0f112d6 100644
--- a/fs/9p/xattr.h
+++ b/fs/9p/xattr.h
@@ -1,15 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright IBM Corporation, 2010
  * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 #ifndef FS_9P_XATTR_H
 #define FS_9P_XATTR_H
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 03614de86942..ff2b7f408966 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * include/net/9p/9p.h
- *
  * 9P protocol definitions.
  *
  *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index e1c308d8d288..2675b8413b5e 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * include/net/9p/client.h
- *
  * 9P Client Definitions
  *
  *  Copyright (C) 2008 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 581555d88cba..86845e965efe 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * include/net/9p/transport.h
- *
  * Transport Definition
  *
  *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
diff --git a/net/9p/client.c b/net/9p/client.c
index 7973267ec846..fc480a230efa 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * net/9p/clnt.c
- *
  * 9P Client
  *
  *  Copyright (C) 2008 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/net/9p/error.c b/net/9p/error.c
index 61c18daf3050..a962217fc158 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * linux/fs/9p/error.c
- *
  * Error string handling
  *
  * Plan 9 uses error strings, Unix uses error numbers.  These functions
diff --git a/net/9p/mod.c b/net/9p/mod.c
index aa38b8b0e0f6..d38358c085ff 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  net/9p/9p.c
- *
  *  9P entry point
  *
  *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 03593eb240d8..ba2a72c4655e 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * net/9p/protocol.c
- *
  * 9P Protocol Support Code
  *
  *  Copyright (C) 2008 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/net/9p/protocol.h b/net/9p/protocol.h
index 6835f91cfda5..39eab817f03d 100644
--- a/net/9p/protocol.h
+++ b/net/9p/protocol.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * net/9p/protocol.h
- *
  * 9P Protocol Support Code
  *
  *  Copyright (C) 2008 by Eric Van Hensbergen <ericvh@gmail.com>
diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index 6ea5ea548cd4..c827f694551c 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  * Copyright IBM Corporation, 2010
  * Author Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #include <linux/mm.h>
diff --git a/net/9p/trans_common.h b/net/9p/trans_common.h
index c43babb3f635..bab083353ad9 100644
--- a/net/9p/trans_common.h
+++ b/net/9p/trans_common.h
@@ -1,15 +1,7 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
 /*
  * Copyright IBM Corporation, 2010
  * Author Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 void p9_release_pages(struct page **, int);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 007bbcc68010..827c47620fc0 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * linux/fs/9p/trans_fd.c
- *
  * Fd transport layer.  Includes deprecated socket layer.
  *
  *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 480fd27760d7..88e563826674 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * linux/fs/9p/trans_rdma.c
- *
  * RDMA transport layer based on the trans_fd.c implementation.
  *
  *  Copyright (C) 2008 by Tom Tucker <tom@opengridcomputing.com>
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index e264dcee019a..2418fa0b58f3 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -1,33 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * linux/fs/9p/trans_xen
  *
  * Xen transport layer.
  *
  * Copyright (C) 2017 by Stefano Stabellini <stefano@aporeto.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation; or, when distributed
- * separately from the Linux kernel or incorporated into other
- * software packages, subject to the following license:
- *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this source file (the "Software"), to deal in the Software without
- * restriction, including without limitation the rights to use, copy, modify,
- * merge, publish, distribute, sublicense, and/or sell copies of the Software,
- * and to permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
- * IN THE SOFTWARE.
  */
 
 #include <xen/events.h>
-- 
2.31.1

