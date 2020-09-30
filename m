Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23128FBC8
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbgJOXo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:44:58 -0400
Received: from mailomta29-re.btinternet.com ([213.120.69.122]:12771 "EHLO
        re-prd-fep-043.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732877AbgJOXo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:44:58 -0400
Received: from re-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.54.8])
          by re-prd-fep-042.btinternet.com with ESMTP
          id <20200930094938.NUGK13627.re-prd-fep-042.btinternet.com@re-prd-rgout-005.btmx-prd.synchronoss.net>;
          Wed, 30 Sep 2020 10:49:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1601459378; 
        bh=GqbtTJobxnddkygFdq3baVZ7r4hha6OmE6WiBxVBwNU=;
        h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version;
        b=qaubQGkris5/I/PefYlao45hHlq4/nIEvvvyhh4AEpTjtOVNOVyJzjk0oBTwdgM4YFY1zJ5U8hFoFJEflFTbZdZRzTJSnGu6eyJ/dAdx8LRg6+gLz0PsBlSTp55hkSmog90q7pQgL3/Zqn7r2KSBUzD6nYQ1NLr4w9wB2Wv7c+SwtOWGY5Jn+8flY39OLh5bUVCfNiFOGjXapeIxL2n2+8jLBET/VJUwhziFwTKU/RQOqbgqP0Dod+ESHAx0cWJNFEqkzq0d9qG6S59jOE5YMOrFM0UArJK2FvTZe+FNOAH8H1I+0J+Bsq83LfeiDzkjUHcol/e4v1m37teRgKiOgg==
Authentication-Results: btinternet.com; none
X-Originating-IP: [81.141.56.129]
X-OWM-Source-IP: 81.141.56.129 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgdduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedtudenucenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhitghhrghrugcujfgrihhnvghsuceorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomheqnecuggftrfgrthhtvghrnhepuedttdelleehueeggfeihfeitdehueekffeviedtffegffeiueegleejgeevgfeinecukfhppeekuddrudeguddrheeirdduvdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeekuddrudeguddrheeirdduvdelpdhmrghilhhfrhhomhepoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqedprhgtphhtthhopeeojhhmohhrrhhishesnhgrmhgvihdrohhrgheqpdhrtghpthhtohepoehlrghfohhrghgvsehgnhhumhhonhhkshdrohhrgheqpdhrtghpthhtohepoehlihhnuhigqdhsvggtuhhrihhthidqmhhoughulhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeoohhsmhhotghomhdqnhgvthdqghhp
        rhhssehlihhsthhsrdhoshhmohgtohhmrdhorhhgqedprhgtphhtthhopeeophgrsghlohesnhgvthhfihhlthgvrhdrohhrgheqpdhrtghpthhtohepoehprghulhesphgruhhlqdhmohhorhgvrdgtohhmqedprhgtphhtthhopeeorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhequcfqtfevrffvpehrfhgtkedvvdenrhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhdprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheqpdhrtghpthhtohepoehsthgvphhhvghnrdhsmhgrlhhlvgihrdifohhrkhesghhmrghilhdrtghomheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from localhost.localdomain (81.141.56.129) by re-prd-rgout-005.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5ED9C74D136117DE; Wed, 30 Sep 2020 10:49:38 +0100
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, laforge@gnumonks.org, jmorris@namei.org,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: [PATCH 3/3] selinux: Add SELinux GTP support
Date:   Wed, 30 Sep 2020 10:49:34 +0100
Message-Id: <20200930094934.32144-4-richard_c_haines@btinternet.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930094934.32144-1-richard_c_haines@btinternet.com>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SELinux GTP implementation is explained in:
Documentation/security/GTP.rst

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 Documentation/security/GTP.rst      | 61 ++++++++++++++++++++++++++
 security/selinux/hooks.c            | 66 +++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +
 security/selinux/include/objsec.h   |  4 ++
 4 files changed, 133 insertions(+)

diff --git a/Documentation/security/GTP.rst b/Documentation/security/GTP.rst
index c748587ec..433fcb688 100644
--- a/Documentation/security/GTP.rst
+++ b/Documentation/security/GTP.rst
@@ -15,6 +15,9 @@ For security module support, three GTP specific hooks have been implemented::
     security_gtp_dev_free()
     security_gtp_dev_cmd()
 
+The usage of these hooks are described below with the SELinux implementation
+described in the `GTP SELinux Support`_ chapter.
+
 
 security_gtp_dev_alloc()
 ~~~~~~~~~~~~~~~~~~~~~~
@@ -37,3 +40,61 @@ zero on success, negative values on failure. The commands are based on values
 from ``include/uapi/linux/gtp.h`` as follows::
 
 ``enum gtp_genl_cmds { GTP_CMD_NEWPDP, GTP_CMD_DELPDP, GTP_CMD_GETPDP };``
