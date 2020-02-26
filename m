Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4016F448
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 01:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgBZAaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 19:30:46 -0500
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:45506
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729387AbgBZAap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 19:30:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582677043; bh=8RRtcuYum8ovdHNN06sxqW2J5odMVOW8xNFE4vMX4DA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=soZ1hb4Br6OuS3IoJXPXQY76/nU8NjxFJoHjojsUeiM/1WOKxK4uR6/K07f3Q2smwitJ3B8YqhugKA4DVaYF4RGDF7bQRv3dLRmmW6IN/o882Hhn8EM11fioBLkuAvbW0PZh6ZaXElhE/QK9OpHawzOwwXRVGFATozb/0zAUBMJGWnSWeL5V5p4mYfP7vwUOdX15N8/MWYXqsm5UiV2iE599FcfhVMMTpnECg2GKRxMizYA0nERzfVi9MUGWJr/F+d53/btsafJNajOomZz+0Ez3dKwpdzSkvHAasKltLmOUO1xYyQoP/mjWkLAGuwWGKVWk7eHP1KGfMhv9yhGlvg==
X-YMail-OSG: eZDYETgVM1kY8ZOHZprUzvTnIHDKLBO86FGQjgcrXb8KeSSxxhuCAyTMqrNmhtf
 DxKxxC9wfxjClsyAxumzJaYYsBhooCwtNiibcg6oSlKknuizXRb.LGmyucLbG_bXndK2gl8JAVco
 X8HO0_wNNtTrLs_ipvT8Q9TlZ0V59IalXsR353MwBiswIrdyM.oRuX2k5a20eA6MFtxIB3FCIIb7
 7YyKTql06AwsaQjx2M1OrfPP5XUlMpSXiW_NocIeyu.Qe89lbrCo6oJCF6fz4FttFmVFGlT5jbkt
 0Y_HpNqSopkzvGGMfcCTJA.ueEu_HaYbdMTWKqtxQqcmtPy2nFBj4k1t8gzarPMMkTvStEeF.z7.
 fZskD9PT5FtUXOzcLLp7MBWe5O5tfKivhgNZPN6stzgsEZBVtWrf_r4h3.CcJZGIOq2ZrrI90xo5
 2plwjfYgTnhkilLd5vpMH6NVqD8Vaqpsd7Fa3nC3plm6PMcUA_q.XB8otnFdcoRsRFlWnPYSgfzq
 tDLhw_ZJWU8iNDFIxE6Q8nkysCxc1sxflOGNbIbf.Nm7uVtLVn0roteDC4O__vBlTD_jD1CUS2zf
 7_M4lP3BwgH6riDMIrdMiN7ZmLGas4a.hAhcGbVH33kfmL6ZA7WlAIMbGI8HVB.CAdrmdgshuZRY
 c4js066k1zkTMyH2_fIF2n_nTFCG4Y4su8n83Ir538f1oX32P4WJiq4rVoLFaKw5WBdgCwc1ygWD
 PnEW1taX9akdGMZyQDetcXnkfxE9OEF4KbnBUl7U6ZD8albEukd7x7wj39fWMa8DRoUvbUoNU8e7
 ujqaV4GrFHnrVGx9ZbufZITTt1KrBMyT7OMgeJhryPB8XxdIy0KNdwJIi65J9JRQfI.C6DcvQCRj
 FLYNS1quSM8a.C4HEYUw0KhHqxQJnSULw5VRfjE3Q_DsGs5hVcr5kTz7WfuWGiMrI1KZtXXhVswS
 EpUUr7wFJLnYoULWI0zsAo6OjzBzm5F0LC7pomCBv4Pv_vUvHevYUbBbuqJcuyyh28OT0yMaRC16
 CvY_CX2QfetyFtwMKq26xADxGMLqnaWfnm0cU9njp1QbarB6Njjkm8zTwwVvZ.9KOmdPzjCt5bLH
 zq3.rf9drLCAGt.Aiz52ZITyR30t.3bOt6O.PWs3ZOXQ4VjcrX7NQwM.eyUpPtvzYAV4TkyylFtb
 CNyTdtXnSbVF9QfZpBL6vvPkrWCH2GxEn3CdkbyfHUTcGRIycimW.iEHZbw0zz9dfQJ0m.jAcExQ
 MBgBgYUu_.Vq6G6iExqPAA1aUlnvg7Kzrfb.Ie4n9dFdlQm60uYViY6ZDjraFoiUVvGuM_475HGA
 opF3iOododssDi4xi0aooaQUZvYWYEUwshz0EwaUHgnmm8o5suwN1ZX7elsHYo5_ZVOGVAemZdOa
 ryvQrck62PxrO5cPpgsfIGwHzw5oauK5xINB0Et1nAWiJReV684Gkws_ObH7UnxvgfcbkRADnUK7
 1dJ73DpFre.6_lH5TAKyiY7GjXiMzaSdIll9lAk_sPVODaOU77blQRzPCDys-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 Feb 2020 00:30:43 +0000
