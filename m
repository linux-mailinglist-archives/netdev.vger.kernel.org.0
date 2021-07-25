Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E973D5042
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhGYVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 17:12:38 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:45155
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229709AbhGYVMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 17:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627249985; bh=xORhjjzL5DrlQj+kyNWxjxAyqHamw8eEmT8Jhj79lBI=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=onaGVwPCbg6vjAJ+EOgJy4QtHKHwt0YisOgVpEafs3oY1fn40J479z1Y2g/gzbXdca7WMhbzDwbmZM+R0DEd9+JNOvplFK/XgN6kZ2Ex4MVu/KvHts8dvNppbUg4x82AzS33+FHRxBbBS0hIaD3z4/CrByjvklo8JIyep/sMAxiQi6GISduPF1Juc7sQ2k8Ei7YmLRA4gVjAbZA+w0k8HuoUNq+w2vvQMagDgoFy9jgga0ymHPMpgULtnDeqXnwqocGsTW5udNGWgFyhCENNFmiB8xpRPgg04viBOZ7dIh6YihYlBitSbGeCN0ei10lAvMRcBTo35iyyVd/zHoQfAw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627249985; bh=jkncHToXB5ap/QnVg3FlvUbRGihEzh6/43vgsh7e2nk=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=TtcvXlcnZZ6w5XNZ5cIT2wMDX/bDcUBiP4XXB2M5HQ7eloNkeOACGLwJxQ1MTLEKo7YuwJQLPQ0CXKX4eFIkQpb3EVdErGqpdxFrWEauBGFYtEd4fgmUvpiqwAjdHYaesxIMiIkUQNkEdMvL7Ex79e/IwgZNAtpcByctHs+mJwmN0RhTBrIO/gAAg0MR1dAcz3QIrBYGwzs34LCAlgE5e8B+WfItFKSbaCkRWgnMmpZdO4yh6fOp5xMPnPpgXTYlhjcrSl/3nU7xBcduQ4w7EYyW4Z2nEeJfksoNNBin+t/lJx7Z/fP+J/T4kW/Wt4LO3eAf5LRqqhlSe+HrpQXSSQ==
X-YMail-OSG: zF.gajcVM1m9vDPzDmRD6YUpKZgd.hlC.MbNogqKOUkqB3LJOznSPhqLJL9Rf1.
 rLacnpztyV7wZt8zot4fvKIXIsxFNueYPm6YpiZWdG4uStptcvgwXmz_NgtvlTLJVuFacW94FbAN
 5KBi91zwR5uCLWLYb5Qnqk5K8zjeTXYwdfrkF.62oLrSI8Yw.vGviDIj_zlkH2tjDwXVOb5qQtrE
 4FofcZONiJo3Da2DOzI3M.I9TVZYqgqIUBUB1qXlQkSF1ZsuE9IpbQkSBPF4gS8tqm8gy3l4rF0Y
 UgkBMCSh71pzx2weMCex8j8mEZzITCuGFVj68zTDssavl8FM80j_CqGxOsB4_fpiuqKyJ.AfTYvD
 .ew1uhk47dua.Zlt696dDDzl38OMSzF2b62KOjlsJSLlkabCvrIzVUhUetsc6OdxLvQrAe4J3H3C
 0SXFBD__Az_bzFQbIHaInz8jEQZLrRhEjLnQ3Wlf44_eHnkie8k77qzlhzHRqb74E1bvK.DLL7B6
 I2K_PATev9_K4jC7VLEC20ZopahjyNqRFn3mNdSEkr8D_cGLA53JZRRy3Bvxtk_iV8MkJdEImFjc
 UVAoCZiBsuRMINstobLt8CH57FQw6JQipkZWbFsfGsa7AhaFvTpLQRKup6e4HVc8i43_zvyGalpB
 U3DZt6pB3hKtieGaVOs9IJvxOF_I5pXg9vNV2c.uVfyeHQqROf5_eNHQXFqTXaBuvvitOAPLqB3c
 bx9cbOXakra0oVW5yUftlHdEH62wD4Xwer8biG7Xxe1TDKRKPc781joRK.bJRM0FMTlzOr05oWd_
 iM8u1x4Msefwen4N.fzbNTJQHuB5cHncpEa3b3k7.49UXcs2RlLHt96CSJMmN3X1V_hxL_Q8vm5I
 M7u1A0ilp0zOpAjBzsDOOl7sHXly0E7xCQ.HUaZqZTyAbN2Jer.cKOsHTZ6LZb1yb9jnKTDiaEcS
 fpjpLsgUswVAIoKWmrt8oVgupxQbn1iOzNDaxM23qxxHly58DxhXOj2FZ.Yi_.V63uEJ5p436UB_
 T7GCIZKkUKYtgpdGeDEW5401x0yvrCc3BuHFkFj_sj8ENknP82YhrsvF59zsSZ7DsIV44QKl..gk
 KN4WbuAYl47N2F5CoVhlHS5PrF9j9y62QaRG76yTOHCsFgkWQ_6sgEMNiQsuo6hGximKUQpAz3yh
 pAHfg_2JnlxVkkaSNh1DC7vHVwprO296Slucb6RcBH6E4AvHq9fhUewXdoenbNCmqPYQV2vggxHa
 SRepBWoZc.ABIJnfeNUjm9kg7jkERa.xdbuuMCOBYA7E5WJqJSizV7Qt9M28Wc8rr9u4rOZ7tb.q
 Mm2Jo4RJyg0tTOlZxlZbD5ZidB0wps6PSAkb0jzyitqiGMG46XqUD.uKyaVgNuTjBaQSCSzI6x2Q
 ATWsXUpbfyQoqDjmh2UiB1nsYVba3mZNcnAEUCihwyxbsERa3oaO_ArRdsTwCINDuXSDyoPQcT3_
 HpEysndbUFdRbs_wrjvUdfFlDdsOsre1nHXbIYNQunbDg7K99zmqgBkHMU4v5YS.nYhdF7cFq0aT
 r_w4ruukMY1XzeF9dB2ft24T9kncaVFhQRSSZqZmrg6P.RiU3PH3.Ao8baM5VoPlE0rCddI4fY7u
 U.sqExi5jDP8FNPRyQsrbYUMZzLzpll5Ag0tQBP0ufxl4YL_VL4tVbIvZHT4ZKF9twuTRHpRq9tk
 YHDjdsSgG7AbWAazGESj0In6pfZxX8hUE_tSxzJR8zSIyTzAOHYHs.lNJoMn7.Amq50Ib4SLfMrO
 5Td3YWSOGh4C_.Puc7wBPc9k3eacD52FhU7N3p7w1g0oArEK6QpISvFokRoxdo9pkqFWvAwWeuRM
 5vKVfsp5JveFIoV1c2_Ind4TJZxniDoKX6dV6eeCpcs1zivBWbwco9V2.QIRTWAdZJJaNFRjJYyY
 z6rx.DNSviDGuK7D3Ne1SvhPu_rz6z2uiSvU0FeE.Vh_q6Rh4OcdwZFehDdzKafNWpfDJS98lzZ5
 2ztvmucb0c.Hi3Bb3AVq0Z3QwTVqOocJ.T7i7Vld3dBkEOmg8TYVSdscEfDIVARrSKjsCxMrA0E2
 nuv4OaCU3SzuBnPof8i28YOy4lzrUqywbiT1H7eP_LVaYMhErCETIbGzoskpFonpAaFa2PVNKioA
 ZP7T08axVyBSAkgF8ZxNxzsY7pNfL.kicFyNUyhgy2.itjYjzDz7ssYneBk84fMeklyJEgfLyysY
 0pnuiB5oENOkTtOunGadT0h5VDKMpYOUNbpXdlMoRyggtjqJqMZP6dYOF4__fJkSKpq5PaDIVy5v
 gdCVZ.CFAFwcKidAsCPHVlcGI2XjvqynJHJDya9TxIRfrnq9XWci1IVfFciHrvOogzQjfqeLq5Vj
 q.fqjlvFwlfLsHIbWemGVa7et16w7Bs1WCW4TWXgqIpRCFtlU4OmBAMWMcty50fz_ggKEVbsPhDh
 wUpwS8GSL0XatO9X927ag9ppOLNO59gkS8dPqV3_S8G4deveqTCGDJAN_61lCpXJA0SmZ7QCJm68
 tije4_prA.lJU_jJHHqdxrouUDdsctsJhgwZdXHkEapEfwE.b1oyQkGRqqE23UjcJIozXR6zDtE8
 AzNMYy19PaGmekuXRT4cH4NliBAhulj4CFVklNQQb_bo9SXZ6k5LIKxrWnCAQls69ndCPa5K7FQU
 4.Nr3UNaG1S3KbmhvjOQGw.r3aAc3AjryLXs5Lw_qyPpd2DNyuUEbH.B05RdIgTQs09YJzQmyqYJ
 zZdR.eXPzf19YmlTfpscyD.626pg4trTS60p1zwL5s11LJfh6Ywe3CA5qtEsnKraGENITekgtaRZ
 QwuBQJD1CDABMtRdAP2y0WGmFgerSJEEINno7Xle0a5Ynge8t6C.cqclCIvd_0OD3K5FBVMmnwRw
 MnT07mnsw.K5XE5e_X.VRNl.cWeH20XSOX0niD8FuoHcM_tXR8I_bD5Q1GjPlYnryVeQ_.6sHJsm
 Tx4pTPabh1OoFPFuM09BbsxveUKcndIoDMmZWtombMxg85nPHkLHooeh3hPpeDOHkZjYmj6ldejk
 AlZuTcXKBmrYldGXjp0oONwD2b406Y2NeyXfbZ37labxhFgy2YwE6pCMYHqDU9MSK63mvIjuyhOY
 yHRYbmzHO1TVZVP.prqU3TpFzql1D92nmcBgCI_n4QUEKvVwRZRV449W.GP5K1qEVrIZ6LJTsL6z
 8UGfhEwM0lu_dSgtCNzBrN5Ekz_OqIqjH_EZtdO_A
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Sun, 25 Jul 2021 21:53:05 +0000
Received: by kubenode530.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID bdff2410ad86ae446ee99ca736669dee;
          Sun, 25 Jul 2021 21:53:02 +0000 (UTC)
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Florian Westphal <fw@strlen.de>, Paul Moore <paul@paul-moore.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
 <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
 <20210724185141.GJ9904@breakpoint.cc>
 <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
 <20210725162528.GK9904@breakpoint.cc>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <75982e4e-f6b1-ade2-311f-1532254e2764@schaufler-ca.com>
