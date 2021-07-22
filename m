Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECEE3D1B03
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 02:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhGVAQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:16:25 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:35400
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhGVAQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915419; bh=ys40P6aOcVrtfywDOdMerV1YACq4nPW6NRWjsvTzIeg=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=OMQn3H59bahAOdDjp7HUwLH77/hPWl9KFaWAA/D1pT0nAkFnSCAqxSKHRzObDbT+zTiy+T7p+5JLERA8lcCkO9GbRRZ+UMcGuqmbmYwrJYuz3wy6G/h24qkqBlm02F/IqELAuNsPxIS65Dndu8nfkZwyKdtYJBy+2a0TzW03cCOsu1gktG9CBqyFQSfGHJD7qmtn/pclklHEV3qtQ85dyALGIx4Nn+UHgUMmUsTKowhXr/C3J6hYUK1zNnY127V6UTjB4fR1CY3SUtN8MBQD3wyUiiNIterW6/hh4bSyLpGzfmHJn7sKLogBWTCUqwvzaouOY6rWXSrQ0MOyq7o2Gg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626915419; bh=YjbHhfbHpVh6zmwRoBcMeTAGeIvvSs8ecq486s/KiCP=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Pu7aRIb2TpcMvQrBmEghcQ2ob9M4EGZHOi/NCm/bsK1JRFT2JJHtjKp9DzE82U3mKV2uF+TJ38vt0CkPuieaYlVs0pxEB75rE112Iuq4DWZo6FoagBcM8yOZUsJMrNrH9CqxNMbUOMs+ZxNKb67XneEkL+fRn1Fh3LTWm6DydvfiNjrxZsVSQ4MOo/ASzXtKN5S23S2e76RcOL6Ote9MdQOCAPlYgQELyG/7PxqtDvZptLpxPKj6N6SuKcghS+3VDEomXxONkkJMO6rS3WeqBFao0QPappStnUa1ReH2tnhPMyIZRhTTtFLakKPYz7WQh7+H0d5cFwY+0qD0ssg9kg==
X-YMail-OSG: QXKlfe8VM1mJ93PjVqmh.L51oaJe64wwsGjT1qD2cyZaGcFIdeRJ40yQjsAUV1I
 8IINO3uTc6KfCXvMXSbv1cvqYQc5iY9X7zodEbB3eIX5qhQvesSfkIbBnmCAFqWKKomJsDsSHj5A
 E41kB6SKBu6VK6UaSuszgANey53JGBJ052xF9rrbca2wj1hzSviU7VVCa2KN887hrLZ6C.WeZd_9
 2Z2ImTjA907FAlA6vNGqM_XPDSzdUzquTD9cfVPMWIU67cSlfFWZYlZS6Hvibn6v4CnuliU_BbLZ
 qlv_sv92TiZbNsL8AqGyg0s5Yd2MWYUj9AZeoFBtVVADZ3FtevdZagfENr7S5vEf82nlI2sVSOdT
 XLy7n1EE2mQJtXn8.OJTiITXr7psWd8YtuU9.t.vBn7b6E1fi6yqYkgk5YUFWTcRzCjFWRx9ccq4
 bDs6yhbYsGLDReDXWFOE.ZidDFebTxoq4hQCZJMYrQs4ML0n7u8169E8Ete.MBPVCROp2xoECZUz
 paGC.PDiPe2NuZ18MwrpLHTcDR5Rn93aHc5a_dGbHNJ5Nj3XLZ8M51nrNjrqAc0XmoccdNIyOs7P
 t15BbNwQmn47188uAS1Pwx1eFh1X5sVnXPZovoTInRDxpGv3s3hUwzlBomJbuRbx1vycRhRnVs4z
 wntjUrmA6QPnvDjCeK7Z0utM3KbSAaGHxSn5pEE2TjPmO6ULCEqBLfSIltf15_A12UK6q7zx8dX7
 SoxX_EuStq37VXDQiJZaHzcrcPaT0UI8Rm_SKA0qNOt2X27icEkomB6Ee_BKdBDRdqHLZXs1WM0s
 oyHoUcL1ge0KlvKOSj1FXuI_tXURz7erGE6puXIiIF61Xofn.DAPrqgH4Ly6PqqG4WVMToiNg9PT
 bcIB6Rva5B6nTovtsVh8abz7yN51PbJb6MvZ5E1HjF3wrMuGU0NkOpWXADanY_d5hliphhLbEB.a
 PjBEmjlXASb2YW0tebKNb1n9DW8avCmwt3gbrV7THnaeyexfdBIGl46h.yAmqNkZHnke_45evojB
 xWZgO2stvRTcJumyPghCYiRYDzCOJWH.1VgcnH14EwGExqlct7T9j1UNONtS603iXQ6d7SoZQjPr
 U1BfEgVzz0Cq72HnbKtPjO_mbSvj5oai7uztC8FpBWAKi3UWN1_mkO73KQM3Cc0VubWe8S_nav8A
 Wewcfy80EQMRUOVNQKXrsJN8n.J5T2gqieY0z4UKonn17EQxbL9voFe3M8y0LrcRztejR1NCmv08
 V2RdxCjx.Zb4_Bz0Xfw3WtyC4FgkS_fy7_K.Ha63aoXKzxLKAnJEJlbDcuPBHEbwakX2YYhtQ1_v
 4C6rYGvYRg1Vh9AwvHRmdCWEEyWQ_MiAvloEDNPOnNUWP7B7uvaS1B4MGvhizdpMaeLSteyYiaSQ
 kzIiD6iSaJsdjy8d2r79NQpDFMg1bc.1rg3rzpXrtecMuXC6drrA1.fVKWs75VOmWFQJhF985mi7
 xbmICtKYOMA1pavKGfw9x2E5Saz1cL8mcQ5.u9K8TyidAudlF496HeRbmxaj3qY6idLb5iF.P7fT
 Z6j6XhtHkKSgBYm7A_YXdpRjM4EhmOEYQQsnCmu0ZTyJ4a3kSJN139c3ESbBbDTkor0IO92Uywjf
 2s84ln_SSuMKsJDmGWQhrchFLK7pq02uuj35JbF3yaFOiPmR1FWhuB4Iw1ueH2Uiv.7gGnX79eKD
 nrxrDhhQ2xeDsBcOGn0At8VNBpNFbT60OTtq4FdpFYrPxiV35CYY_gRB4MeXcXqQt65QPMQjRf9T
 dk7pQR0opflGzGEgqn72T8.9JePNy2Wf6b666Yz6x90CraKjk3v7CWNmfFgfpq4UFGEGcYCmu83f
 BgGVGFhUtD.nVvZd2KFh.ohaJusFYqfHY9WwV6QK7jiZBeEOpGgMZX9oxqSsvrmLSPjX4g.MjpJy
 KVX.DUt7IMkmakXfjn0ADGl3819v3E2TeH_wOt3nE.efynWCwDC1nnFLfLkqE9bwWxMxgshi_T5t
 kh2fLOV9eXO2d6e5K62SQRJ_zbdUnzn5k1VA8ltmJ7l0zi3FZH04lvpKtOfqOyvm93wstNk8OA1C
 z.ENh1z6ZaRzI5ndoCn.V.YtVY8KQgZvvvlUWZzwZUl3cs6stN8.81MwVVyjQ97KiYuq7fo06kRy
 Jl9Qi5MsRvtYFaUv6780dpX_j0WJ7xOYFKHEsICxVpwCGBfU355mQmWeMmEsRb1T4S5DPwUn29PR
 6YZItd2lE3xaMLpjWXw_yYcYoMN.vZF8ga5y6xPG80VANcm2IyO7MblZ_2pGEdOw1DpUVICM4ZBp
 9t1FgJJ7fat5UL2cFHF2_eFsWuKwInIGzEuIOcnyRgyb1johLTa9dj6ooeJ4x4oWCcxXhi4i1XZg
 m3dNgVRJJk_aal0GdDd8hYOFLWakBRPVfiK8lJg474R35nmKr8xliJCRlc2mTGdOL0EtmT_l42YL
 CNh9mjXQbv92S7hIvFksIRKV_PRJ7yxJnRsdm8ZUfUcjCyGse57rFehmQ6BLuRCwFe2311DZ3ZFI
 93Bs6.5LlshBEXLEJ6SvL.81VQVSNf.bZZyzTBf8jkAtGRrymd4T1ljuepYZ9D.0nfJnDtrxgFCq
 fGb1uu9NZkeHdvs42DZsyuZIcbzsVqtqp2LerTeGBxt22Ydp5lCwPSe739K01l9AYkTz8MoiVIeH
 l9ByspCttNwlX.Lgt455vo4HvCaOKuqBo021hdDDlQh0wSahcFQYhv4Yt9CFhizfehkuNXCRT80h
 G1jr3Hn8QEroSy7oOV89aLs4lwUWyF9c6lBuYovqG.ptXIDxxbjUSJ3Nsx6KZoGfpkI_c878ZfOu
 of.Qj.iIEW0yahvPAaZsw_73Ui7ovQ5Pl_GdggomPbXUnQEyiwuuTajENy7ahpm3dlFyHqAzoFWa
 OYSdu5_lRv0AhA8wWUji60WwBIYQg9uZLlg9dn4tqeilh6UQAJOoqPSy4PKlp9F2XKJ0tG1rzyXd
 I9ySCPwdaMO4uRcicCLEvDClYs6skcab.IEhsO2bRJ5STQLZhnOwvyZ2ULtJDs6VaFvB8woPiZSE
 IwYHyYeKaufwY2c5EBmyxz3.lT9FQU9QGjcqFNc17SVQ63R24HG_LaDkSKGYkXmRsKFV5hQsiz0E
 iGTr1x7iQZZkJbSAcoGmPt0UeJD6tSiaH3scXHb06gBHfm9icg7hBAUKBYUW6Cf7iZVfKbMukxUu
 0qv4MKQOGjg.EJThR1bVC1hbSI5hSLm2DoBb7qSCLO0v6txcJRcg04HcTVBb0AcqHH.Z3HsvMzyn
 _PkV9vAkDE1icvLPpCix16XAKAo6mgtnaDVSuMipxNdUXgl4s
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 00:56:59 +0000
Received: by kubenode520.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 92d5ed256cfca90298f7e22b0bfc2b3a;
          Thu, 22 Jul 2021 00:56:57 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v28 08/25] LSM: Use lsmblob in security_secid_to_secctx