+
+
+GTP SELinux Support
+===================
+
+Policy Statements
+-----------------
+The following class and permissions to support GTP are available within the
+kernel::
+
+    class gtp { add del get }
+
+The permissions are described in the sections that follow.
+
+
+Security Hooks
+--------------
+
+The `GTP LSM Support`_ chapter above describes the following GTP security
+hooks with the SELinux specifics expanded below::
+
+    security_gtp_dev_alloc -> selinux_gtp_dev_alloc_security(gtp)
+    security_gtp_dev_free  -> selinux_gtp_dev_free_security(gtp)
+    security_gtp_dev_cmd   -> selinux_gtp_dev_cmd(gtp, cmd)
+
+
+selinux_gtp_dev_alloc_security()
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Allocates a security structure for a GTP device provided the caller has the
+``gtp { add }`` permission. Can return errors ``-ENOMEM`` or ``-EACCES``.
+Returns zero if the security structure has been allocated.
+
+
+selinux_gtp_dev_free_security()
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Frees a security structure for a GTP device provided the caller has the
+``gtp { del }`` permission. Can return error ``-EACCES``. Returns zero if the
+security structure has been freed.
+
+
+selinux_gtp_dev_cmd()
+~~~~~~~~~~~~~~~~~~~~~
+Validate if the caller (current SID) and the GTP device SID have the required
+permission to perform the operation. The GTP/SELinux permission map is
+as follow::
+
+    GTP_CMD_NEWPDP = gtp { add }
+    GTP_CMD_DELPDP = gtp { del }
+    GTP_CMD_GETPDP = gtp { get }
+
+Returns ``-EACCES`` if denied or zero if allowed.
+
+NOTES::
+   1) If the GTP device has the ``{ add }`` permission it can add device and
+      also add PDP's (packet data protocol).
+
+   2) If the GTP device has the ``{ del }`` permission it can delete a device
+      and also delete PDP's.
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d6b182c11..5229a4f20 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
+#include <net/gtp.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -5520,6 +5521,68 @@ static int selinux_tun_dev_open(void *security)
 	return 0;
 }
 
+static int selinux_gtp_dev_alloc_security(struct gtp_dev *gtp)
+{
+	struct gtp_security_struct *gtpsec;
+	u32 sid = current_sid();
+	int err;
+
+	err = avc_has_perm(&selinux_state, sid, sid,
+			   SECCLASS_GTP, GTP__ADD, NULL);
+	if (err < 0)
+		return err;
+
+	gtpsec = kzalloc(sizeof(*gtpsec), GFP_KERNEL);
+	if (!gtpsec)
+		return -ENOMEM;
+
+	gtpsec->sid = sid;
+	gtp->security = gtpsec;
+
+	return 0;
+}
+
+static int selinux_gtp_dev_free_security(struct gtp_dev *gtp)
+{
+	struct gtp_security_struct *gtpsec = gtp->security;
+	u32 sid = current_sid();
+	int err;
+
+	err = avc_has_perm(&selinux_state, sid, gtpsec->sid,
+			   SECCLASS_GTP, GTP__DEL, NULL);
+	if (err < 0)
+		return err;
+
+	gtp->security = NULL;
+	kfree(gtpsec);
+
+	return 0;
+}
+
+static int selinux_gtp_dev_cmd(struct gtp_dev *gtp, enum gtp_genl_cmds cmd)
+{
+	struct gtp_security_struct *gtpsec = gtp->security;
+	u32 perm, sid = current_sid();
+
+	switch (cmd) {
+	case GTP_CMD_NEWPDP:
+		perm = GTP__ADD;
+		break;
+	case GTP_CMD_DELPDP:
+		perm = GTP__DEL;
+		break;
+	case GTP_CMD_GETPDP:
+		perm = GTP__GET;
+		break;
+	default:
+		WARN_ON(1);
+		return -EPERM;
+	}
+
+	return avc_has_perm(&selinux_state, sid, gtpsec->sid,
+			    SECCLASS_GTP, perm, NULL);
+}
+
 #ifdef CONFIG_NETFILTER
 
 static unsigned int selinux_ip_forward(struct sk_buff *skb,
@@ -7130,6 +7193,8 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
+	LSM_HOOK_INIT(gtp_dev_free_security, selinux_gtp_dev_free_security),
+	LSM_HOOK_INIT(gtp_dev_cmd, selinux_gtp_dev_cmd),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
 	LSM_HOOK_INIT(ib_endport_manage_subnet,
@@ -7204,6 +7269,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(inode_getsecctx, selinux_inode_getsecctx),
 	LSM_HOOK_INIT(sk_alloc_security, selinux_sk_alloc_security),
 	LSM_HOOK_INIT(tun_dev_alloc_security, selinux_tun_dev_alloc_security),
+	LSM_HOOK_INIT(gtp_dev_alloc_security, selinux_gtp_dev_alloc_security),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 40cebde62..3865a4549 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -249,6 +249,8 @@ struct security_class_mapping secclass_map[] = {
 	  {"open", "cpu", "kernel", "tracepoint", "read", "write"} },
 	{ "lockdown",
 	  { "integrity", "confidentiality", NULL } },
+	{ "gtp",
+	  { "add", "del", "get", NULL } },
 	{ NULL }
   };
 
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 330b7b6d4..311ffb6ea 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -148,6 +148,10 @@ struct perf_event_security_struct {
 	u32 sid;  /* SID of perf_event obj creator */
 };
 
+struct gtp_security_struct {
+	u32 sid;  /* SID of gtp obj creator */
+};
+
 extern struct lsm_blob_sizes selinux_blob_sizes;
 static inline struct task_security_struct *selinux_cred(const struct cred *cred)
 {
-- 
2.26.2

