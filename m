Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312874F4624
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbiDEUAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457643AbiDEQYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:24:03 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com (sonic311-30.consmr.mail.ne1.yahoo.com [66.163.188.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7519F3AB
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 09:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649175722; bh=szf/cJYLQOZWni9lQf7ZhLfzr+7rhBIA+E3sIp1+wJc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=bZfL/NxYUY/nWW3qF2ZJjXG7Dg3pNQUyUnVHMCdlQYcK8KhjV2XIlaKccjneeCkFwe+UCJcmiHojHKBIADLU4Ikbupp+K45ltqzCRWzFjDPZMJ3/O7vaBcjp67kmvgMnWI7P0TCKjW99cXK8bk+5rylTUO1IAsJur8Jnb/KOHY4RMaxTIYqnDQ1lTkISegPfoAVdUD6+eHMiQt4gKQJoSBEhNaGN2pU/bjA9ttpnY4VZfD8LFNi+2w1An9PfTYYCHWIluLdQOnyvy9qkUs33ycWByVBKC8R7NedWGNHjON7zbO7QJDyfam89JJ2UClf7U5zwYsNlK8flfJ4iFI5e4A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649175722; bh=MjWoY0XQ7yCC8DRinMvFIWEycwD9ENQrbHuDSvHQo40=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=QZqQZtXrXXr+kG1OaAGR8Qn0h22DavyioI6fHj1usmFCPqfQk8tQXvolZqg3SQvh/W0Nuv0T5zGX2AYVLxAj9eiQkIJyD/5kj1LCyQJKBgCt7YeKkyYi1rqEQUnWFCH1aTzNEUiMEPTOxKWN75UfbQG2AvV7uZsjc//Nbr8u8pkbOcd5ieeLWq/Kr8xKN/1drb2wiykVfYRVCSr9KhChmWf3nosToXopMFGmlcxdmbHYy/V+v1rF1NKkAU8PZHQKcJervgnJWq41qGIQxnhHgp02Nhh/mxFhno06j4KJ1DUqqFDVTNoh99mw8mM+fcs97dodAzpjpLFFo6+fz2H9wQ==
X-YMail-OSG: zQyH2LwVM1lp5wptu1Nu6P6xp3FdwTzJCg9Lej0g55C5Xx0XIRvIQ05IUhF81Xa
 p5wo8I1T_FGz5a.8kX7LA.b37J19Sa53hRJwhiWeUEz0vNsHWCZ4Zw8ii81Awkjj0Gk8GHkvtcKt
 JBgvws_8K8YjlxSr3DgFY7b9uTWdblyYIjBK9tHDGhHLPi0pq_ZGwvP4Pszxk5mEmqQb.ecXvauS
 3uVHa7k5mgaWEQ9.xJnR1BNEh5CXais8nD.voUgflz2WxJnhRulTYQ_s5hjDIBMfyIJ6.N_m7CXQ
 pxC46xxx9gSozYR6ffjr.SLgNTxb3.xrWdXmQ3vKVEUtkvCC2QxbK2QkKAyYpYc7p5j4NjYPyXGS
 uK3NDvg6a9ynh8e1.Vt0v5gyBrGgdZP00r4n6C41JCCETeT_BwtjsDgN4hYPSYuIKKvVA5Bw.aMo
 8CJ0zW2G.uvcecyYN4GKTRI2pUAfIHD5dhoIZWZkrVQH.zmFeuZIB5T0gV1tgD2P8YJpZFPhyW2q
 3mG3qzvduo66EOgEyniniTs57H2nebdeRyaWflufxY9pYu_pk5ZDT_ftZhA1a6pw2H0EkOq88V7a
 CXER_19r_9N3Gw9iOtemV_Ip4H25Xq6OfftLt.GTr.n_.BX7pYd63zeJtFsCE22LImCE7fN4VNKN
 Nop0eL23X2KvJJrQI3EGmNzQVP7Bbew2cVZeNLRwdp2P8i2gg22C4W.cG3q4uQ24fK2sxUA1n9NZ
 i3z9gTrvNEFRo_Jqn9pt5i0L_nGvWtdNYRDDsLwSe7VA3pwjpJINAtCWe0iilbPU8f9OO9Pade6K
 MzzFtSLMhzhSFARvhqkOOW5IDc3LwHg0dv4iOgSR3SRmD0_tmMH6.rj6tKKWhhS7IT.KFZjaILr8
 GyWYjD_hc9lGUTt9lSU2DYoiRKTu6CO8FJzEP0uz0T8rpzOJgmtt9axS2xqEb62VtkLpt.N0t74h
 61R5hpRnUjCa1IDwAslSGt.vYPCHM3bZ1IbEgr29EyMdasfmXRWp5VtTYPgia9LBhzCSgrTBU9fI
 FCGnWpVhg_eXTGgRKoUnb8IxtUC1DNFPVNKeVlnCOTwVX2EjMuwPfbI.XOwt6XjQQ8vlpJko_PMd
 X_n_SW9mCGqGvtBFIa5XBfID9pjmF.BDJBmTIkBuIUTtl9iXDtQZ8xRnVBsPmrsP2OHkx7h.C.kT
 NgEWrcNmNy1l1jmP0AGTMtXIMaza92pxwqPYhqEpdARZaWi_g2RdDlaTc1pXubLpzoqI92wf68N1
 Z4jCCpMkm3yjfFA8nGqTxtMc9LG_OIl.2FRtwBmgUEuFai4hZUvFS10QsgYMQXhslH2cKpYvcfZX
 wKMzAleqOjU7WuAkPCx5LkGLZL2_eCPbg2Bn4GMlcqaJ1uKrCt12c.4k_5B.bTMhXd7ARp88EACu
 79CBisyF280Aj2dwhkcmwHuaDMD449DDyQzY6l6JdE5qZvSl7RvT6Ckhu9Ml7iksUEMroGMicaMu
 bti8mRpar5mkedy_AOxThS8l46n2uSHNr8vs7abj_o9u9ykY18P5lJIrYi9tW9ZGdn0ZhK_1fqej
 1Lck.Ig0FCYlp2qDft_xZr1VATGM1Gue_TWbpX2izkpS2bS4T2QZZF8q7FgE6WWvki4Ut.eZImyy
 .cNRifDt6GlQErfWY3mUn3.L8efdsmXVwggeBTKja1hnandR1RROlB3OnPBNch8FFAFiZnOhvAXr
 QIjHOGd5HjN4lxsee4tcq1ADCo8UoZxbgiEULZRx5a_UHjbtpexPcu7PFTuyeXbsNe4qJmLQY5Qs
 XzxDp3xlUqZcCh06XH1XsuAhtIH6.0zGeMZ65XRvSKE_XQsAKxgM5ukcIOXxXMPcYTD1VTYrDhKH
 c.AaIVuH3Rc2.6d7.ac2nHWtLILdFBEhx2mcP9ekRNsABsUqG4xD3dykanY8e3mYVMC0.ieDQk2n
 OQbEbhfBkt1DQqdP.g3tVCdmDZWcNVWmvMGw0fYzqvicvnXGi01FHwTrUvP6ENNRDh6d84BrUevr
 QioA4Gg0RDKJug0e.Jl2jm9abJEojMxAxwmWzxR.O0n8qZfYo0s_zBK655X.O3GUSl9ZvLn75nq1
 1CC0q.V2UcuNkx_lb5Z9x6hFFZixe7VLqytr1BAVIZZWlXRypUeXtVND0ZB9IMIRHx2mJrw2l2fS
 Bf_fJ9OHXPEfwBlG80hEqu9C21UKSfOLni7bAO_yUjP6ZvHToll22s24VlPQ3BE__5B8gQNX5Qet
 TFSx_AgGA48hwvK22F0vvPa1gMQ8Y4ZiOoiRere2IY4PonJv99q6MnJaS_jLHBKicawqnkrZpUf0
 yK3F3agTG7yf2B6E-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Apr 2022 16:22:02 +0000
Received: by hermes--canary-production-bf1-665cdb9985-6hz22 (VZM Hermes SMTP Server) with ESMTPA ID 3e6e483849819b115c06d1b80343537d;
          Tue, 05 Apr 2022 16:21:58 +0000 (UTC)
Message-ID: <fb804242-da2c-4213-9dc3-f09ea42f0355@schaufler-ca.com>
Date:   Tue, 5 Apr 2022 09:21:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Djalal Harouni <tixxdz@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
 <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
 <20220401235537.mwziwuo4n53m5cxp@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CACYkzJ5QgkucL3HZ4bY5Rcme4ey6U3FW4w2Gz-9rdWq0_RHvgA@mail.gmail.com>
 <CAEiveUcx1KHoJ421Cv+52t=0U+Uy2VF51VC_zfTSftQ4wVYOPw@mail.gmail.com>
 <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
 <385e4cf4-4cd1-8f41-5352-ea87a1f419ad@schaufler-ca.com>
 <0497bb46586c4f37b9bd01950ba9e6a5@huawei.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <0497bb46586c4f37b9bd01950ba9e6a5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20001 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/2022 8:29 AM, Roberto Sassu wrote:
>> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
>> Sent: Tuesday, April 5, 2022 4:50 PM
>> On 4/4/2022 10:20 AM, Roberto Sassu wrote:
>>>> From: Djalal Harouni [mailto:tixxdz@gmail.com]
>>>> Sent: Monday, April 4, 2022 9:45 AM
>>>> On Sun, Apr 3, 2022 at 5:42 PM KP Singh <kpsingh@kernel.org> wrote:
>>>>> On Sat, Apr 2, 2022 at 1:55 AM Alexei Starovoitov
>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>> ...
>>>>>>> Pinning
>>>>>>> them to unreachable inodes intuitively looked the
>>>>>>> way to go for achieving the stated goal.
>>>>>> We can consider inodes in bpffs that are not unlinkable by root
>>>>>> in the future, but certainly not for this use case.
>>>>> Can this not be already done by adding a BPF_LSM program to the
>>>>> inode_unlink LSM hook?
>>>>>
>>>> Also, beside of the inode_unlink... and out of curiosity: making
>> sysfs/bpffs/
>>>> readonly after pinning, then using bpf LSM hooks
>>>> sb_mount|remount|unmount...
>>>> family combining bpf() LSM hook... isn't this enough to:
>>>> 1. Restrict who can pin to bpffs without using a full MAC
>>>> 2. Restrict who can delete or unmount bpf filesystem
>>>>
>>>> ?
>>> I'm thinking to implement something like this.
>>>
>>> First, I add a new program flag called
>>> BPF_F_STOP_ONCONFIRM, which causes the ref count
>>> of the link to increase twice at creation time. In this way,
>>> user space cannot make the link disappear, unless a
>>> confirmation is explicitly sent via the bpf() system call.
>>>
>>> Another advantage is that other LSMs can decide
>>> whether or not they allow a program with this flag
>>> (in the bpf security hook).
>>>
>>> This would work regardless of the method used to
>>> load the eBPF program (user space or kernel space).
>>>
>>> Second, I extend the bpf() system call with a new
>>> subcommand, BPF_LINK_CONFIRM_STOP, which
>>> decreasres the ref count for the link of the programs
>>> with the BPF_F_STOP_ONCONFIRM flag. I will also
>>> introduce a new security hook (something like
>>> security_link_confirm_stop), so that an LSM has the
>>> opportunity to deny the stop (the bpf security hook
>>> would not be sufficient to determine exactly for
>>> which link the confirmation is given, an LSM should
>>> be able to deny the stop for its own programs).
>> Would you please stop referring to a set of eBPF programs
>> loaded into the BPF LSM as an LSM? Call it a BPF security
>> module (BSM) if you must use an abbreviation. An LSM is a
>> provider of security_ hooks. In your case that is BPF. When
>> you call the set of eBPF programs an LSM it is like calling
>> an SELinux policy an LSM.
> An eBPF program could be a provider of security_ hooks
> too.

No, it can't. If I look in /sys/kernel/security/lsm what
you see is "bpf". The LSM is BPF. What BPF does in its
hooks is up to it and its responsibility.

>   The bpf LSM is an aggregator, similarly to your
> infrastructure to manage built-in LSMs. Maybe, calling
> it second-level LSM or secondary LSM would better
> represent this new class.

It isn't an LSM, and adding a qualifier doesn't make it
one and only adds to the confusion.

> The only differences are the registration method, (SEC
> directive instead of DEFINE_LSM), and what the hook
> implementation can access.

Those two things pretty well define what an LSM is.

> The implementation of a security_ hook via eBPF can
> follow the same structure of built-in LSMs, i.e. it can be
> uniquely responsible for enforcing and be policy-agnostic,
> and can retrieve the decisions based on a policy from a
> component implemented somewhere else.

The BPF LSM provides mechanism. The eBPF programs provide policy.

>
> Hopefully, I understood the basic principles correctly.
> I let the eBPF maintainers comment on this.
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
>>> What do you think?
>>>
>>> Thanks
>>>
>>> Roberto
>>>
>>> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
>>> Managing Director: Li Peng, Zhong Ronghua