Date:   Wed, 21 Jul 2021 17:47:41 -0700
Message-Id: <20210722004758.12371-9-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change security_secid_to_secctx() to take a lsmblob as input
instead of a u32 secid. It will then call the LSM hooks
using the lsmblob element allocated for that module. The
callers have been updated as well. This allows for the
possibility that more than one module may be called upon
to translate a secid to a string, as can occur in the
audit code.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: linux-audit@redhat.com
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/android/binder.c                | 12 +++++++++-
 include/linux/security.h                |  5 +++--
 include/net/scm.h                       |  7 +++++-
 kernel/audit.c                          | 20 +++++++++++++++--
 kernel/auditsc.c                        | 27 ++++++++++++++++++----
 net/ipv4/ip_sockglue.c                  |  4 +++-
 net/netfilter/nf_conntrack_netlink.c    | 14 ++++++++++--
 net/netfilter/nf_conntrack_standalone.c |  4 +++-
 net/netfilter/nfnetlink_queue.c         | 11 +++++++--
 net/netlabel/netlabel_unlabeled.c       | 30 +++++++++++++++++++++----
 net/netlabel/netlabel_user.c            |  6 ++---
 security/security.c                     | 11 +++++----
 12 files changed, 122 insertions(+), 29 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index bcec598b89f2..3e97a6de5e80 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2711,6 +2711,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (target_node && target_node->txn_security_ctx) {
 		u32 secid;
+		struct lsmblob blob;
 		size_t added_size;
 
 		/*
@@ -2723,7 +2724,16 @@ static void binder_transaction(struct binder_proc *proc,
 		 * case well anyway.
 		 */
 		security_task_getsecid_obj(proc->tsk, &secid);
-		ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
+		/*
+		 * Later in this patch set security_task_getsecid() will
+		 * provide a lsmblob instead of a secid. lsmblob_init
+		 * is used to ensure that all the secids in the lsmblob
+		 * get the value returned from security_task_getsecid(),
+		 * which means that the one expected by
+		 * security_secid_to_secctx() will be set.
+		 */
+		lsmblob_init(&blob, secid);
+		ret = security_secid_to_secctx(&blob, &secctx, &secctx_sz);
 		if (ret) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = ret;
diff --git a/include/linux/security.h b/include/linux/security.h
index 986a8f4bcd54..ef33be59998e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -547,7 +547,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
 			 size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen);
 int security_secctx_to_secid(const char *secdata, u32 seclen,
 			     struct lsmblob *blob);
 void security_release_secctx(char *secdata, u32 seclen);
