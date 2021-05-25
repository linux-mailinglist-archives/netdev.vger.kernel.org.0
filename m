Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A926039069E
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhEYQ2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 12:28:22 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com ([66.163.187.38]:36627
        "EHLO sonic308-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232200AbhEYQ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 12:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621960010; bh=BD3GqEim1Y92Z2U6phKieHB3T+F4MYqcebEsuDm5l1A=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=QW+3iU7a7ceqwRIYmapNoOiimWFbqemksZ1UZ0tFofjek0F2Y85MbBdwP1dtKwhHbJYAD6+L7F7SR5BfUC5k9i/KaLUAOwbw8un4hY4/XLDJmxoEcFQpMaFcbVclTIee/c9BAMyorr/3oO818I1AdOLwyw/rInI5Ubdt4nN5L/6f22+bx1zZ0iFXxqMjqiqSq79wqlAREsLI0wDPxQivmWJFuj+6B3NFUnFDv4DsFtHtfMUOdEKujLMG2ZWbGTMxXLHiCL9U5vgMtk2dZa9oliqM4w8lI3PyWlbSvZa46L0hw+pwzb662V74iPXmbb0sXm8/eSPrt9J/Tflmkuvsqg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621960010; bh=B6T1tCYLXdE7+wjlu/xuE9PM9Mjqfrme1obzWbl9kbB=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=PpmTvGmp13Skr8P7owM+nJpsuzTUT/YC+y4I14SiwR3WCxcXQVrouVLv74snMEZO/CQKbWc++qpQApNxiJ8dB5iMnCjEk9TeZUe7Ja8o2gr2ZEuhHe3TCz6MDIC/rK6gWsVGPnVl0VU+76M2RpG2MObvFiYVKrHuSTUrmxWkugVZULrziwTrDkvKA9tWJER7hCt3X/vW5iQf8b2+AI8/S8a8mCDu3jdHBXkdUZUMdTBi3sWRlPf1JhKni1VJ6ylJjPcyEEXqbXWua7mTA9f6q1uqnajIxeoa95fROPpcTjeqDFrNYLURivb8BjVfudMbmHpjt7zWcQOhTsjWv5RIQg==
X-YMail-OSG: Lx1h_8QVM1neczqR9vDyfVmynXXLqgPWnkZPVgmGtTcBn4NLwq7r90_1O_abcef
 GpcvK5BGrGPos8HEvPFiPpN5vizhw1MfNVz_NhTbIXoXWsbqd9jMlMFvqCu20T4XJ56d146ypx2Q
 VDbVVtkGlNXmHmtw2G7FPclCpFg2TFzEW3qtJnP0OpjnSoDykT30d48wxkPyrIm.0vzDfNAJbyyC
 GQywA_055WmnNn4UOn4LJZz3wnTbo65IM3L7vRzfDxRwbombDUNoWREbIdHK6uC4N_AeqZ8hEvE6
 L3MwLLMdSJvu_xs1zVzMSLsLobur24KIsrUyU_tNJk7hD8ua7l4jS8rk0npEu4VvnvaSz9ZRZfJi
 cRjLxvXMcD3CU.bmvnVpTXBDKtTK6StSQw.C3D4kQzgmnQ38o95gb2ZFZMInLzBiy2El1Z2OcyLO
 GsQ6YoO8zSubhMW.RpPw.pOEbixOm4rhwKJrQuoGut3jZhyLQV4WtoQrkK4O4V3AxTnwJoZmSWcV
 .MN59Tq22bURt.SfiUKG6jAbbeCr.ZUFtmVmRiFoZf5Yk7_XLWbX1XuqxzvWktMD0dJtJby_IMNn
 ee_AvyofWl3yvRvZwQSg7f.2PvtbFYAXr6KXB61jYfTarF3JzhzKijb6tdDixN2f3UWx2dHr_bn1
 43ArRV6rqBgrt9qNUBEXih8MSQe6War4tyZr8lWAcOhKt.NFD.QBqOMhFSelNE2s7NGTd4dTWIAt
 cvO0jrWc.68ghQSjuFtK0z.mrCUSD_hl5wzE_y7WI4OY1Cjfftd9QRxKwM.NjORCoI_3yTAdmmSI
 jPBOjG.GgxA3qFs7XRxJYBZx9MTMzoC0i7Mf4kJ6c_Pjgjhm.VURxVzP4nhSd4Vjj6xg_wVhwOgb
 qDlGuVF7ZYkqbKCZg4ItH9D4eJdbuPt_YlrdpI9rgvHZH.uMtSlGvgYoqpvg4CNjMOkMx8se0BL7
 SiNWtdIhSzLBhyvH7xhVRL_O_Au9.LbCeP9XA6ttcy6PqXwkWb9FSC6suswfuxteYP4gbXWEcctf
 L5pv.vZUU5lRPdECq2yw.Eye8E4ZNj9tFtHkJcb5JU9G5D2q4DHvPK7FRswTx_IVczIXbU_dco3t
 nX_dUnViaFizLaCn.yXuYVqnN0ogqba7BquMYGGjqja8EU_QW78m_GnnOjrth491PbBSUAGCmtax
 SWLe2unQYTNKtufF8vu3qN2NsydskyPzNJqIX0vd6KLNGOh4U0V28TE7THB8uxOx9yyqHeU4Sydj
 aKUJZH7u9dSl0OFiUD3LNvKNRMNZvoHi7Aa4l0okPEeXplNJrRDN7.lmKhBAUFIaZveifeoiwFSc
 KZpsv0uPX4b6IMMYTPxVV3z1GeqmX20ZS.fPpkXTTStSpIr.E7Q1UzVQppNS6EO72ieqhzGovkDS
 y_6JhxKi0ENb_6lY52elDX7PjihvEHe6G..Gl.rvCB6lfVEnGR7jeqVWnHBOMQhivJbc9UjAuJt9
 NtFV1GbqQl185ja1H.MZfYECfiZRiz_p5TD.XB1b9lsI5Ujud_rjPX3eS9bOIkUBDoOsnaIDpw2Z
 4HV.Pt2eEWOAOJ7BljjBo3ZY9J7ErvRYqt.uQ4tDgZtvuQnX1CCo0WEqId2gzoxGDiqfAqLiMz1Q
 mNkHdsC9i4ZaLaL7_2E9ZLAzJB3WjBIdEsyBQ0mZZStPiCeoofTAvOftOVfDh6iZiFI7Sl9CMhQk
 3vyhH486Zotan4gaKEMH5g9Nu3coNbUWJR2kLQJ6DzDPyUGpM1xsSuZOAZgjjVkb6UCmyeHx612w
 BqdzBzI.yVjDW02CDNQSd7vR0x52ksCoqckzCaZcMYe_O0RUGvTrSf4q8PUO1b9viaU_iF__ZYPf
 hhTzE6LGY7C8Zl2ldWxPH2.hbtT4geO5J8ZK8a4NJLCqMWPUUr7O2auQhV1fTQV6AcC3EaMYAF6l
 PAXnBcqdwgnbkledHSr8M1TSsToWBymKbf0uqYwAUVBBDLfKWUCOP_uPfFtGLZjKnv6AZihgvQRG
 u6y5_Zy_TvmyMZGer1LckEcXZ7SS_iGXNFpZ6UR2tpmGtjalY6UzhU0TPfjLJVsXMFDie2LxDI59
 a4sW31kF2pBM_w8Jn_Bq2smmPSLx3Yj1qpjv7HL3QcRIM6949Q7LpHaQDJwkUJw9EvG3wNQj_MUj
 09qRiYZSYEy6zwvwH3f9iWnFiuUdevOoXw.KxZv.ouieLsqkWYeIjmGhWQOyoxx_8BkP85bSrQfr
 27TApjjPhy.UXJdPZr01eKTu4_ifsJ9OPlJD85qBV5V2U61kcFpl2TVMk7IUiDHHzud5bJBuxTZ5
 OtMXTbYKuMkFPe_VSBtNunr.CSxUN9.isLbN3z0QQDVFZsM8_fOX2Mklt80AgPKTkhdZijuwDjRK
 FtZgKbB_ciLxv6r7XWRS0P23lswlJFF3SQVdursmuBUYYJF47sNlR847GSOydVGdRnHC6MaZE3lp
 Ft3dtuwTUPvsE0bqdoaF4RK1I_tL_NaDdBx_1hhmMEjesBi1tXN6uni8QGbtsI1uGp_fH17IQ6.Y
 fDn4u6mNAC0pRy2o_TtNxeWiVTZrRoj4UeQhLVdTwJ2_ah3hhkAzQvUKZTwONoLgmC9xPsYMFZLC
 _SDOMkTfoT3cYrLxB6qwk.tj1eLP9Wh6SqwX9tZILoFCMM631rIz5jNC.LB2KirrurNF5FEnJzmL
 L_GcUY9QJI1RMIbyefEgRhzgOaJEtCRvczJnwP5Fv5ShazvIrGaCN4tQKJXjMbfvcfFOD4S5Ljj.
 cngx9jg.StnUpq4A2RbchURDq.HuYkZCilKlmccEa1tG9CefUvdLU1m8kfBvymXJsWJOeKHecC12
 o91vo743C4kyZTfSGJFxy7pcG1y_RaLgofjHvnZK4r0lAlSngf1xeZ29rrb8W_lwMOg1xNr2hTbs
 41PxnPpwwygEq_T1rL7Oq.KjFHKuFZI7orfSKzWL._gfz8Jc4C25ZNoUKIzJlvsdQR7Z2PfMA6iw
 IAxxVSzX.wGStxC.597UrsOls.q5272HH743sOzHPSfqnjIQ_cgqMx1eIdXOQBBkMVsFJTgK7moR
 bZHTyUtzEQ7hndmpnwW1flHud6MRXK8kMh1PJWyDlAU7uRtad2.rhf82V0Wo03vxuUXYrvD4jeDU
 5esKTGsP_8VJ2FA1MMkcVwIWap4AcV4EunRHS4uDO3AvgLT8Icd7QJPbDWPe6QLX5ZlLxuNYSPoC
 nOkwhVA7uT2rO8_c_j9Thbw7dn2LqVGdXFLT5rdFdVkIRvg7iat8DyXa1TkhMpq8aKtinEfGKs6R
 LNoRu06hSpxsVpgfBFH5QZNt4OVj1D4Vq9EoBBVeuO8rIxsKWEtZlSv3Hf6i2iXH3n_FcW3.ZMQD
 CMwQI3OIBWzFjyuilVf.UHf6ZGFba9j7.S1A-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Tue, 25 May 2021 16:26:50 +0000
Received: by kubenode565.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c84844c20081fd17efdfb709cdaf79ad;
          Tue, 25 May 2021 16:26:46 +0000 (UTC)
Subject: Re: [PATCH v26 22/25] Audit: Add new record for multiple process LSM
 attributes
To:     Paul Moore <paul@paul-moore.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-23-casey@schaufler-ca.com>
 <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <7fbbaa90-3f47-aa84-2ba2-ff867a625341@schaufler-ca.com>
Date:   Tue, 25 May 2021 09:26:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/2021 1:19 PM, Paul Moore wrote:
> On Thu, May 13, 2021 at 4:32 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> Create a new audit record type to contain the subject information
>> when there are multiple security modules that require such data.
>> This record is linked with the same timestamp and serial number
>> using the audit_alloc_local() mechanism.
> The record is linked with the other associated records into a single
> event, it doesn't matter if it gets the timestamp/serial from
> audit_alloc_local() or an existing audit event, e.g. ongoing syscall.
>
>> The record is produced only in cases where there is more than one
>> security module with a process "context".
>> In cases where this record is produced the subj= fields of
>> other records in the audit event will be set to "subj=?".
>>
>> An example of the MAC_TASK_CONTEXTS (1420) record is:
>>
>>         type=UNKNOWN[1420]
>>         msg=audit(1600880931.832:113)
>>         subj_apparmor==unconfined
> It should be just a single "=" in the line above.
>
>>         subj_smack=_
>>
>> There will be a subj_$LSM= entry for each security module
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
>>  include/linux/audit.h                   | 24 ++++++++
>>  include/linux/security.h                | 16 ++++-
>>  include/net/netlabel.h                  |  3 +-
>>  include/net/scm.h                       |  2 +-
>>  include/net/xfrm.h                      | 13 +++-
>>  include/uapi/linux/audit.h              |  1 +
>>  kernel/audit.c                          | 80 ++++++++++++++++++-------
>>  kernel/audit.h                          |  3 +
>>  kernel/auditfilter.c                    |  6 +-
>>  kernel/auditsc.c                        | 75 ++++++++++++++++++++---
>>  net/ipv4/ip_sockglue.c                  |  2 +-
>>  net/netfilter/nf_conntrack_netlink.c    |  4 +-
>>  net/netfilter/nf_conntrack_standalone.c |  2 +-
>>  net/netfilter/nfnetlink_queue.c         |  2 +-
>>  net/netlabel/netlabel_domainhash.c      |  4 +-
>>  net/netlabel/netlabel_unlabeled.c       | 24 ++++----
>>  net/netlabel/netlabel_user.c            | 20 ++++---
>>  net/netlabel/netlabel_user.h            |  6 +-
>>  net/xfrm/xfrm_policy.c                  | 10 ++--
>>  net/xfrm/xfrm_state.c                   | 20 ++++---
>>  security/integrity/ima/ima_api.c        |  7 ++-
>>  security/integrity/integrity_audit.c    |  6 +-
>>  security/security.c                     | 46 +++++++++-----
>>  security/smack/smackfs.c                |  3 +-
>>  25 files changed, 274 insertions(+), 107 deletions(-)
> ...
>
>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>> index 97cd7471e572..229cd71fbf09 100644
>> --- a/include/linux/audit.h
>> +++ b/include/linux/audit.h
>> @@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struct *t)
>>                 __audit_ptrace(t);
>>  }
>>
>> +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
>> +{
>> +       struct audit_context *context = audit_context();
>> +
>> +       if (context)
>> +               return context;
>> +
>> +       if (lsm_multiple_contexts())
>> +               return audit_alloc_local(gfp);
>> +
>> +       return NULL;
>> +}
> See my other comments, but this seems wrong at face value.  The
> additional LSM record should happen as part of the existing audit log
> functions.
>
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index 0129400ff6e9..ddab456e93d3 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -182,6 +182,8 @@ struct lsmblob {
>>  #define LSMBLOB_INVALID                -1      /* Not a valid LSM slot number */
>>  #define LSMBLOB_NEEDED         -2      /* Slot requested on initialization */
>>  #define LSMBLOB_NOT_NEEDED     -3      /* Slot not requested */
>> +#define LSMBLOB_DISPLAY                -4      /* Use the "display" slot */
>> +#define LSMBLOB_FIRST          -5      /* Use the default "display" slot */
>>
>>  /**
>>   * lsmblob_init - initialize an lsmblob structure
>> @@ -248,6 +250,15 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
>>         return 0;
>>  }
>>
>> +static inline bool lsm_multiple_contexts(void)
>> +{
>> +#ifdef CONFIG_SECURITY
>> +       return lsm_slot_to_name(1) != NULL;
>> +#else
>> +       return false;
>> +#endif
>> +}
>> +
>>  /* These functions are in security/commoncap.c */
>>  extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
>>                        int cap, unsigned int opts);
>> @@ -578,7 +589,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>>                          size_t size);
>>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>>  int security_ismaclabel(const char *name);
>> -int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
>> +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
>> +                            int display);
>>  int security_secctx_to_secid(const char *secdata, u32 seclen,
>>                              struct lsmblob *blob);
>>  void security_release_secctx(struct lsmcontext *cp);
>> @@ -1433,7 +1445,7 @@ static inline int security_ismaclabel(const char *name)
>>  }
>>
>>  static inline int security_secid_to_secctx(struct lsmblob *blob,
>> -                                          struct lsmcontext *cp)
>> +                                          struct lsmcontext *cp, int display)
>>  {
>>         return -EOPNOTSUPP;
>>  }
>> diff --git a/include/net/netlabel.h b/include/net/netlabel.h
>> index 73fc25b4042b..9bc1f969a25d 100644
>> --- a/include/net/netlabel.h
>> +++ b/include/net/netlabel.h
>> @@ -97,7 +97,8 @@ struct calipso_doi;
>>
>>  /* NetLabel audit information */
>>  struct netlbl_audit {
>> -       u32 secid;
>> +       struct audit_context *localcontext;
>> +       struct lsmblob lsmdata;
>>         kuid_t loginuid;
>>         unsigned int sessionid;
>>  };
>> diff --git a/include/net/scm.h b/include/net/scm.h
>> index b77a52f93389..f4d567d4885e 100644
>> --- a/include/net/scm.h
>> +++ b/include/net/scm.h
>> @@ -101,7 +101,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
>>                  * and the infrastructure will know which it is.
>>                  */
>>                 lsmblob_init(&lb, scm->secid);
>> -               err = security_secid_to_secctx(&lb, &context);
>> +               err = security_secid_to_secctx(&lb, &context, LSMBLOB_DISPLAY);
>>
>>                 if (!err) {
>>                         put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
>> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
>> index c58a6d4eb610..f8ad20d34498 100644
>> --- a/include/net/xfrm.h
>> +++ b/include/net/xfrm.h
>> @@ -669,13 +669,22 @@ struct xfrm_spi_skb_cb {
>>  #define XFRM_SPI_SKB_CB(__skb) ((struct xfrm_spi_skb_cb *)&((__skb)->cb[0]))
>>
>>  #ifdef CONFIG_AUDITSYSCALL
>> -static inline struct audit_buffer *xfrm_audit_start(const char *op)
>> +static inline struct audit_buffer *xfrm_audit_start(const char *op,
>> +                                                   struct audit_context **lac)
>>  {
>> +       struct audit_context *context;
>>         struct audit_buffer *audit_buf = NULL;
>>
>>         if (audit_enabled == AUDIT_OFF)
>>                 return NULL;
>> -       audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
>> +       context = audit_context();
>> +       if (lac != NULL) {
>> +               if (lsm_multiple_contexts() && context == NULL)
>> +                       context = audit_alloc_local(GFP_ATOMIC);
>> +               *lac = context;
>> +       }
> Okay, we've got a disconnect here regarding "audit contexts" and
> "local contexts", skip down below where I attempt to explain things a
> little more but basically if there is a place that uses this pattern:
>
>   audit_log_start(audit_context(), ...);
>
> ... you don't need, or want, a "local context".  You might need a
> local context if you see the following pattern:
>
>   audit_log_start(NULL, ...);
>
> The "local context" idea is a hack and should be avoided whenever
> possible; if you have an existing audit context from a syscall, or
> something else, you *really* should use it ... or have a *really* good
> explanation as to why you can not.
>
>> +       audit_buf = audit_log_start(context, GFP_ATOMIC,
>>                                     AUDIT_MAC_IPSEC_EVENT);
>>         if (audit_buf == NULL)
>>                 return NULL;
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 841123390d41..60c027d7759c 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -386,10 +386,12 @@ void audit_log_lost(const char *message)
>>  static int audit_log_config_change(char *function_name, u32 new, u32 old,
>>                                    int allow_changes)
>>  {
>> +       struct audit_context *context;
>>         struct audit_buffer *ab;
>>         int rc = 0;
>>
>> -       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONFIG_CHANGE);
>> +       context = audit_alloc_for_lsm(GFP_KERNEL);
>> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> Use the existing context, don't create your own, it breaks the record
> associations in the audit event stream.
>
>>         if (unlikely(!ab))
>>                 return rc;
>>         audit_log_format(ab, "op=set %s=%u old=%u ", function_name, new, old);
>> @@ -398,7 +400,7 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
>>         if (rc)
>>                 allow_changes = 0; /* Something weird, deny request */
>>         audit_log_format(ab, " res=%d", allow_changes);
>> -       audit_log_end(ab);
>> +       audit_log_end_local(ab, context);
> More on this below, but we really should just use audit_log_end(),
> "local contexts" are not special, the are regular audit contexts ...
> although if they are used properly (limited scope) you do need to free
> them when you are done.
>
>>         return rc;
>>  }
>>
>> @@ -1357,7 +1355,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>>                                 if (err)
>>                                         break;
>>                         }
>> -                       audit_log_user_recv_msg(&ab, msg_type);
>> +                       lcontext = audit_alloc_for_lsm(GFP_KERNEL);
>> +                       audit_log_common_recv_msg(lcontext, &ab, msg_type);
> Same.
>
>>                         if (msg_type != AUDIT_USER_TTY) {
>>                                 /* ensure NULL termination */
>>                                 str[data_len - 1] = '\0';
>> @@ -1370,7 +1369,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>>                                         data_len--;
>>                                 audit_log_n_untrustedstring(ab, str, data_len);
>>                         }
>> -                       audit_log_end(ab);
>> +                       audit_log_end_local(ab, lcontext);
> Same.
>
>>                 }
>>                 break;
>>         case AUDIT_ADD_RULE:
>> @@ -1378,13 +1377,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>>                 if (data_len < sizeof(struct audit_rule_data))
>>                         return -EINVAL;
>>                 if (audit_enabled == AUDIT_LOCKED) {
>> -                       audit_log_common_recv_msg(audit_context(), &ab,
>> +                       lcontext = audit_alloc_for_lsm(GFP_KERNEL);
>> +                       audit_log_common_recv_msg(lcontext, &ab,
>>                                                   AUDIT_CONFIG_CHANGE);
>>                         audit_log_format(ab, " op=%s audit_enabled=%d res=0",
>>                                          msg_type == AUDIT_ADD_RULE ?
>>                                                 "add_rule" : "remove_rule",
>>                                          audit_enabled);
>> -                       audit_log_end(ab);
>> +                       audit_log_end_local(ab, lcontext);
> Same.  I'm going to stop calling these out, I think you get the idea.
>
>> @@ -2396,6 +2415,21 @@ void audit_log_end(struct audit_buffer *ab)
>>         audit_buffer_free(ab);
>>  }
>>
>> +/**
>> + * audit_log_end_local - end one audit record with local context
>> + * @ab: the audit_buffer
>> + * @context: the local context
>> + *
>> + * Emit an LSM context record if appropriate, then end the audit event
>> + * in the usual way.
>> + */
>> +void audit_log_end_local(struct audit_buffer *ab, struct audit_context *context)
>> +{
>> +       audit_log_end(ab);
>> +       audit_log_lsm_common(context);
>> +       audit_free_local(context);
>> +}
> Eeesh, no, not this please.
>
> First, some background on audit contexts and the idea of a "local
> context" as we have been using it in the audit container ID work,
> which is where this originated.  An audit context contains a few
> things, but likely the most important for this discussion is the audit
> event timestamp and serial number (I may refer to this combo as just a
> "timestamp" in the future); this timestamp/serial is shared across all
> of the audit records that make up this audit event, linking them
> together.  A shared timestamp is what allows you to group an open()
> SYSCALL record with the PATH record that provides the file's pathname
> info.
>
> While there are some exceptions in the current code, most audit events
> occur as a result of a syscall, and their audit context in this case
> is the syscall's audit context (see the open() example above), but
> there are some cases being discussed where we have an audit event that
> does not occur as a result of a syscall but there is a need to group
> multiple audit records together in a single event.  This is where the
> "local context" comes into play, it allows us to create an audit
> context outside of a syscall and share that context across multiple
> audit records, allowing the records to share a timestamp/serial and
> grouping them together as a single audit event in the audit stream.
>
> While a function like audit_alloc_local() make sense, there really
> shouldn't be an audit_log_end_local() function, the normal
> audit_log_end() function should be used.
>
> Does that make sense?
>
>> diff --git a/kernel/audit.h b/kernel/audit.h
>> index 27ef690afd30..5ad0c6819aa8 100644
>> --- a/kernel/audit.h
>> +++ b/kernel/audit.h
>> @@ -100,6 +100,7 @@ struct audit_context {
>>         int                 dummy;      /* must be the first element */
>>         int                 in_syscall; /* 1 if task is in a syscall */
>>         bool                local;      /* local context needed */
>> +       bool                lsmdone;    /* multiple security reported */
> "lsmdone" doesn't seem consistent with the comment, how about
> "lsm_multi" or something similar?
>
>>         enum audit_state    state, current_state;
>>         unsigned int        serial;     /* serial number for record */
>>         int                 major;      /* syscall number */
>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> index d4e061f95da8..55509faf5341 100644
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -1013,6 +1013,13 @@ void audit_free_context(struct audit_context *context)
>>  }
>>  EXPORT_SYMBOL(audit_free_context);
>>
>> +void audit_free_local(struct audit_context *context)
>> +{
>> +       if (context && context->local)
>> +               audit_free_context(context);
>> +}
>> +EXPORT_SYMBOL(audit_free_local);
> We don't need this function, just use audit_free_context().  A "local
> context" is the same as a non-local context; what makes a context
> "local" is the scope of the audit context (local function scope vs
> syscall scope) and nothing else.
>
>> @@ -1504,6 +1512,47 @@ static void audit_log_proctitle(void)
>>         audit_log_end(ab);
>>  }
>>
>> +void audit_log_lsm_common(struct audit_context *context)
>> +{
>> +       struct audit_buffer *ab;
>> +       struct lsmcontext lsmdata;
>> +       bool sep = false;
>> +       int error;
>> +       int i;
>> +
>> +       if (!lsm_multiple_contexts() || context == NULL ||
>> +           !lsmblob_is_set(&context->lsm))
>> +               return;
>> +
>> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CONTEXTS);
>> +       if (!ab)
>> +               return; /* audit_panic or being filtered */
> We should be consistent with our use of audit_panic() when we bail on
> error; we use it below, but not here - why?
>
>> +       for (i = 0; i < LSMBLOB_ENTRIES; i++) {
>> +               if (context->lsm.secid[i] == 0)
>> +                       continue;
>> +               error = security_secid_to_secctx(&context->lsm, &lsmdata, i);
>> +               if (error && error != -EINVAL) {
>> +                       audit_panic("error in audit_log_lsm");
>> +                       return;
>> +               }
>> +
>> +               audit_log_format(ab, "%ssubj_%s=%s", sep ? " " : "",
>> +                                lsm_slot_to_name(i), lsmdata.context);
>> +               sep = true;
>> +               security_release_secctx(&lsmdata);
>> +       }
>> +       audit_log_end(ab);
>> +       context->lsmdone = true;
> Maybe I missed it, but why do we need this flag?
>
>> +}
>> +
>> +void audit_log_lsm(struct audit_context *context)
>> +{
>> +       if (!context->lsmdone)
>> +               audit_log_lsm_common(context);
>> +}
> I think I was distracted with the local context issue and I've lost
> track of the details here, perhaps it's best to fix the local context
> issue first (that should be a big change to this patch) and then we
> can take another look.
>
>
> --
> paul moore
> www.paul-moore.com
