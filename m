Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F533EAD44
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhHLWik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:38:40 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:35114
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231898AbhHLWik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 18:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628807892; bh=8qkBiGm+CMHsia/0VFbfZ560DIEBUk51sqx+1QrltPo=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=pmlydQ+E0+IR8XM0Z6KuNSGmXtu4ExOOnk4JNqlDbs6Rs1efIHkVjSYv4TZQq3/043epbrqhkVsQuB+Tqp9HrsA6QhkSn3kjImc91JSD0wp/2ghmwoJbhK5bDzkBbDaR6O4yjOMWnumZbMC2M0qKS9FhB9KOqvKWItry3C2GMq1oUH041T8In0n0xFSiRu5IYil7GIZp0gSpjldHLbUSy/fSXEmAF1KcIdsTDFYlOW6sqEnefcTGnRSQTiMX8pI6foZDlekdocKUIy0LoVvkU7cV+cG7dkbemr9IkM0ec8RTGK3ipTKFCsKCrXrw5mg8JguBqcpfV+R26gNuJ3PBLA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628807892; bh=B9mkpkhFDSF38PtUISCt7F1nbSsLDBY4boxZLoknRZd=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=mqpUN1wQqQcsKFJBKzRKJTIf2nBD9lWB0LfSVWF7jIdeSfmVxJre2xCAcuagYLwDr/43BwNhfnec87vUDqR/ShivIX7wP+dBLIIz5mnbrjT/8ICA8kyuImqB9nbrTNJzTu6X07xvL2DWZVd/6GEZFbsw7Vuvvj4esefP7mi09dwJ6j0uGFRCulcx4bbFK4e7I4VO+LpXn5leRbwRe5ZRUe6VcrNPlhmxrTS2I0KEDvLGKs7M9THQHAmQeZpcHa574yHCs3GLDNDFLrIDCH/iSQqub4sRntEHz5EUNgo3dKTU2u3mIWto/s/9hC/Imn2a5Lf9RHrcjyrHPf50lyBqtA==
X-YMail-OSG: AbnfKTMVM1mXVqUdaMdSRzCSsYaJ5v9zrpMqNNVBox07tTsTG3JZEVvn7BfM2j.
 y_xQxiMYis1dtnwgqrPTCYVac1juO9fbN.tICoutL7KrHZQnY5hpZjzf1KQKT8d_wUhzfGnh98hc
 w.l1E_ZNIjN73aBU8bdFvRyYRcTlVhBbSAgYBM51Uyy4Gli9k.s89KApfW2UDWJax29cnCihXFa_
 Canykoh4zGj55mEglCC.h4vD7T3CfPMjMewRXjaNkSWrOSQREKj9lzNG9MWHHL2xIe_xx6nmGgTi
 oR9yVr5hnb8pcxwtr3NyzTuIffwlN0HkO61H.1CldZi37W96IzI.peoJEZsWs_YH4rovnZJ0TXfp
 AMTpJtKy5o07sTMe10nX3q6msfNqqAmepYlV92_kkuniLVov4N_lTxLTKuY4j1U8JwE5jDq.VfO3
 UgLVAXXG.hxXjuE.e8k_ndeg.INQhBTEnTrli5amJhTzHs4vgDTPVGlAMu2IdYLj5_HejxFh46bK
 o.otitufVZitU6_gBC5cd5GsL19v8a8B7b1xephseviT06NRXtmKitDYBGxHTFlqdv9CfYEBLBCk
 xDIVHIIwWXNVu2nNF4mrH9o4hxvZp.ys.hAEiZY122eXR2UrpUTFtVc5HxjcfShEw_ZI5rwpTkgT
 jDiZRrJGUkdAbuPVEu9GwI93zsrdKKzXCZHAZroiwVvk.lOdTBnRTNUJmbYpGZzFPQ3BPb.bT4on
 smV4GO_PJfHTI8NqfXLNmYLRELK2VsuZwKlzZIbU9RPsLSu0S2OOFTxDeaVKONQnCFvVNO6.eKkY
 qTz2.XZCzzIAjS6Gp_t2ETJIQPLj0G_FLFehjnMmjriAZny5odOkPIy6CHkhDAC7lYhO9dic9v.m
 H6Vgs69jctRmLCQ8xKJmv1Ik3lzqfyVB5XLX9br.osIkgUJtMUl3cl2C8V5lJHCV7Mc.gZYN3ToJ
 llK1wmlJvsY.Akzw1NO.DsXiJ8uuMEgZ8Xo7tVbNP0kufbnUA4LVP7PYht2wicDrDoebiV5Iflbo
 a8KnMZhz52ZASOu9bpiciVQOkdYKQjUu7WNFEoU3_DbD1mmQwoylR4E.2IC5FExjvrhhzew6i4Su
 9.ymY9ffyCPE.dweZ.I1maRO0qgWsgtAPzVAdiVGgV826wVZb4CzAMiL3cE.t6QEx2XdfSTa3tlb
 US.yL5lPbuKdDX4Y053hndCiSTjfYPWUdAYzec5z.4CuDb3hFcD8PdREAkI_ixpzzFBmykVZHMvq
 TgmSJDRCGfFy8sAxlT_RWT9wIR05AxeSdEV06koJciSAXcI9D_d4mNGjZOg2ydCKnRuBLaRDVfjs
 dOL8rILoJVChKfcKiu_e9mqr1VM_z5tCdrhaz_ah5fxDaqP2j9cb2VUMxQjmIwES2HfQmL60.Bzt
 FH3m30_uVjy0mnoZRbwGJc7i643WsI69LaLuPoS1f9odMdFwWO0auTvd1P7Jh21q_IDDgOvfsdyd
 zZUMuuz4LCxaKHvAYVAK5pwAywj0tTPoFIj03bZ_i.I0Ci9U1aoxbMIK6qg_xzWp7KlMjRQEvaBJ
 DFHANIqpiu1h9XIMmT_0jA3AUIMz8kVpo8.Iqhgd7saePpqadhxwPMRvU3nRc9g7mQPFetU3NWyS
 GQPY0wnsZxSHr7uWZoTNT67TOsCN6OhPtQFIx649lPidmRm3r1ju8aQdzhgtlsinr6og9IrO.FBp
 GdiikD6Dcp60mRGuzbP6cbSpr1CBugxdXTCBd6uiGzKjSR7W2LhSxbnVijFPNzTIE1lK2msO1T8g
 XFKFGHwCpbBnNYd6EpRgxsZ5T.FFAW7DYad3HO_br_xwSUfdBDC4SS.8R50Z2JMIrYb3Kh3SnpDQ
 .Zlq.xKjo4fPdJRiSusTVZJL4IH1QNztivP3jgtuXrEvgTvVg_YYNfn3SXw3QR_nF_nmmVOlICUR
 ys3LR1E16CGTNgj4ZHD11hN0KhzNTwLwOJWsCXLzLpwc1MrGazpogSr.BuSxzICRSK5czGRsbVO7
 NlC6Z5Zh8sFfsYynQE6lDoFA.6byEzRszsI42v68fy.HlgOM9cip_reTK.33h03HaMH8lUVhCymB
 q9Gz3ZOfkvOM7LOywRyK4xTea8XHSZXZ4xcv0b5qeYvVB0xfdqZ3ui.lZHY0f_ryT_oOzRmkBsay
 1xPchif9w5B4QyDzsUb1bqz2xea0sxB7ng3WUNnIB5MQHu35hzxbpeVm896FP2sIcJ6u1wVcMwBr
 xgXQ2nhRa8kqR2nLsL7GxiowpJVAk8d7QQRXsvIBBxVaBx1_flAsgwnawlX.ymWdP5AnUfdVIgD9
 7
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 12 Aug 2021 22:38:12 +0000
Received: by kubenode529.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 3e1d123009f6cf25958e08f45f1d9823;
          Thu, 12 Aug 2021 22:38:08 +0000 (UTC)