@@ -1397,7 +1397,8 @@ static inline int security_ismaclabel(const char *name)
 	return 0;
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static inline int security_secid_to_secctx(struct lsmblob *blob,
+					   char **secdata, u32 *seclen)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c256..23a35ff1b3f2 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -92,12 +92,17 @@ static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_SECURITY_NETWORK
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen;
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &secdata, &seclen);
+		/* There can only be one security module using the secid,
+		 * and the infrastructure will know which it is.
+		 */
+		lsmblob_init(&lb, scm->secid);
+		err = security_secid_to_secctx(&lb, &secdata, &seclen);
 
 		if (!err) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, seclen, secdata);
diff --git a/kernel/audit.c b/kernel/audit.c
index 121d37e700a6..22286163e93e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1442,7 +1442,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_SIGNAL_INFO:
 		len = 0;
 		if (audit_sig_sid) {
-			err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
+			struct lsmblob blob;
+
+			/*
+			 * lsmblob_init sets all values in the lsmblob
+			 * to audit_sig_sid. This is temporary until
+			 * audit_sig_sid is converted to a lsmblob, which
+			 * happens later in this patch set.
+			 */
+			lsmblob_init(&blob, audit_sig_sid);
+			err = security_secid_to_secctx(&blob, &ctx, &len);
 			if (err)
 				return err;
 		}
