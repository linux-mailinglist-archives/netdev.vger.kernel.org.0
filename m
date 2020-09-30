Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9528F887
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgJOS2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:28:04 -0400
Received: from mailomta3-re.btinternet.com ([213.120.69.96]:15879 "EHLO
        re-prd-fep-040.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727416AbgJOS2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:28:03 -0400
Received: from re-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.54.8])
          by re-prd-fep-048.btinternet.com with ESMTP
          id <20200930094937.RIOR4701.re-prd-fep-048.btinternet.com@re-prd-rgout-005.btmx-prd.synchronoss.net>;
          Wed, 30 Sep 2020 10:49:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1601459377; 
        bh=6y+3VUcd+KiANv8kuQjEep/9gfmUbV3RO7ckCcntMJc=;
        h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version;
        b=UYTM3JQCkzwhCDFxJaRS0WCwICDIyr86VVrNKfZ31ezkyFvNCjx446Tv/TCpTcviR2N+FF8ElREBhWjC/XzU2MbAc4CW6k/jYN6IH6KIK6Xt2Ux6N+F78XVrEUIyablcKl5jo403EM7PPKTPZ1AzkKBBoqtAj/U5kjouOjcBdH9QCcIrwaMnNOHgazbTX1PX7VBdEUmLtKdozyi1C2WgSUJxXP10nzvGXff+OGMHCkAINQZ+Rx0YUI9kZvKnKAkN3CZaNf/rlBOZpFZ3fNKDAMnOy3FU9jpYCkL2FFN15VRp+pR9ZVtqnWj4lNi3sL+wFMoTi7W39YDek5k1xKtxBg==
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
        id 5ED9C74D136117BE; Wed, 30 Sep 2020 10:49:37 +0100
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        pablo@netfilter.org, laforge@gnumonks.org, jmorris@namei.org,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: [PATCH 1/3] security: Add GPRS Tunneling Protocol (GTP) security hooks
Date:   Wed, 30 Sep 2020 10:49:32 +0100
Message-Id: <20200930094934.32144-2-richard_c_haines@btinternet.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930094934.32144-1-richard_c_haines@btinternet.com>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GTP security hooks are explained in:
Documentation/security/GTP.rst

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 Documentation/security/GTP.rst   | 39 ++++++++++++++++++++++++++++++++
 Documentation/security/index.rst |  1 +
 include/linux/lsm_hook_defs.h    |  3 +++
 include/linux/lsm_hooks.h        | 13 +++++++++++
 include/linux/security.h         | 22 ++++++++++++++++++
 security/security.c              | 18 +++++++++++++++
 6 files changed, 96 insertions(+)
 create mode 100644 Documentation/security/GTP.rst

diff --git a/Documentation/security/GTP.rst b/Documentation/security/GTP.rst
new file mode 100644
index 000000000..c748587ec
--- /dev/null
+++ b/Documentation/security/GTP.rst
@@ -0,0 +1,39 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================
+GPRS Tunneling Protocol (GTP)
+=============================
+
+GTP LSM Support
+===============
+
+Security Hooks
+--------------
+For security module support, three GTP specific hooks have been implemented::
+
+    security_gtp_dev_alloc()
+    security_gtp_dev_free()
+    security_gtp_dev_cmd()
+
+
+security_gtp_dev_alloc()
+~~~~~~~~~~~~~~~~~~~~~~
+Allows a module to allocate a security structure for a GTP device. Returns a
+zero on success, negative values on failure.
+If successful the GTP device ``struct gtp_dev`` will hold the allocated
+pointer in ``void *security;``.
+
+
+security_gtp_dev_free()
+~~~~~~~~~~~~~~~~~~~~~~
+Allows a module to free the security structure for a GTP device. Returns a
+zero on success, negative values on failure.
+
+
+security_gtp_dev_cmd()
+~~~~~~~~~~~~~~~~~~~~~~
+Allows a module to validate a command for the selected GTP device. Returns a
+zero on success, negative values on failure. The commands are based on values
+from ``include/uapi/linux/gtp.h`` as follows::
+
+``enum gtp_genl_cmds { GTP_CMD_NEWPDP, GTP_CMD_DELPDP, GTP_CMD_GETPDP };``
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 8129405eb..cdbdaa83b 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -16,3 +16,4 @@ Security Documentation
    siphash
    tpm/index
    digsig