Subject: Re: [PATCH v28 22/25] Audit: Add record for multiple process LSM
 attributes
To:     Paul Moore <paul@paul-moore.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
 <20210722004758.12371-23-casey@schaufler-ca.com>
 <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com>
Date:   Thu, 12 Aug 2021 15:38:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18850 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/2021 1:59 PM, Paul Moore wrote:
> On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> Create a new audit record type to contain the subject information
>> when there are multiple security modules that require such data.
>> This record is linked with the same timestamp and serial number
>> using the audit_alloc_local() mechanism.
>> The record is produced only in cases where there is more than one
>> security module with a process "context".
>> In cases where this record is produced the subj=3D fields of
>> other records in the audit event will be set to "subj=3D?".
>>
>> An example of the MAC_TASK_CONTEXTS (1420) record is:
>>
>>         type=3DUNKNOWN[1420]
>>         msg=3Daudit(1600880931.832:113)
>>         subj_apparmor=3D"=3Dunconfined"
>>         subj_smack=3D"_"
>>
>> There will be a subj_$LSM=3D entry for each security module
>> LSM that supports the secid_to_secctx and secctx_to_secid
>> hooks. The BPF security module implements secid/secctx
>> translation hooks, so it has to be considered to provide a
>> secctx even though it may not actually do so.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> To: paul@paul-moore.com
>> To: linux-audit@redhat.com
>> To: rgb@redhat.com
>> Cc: netdev@vger.kernel.org
>> ---
>>  drivers/android/binder.c                |  2 +-
>>  include/linux/audit.h                   | 16 +++++
>>  include/linux/security.h                | 16 ++++-
>>  include/net/netlabel.h                  |  2 +-
>>  include/net/scm.h                       |  2 +-
>>  include/net/xfrm.h                      | 13 +++-
>>  include/uapi/linux/audit.h              |  1 +
>>  kernel/audit.c                          | 90 +++++++++++++++++++-----=
-
>>  kernel/auditfilter.c                    |  5 +-
>>  kernel/auditsc.c                        | 27 ++++++--
>>  net/ipv4/ip_sockglue.c                  |  2 +-
>>  net/netfilter/nf_conntrack_netlink.c    |  4 +-
>>  net/netfilter/nf_conntrack_standalone.c |  2 +-
>>  net/netfilter/nfnetlink_queue.c         |  2 +-
>>  net/netlabel/netlabel_unlabeled.c       | 21 +++---
>>  net/netlabel/netlabel_user.c            | 14 ++--
>>  net/netlabel/netlabel_user.h            |  6 +-
>>  net/xfrm/xfrm_policy.c                  |  8 ++-
>>  net/xfrm/xfrm_state.c                   | 18 +++--
>>  security/integrity/ima/ima_api.c        |  6 +-
>>  security/integrity/integrity_audit.c    |  5 +-
>>  security/security.c                     | 46 ++++++++-----
>>  security/smack/smackfs.c                |  3 +-
>>  23 files changed, 221 insertions(+), 90 deletions(-)
>>
>> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
>> index 2c3a2348a144..3520caa0260c 100644
>> --- a/drivers/android/binder.c
>> +++ b/drivers/android/binder.c
>> @@ -2722,7 +2722,7 @@ static void binder_transaction(struct binder_pro=
c *proc,
>>                  * case well anyway.
>>                  */
>>                 security_task_getsecid_obj(proc->tsk, &blob);
>> -               ret =3D security_secid_to_secctx(&blob, &lsmctx);
>> +               ret =3D security_secid_to_secctx(&blob, &lsmctx, LSMBL=
OB_DISPLAY);
>>                 if (ret) {
>>                         return_error =3D BR_FAILED_REPLY;
>>                         return_error_param =3D ret;
>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>> index 97cd7471e572..85eb87f6f92d 100644
>> --- a/include/linux/audit.h
>> +++ b/include/linux/audit.h
>> @@ -291,6 +291,7 @@ extern int  audit_alloc(struct task_struct *task);=

>>  extern void __audit_free(struct task_struct *task);
>>  extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
>>  extern void audit_free_context(struct audit_context *context);
>> +extern void audit_free_local(struct audit_context *context);
>>  extern void __audit_syscall_entry(int major, unsigned long a0, unsign=
ed long a1,
>>                                   unsigned long a2, unsigned long a3);=

>>  extern void __audit_syscall_exit(int ret_success, long ret_value);
>> @@ -386,6 +387,19 @@ static inline void audit_ptrace(struct task_struc=
t *t)
>>                 __audit_ptrace(t);
>>  }
>>
>> +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
>> +{
>> +       struct audit_context *context =3D audit_context();
>> +
>> +       if (context)
>> +               return context;
>> +
>> +       if (lsm_multiple_contexts())
>> +               return audit_alloc_local(gfp);
>> +
>> +       return NULL;
>> +}
> We don't want to do this, at least not as it is written above.  We
> shouldn't have a function which abstracts away the creation of a local
> audit_context.  Usage of a local audit_context should be explicit in
> the caller, and if the caller's execution context is ambiguous enough
> that it can require both a task_struct audit_context and a local
> audit_context then we need to handle that on a case-by-case basis.
> Hiding it like this is guaranteed to cause problems later.

OK. Please understand that *every case* where I've used audit_alloc_for_l=
sm()
is a case where I have *verified* that context may be NULL. I will make
the change.

> I probably did a poor job of explaining what a local context is during
> the last patchset; I'll try to do a better job here but also let me
> say this as clear as I can ... if the "current" task struct is valid
> for a given code path, *never* use a local audit context.

I probably did a poor job of demonstrating that I never use a local
context where there's a valid current context.

>   The local
> audit context is a hack that is made necessary by the fact that we
> have to audit things which happen outside the scope of an executing
> task, e.g. the netfilter audit hooks, it should *never* be used when
> there is a valid task_struct.

In the existing audit code a "current context" is only needed for
syscall events, so that's the only case where it's allocated. Would
you suggest that I track down the non-syscall events that include
subj=3D fields and add allocate a "current context" for them? I looked
into doing that, and it wouldn't be simple.

> It's the audit_context which helps bind multiple audit records into a
> single event, creating a new, "local" audit_context destroys that
> binding

=2E.. if there's a current context. There often isn't. That's why I'm
using a local context. There is not a "current" context available.

>  as audit records created using that local audit_context have a
> different timestamp from those records created using the current
> task_struct's audit_context.

(Weeps) I only introduce a local context where there is no current
context available, so this is never a problem.

> Hopefully that makes sense?

Yes, it makes sense. Methinks you may believe that the current context
is available more regularly than it actually is.

I instrumented the audit event functions with:

	WARN_ONCE(audit_context, "%s has context\n", __func__);
	WARN_ONCE(!audit_context, "%s lacks context\n", __func__);

I only used local contexts where the 2nd WARN_ONCE was hit.


>>                                 /* Private API (for audit.c only) */
>>  extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
>>  extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid=
_t gid, umode_t mode);
>> @@ -560,6 +574,8 @@ extern int audit_signals;
>>  }
>>  static inline void audit_free_context(struct audit_context *context)
>>  { }
>> +static inline void audit_free_local(struct audit_context *context)
>> +{ }
>>  static inline int audit_alloc(struct task_struct *task)
>>  {
>>         return 0;
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 3e9743118fb9..b3cf68cf2bd6 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -182,6 +182,8 @@ struct lsmblob {
>>  #define LSMBLOB_INVALID                -1      /* Not a valid LSM slo=
t number */
>>  #define LSMBLOB_NEEDED         -2      /* Slot requested on initializ=
ation */
>>  #define LSMBLOB_NOT_NEEDED     -3      /* Slot not requested */
>> +#define LSMBLOB_DISPLAY                -4      /* Use the "display" s=
lot */
>> +#define LSMBLOB_FIRST          -5      /* Use the default "display" s=
lot */
>>
>>  /**
>>   * lsmblob_init - initialize an lsmblob structure
>> @@ -248,6 +250,15 @@ static inline u32 lsmblob_value(const struct lsmb=
lob *blob)
>>         return 0;
>>  }
>>
>> +static inline bool lsm_multiple_contexts(void)
>> +{
>> +#ifdef CONFIG_SECURITY
>> +       return lsm_slot_to_name(1) !=3D NULL;
>> +#else
>> +       return false;
>> +#endif
>> +}
>> +
>>  /* These functions are in security/commoncap.c */
>>  extern int cap_capable(const struct cred *cred, struct user_namespace=
 *ns,
>>                        int cap, unsigned int opts);
>> @@ -578,7 +589,8 @@ int security_setprocattr(const char *lsm, const ch=
ar *name, void *value,
>>                          size_t size);
>>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>>  int security_ismaclabel(const char *name);
>> -int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext =
*cp);
>> +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext =
*cp,
>> +                            int display);
>>  int security_secctx_to_secid(const char *secdata, u32 seclen,
>>                              struct lsmblob *blob);
>>  void security_release_secctx(struct lsmcontext *cp);
>> @@ -1433,7 +1445,7 @@ static inline int security_ismaclabel(const char=
 *name)