Date:   Sun, 25 Jul 2021 14:53:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210725162528.GK9904@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18736 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/2021 9:25 AM, Florian Westphal wrote:
> Paul Moore <paul@paul-moore.com> wrote:
>>> There is the skb extension infra, does that work for you?
>> I was hopeful that when the skb_ext capability was introduced we might=

>> be able to use it for the LSM(s), but when I asked netdev if they
>> would be willing to accept patches to leverage the skb_ext
>> infrastructure I was told "no".
> I found
>
> https://lore.kernel.org/netdev/CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82=
mWPduvWwd4A@mail.gmail.com/#r
>
> and from what I gather from your comments and that of Casey
> I think skb extensions is the correct thing for this (i.e., needs
> netlabel/secid config/enablement so typically won't be active on
> a distro kernel by default).

RedHat and android use SELinux and will want this. Ubuntu doesn't
yet, but netfilter in in the AppArmor task list. Tizen definitely
uses it with Smack. The notion that security modules are only used
in fringe cases is antiquated.=20

> It certainly makes more sense to me than doing lookups
> in a hashtable based on a ID

Agreed. The data burden required to support a hash scheme
for the security module stacking case is staggering.

>  (I tried to do that to get rid of skb->nf_bridge
> pointer years ago and it I could not figure out how to invalidate an en=
try
> without adding a new skb destructor callback).

