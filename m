Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CF38D084
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEUWHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:07:13 -0400
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:45096
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhEUWHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621634746; bh=aSHcnHFaJCW0nUDhY7hbjuJXu9n+xFG+sWnFXaRVTUI=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=QFUWJ2qNKTxCqlnpPvO/j5Qu22dfrkcuPx9j0giRBAUlaSlgniWT1t3yat9wmk2tgPfHC+1XR/YndYjyd2OAYzas1/uwcF0CbnRJDxAMB+oFqJhJvYJRgUQE2wUPJ0HDxHWqlLBYhPOtO2CxvLRy3w1Vpu4LXne+9dWpwOlQGTRDt9GqUrxupd2hjiBZsrnmWpUZPMPDGhQyXmPcq8gAO9oF7CpMQFKEq6AiGE2eOsc1pMBsr0pfSncCJcqDJpq5KKMYC40eypCUlW7kIrKC1Mn4PUFO87uyWxtYvDPgNKPFUJwfRxvbja6cEtWj46rXzsa1Fmg3ZuCUE9Zx2Rlj0A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621634746; bh=fpG9JvrtbVx5hmtjD6nKPeaf/P8rK9gYZXjs5B0pJ7/=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=DzIfbILm+UBPfZQUdah7Kgx4NFkB3wVwe6ggYNwldDNaKwidQQIV7ic8Hjq7MQGzbp+duPLxnZ90KuiPRjeIp8YuNW7OKUPlrQZ0CmYcdfq8qDM0Fv5MLx6qsZl9QMBPHAgNNU8Kgf8QWNA/lECOBhro1AgDdEQpv4KGtT9Tv4lUAmqFQQ2HhVqL37PpWugucXP6qI564lv4HMteMVOlVa7mbYijhAeT4KU73LTeWLQy9CZMx85dcQb5RADEMZgTlPOeF/zPcKg4OKnPcTPImyIFEWcFLe7XxNVfFtTmuePe/VK/hSbjyGmojtbME1/QElJq3Ro/KG/10yZhXdjQfg==
X-YMail-OSG: rh5hvEQVM1mSTO3p3a60oHROInzmobpIDH7Aijhqs3LKGs2MWp_XNLOjZcOF24Y
 5T.gjxx6pkPro_.zYM.o6wd14LvKXcmzTXsj6r3FGe7NNmS4wL.9UlgPvjuMdJhY0swvEhw3FjRk
 grGFMpDoPUmaUFXO9CxhGZwp3ndQ5OYw8iS4r6w8dRPDZK_T8ZLPPEyRcAIIGYWrNeXAPXZ6ivo.
 ow_CHd1YoZ2vzTPyZ4uDjAN8x8aaDaQMfJjwnkybidDZ992onFf3ChbjiOdCFjFwKRpCOUBd_kxw
 59rkVeIlFq2UzXzTsK.OVGLjsp70n2sRRDuRvUV33ZbV6rVvKAWVSCSebkiVguc7ZDZUlLlUBwvy
 EpYGAvGuX_nsFyIH8JiP5VpubYXc9WT7rHhx.QVGESkNlQyeQYNr8M4obdRRS4krFeMohPzYpZ4h
 NoCj1ayy4bRDHWoR.rtgXjuhq6YC_4Ggq6FjctYd_M1VIXnJ1ioYC4Cf6rvTGx25Tmv48fsntmRF
 wIQTw1sHVXlZMnXuN80zEFZvmfDCqBsV8PiSzJ3IFZ09dKkEJaCTcJajClZgqNfib_pgbQEwb6R6
 DEhJZRuDEfNqWATYDnrkme8Io1iV6tpFX..8q66D.xdv4ePsY6GlQpI8CsGD8omI_NtAzM4uAFBi
 9dlrs90dlgmlnPRPEFx4JHbkTlcVacmZJ2XIev4Rr4VWacYBps4YsGsZCqRsW5tUMNyYu_uOXqTq
 WB.hlnawhkrWkw3tbxj8sTBl8NDrLY6gkLqDHuOzJr8gZeH1E767LihliIsyuogx3pi_e7j3.Ogi
 YwNmmlVdHCodedJ1EnzgAIyIYHnp0.6xo01Kh7XsjbCEdTvqsSIZNGq9cT7pgQ08WywKAut.HRfJ
 rDRhdPXVW1ILBoeWJ8whwdTT3zq3MaXpzOzBZbqKcEguCqXQ6tgoSU4UQARXfMCeEfpu9WenOwLL
 fFappJFqVR9s3zh5OH5xmDFSB5rREA_wjfGlRs2PpqXLOesidX_5mekhRqTUH5QTZArXKIpd2fcA
 WCz0j20HTgaSNPGwu8GOuZ_vZPpKCUQBTSOcN1bXITVY8OXZMSihV0GOaET7Ah3l66IYABWLSLzX
 9Dgxto05FXDpNdzao_bQGI5F7Ro8.qfF8e4kqDcYp4.YGmSKG.yyKThNWVxch9fcDfUElGwA6QQS
 _DA5FKSPR078BB8vbcMSuY1wB_9r3LldUW9Yx9H0cF3iaVdn8R8ON1YjA3BcvvJZ.aWRXM3Z0oDo
 _SLSz.F7hp9UdWJABAruJQfV0sgtlgNJtwUzPfIPDdNOKhWb9CsP13fCknRyO_w2xGiIeSOnJgls
 AHefrg9iRpaEKy4VzCbJeLtccSedk0dlV45yVmRrFp9zruavNVC3_IqL5lU8wFfqTwAbVljb8HfU
 5t7NjRaHEFwoejzFUvUHG84TjcJd9Kzy6ItZLkGCsIKfsDy2oW6Fo7U7o2MHhGkW.Yx51puU8r4C
 4JwdGXubd9zMb9Xiif0b8AIiMSveGWJJSiNh3YW3HZmEqIJSdg0FnQFf4uY5MJvdFYL09CI9cilP
 KXXmnOROdFUjJaCRgPSjd4hpPVrjjq4H7.aeOoUzuVuP2t08Q6PndkDc_CqFif3Hy95pkEXBDlPR
 lqd7rp2r4rBWuSYqb9JLxAtxylxLN3cmw7PoWJMRhQ0LKq2k8Q5t7GCWTpI.WmGx2iJI_SpICpWU
 qg9AimE3qodo2Wl.ytlRSglbksPlRg6Vnh6WtHZzkwFamkGuyDUUBgDCvs1aY4bSbW6CftjSWPC2
 f_1GGCIotLO5jzhrBaochSAyYYNdfPhHYAad13_KzTRNjKs29ufO1GpFApQwP.C8Q53zTRuyXhiM
 ycEXVWNatZU4QXQAw1w_ufbLSrevAb9Pv5RqugT2972.53QTzw94QtE31dqOvO.1OIFte_XHhAjr
 zma0c53wok0IHdby4TfSNuVTQX0MXjuZehGdT35DKMlrHQuvCpbEG9avkktfUEuauWD7JqvCWJ0j
 cnWcrC9d.KtJoPXans3uWYrT3YZEwDQxgxuI3sTz3yWM1ZQJ3amgtCxbhgeX93SlQzDJ3Exf_mJq
 53Lf_0cPG.7ulDfX4os_OjW9Q6vI3jtF4Umgb8I.Mez3f4i9wQmArCeV4q2VvIrmtVu9F9YhngIn
 GdSKNsLrcFV6qeyb3gaMBntvUS1r0PmsZsonRUmj1iWHNC7E3PagtxmSRO9sgsK2JQGA9OdFd0e2
 Qgy1UPzHbh8kGYiaFoZLGx6cxV44TIptxNi0TxNkZXYfF5FMGSEUKzm5Rjvo87mn07Sp.Pubdf7o
 vI9qc8vWaR5wRderoDT.fSkXiMWgJGFvEeHmkcY478jDBQ8rfDN1391FxelSL0Z1QcS7YyvNyxb4
 1nEMqo.MAF5SSGbz1_hfVb8lNJgnzcWHa07.1fCo83aKtrL1iYKFETUaJaHAJbicQAnP8YykLZ8Y
 cMXHhX.Afd0GCUqdCBJav.jUwArqjw6wWT.bhTeD.2N76zYrsM8q5S8FWCc25yfgdgHR0ruqnCmC
 3HIx0TQlMIHA6iMQwfMV8Ba3CCXtRsmWCrmcKrPDkQFu__7PEo_hZDgTH9ABMF1X1DCE1VDJdvK6
 fSD7rcXdZEw9oKd5UejAb0Xp9IkyLA.yeIM.Nd8cEkaYW1naBxVbcPd_EOnpWf4eb2am4kUI58Fy
 CtZMfE2lqD3vXPej87fVIJOluyCXNrsIefzo2ZODstV3blg5pqZwneNTS3rTqBEWAcNfrHXsrOS1
 _iaIRZ6WIWedw1ehISTwHSFs_pagRwerWt1lRKbH9wvfAaqXz_PtTaK12b7jpTvwV.4MnPzcpc_J
 BZ4eFFWGMwq8pCuslH_SE8pZMjjCmXigecxxmA0vcz.8pHJESZExi5QYM7rYQDX7MGu2WQFbPIr5
 7FSWaQZGNxGcbXSCp7ZQkFCnP3qFZKU6_v8usXPD12RKT9_cXY5qT0Wm6vZMYg_HPpn2PMdvn1mR
 1688L09HeiNPPNd7Y600lPVyBtUGw_UY9w9xFS8BazNwDd.s8_5ScOIdpaMeE21s0ravL4kPzMD8
 oaqnVHUDaJeZlS2qLV74X9WC7mdwbVnIMNmVr4QLjgksr1OKFhu6dtb4JbofyyMnI1Hq9jLJipjE
 3qUw5.oRvMGgTnAE0QE8.20wXwyXovWcvAFnP7Lvv78Z9owzzDX3ptMZlI6keB7uUO4XvsV8bQip
 1UGp1bmWMybAhH_1ypl49UiOYw4htNXM4nafHc83ngYHni4p9q5MZy9gTISrbngHiwctWO5iJ7wm
 bffIrp.tU6PnLXm64_gfpN2LtP2M3l6NrT_f8ub.SJCx2im2uP_bLv5OOtS4ele8C5W2lsATbi.E
 afMi6INmmP_S1xBf5UhmU30hKBxb3FI7NN2H37qUT1mU-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 21 May 2021 22:05:46 +0000