>>  }
>>
>>  static inline int security_secid_to_secctx(struct lsmblob *blob,
>> -                                          struct lsmcontext *cp)
>> +                                          struct lsmcontext *cp, int =
display)
>>  {
>>         return -EOPNOTSUPP;
>>  }
>> diff --git a/include/net/netlabel.h b/include/net/netlabel.h
>> index 73fc25b4042b..216cb1ffc8f0 100644
>> --- a/include/net/netlabel.h
>> +++ b/include/net/netlabel.h
>> @@ -97,7 +97,7 @@ struct calipso_doi;
>>
>>  /* NetLabel audit information */
>>  struct netlbl_audit {
>> -       u32 secid;
>> +       struct lsmblob lsmdata;
>>         kuid_t loginuid;
>>         unsigned int sessionid;
>>  };
> This chunk seems lost here, does it belong in another patch?

Probably. I am getting a touch of patch-rot showing up.


>> diff --git a/include/net/scm.h b/include/net/scm.h
>> index b77a52f93389..f4d567d4885e 100644
>> --- a/include/net/scm.h
>> +++ b/include/net/scm.h
>> @@ -101,7 +101,7 @@ static inline void scm_passec(struct socket *sock,=
 struct msghdr *msg, struct sc
>>                  * and the infrastructure will know which it is.
>>                  */
>>                 lsmblob_init(&lb, scm->secid);
>> -               err =3D security_secid_to_secctx(&lb, &context);
>> +               err =3D security_secid_to_secctx(&lb, &context, LSMBLO=
B_DISPLAY);
> Misplaced code change?

Same here.


>>                 if (!err) {
>>                         put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, contex=
t.len,
>> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
>> index cbff7c2a9724..a10fa01f7bf4 100644
>> --- a/include/net/xfrm.h
>> +++ b/include/net/xfrm.h
>> @@ -660,13 +660,22 @@ struct xfrm_spi_skb_cb {
>>  #define XFRM_SPI_SKB_CB(__skb) ((struct xfrm_spi_skb_cb *)&((__skb)->=
cb[0]))
>>
>>  #ifdef CONFIG_AUDITSYSCALL
>> -static inline struct audit_buffer *xfrm_audit_start(const char *op)
>> +static inline struct audit_buffer *xfrm_audit_start(const char *op,
>> +                                                   struct audit_conte=
xt **lac)
>>  {
>> +       struct audit_context *context;
>>         struct audit_buffer *audit_buf =3D NULL;
>>
>>         if (audit_enabled =3D=3D AUDIT_OFF)
>>                 return NULL;
>> -       audit_buf =3D audit_log_start(audit_context(), GFP_ATOMIC,
>> +       context =3D audit_context();
>> +       if (lac !=3D NULL) {
>> +               if (lsm_multiple_contexts() && context =3D=3D NULL)
>> +                       context =3D audit_alloc_local(GFP_ATOMIC);
>> +               *lac =3D context;
>> +       }
>> +
>> +       audit_buf =3D audit_log_start(context, GFP_ATOMIC,
>>                                     AUDIT_MAC_IPSEC_EVENT);
>>         if (audit_buf =3D=3D NULL)
>>                 return NULL;
> Related to the other comments around local audit_contexts, we don't
> want to do this; use the existing audit_context, @lac in this case, so
> that this audit record is bound to the other associated records into a
> single audit event (all have the same timestamp).

Hmm. This is clearly a problem. Looks like a change came in
that I didn't see.

>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 841123390d41..cba63789a164 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -386,10 +386,12 @@ void audit_log_lost(const char *message)
>>  static int audit_log_config_change(char *function_name, u32 new, u32 =
old,
>>                                    int allow_changes)
>>  {
>> +       struct audit_context *context;
>>         struct audit_buffer *ab;
>>         int rc =3D 0;
>>
>> -       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONF=
IG_CHANGE);
>> +       context =3D audit_alloc_for_lsm(GFP_KERNEL);
>> +       ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANG=
E);
> We shouldn't need to do this for the reasons discussed up near the top
> of this email (and elsewhere as well).

Here and elsewhere, I only put audit_alloc_for_lsm() in because there
are cases where audit_context() returns NULL. Really.

>
> I'm going to refrain from commenting on the other uses of
> audit_alloc_for_lsm() in this patch unless there is something unique
> to the code path, so if you don't see me comment about a use of
> audit_alloc_for_lsm() you can assume it should be removed and the
> existing audit_context used instead.
>
>> @@ -399,6 +401,7 @@ static int audit_log_config_change(char *function_=
name, u32 new, u32 old,
>>                 allow_changes =3D 0; /* Something weird, deny request =
*/
>>         audit_log_format(ab, " res=3D%d", allow_changes);
>>         audit_log_end(ab);
>> +       audit_free_local(context);
> See my comment directly above regarding usage of
> audit_alloc_for_lsm(), it obviously applies here too.
>
>> @@ -2128,6 +2136,36 @@ void audit_log_key(struct audit_buffer *ab, cha=
r *key)
>>                 audit_log_format(ab, "(null)");
>>  }
>>
>> +static void audit_log_lsm(struct audit_context *context, struct lsmbl=
ob *blob)
> See my note below about moving this into audit_log_task_context(),

Either works for me. This seemed consistent with the rest of the audit
code, but I'm happy to change it if you like that better.

>  but
> if we really need to keep this as a separate function, let's consider
> changing the name to something which indicates that it logs the LSM
> data as *subject* fields.  How about audit_log_lsm_subj()?
>
>> +{
>> +       struct audit_buffer *ab;
>> +       struct lsmcontext lsmdata;
>> +       bool sep =3D false;
>> +       int error;
>> +       int i;
>> +
>> +       ab =3D audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CON=
TEXTS);
>> +       if (!ab)
>> +               return; /* audit_panic or being filtered */
>> +
>> +       for (i =3D 0; i < LSMBLOB_ENTRIES; i++) {
>> +               if (blob->secid[i] =3D=3D 0)
>> +                       continue;
>> +               error =3D security_secid_to_secctx(blob, &lsmdata, i);=

>> +               if (error && error !=3D -EINVAL) {
>> +                       audit_panic("error in audit_log_lsm");
>> +                       return;
>> +               }
>> +
>> +               audit_log_format(ab, "%ssubj_%s=3D\"%s\"", sep ? " " :=
 "",
>> +                                lsm_slot_to_name(i), lsmdata.context)=
;
>> +               sep =3D true;
> Since @i starts at zero, you can get rid of @sep by replacing it with @=
i:
>
>   audit_log_format(ab, ..., (i ? " " : ""), ...);

Clever.

>
>> +               security_release_secctx(&lsmdata);
>> +       }
>> +       audit_log_end(ab);
>> +}
>> @@ -2138,7 +2176,18 @@ int audit_log_task_context(struct audit_buffer =
*ab)
>>         if (!lsmblob_is_set(&blob))
>>                 return 0;
>>
>> -       error =3D security_secid_to_secctx(&blob, &context);
>> +       /*
>> +        * If there is more than one security module that has a
>> +        * subject "context" it's necessary to put the subject data
>> +        * into a separate record to maintain compatibility.
>> +        */
>> +       if (lsm_multiple_contexts()) {
>> +               audit_log_format(ab, " subj=3D?");
>> +               audit_log_lsm(ab->ctx, &blob);
>> +               return 0;
>> +       }
>> +
>> +       error =3D security_secid_to_secctx(&blob, &context, LSMBLOB_FI=
RST);
> Instead of the lsm_multiple_contexts() case bailing on the rest of the
> function with a return inside the if-block, let's made the code a bit
> more robust by organizing it like this:

Sure, why not?

>
>   int audit_log_task_context(ab)
>   {
>      /* common stuff at the start */
>
>      if (lsm_multiple_contexts()) {
>        /* multi-LSM stuff */
>      } else {
>        /* single LSM stuff */
>      }
>
>      /* common stuff at the end */
>   }
>
> ... it also may make sense to just move the body of audit_log_lsm()
> into audit_log_task_context() and do away with audit_log_lsm()
> entirely; is it ever going to be called from anywhere else?
>
>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> index 0e58a3ab56f5..01fdcbf468c0 100644
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -993,12 +993,11 @@ struct audit_context *audit_alloc_local(gfp_t gf=
pflags)
>>         context =3D audit_alloc_context(AUDIT_STATE_BUILD, gfpflags);
>>         if (!context) {
>>                 audit_log_lost("out of memory in audit_alloc_local");
>> -               goto out;
>> +               return NULL;
>>         }
>>         context->serial =3D audit_serial();
>>         ktime_get_coarse_real_ts64(&context->ctime);
>>         context->local =3D true;
>> -out:
>>         return context;
>>  }
> This chunk should be moved to 21/25 when audit_alloc_local() is first d=
efined.

