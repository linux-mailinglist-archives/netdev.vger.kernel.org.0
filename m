Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E160102F7F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKSWrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:47:53 -0500
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:36500
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbfKSWrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203671; bh=T+7vkOglemjDcJCtI0jsgL0AaHeYGYB4YiqPLcOqBMY=; h=From:To:Subject:Date:In-Reply-To:References:From:Subject; b=adOlp2wiyUcWnruMTmCfV+Vr/qhQ2JvvQmKjbakyTWkpHxAJ3pb0oImL/E8wkShRKHhXF83lBsJO3T5N+dVk9DjJHOgjLa25zv207AJEO8AT/nzmWjd3oZ1+Tcwgr7JbHcwmfltux3fSwvGpcIHtWhJsXiJKRiI2Wa1JL2bIJnmqe96txngdlsjuOVE75H8xUIcDF0ud1vO5F23333irQkdLfGva0ofulfbRxaik4BgAk6xsFvglx6l65Y6k8P+rgWtrT8uPA3Hvm/L7IhgeCPTTKiD6arOOrBCI5BbtR/odmRcilHtIushrXc88uwTOz6ZVkmRhJzKVujfFq8SOQw==
X-YMail-OSG: jXANnlcVM1nCSOGcID_Ab8aov7TE5mSeu6j0pBarBlBMyKAbj8ebvKyWtiijwL5
 BHuliD_ED96eEBhgWg_mo.m92XNEgk5EtsbCmbBJRtQnw2PuUHP6YV5cFI.0ginoeENp7fOmGjxj
 hCJIsOdU.Spt8VY4s3SH9VPft46pI42lcH56aPI_x3GY3dX7id.JlPGk5JATR9FXRV0r_bSqnASy
 NATa1_Ol8tOlK4I8vd5yh_yiKSh34WvJQ60W2Y1H506zQ91KMDif42s.XWUVUNOuxpsfoUfIwYTg
 kjV2EvTb2JK35Gurw07ZBlPVjG77Q53slnIs4T3aAYsVqWhw3sAtVirUtphRykNjpQo1hX06Ki90
 IBIN1MhKf9Mym281RyphfuUTLHSP80EGyPrbndwIWL0u9i02JhKXV1ilZ4S.EDqEWnRAbCpNDFIK
 AILB7wl7hDfP3fGIl4Rh6npM1N32YJCj1YDDIv2.l3Cvlu2eAtnBgTPslsGrRBx0LWPY5IACyS.h
 UPTdz__LCkkFOqInwZMOYRAZaLGMEG3.R3s4YJutbLa3k1sIoxiuM3SDBug5vE6D3R5jzaCN4Utd
 ZO3ntaHBxxdW6.0jozNOLGexnzUmAIAtu4tdy2HNcOWbz9Xf.EywTD6aORU3HFcs21cKxEseTxyD
 EOIMK9o6E9y6gSa3R1ouMFfAiuo2dVW1pGiuDkPVY1sqozTJvJbd2fL7c6wrw5gQ9DrHE9efcfy3
 3RrQbUphSkM1Q3iEgLX9czSWDkiGE5FBgPhQeZ17CneNnIAx0U6VgacQ7kUKqk.tcpTOW7L0Z.A8
 aHHndBXHWpu1pzOks6wsYb3cnegjR.LU.m58zD24G28tc9eqeJcqDMjq2Ra.NawpcENUcpKdWgzc
 hDYajToaAWjZhliuZv79OVtRWYMqlaEvBVN3V2.c38CsmHKSrg1RpJ43_07kSRJyk5wzjD9KTHO5
 mHRH0uAkChHNruP4F_c1bbQOuCC1P_WIRl.cyj8PiR0TdwWSTSFTcDmmhPwY5GXhvJ4SHEFv1L4k
 rUQpQvD4NbY4nb.IEgBYufBXLxhELs7zfhwMfrpuUd8Agf.ceqb62sjX6tjyjMTryWCwtWfXXEbs
 BNjhX00wSUcfcgLhoSatZi3uMxxS91AGUzfDTn1lHHPcexsr_mbYgNU94kJRBJWeqwJmGi5b3MA_
 bN91p.iRQdwNs8nCqo6oBLk4QZ3OiO9lEeu_hXaPJKDpwmvn4hmNah.RHiFtL1BsWQXUVbgzehtx
 W2JtrUy_EkHddNgu2UVZRDgbkdB.K1PjfRVYVKVpRZHJUG6tO6AO9zsdDmrz7XoLghhQm_UNc3Hj
 lcXmZtVXNeMDO5.YS2iDjRLlf60rEo4tc4mji7Mb0aaK_luRbKna_T3GPlk1dm_9caWI4R1dElbR
 KRVMk5yvee9yohPqb8T1YpYbwgsDgIQZemVQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:47:51 +0000