Received: by kubenode572.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e695631a07a97c834a4ba421db0199a4;
          Fri, 21 May 2021 22:05:43 +0000 (UTC)
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
Message-ID: <d753115f-6cbd-0886-473c-b10485cb7c52@schaufler-ca.com>
Date:   Fri, 21 May 2021 15:05:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/2021 1:19 PM, Paul Moore wrote:
> On Thu, May 13, 2021 at 4:32 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
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
>> In cases where this record is produced the subj=3D fields of
>> other records in the audit event will be set to "subj=3D?".
>>
>> An example of the MAC_TASK_CONTEXTS (1420) record is:
>>
>>         type=3DUNKNOWN[1420]
>>         msg=3Daudit(1600880931.832:113)
>>         subj_apparmor=3D=3Dunconfined
> It should be just a single "=3D" in the line above.

AppArmor provides the 2nd "=3D" as part of the subject context.
What's here is correct. I won't argue that it won't case confusion
or worse.


>>         subj_smack=3D_
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
>>  include/linux/audit.h                   | 24 ++++++++
>>  include/linux/security.h                | 16 ++++-
>>  include/net/netlabel.h                  |  3 +-
>>  include/net/scm.h                       |  2 +-
>>  include/net/xfrm.h                      | 13 +++-
>>  include/uapi/linux/audit.h              |  1 +
>>  kernel/audit.c                          | 80 ++++++++++++++++++------=
-
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
>> @@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struc=
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
> See my other comments, but this seems wrong at face value.  The
> additional LSM record should happen as part of the existing audit log
> functions.

I'm good with that. But if you defer calling audit_alloc_local()
until you know you need it you may be in a place where you can't
associate the new context with the event. I think. I will have
another go at it.

<snip>=20

> I think I was distracted with the local context issue and I've lost
> track of the details here, perhaps it's best to fix the local context
> issue first (that should be a big change to this patch) and then we
> can take another look.

I really need to move forward. I'll give allocation of local contexts
as necessary in audit_log_task_context() another shot.=20

>
>
> --
> paul moore
> www.paul-moore.com