+   GTP
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2a8c74d99..ad4bbe042 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -322,6 +322,9 @@ LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
 	 struct sockaddr *address, int addrlen)
 LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_endpoint *ep,
 	 struct sock *sk, struct sock *newsk)
+LSM_HOOK(int, 0, gtp_dev_alloc_security, struct gtp_dev *gtp)
+LSM_HOOK(int, 0, gtp_dev_free_security, struct gtp_dev *gtp)
+LSM_HOOK(int, 0, gtp_dev_cmd, struct gtp_dev *gtp, enum gtp_genl_cmds cmd)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 9e2e3e637..cd73319b9 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -982,6 +982,19 @@
  *	This hook can be used by the module to update any security state
  *	associated with the TUN device's security structure.
  *	@security pointer to the TUN devices's security structure.
+ * @gtp_dev_alloc_security:
+ *	Allocate and attach a security structure to the gtp->security field.
+ *	@gtp contains the GTP device structure to secure.
+ *	Returns a zero on success, negative values on failure.
+ * @gtp_dev_free_security:
+ *	Deallocate and free the security structure stored in gtp->security.
+ *	@gtp contains the GTP device structure to free.
+ *	Returns a zero on success, negative values on failure.
+ * @gtp_dev_cmd:
+ *	Check permissions according to the @cmd.
+ *	@gtp contains the GTP device to access.
+ *	@cmd contains the GTP command.
+ *	Returns a zero on success, negative values on failure.
  *
  * Security hooks for SCTP
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 0a0a03b36..e214605c2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/gtp.h>
 
 struct linux_binprm;
 struct cred;
@@ -58,6 +59,8 @@ struct fs_parameter;
 enum fs_value_type;
 struct watch;
 struct watch_notification;
+struct gtp_dev;
+enum gtp_genl_cmds;
 
 /* Default (no) options for the capable function */
 #define CAP_OPT_NONE 0x0
@@ -1365,6 +1368,9 @@ int security_sctp_bind_connect(struct sock *sk, int optname,
 			       struct sockaddr *address, int addrlen);
 void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
 			    struct sock *newsk);
+int security_gtp_dev_alloc(struct gtp_dev *gtp);
+int security_gtp_dev_free(struct gtp_dev *gtp);
+int security_gtp_dev_cmd(struct gtp_dev *gtp, enum gtp_genl_cmds cmd);
 
 #else	/* CONFIG_SECURITY_NETWORK */
 static inline int security_unix_stream_connect(struct sock *sock,
@@ -1582,6 +1588,22 @@ static inline void security_sctp_sk_clone(struct sctp_endpoint *ep,
 					  struct sock *newsk)
 {
 }
+
+static inline int security_gtp_dev_alloc(struct gtp_dev *gtp)
+{
+	return 0;
+}
+
+static inline int security_gtp_dev_free(struct gtp_dev *gtp)
+{
+	return 0;
+}
+
+static inline int security_gtp_dev_cmd(struct gtp_dev *gtp,
+				      enum gtp_genl_cmds cmd)
+{
+	return 0;
+}
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
diff --git a/security/security.c b/security/security.c
index 70a7ad357..12699a789 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2304,6 +2304,24 @@ void security_sctp_sk_clone(struct sctp_endpoint *ep, struct sock *sk,
 }
 EXPORT_SYMBOL(security_sctp_sk_clone);
 
+int security_gtp_dev_alloc(struct gtp_dev *gtp)
+{
+	return call_int_hook(gtp_dev_alloc_security, 0, gtp);
+}
+EXPORT_SYMBOL(security_gtp_dev_alloc);
+
+int security_gtp_dev_free(struct gtp_dev *gtp)
+{
+	return call_int_hook(gtp_dev_free_security, 0, gtp);
+}
+EXPORT_SYMBOL(security_gtp_dev_free);
+
+int security_gtp_dev_cmd(struct gtp_dev *gtp, enum gtp_genl_cmds cmd)
+{
+	return call_int_hook(gtp_dev_cmd, 0, gtp, cmd);
+}
+EXPORT_SYMBOL(security_gtp_dev_cmd);
+
 #endif	/* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-- 
2.26.2