Received: by smtp420.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 8bee77f89adf38a723fc4d156e28321a;
          Tue, 19 Nov 2019 22:47:49 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 13/25] LSM: Specify which LSM to display
Date:   Tue, 19 Nov 2019 14:47:08 -0800
Message-Id: <20191119224714.13491-7-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119224714.13491-1-casey@schaufler-ca.com>
References: <20191119224714.13491-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new entry "display" in the procfs attr directory for
controlling which LSM security information is displayed for a
process. A process can only read or write its own display value.

The name of an active LSM that supplies hooks for
human readable data may be written to "display" to set the
value. The name of the LSM currently in use can be read from
"display". At this point there can only be one LSM capable
of display active. A helper function lsm_task_display() is
provided to get the display slot for a task_struct.

Setting the "display" requires that all security modules using
setprocattr hooks allow the action. Each security module is
responsible for defining its policy.

AppArmor hook provided by John Johansen <john.johansen@canonical.com>
SELinux hook provided by Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 fs/proc/base.c                       |   1 +
 include/linux/lsm_hooks.h            |  15 +++
 security/apparmor/include/apparmor.h |   3 +-
 security/apparmor/lsm.c              |  32 +++++
 security/security.c                  | 169 ++++++++++++++++++++++++---
 security/selinux/hooks.c             |  11 ++
 security/selinux/include/classmap.h  |   2 +-
 security/smack/smack_lsm.c           |   7 ++
 8 files changed, 221 insertions(+), 19 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea9501afb8..950c200cb9ad 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2652,6 +2652,7 @@ static const struct pid_entry attr_dir_stuff[] = {
 	ATTR(NULL, "fscreate",		0666),
 	ATTR(NULL, "keycreate",		0666),
 	ATTR(NULL, "sockcreate",	0666),
+	ATTR(NULL, "display",		0666),
 #ifdef CONFIG_SECURITY_SMACK
 	DIR("smack",			0555,
 	    proc_smack_attr_dir_inode_ops, proc_smack_attr_dir_ops),
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index cfe5393840c7..b2ec81fcd1e2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -2171,4 +2171,19 @@ static inline void security_delete_hooks(struct security_hook_list *hooks,
 
 extern int lsm_inode_alloc(struct inode *inode);
 
+/**
+ * lsm_task_display - the "display" LSM for this task
+ * @task: The task to report on
+ *
+ * Returns the task's display LSM slot.
+ */
+static inline int lsm_task_display(struct task_struct *task)
+{
+	int *display = task->security;
+
+	if (display)
+		return *display;
+	return LSMBLOB_INVALID;
+}
+
 #endif /* ! __LINUX_LSM_HOOKS_H */
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 6b7e6e13176e..e4b43e5bb8f9 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -28,8 +28,9 @@
 #define AA_CLASS_SIGNAL		10
 #define AA_CLASS_NET		14
 #define AA_CLASS_LABEL		16
+#define AA_CLASS_DISPLAY_LSM	17
 
-#define AA_CLASS_LAST		AA_CLASS_LABEL
+#define AA_CLASS_LAST		AA_CLASS_DISPLAY_LSM
 
 /* Control parameters settable through module/boot flags */
 extern enum audit_mode aa_g_audit;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 11845348eefb..fefccd559541 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -599,6 +599,25 @@ static int apparmor_getprocattr(struct task_struct *task, char *name,
 	return error;
 }
 
+
+static int profile_display_lsm(struct aa_profile *profile,
+			       struct common_audit_data *sa)
+{
+	struct aa_perms perms = { };
+	unsigned int state;
+
+	state = PROFILE_MEDIATES(profile, AA_CLASS_DISPLAY_LSM);
+	if (state) {
+		aa_compute_perms(profile->policy.dfa, state, &perms);
+		aa_apply_modes_to_perms(profile, &perms);
+		aad(sa)->label = &profile->label;
+
+		return aa_check_perms(profile, &perms, AA_MAY_WRITE, sa, NULL);
+	}
+
+	return 0;
+}
+
 static int apparmor_setprocattr(const char *name, void *value,
 				size_t size)
 {
@@ -610,6 +629,19 @@ static int apparmor_setprocattr(const char *name, void *value,
 	if (size == 0)
 		return -EINVAL;
 
+	/* LSM infrastructure does actual setting of display if allowed */
+	if (!strcmp(name, "display")) {
+		struct aa_profile *profile;
+		struct aa_label *label;
+
+		aad(&sa)->info = "set display lsm";
+		label = begin_current_label_crit_section();
+		error = fn_for_each_confined(label, profile,
+					     profile_display_lsm(profile, &sa));
+		end_current_label_crit_section(label);
+		return error;
+	}
+
 	/* AppArmor requires that the buffer must be null terminated atm */
 	if (args[size - 1] != '\0') {
 		/* null terminate */
diff --git a/security/security.c b/security/security.c
index 3aba440624f9..c2874f6587d2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/string.h>
 #include <linux/msg.h>
+#include <linux/binfmts.h>
 #include <net/flow.h>
 #include <net/sock.h>
 
@@ -43,7 +44,14 @@ static struct kmem_cache *lsm_file_cache;
 static struct kmem_cache *lsm_inode_cache;
 
 char *lsm_names;
-static struct lsm_blob_sizes blob_sizes __lsm_ro_after_init;
+
+/*
+ * The task blob includes the "display" slot used for
+ * chosing which module presents contexts.
+ */
+static struct lsm_blob_sizes blob_sizes __lsm_ro_after_init = {
+	.lbs_task = sizeof(int),
+};
 
 /* Boot-time LSM user choice */
 static __initdata const char *chosen_lsm_order;
@@ -438,8 +446,10 @@ static int lsm_append(const char *new, char **result)
 
 /*
  * Current index to use while initializing the lsmblob secid list.
+ * Pointers to the LSM id structures for local use.
  */
 static int lsm_slot __lsm_ro_after_init;
+static struct lsm_id *lsm_slotlist[LSMBLOB_ENTRIES];
 
 /**
  * security_add_hooks - Add a modules hooks to the hook lists.
@@ -459,6 +469,7 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
 	if (lsmid->slot == LSMBLOB_NEEDED) {
 		if (lsm_slot >= LSMBLOB_ENTRIES)
 			panic("%s Too many LSMs registered.\n", __func__);
+		lsm_slotlist[lsm_slot] = lsmid;
 		lsmid->slot = lsm_slot++;
 		init_debug("%s assigned lsmblob slot %d\n", lsmid->lsm,
 			   lsmid->slot);
@@ -588,6 +599,8 @@ int lsm_inode_alloc(struct inode *inode)
  */
 static int lsm_task_alloc(struct task_struct *task)
 {
+	int *display;
+
 	if (blob_sizes.lbs_task == 0) {
 		task->security = NULL;
 		return 0;
@@ -596,6 +609,15 @@ static int lsm_task_alloc(struct task_struct *task)
 	task->security = kzalloc(blob_sizes.lbs_task, GFP_KERNEL);
 	if (task->security == NULL)
 		return -ENOMEM;
+
+	/*
+	 * The start of the task blob contains the "display" LSM slot number.
+	 * Start with it set to the invalid slot number, indicating that the
+	 * default first registered LSM be displayed.
+	 */
+	display = task->security;
+	*display = LSMBLOB_INVALID;
+
 	return 0;
 }
 
@@ -1551,14 +1573,26 @@ int security_file_open(struct file *file)
 
 int security_task_alloc(struct task_struct *task, unsigned long clone_flags)
 {
+	int *odisplay = current->security;
+	int *ndisplay;
 	int rc = lsm_task_alloc(task);
 
-	if (rc)
+	if (unlikely(rc))
 		return rc;
+
 	rc = call_int_hook(task_alloc, 0, task, clone_flags);
-	if (unlikely(rc))
+	if (unlikely(rc)) {
 		security_task_free(task);
-	return rc;
+		return rc;
+	}
+
+	if (odisplay) {
+		ndisplay = task->security;
+		if (ndisplay)
+			*ndisplay = *odisplay;
+	}
+
+	return 0;
 }
 
 void security_task_free(struct task_struct *task)
@@ -1955,23 +1989,110 @@ int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
 				char **value)
 {
 	struct security_hook_list *hp;
+	int display = lsm_task_display(current);
+	int slot = 0;
+
+	if (!strcmp(name, "display")) {
+		/*
+		 * lsm_slot will be 0 if there are no displaying modules.
+		 */
+		if (lsm_slot == 0)
+			return -EINVAL;
+
+		/*
+		 * Only allow getting the current process' display.
+		 * There are too few reasons to get another process'
+		 * display and too many LSM policy issues.
+		 */
+		if (current != p)
+			return -EINVAL;
+
+		display = lsm_task_display(p);
+		if (display != LSMBLOB_INVALID)
+			slot = display;
+		*value = kstrdup(lsm_slotlist[slot]->lsm, GFP_KERNEL);
+		if (*value)
+			return strlen(*value);
+		return -ENOMEM;
+	}
 
 	hlist_for_each_entry(hp, &security_hook_heads.getprocattr, list) {
 		if (lsm != NULL && strcmp(lsm, hp->lsmid->lsm))
 			continue;
+		if (lsm == NULL && display != LSMBLOB_INVALID &&
+		    display != hp->lsmid->slot)
+			continue;
 		return hp->hook.getprocattr(p, name, value);
 	}
 	return -EINVAL;
 }
 
+/**
+ * security_setprocattr - Set process attributes via /proc
+ * @lsm: name of module involved, or NULL
+ * @name: name of the attribute
+ * @value: value to set the attribute to
+ * @size: size of the value
+ *
+ * Set the process attribute for the specified security module
+ * to the specified value. Note that this can only be used to set
+ * the process attributes for the current, or "self" process.
+ * The /proc code has already done this check.
+ *
+ * Returns 0 on success, an appropriate code otherwise.
+ */
 int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size)
 {
 	struct security_hook_list *hp;
+	char *term;
+	char *cp;
+	int *display = current->security;
+	int rc = -EINVAL;
+	int slot = 0;
+
+	if (!strcmp(name, "display")) {
+		/*
+		 * Change the "display" value only if all the security
+		 * modules that support setting a procattr allow it.
+		 * It is assumed that all such security modules will be
+		 * cooperative.
+		 */
+		if (size == 0)
+			return -EINVAL;
+
+		hlist_for_each_entry(hp, &security_hook_heads.setprocattr,
+				     list) {
+			rc = hp->hook.setprocattr(name, value, size);
+			if (rc < 0)
+				return rc;
+		}
+
+		rc = -EINVAL;
+
+		term = kmemdup_nul(value, size, GFP_KERNEL);
+		if (term == NULL)
+			return -ENOMEM;
+
+		cp = strsep(&term, " \n");
+
+		for (slot = 0; slot < lsm_slot; slot++)
+			if (!strcmp(cp, lsm_slotlist[slot]->lsm)) {
+				*display = lsm_slotlist[slot]->slot;
+				rc = size;
+				break;
+			}
+
+		kfree(cp);
+		return rc;
+	}
 
 	hlist_for_each_entry(hp, &security_hook_heads.setprocattr, list) {
 		if (lsm != NULL && strcmp(lsm, hp->lsmid->lsm))
 			continue;
+		if (lsm == NULL && *display != LSMBLOB_INVALID &&
+		    *display != hp->lsmid->slot)
+			continue;
 		return hp->hook.setprocattr(name, value, size);
 	}
 	return -EINVAL;
@@ -1991,15 +2112,15 @@ EXPORT_SYMBOL(security_ismaclabel);
 int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
 {
 	struct security_hook_list *hp;
-	int rc;
+	int display = lsm_task_display(current);
 
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		rc = hp->hook.secid_to_secctx(blob->secid[hp->lsmid->slot],
-					      secdata, seclen);
-		if (rc != 0)
-			return rc;
+		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
+			return hp->hook.secid_to_secctx(
+					blob->secid[hp->lsmid->slot],
+					secdata, seclen);
 	}
 	return 0;
 }
@@ -2009,16 +2130,15 @@ int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob)
 {
 	struct security_hook_list *hp;
-	int rc;
+	int display = lsm_task_display(current);
 
 	lsmblob_init(blob, 0);
 	hlist_for_each_entry(hp, &security_hook_heads.secctx_to_secid, list) {
 		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
 			continue;
-		rc = hp->hook.secctx_to_secid(secdata, seclen,
-					      &blob->secid[hp->lsmid->slot]);
-		if (rc != 0)
-			return rc;
+		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
+			return hp->hook.secctx_to_secid(secdata, seclen,
+						&blob->secid[hp->lsmid->slot]);
 	}
 	return 0;
 }
@@ -2026,7 +2146,15 @@ EXPORT_SYMBOL(security_secctx_to_secid);
 
 void security_release_secctx(char *secdata, u32 seclen)
 {
-	call_void_hook(release_secctx, secdata, seclen);
+	struct security_hook_list *hp;
+	int *display = current->security;
+
+	hlist_for_each_entry(hp, &security_hook_heads.release_secctx, list)
+		if (display == NULL || *display == LSMBLOB_INVALID ||
+		    *display == hp->lsmid->slot) {
+			hp->hook.release_secctx(secdata, seclen);
+			return;
+		}
 }
 EXPORT_SYMBOL(security_release_secctx);
 
@@ -2151,8 +2279,15 @@ EXPORT_SYMBOL(security_sock_rcv_skb);
 int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
 				      int __user *optlen, unsigned len)
 {
-	return call_int_hook(socket_getpeersec_stream, -ENOPROTOOPT, sock,
-				optval, optlen, len);
+	int display = lsm_task_display(current);
+	struct security_hook_list *hp;
+
+	hlist_for_each_entry(hp, &security_hook_heads.socket_getpeersec_stream,
+			     list)
+		if (display == LSMBLOB_INVALID || display == hp->lsmid->slot)
+			return hp->hook.socket_getpeersec_stream(sock, optval,
+								 optlen, len);
+	return -ENOPROTOOPT;
 }
 
 int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5570a6ed49d5..5f50dae7c107 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6315,6 +6315,17 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 	/*
 	 * Basic control over ability to set these attributes at all.
 	 */
+
+	/*
+	 * For setting display, we only perform a permission check;
+	 * the actual update to the display value is handled by the
+	 * LSM framework.
+	 */
+	if (!strcmp(name, "display"))
+		return avc_has_perm(&selinux_state,
+				    mysid, mysid, SECCLASS_PROCESS2,
+				    PROCESS2__SETDISPLAY, NULL);
+
 	if (!strcmp(name, "exec"))
 		error = avc_has_perm(&selinux_state,
 				     mysid, mysid, SECCLASS_PROCESS,
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 32e9b03be3dd..ab68612d0885 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -52,7 +52,7 @@ struct security_class_mapping secclass_map[] = {
 	    "execmem", "execstack", "execheap", "setkeycreate",
 	    "setsockcreate", "getrlimit", NULL } },
 	{ "process2",
-	  { "nnp_transition", "nosuid_transition", NULL } },
+	  { "nnp_transition", "nosuid_transition", "setdisplay", NULL } },
 	{ "system",
 	  { "ipc_info", "syslog_read", "syslog_mod",
 	    "syslog_console", "module_request", "module_load", NULL } },
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e42336328446..aac8cb0de733 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3519,6 +3519,13 @@ static int smack_setprocattr(const char *name, void *value, size_t size)
 	struct smack_known_list_elem *sklep;
 	int rc;
 
+	/*
+	 * Allow the /proc/.../attr/current and SO_PEERSEC "display"
+	 * to be reset at will.
+	 */
+	if (strcmp(name, "display") == 0)
+		return 0;
+
 	if (!smack_privileged(CAP_MAC_ADMIN) && list_empty(&tsp->smk_relabel))
 		return -EPERM;
 
-- 
2.20.1

