Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3454639CA6C
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 20:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFESNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 14:13:02 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com ([66.163.188.211]:40043
        "EHLO sonic311-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhFESMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 14:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622916663; bh=Kje5cwPgu4QYPNIDOpbrtDsTRbg0y4ZTsWOdXLjZyNY=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=NHenALg2M4T+mv8CS+C0EfwlPsnt3ibsxJ8iCndyOJaIiWmMJCsYtP2SyYWdoWTRD80bDIj8XT+AkrANLv0oxkx7tkaNc1Lpi7XoKxYWzIQZRfX3GGJLsj/FpT6Qs7ayHrFzQSd4Fj9QTeTXjMBcSJa3nsMjd8EhfJMiJSs+NqvW8HCKUuWKBDqR+upSy87xQ/qrHtYlIAmLJIuZLIM9Fzm+DtYn7Zu1MDqCyuzc26C1SgLNJLK2n8Uu6rgCLjbR8gE0CPXG81T+r2Qr8GBOPcM8rM/d/yK+X7EJ4VQw9i18Yp4DxR3mfAk1Ce80Ec1xW5b18l8aFggHlv0vHRMMBA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622916663; bh=3be9mn+SpSR6oENaqbbPO4rKoBPSzknj1RT6Yoe/bry=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=MXibhGPi/qqeqbyoFyBmRdVq6Gg6t6AI8cbW9qbrugmMVWVIdPlN4VtcXx84H77urDaA9JkDlTa0Yt2KtGQWNYRwAK2H32bZWj/z5gdfYeTAymShx2jQBChdx6xl/GS0NCuBbivCTEvtTjvJXTkkPqXSafeJJRu0//2LnRpzO+60KDLeBEETsK5wYgvDWbX4QDTzVwEhkAcmWiHWyQ0Vv5KWpqlic4WSSSvwjqi5dbr+huTk96//alzskJFXcLtzqVWIZVk2N5ZMNWEJqFL7C9F6Z5Dy55mNKHQUtNj1mS4wNj4L4N3jGLqOL1hAwMWZQjzbNAEq/dhaW2bPQW5yqA==
X-YMail-OSG: cF8D8R0VM1nsuMxMLI00sxlIxjKLHsI0L1VQDvvbdxJhZj16PsIhofgaxQy9Qh5
 PKLQ_C6CtWijqfLxwhEKuXJO.VWrw8oGZWBlqZVDEDiMGAB7y23VRKDWZbVUav15Kw5PR5ar7E14
 vZG30SdYl_6Vq_MrrhP4hyQ6ZUokYURZBjwG1QlDJFvCwqMv5pffQXh7oCoekciyOAxqDP.nN4YX
 Jyp34s4kGps3i32YyijYCZVtUuHvOMVxziIFU1whUeVskOOOoMvfecBI3sm2NAIyLwvd2fz.0Iw8
 vRcMqDhIU1A0TkK8vhfTOIYFNY6go4oOEs2MpduyjxphAQpDEusjjEQ3963bYWIIQDK3AQTtfPDA
 XNIfjVd57ckd7GtJ9s_ezKyGadVCepA08TcSSZ.a_lg8dNmz99kHo5bzgdXqzqJfGfesqdl_3pxz
 f0eKBamSbZpbeDP7I1jJSj6wVV_nDGLeTioXu5tm.0nusPIIqOEBCZaLrAQRJQ17HfXd2ZjmxFSk
 7CFJSxI2REynHUqR.aLdSUMkASA3tzem5XRw7vWyp0zqMvDZL7Rl7AYBx9JMk86VkbgfHbJpTPd_
 _olgNx_I9ior3yHUqCc_2R7HqxobiaDzl4pNOCQuOWS1BOPTVPEmCU8qsdgx2GLvzm.9JZd8_2B.
 FjHWQAcHLXp3U0oB6oSIPTe5OuIhhYbLaAZkd3PLBudwtPfrzcBDxlVlpyAND7suHee80HtjMXOn
 ZNKSqv3oqiEArfrYVmmRfABQF31GLhAB3CNAkkmCiWY_nYOJS6wumV4xsBpw.of1vv6a.jjLO9JI
 jtHNJf68xC9aczo0OlKK_7oE.xRqPenZd3GUsmf2AouNSs8ApXTxLNzsedP3UKudLJCja.lq4xuD
 u_92q78vMTUA4BAPQR101yVPoh0L_mi7HwdtY5u5nXg7pOzw9jNO_IeIO0vBsWKaNjAm7IRYTulX
 ts3GnsDxosDZ2pINug5_Pp5hgvOQtwCNY_OfieaXs1.GhrN5LH6nLXdOIdpAIbjAUWAPQZ1s1QnC
 MCp3k7LnOEqHUvIIr.199TWE5JfKY4Y2F1npua1NxaQNkKcOY19zFKyQUW6Zy0DhmjFOnSQiSMo7
 KchgtzOpyj_y4T.p0yycV8OjFvbE61xND_7YRSqLH0nn4oETKisE5VaorBV3_L7Y13Khflo4RmgI
 67e7_IcQXQXjWMFNjLdHnw3oYFKjNQYmQo4BZTadpSei1.cf.jpJ4UwL639pGykIHQrT44NMpFA1
 tG3WYZLj39oDTlA38PIs1uOjvq2hMR0H_IMPxQnXjzKVzCK3xRvZaiRnIyWd4TSmpJ4OyyogZ1fV
 XXgoYNk6tGr0uEVx6jYHVA6Aw2DvueB.Bcf5Z_qc99gmJcWLST9iFxcySO5pi_U6x.0vCoOr8a3V
 N097UKeSn40lFfX6sY4BIY6B8wRz9ESW2CXPtXfbvLUFixkbkEnAeJsjYaLfa0nlnDDgfAkGYCSU
 aF3syfObRoC0crdAZXAC1mgqCiC_xW3_yOOQ8UKByyZRDRSBeTiw3SEcAQjulndZmFx.4ifrgbif
 wl8iS1QR7DrzWGIWpNj1dAMB4ED4HtzOGgcrbJ0CcFTcabTUXoCtnN0J9xwC6MblCJ3C15olO2_8
 4KAK5Mx.Og3xCKPkpMvwfyNEGBSW3M3_YyMZRcd_TEODz7Y_w1BNoJ6f9tKOH7GxjbforI4BAUZ2
 18SQ9YMnKPke19i.4B2JodLdPsA6Dy5faTr9uVtD37Ymg8_xzflH.N4DJJ.pupDJunOtRh34kiO6
 Q4xwjhrvD1iQvOuUXkJRZXVLMlMB8FzbQCOrg3Vy_v_jKPU2wgf0kjD_ttSAR9dPvlKQEGmef8RX
 0AMY4mn7Zbj7mul1vrFdo_sH29OEoIdIjx7ap0Cu0V5LTWXEoRGfgaGNcqHLryVgs5xF7Snou7aD
 ws4t_K_.rETD_impryBUW0B5THpPjoNu2W1YT3TyKco6ydIsXWyFLGYwHwilBV9wvcCuT4UbTfGB
 dvSpH1jWtrXSaXtRMbOkJVbQIIW_feCCUt6TLpmlWQrhju3P.tCFDEKg1TpT6k7ofkrjU5t3xt3L
 JYwOncSxDio8dofJm7v0PfeXvR6K1auhdAI7.FP_hf5X8eczvZg14mBve5FPBJ4Rrc8Niabllu63
 p3a5Hh_B4iHYf6oLcOFzD4XPC9Y1WqOiFJEofGSjxhXd.2nASVXTnr5ZdqtXQ5nBS6cXEcxUxB.I
 jO7zBYFjmaDv_ygDjNVWw3CZ5nSqpfXFiDUMip7ckByJhloYWif4Krf9poRp3d2.y9Ihhmf7hnr1
 nGyskCAPwf2WUBRNfYg1hQLNq5__Qrsm_zrFLBR4cIWjkVBSsujS8t3.HUad9fUvW_bWMVqE0L97
 M1IKeuVkiANKmQuPHwnVYGDKs9vyHmNZ4qj8Woi78f3LvjVOjFztCjVpNeWccBaWvwKIzaYMd6Eq
 1zRtmrKDBt4gDfXfDMEn4noMMsMmG0qsqRzTq9NjotF9_ZUVos.KcvyY4X2ELQVnqaZbKiWHiA03
 v9ZQ9wRXmCirAD8WoObjlisTSYfrYYmAh5NTq_8qAHIOy9CJtNqjN3bLj614cHxaY0KB0CwxI0Yz
 fq2bS49dk2EwY0Rj4_futCXs8g7UAxB437g7nqjJZ3_cEXdTf272TLtSKTJwqzZV3xA4ffsKUrQD
 .hsCXc1eYjUrfzsIuviR5Dt7lgdccp0VNkguQS_w9_U7QM3YkvARIqTSyHyxjv31FPmyJTFdNywD
 X6WwmmvfoNo3MM4o0LBRlpuZTdOjznKYOjNgLLO.lZ2W0UiwZSO7JnvhWCvYl.SHPMqOuMuAcd98
 TuSv6F5jrUUx1HscYbpT_KQSy4PV89TOa9qDbtHTxkrtXjuZG_JlYNZUHcJGLtht1U4YtKrDDZqP
 YziYeK9sL5JU3EQO8ypHrtxpFir_0s.SlyEi.a3BZpouTpkZFioJvy55z_wfk5kA9LAt1ohLfD5B
 LpVw7Q.XG7e9iQaRfAUec9So3LBcDUehA6xeTq_3e8X5Y8EuzrY0gFe2QqyImmwnAS7U7z6yaW_o
 eXFOjM468cqLpzNsStX4lREHQC34tU4vikIentHbTwgVKH_M7V7dzU9IEnwoFeUA2bpsosaZVgKo
 XXUFaHOCl4hZrWCOIYDbvCDXogsm4tD_HU7f2Zd6gbLiPPYtIt14dR0T20gzdsOc.5bUmFW5kRU0
 JZO5A2t6DjY.jPDP5VRAIfMxoWuh64tdA.ag6Jig6D7f8ViVITCNOFtXu8JkBvRS27TKqg_91..b
 J89ucG5vmW4EC_lmvLXVft4flGxRLhEL6YkGpBJPICSE1AuHfwrjieMbDuJPl5wuS_6eomVm2dm8
 p.nQ_Qpzis.Rtk2rNqwaWx_GccY4wXFdz7FMHdMsrI7Vez54DFoq_LNXApdxANNRbLQ63q6nx8Em
 nsXTqV9NI3Or1K9Y.gppLcLne0cPNznDkPIzkbKS8yjrcV1KaPUAVDJgnJqAWUeZMzjzr2LoTACv
 4xNwYbqU6b2zDXLe2KFi.pyF6WRDJ_xNQhKdHSQtabUVA2Y_.joV.0WMuxZd6JJ45uJcZhgIdZeE
 0DT46CbONaK6ZfcRHaZT55RTJQrs.uayemwqwuLxR1tE.H3CG_7GIktC_T30HbTNC8e07hXOtFnq
 NQK46t5sr2iUh2CnH_xuHbkvYGabd.p_LdKECQYwWwLpvz22LlW4whY1t3OjVf6oJXhhuIbHt2QP
 8JbT2QY45Vzg.tUR4uW80gHns9PeoeNWFEo.BGyBFU3IrbiGT_AtqOYNp_KPlKuNlChKP54T4XSy
 W2ThzaXXsq9y5uGxYHEryzrfdtGqPhuNX9Pu7BC_S2.qixPuC2_Xbev9pRnih_jtd27iNB7jjUjJ
 3EWabuxb32IGiIkuPCE7AduWlWgRCYs5kBY7vUCnBOWPBktBXfSY7I511WxOJ_RlR1ji4BTalFEG
 nF0xF4kYpCrvA.Rk0nPfd35yCVFpPwpRusZmSzvzvwkdP8WyImNJcdSVjcOHOTc8DbCJJrZiYwTQ
 Ai7a59irZxwmHIszqD7_BzCtaQ7Ay2VXYqJBScNKVcj6pIKtRoHeChsLiKUHZYcHM7Tmj_RSjFxf
 QeOrVxCQWMyg-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Sat, 5 Jun 2021 18:11:03 +0000
Received: by kubenode542.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID fa5b415bf7046dbe1092e3061ce7176e;
          Sat, 05 Jun 2021 18:11:01 +0000 (UTC)
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210517092006.803332-1-omosnace@redhat.com>
 <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net>
 <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net>
 <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net>
 <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net>
 <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net>
 <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
 <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net>
 <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
 <CAADnVQ+0bNtDj46Q8s-h=rqJgZz2JaGTeHpbmof3e7fBBQKuDQ@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <64552a82-d878-b6e6-e650-52423153b624@schaufler-ca.com>
Date:   Sat, 5 Jun 2021 11:10:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+0bNtDj46Q8s-h=rqJgZz2JaGTeHpbmof3e7fBBQKuDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/2021 5:08 PM, Alexei Starovoitov wrote:
> On Fri, Jun 4, 2021 at 4:34 PM Paul Moore <paul@paul-moore.com> wrote:
>>> Again, the problem is not limited to BPF at all. kprobes is doing reg=
ister-
>>> the hooks which are equivalent to the one of BPF. Anything in run-tim=
e
>>> trying to prevent probe_read_kernel by kprobes or BPF is broken by de=
sign.
>> Not being an expert on kprobes I can't really comment on that, but
>> right now I'm focused on trying to make things work for the BPF
>> helpers.  I suspect that if we can get the SELinux lockdown
>> implementation working properly for BPF the solution for kprobes won't=

>> be far off.
> Paul,
>
> Both kprobe and bpf can call probe_read_kernel=3D=3Dcopy_from_kernel_no=
fault
> from all contexts.
> Including NMI. Most of audit_log_* is not acceptable.
> Just removing a wakeup is not solving anything.
> Audit hooks don't belong in NMI.
> Audit design needs memory allocation. Hence it's not suitable
> for NMI and hardirq. But kprobes and bpf progs do run just fine there.
> BPF, for example, only uses pre-allocated memory.

You have fallen into a common fallacy. The fact that the "code runs"
does not assure that the "system works right". In the security world
we face this all the time, often with performance expectations. In this
case the BPF design has failed to accommodate the long standing needs
of audit and SELinux. Shifting the responsibility for these design flaws
to SELinux is inappropriate. Integration of sub-systems is usually the
burden of the newcomer, which in this case is BPF. Paul is doing the
bulk of your work for you. Maybe you could step up to your responsibility=

and work with him, not against him.