Received: by smtp404.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID bf027b62544540883a33b875121270dc;
          Wed, 26 Feb 2020 00:30:42 +0000 (UTC)
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook> <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
 <202002241136.C4F9F7DFF@keescook> <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <4b56177f-8148-177b-e1e5-c98da86b3b01@schaufler-ca.com>
Date:   Tue, 25 Feb 2020 16:30:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.15302 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_241)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/2020 9:41 PM, Alexei Starovoitov wrote:
> On Mon, Feb 24, 2020 at 01:41:19PM -0800, Kees Cook wrote:
>> But the LSM subsystem doesn't want special cases (Casey has worked ver=
y
>> hard to generalize everything there for stacking). It is really hard t=
o
>> accept adding a new special case when there are still special cases ye=
t
>> to be worked out even in the LSM code itself[2].
>> [2] Casey's work to generalize the LSM interfaces continues and it qui=
te
>> complex:
>> https://lore.kernel.org/linux-security-module/20200214234203.7086-1-ca=
sey@schaufler-ca.com/
> I think the key mistake we made is that we classified KRSI as LSM.
> LSM stacking, lsmblobs that the above set is trying to do are not neces=
sary for KRSI.
> I don't see anything in LSM infra that KRSI can reuse.
> The only thing BPF needs is a function to attach to.
> It can be a nop function or any other.
> security_*() functions are interesting from that angle only.
> Hence I propose to reconsider what I was suggesting earlier.
> No changes to secruity/ directory.
> Attach to security_*() funcs via bpf trampoline.
> The key observation vs what I was saying earlier is KRSI and LSM are wr=
ong names.
> I think "security" is also loaded word that should be avoided.

No argument there.

> I'm proposing to rename BPF_PROG_TYPE_LSM into BPF_PROG_TYPE_OVERRIDE_R=
ETURN.
>
>> So, unless James is going to take this over Casey's objections, the pa=
th
>> forward I see here is:
>>
>> - land a "slow" KRSI (i.e. one that hooks every hook with a stub).
>> - optimize calling for all LSMs
> I'm very much surprised how 'slow' KRSI is an option at all.
> 'slow' KRSI means that CONFIG_SECURITY_KRSI=3Dy adds indirect calls to =
nop
> functions for every place in the kernel that calls security_*().
> This is not an acceptable overhead. Even w/o retpoline
> this is not something datacenter servers can use.

In the universe I live in data centers will disable hyper-threading,
reducing performance substantially, in the face of hypothetical security
exploits. That's a massively greater performance impact than the handful
of instructions required to do indirect calls. Not to mention the impact
of the BPF programs that have been included. Have you ever looked at what=

happens to system performance when polkitd is enabled?


>
> Another option is to do this:
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 64b19f050343..7887ce636fb1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -240,7 +240,7 @@ static inline const char *kernel_load_data_id_str(e=
num kernel_load_data_id id)
>         return kernel_load_data_str[id];
>  }
>
> -#ifdef CONFIG_SECURITY
> +#if defined(CONFIG_SECURITY) || defined(CONFIG_BPF_OVERRIDE_RETURN)
>
> Single line change to security.h and new file kernel/bpf/override_secur=
ity.c
> that will look like:
> int security_binder_set_context_mgr(struct task_struct *mgr)
> {
>         return 0;
> }
>
> int security_binder_transaction(struct task_struct *from,
>                                 struct task_struct *to)
> {
>         return 0;
> }
> Essentially it will provide BPF side with a set of nop functions.
> CONFIG_SECURITY is off. It may seem as a downside that it will force a =
choice
> on kernel users. Either they build the kernel with CONFIG_SECURITY and =
their
> choice of LSMs or build the kernel with CONFIG_BPF_OVERRIDE_RETURN and =
use
> BPF_PROG_TYPE_OVERRIDE_RETURN programs to enforce any kind of policy. I=
 think
> it's a pro not a con.

Err, no. All distros use an LSM or two. Unless you can re-implement SELin=
ux
in BPF (good luck with state transitions) you've built a warp drive witho=
ut
ever having mined dilithium crystals.