True. I was trying to minimize the change to the original audit_alloc_loc=
al()
patch on the assumption that it was coming in for other reasons, but that=
 hasn't
happened.


>> @@ -1019,6 +1018,13 @@ void audit_free_context(struct audit_context *c=
ontext)
>>  }
>>  EXPORT_SYMBOL(audit_free_context);
>>
>> +void audit_free_local(struct audit_context *context)
>> +{
>> +       if (context && context->local)
>> +               audit_free_context(context);
>> +}
>> +EXPORT_SYMBOL(audit_free_local);
> If this is strictly necessary, and I don't think it is, it should also
> be moved to patch 21/25 with the original definition of a local
> audit_context.  However,  there really should be no reason why we have
> to distinguish between a proper and local audtit_context when it comes
> to free'ing the memory, just call audit_free_context() in both cases.
>
>> @@ -1036,7 +1042,7 @@ static int audit_log_pid_context(struct audit_co=
ntext *context, pid_t pid,
>>                          from_kuid(&init_user_ns, auid),
>>                          from_kuid(&init_user_ns, uid), sessionid);
>>         if (lsmblob_is_set(blob)) {
>> -               if (security_secid_to_secctx(blob, &lsmctx)) {
>> +               if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FI=
RST)) {
> Misplaced code change?
>
> Actually, there are a lot of these below, I'm not going to comment on
> all of them as I think you get the idea ... and I very well may be
> wrong so I'll save you all of my wrongness in that case :)
>
>> diff --git a/security/security.c b/security/security.c
>> index cb359e185d1a..5d7fd982f84a 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -2309,7 +2309,7 @@ int security_setprocattr(const char *lsm, const =
char *name, void *value,
>>                 hlist_for_each_entry(hp, &security_hook_heads.setproca=
ttr,
>>                                      list) {
>>                         rc =3D hp->hook.setprocattr(name, value, size)=
;
>> -                       if (rc < 0)
>> +                       if (rc < 0 && rc !=3D -EINVAL)
>>                                 return rc;
>>                 }
> This really looks misplaced ... ?

Yeah, you're not the first person to notice these bits of patch-rot.
I have some clean-up to do.

Thank you for the review.