@@ -2131,12 +2140,19 @@ int audit_log_task_context(struct audit_buffer *ab)
 	unsigned len;
 	int error;
 	u32 sid;
+	struct lsmblob blob;
 
 	security_task_getsecid_subj(current, &sid);
 	if (!sid)
 		return 0;
 
-	error = security_secid_to_secctx(sid, &ctx, &len);
+	/*
+	 * lsmblob_init sets all values in the lsmblob to sid.
+	 * This is temporary until security_task_getsecid is converted
+	 * to use a lsmblob, which happens later in this patch set.
+	 */
+	lsmblob_init(&blob, sid);
+	error = security_secid_to_secctx(&blob, &ctx, &len);
 	if (error) {
 		if (error != -EINVAL)
 			goto error_path;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 447614b7a50b..df8a57c5355d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -677,6 +677,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 					security_task_getsecid_subj(tsk, &sid);
 					need_sid = 0;
 				}
+				/*
+				 * lsmblob_init sets all values in the lsmblob
+				 * to sid. This is temporary until
+				 * security_task_getsecid() is converted to
+				 * provide a lsmblob, which happens later in
+				 * this patch set.
+				 */
 				lsmblob_init(&blob, sid);
 				result = security_audit_rule_match(&blob,
 							f->type, f->op,
@@ -693,6 +700,13 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (f->lsm_isset) {
 				/* Find files that match */
 				if (name) {
+					/*
+					 * lsmblob_init sets all values in the
+					 * lsmblob to sid. This is temporary
+					 * until name->osid is converted to a
+					 * lsmblob, which happens later in
+					 * this patch set.
+					 */
 					lsmblob_init(&blob, name->osid);
 					result = security_audit_rule_match(
 								&blob,
@@ -999,6 +1013,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	char *ctx = NULL;
 	u32 len;
 	int rc = 0;
+	struct lsmblob blob;
 
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_OBJ_PID);
 	if (!ab)
@@ -1008,7 +1023,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (sid) {
-		if (security_secid_to_secctx(sid, &ctx, &len)) {
+		lsmblob_init(&blob, sid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1252,8 +1268,10 @@ static void show_special(struct audit_context *context, int *call_panic)
 		if (osid) {
 			char *ctx = NULL;
 			u32 len;
+			struct lsmblob blob;
 
-			if (security_secid_to_secctx(osid, &ctx, &len)) {
+			lsmblob_init(&blob, osid);
+			if (security_secid_to_secctx(&blob, &ctx, &len)) {
 				audit_log_format(ab, " osid=%u", osid);
 				*call_panic = 1;
 			} else {
@@ -1408,9 +1426,10 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (n->osid != 0) {
 		char *ctx = NULL;
 		u32 len;
+		struct lsmblob blob;
 
-		if (security_secid_to_secctx(
-			n->osid, &ctx, &len)) {
+		lsmblob_init(&blob, n->osid);
+		if (security_secid_to_secctx(&blob, &ctx, &len)) {
 			audit_log_format(ab, " osid=%u", n->osid);
 			if (call_panic)
 				*call_panic = 2;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index ec6036713e2c..2f089733ada7 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -130,6 +130,7 @@ static void ip_cmsg_recv_checksum(struct msghdr *msg, struct sk_buff *skb,
 
 static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 {
+	struct lsmblob lb;
 	char *secdata;
 	u32 seclen, secid;
 	int err;
@@ -138,7 +139,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &secdata, &seclen);
+	lsmblob_init(&lb, secid);
+	err = security_secid_to_secctx(&lb, &secdata, &seclen);
 	if (err)
 		return;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e81af33b233b..9bf1f5460681 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -341,8 +341,13 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct nlattr *nest_secctx;
 	int len, ret;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return 0;
 
@@ -650,8 +655,13 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
+	/* lsmblob_init() puts ct->secmark into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, NULL, &len);
 	if (ret)
 		return 0;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 214d9f9e499b..89b6f5ebcfc4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -175,8 +175,10 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	int ret;
 	u32 len;
 	char *secctx;
+	struct lsmblob blob;
 
-	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
+	lsmblob_init(&blob, ct->secmark);
+	ret = security_secid_to_secctx(&blob, &secctx, &len);
 	if (ret)
 		return;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f774de0fc24f..a781e757d593 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -305,13 +305,20 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	struct lsmblob blob;
+
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
-	if (skb->secmark)
-		security_secid_to_secctx(skb->secmark, secdata, &seclen);
+	if (skb->secmark) {
+		/* lsmblob_init() puts ct->secmark into all of the secids in
+		 * blob. security_secid_to_secctx() will know which security
+		 * module to use to create the secctx.  */
+		lsmblob_init(&blob, skb->secmark);
+		security_secid_to_secctx(&blob, secdata, &seclen);
+	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index c29a8d7a7070..5cbbc469ac7c 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -376,6 +376,7 @@ int netlbl_unlhsh_add(struct net *net,
 	struct audit_buffer *audit_buf = NULL;
 	char *secctx = NULL;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (addr_len != sizeof(struct in_addr) &&
 	    addr_len != sizeof(struct in6_addr))
@@ -438,7 +439,11 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
+		/* lsmblob_init() puts secid into all of the secids in blob.
+		 * security_secid_to_secctx() will know which security module
+		 * to use to create the secctx.  */
+		lsmblob_init(&blob, secid);
+		if (security_secid_to_secctx(&blob,
 					     &secctx,
 					     &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
@@ -475,6 +480,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af4list_remove(addr->s_addr, mask->s_addr,
@@ -494,8 +500,13 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		if (dev != NULL)
 			dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -537,6 +548,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 	struct net_device *dev;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	spin_lock(&netlbl_unlhsh_lock);
 	list_entry = netlbl_af6list_remove(addr, mask, &iface->addr6_list);
@@ -555,8 +567,13 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		if (dev != NULL)
 			dev_put(dev);
+		/* lsmblob_init() puts entry->secid into all of the secids
+		 * in blob. security_secid_to_secctx() will know which
+		 * security module to use to create the secctx.  */
+		if (entry != NULL)
+			lsmblob_init(&blob, entry->secid);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
+		    security_secid_to_secctx(&blob,
 					     &secctx, &secctx_len) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", secctx);
 			security_release_secctx(secctx, secctx_len);
@@ -1082,6 +1099,7 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 	u32 secid;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	data = genlmsg_put(cb_arg->skb, NETLINK_CB(cb_arg->nl_cb->skb).portid,
 			   cb_arg->seq, &netlbl_unlabel_gnl_family,
@@ -1136,7 +1154,11 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &secctx, &secctx_len);
+	/* lsmblob_init() secid into all of the secids in blob.
+	 * security_secid_to_secctx() will know which security module
+	 * to use to create the secctx.  */
+	lsmblob_init(&blob, secid);
+	ret_val = security_secid_to_secctx(&blob, &secctx, &secctx_len);
 	if (ret_val != 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 3ed4fea2a2de..893301ae0131 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -86,6 +86,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	struct audit_buffer *audit_buf;
 	char *secctx;
 	u32 secctx_len;
+	struct lsmblob blob;
 
 	if (audit_enabled == AUDIT_OFF)
 		return NULL;
@@ -98,10 +99,9 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 from_kuid(&init_user_ns, audit_info->loginuid),
 			 audit_info->sessionid);
 
+	lsmblob_init(&blob, audit_info->secid);
 	if (audit_info->secid != 0 &&
-	    security_secid_to_secctx(audit_info->secid,
-				     &secctx,
-				     &secctx_len) == 0) {
+	    security_secid_to_secctx(&blob, &secctx, &secctx_len) == 0) {
 		audit_log_format(audit_buf, " subj=%s", secctx);
 		security_release_secctx(secctx, secctx_len);
 	}
diff --git a/security/security.c b/security/security.c
index 1621a28bf9c4..607e54a0e85f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2174,17 +2174,16 @@ int security_ismaclabel(const char *name)
 }
 EXPORT_SYMBOL(security_ismaclabel);
 
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(struct lsmblob *blob, char **secdata, u32 *seclen)
 {
 	struct security_hook_list *hp;
 	int rc;
 
-	/*
-	 * Currently, only one LSM can implement secid_to_secctx (i.e this
-	 * LSM hook is not "stackable").
-	 */
 	hlist_for_each_entry(hp, &security_hook_heads.secid_to_secctx, list) {
-		rc = hp->hook.secid_to_secctx(secid, secdata, seclen);
+		if (WARN_ON(hp->lsmid->slot < 0 || hp->lsmid->slot >= lsm_slot))
+			continue;
+		rc = hp->hook.secid_to_secctx(blob->secid[hp->lsmid->slot],
+					      secdata, seclen);
 		if (rc != LSM_RET_DEFAULT(secid_to_secctx))
 			return rc;
 	}
-- 
2.31.1

