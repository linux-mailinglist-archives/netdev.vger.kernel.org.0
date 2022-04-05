Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D3A4F4387
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352685AbiDEUDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452049AbiDEPyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:54:20 -0400
Received: from sonic314-26.consmr.mail.ne1.yahoo.com (sonic314-26.consmr.mail.ne1.yahoo.com [66.163.189.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0D61D1935
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649170201; bh=wj9b4EM96Nw9uy/BlR8A+kRsw+NxU/IGvlc7WNtaG6Y=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=szLTqN29hH0Fplkr6uAe+MXF5PEA5fsJqTjRbZbWpnvC0Al5xHpu2TN4ooBY38wWJ8uiTpimodlROdpLS5wh+w/cRUkreeUOk4IRrNYkk0oRW0v4kPNiuhgPw1X5zsHOt/MDQkQXGnSVaNgfhv762MM6O896isbhEQuhBvsq1ESOUk/TvdnN2GUdrLh5aQ5PKEy7nh36gPUebwxqWz//ak3Yuw61QLtypYZo2v+UhhO4ojX1rvbwuZSNQau/+CPl1qE7BLh8g5V3Oflo+FP9jLuvjXqyU3z15HyXJgvy6iIksyrZovyQwmLa6sOUWH8w5VOCGholry/lqUHaRfRKYQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649170201; bh=3ZN3cB5DrA9X/nY5OB/U+58iiXHAjbJw4aWJEs1+cuQ=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=DR1WkSMA58A7/84XbZe7tMPfrRoaKZfEofoTrXU55nzLbY4vyUCbCqDRR9vTC/Uadze+3Ih+fk9/OmEKXlLppRWnckXs7yEoDdbb1WxeA2BD+pBqa9ECHGxmWnpbUTNDe1t0cqQNPdRzvApbSFo59cOpx7FQiPfJ45QLXI6P3V1tLvseXsla3JhAphQvqPfea+KVBdU4EfvwaWyXsIKvq9+Q1xBRonm8LG2UkuJEo/kC6kyrnbt/cBHxXPlbLCTtK/dxx9qrMMl1Wm4gBUD0Zkw7Xm6NU1wxUyPD3d1PcroVIC0uhVcDjmLLYKx7g8iQESNTKTMCxrHzntqKfbbmRQ==
X-YMail-OSG: CFOYxhkVM1m8ajYW0_qAcFcSymFYK7L2a6qwzT9OQ2UUlnv.BUpaBF0wlxuQwal
 Id7mxXvbyHI3SKjYGp5dT0n84hYQnlM1pHkE4PFSYGPgBksboFZsw7oyD2lk5ECMCbr9SWtAVmH0
 .d_7i9b6VeRrpvgGKNa1LydWgjhZ1aF1j0WCXmVAvxhuASrx4AcSwEbxIrf02ZzIpdkF0tRIDiGA
 fIiLtCbvL7HMF.6JTu0hqKSkEm800._UKU74Zj1c8CSy3J6teokbUoLkU9l7KOyyfqPed71COGc.
 Uk6.j4EupI6yx7AEAnyNrmRVsu.lfDRd0uLTdnaAKNWCzNHP0Rk81z_8._7QaZOYHEjwEpEZXCpK
 zI2AD45g77679.Ja5Ys2GLvFXjX3.xp7aclyNNvofR7Jh067Y2gXqzIBDSu87zaEdP2MK837M.xB
 1OfFnJdnAvbWt_H_q3.Q1tMwL3Kixm_AgnvjlHbLwHBbqA5JOFNcArx5haZqok5xRTl2mf0F1D6l
 .FzSfaWxY3OLo.mtM7g8kOFRLw0CvXlG4TIfXPLXErAlD6mRLM2xXPDwG1nR1vqd_xRYbS9xlKjK
 TuOonIiTKMvOhrUQC02h69nK_tpOB8yYlI4k7YiEMslyPBbGWOFMwySUOrpRH.vBxhe.l6oheiYx
 o5NBcl7BgAa1X3ivsn5SA.3767Hce6hgpq.yEFeQs06Ap8HcIVM14Y7deXwZmV1GWFltSdN_pJF2
 UG58DzAejc8YGRZBu6lz5tuJrea9nd0slrvU3mECSMxrEbsyUTmunNoMIk0rA.aRSWtwaxhHGzuE
 5DgTgrWYaNzOwZ4VJJOYi.I9idvbKTmuLsXnnv.GOl.FDes9fM1fDSPMyMqXOnQWmSt2QuGgkxiX
 O3J3CdGHIe2rsXRPr.0Wfe80l9txzoYyLA8ixpWlcmwY4mQ_Vp1oIgPvoKW8xWZfwbNjYoK.tVc9
 DtYt_F4pHOqWb50NMKpHgAoi71Doo1u06ukfMzUSZyXaMjeTVIRzpEPEWCbLExiAl0aFBdB5KRBJ
 te6O8QwP6VrOI6itfgkCtp3fEiaVJVMr47S.xuFOxzyKMGKcbgS.ruL8Rhe5lC5utwjw3f0BH0Nx
 buLatAE2DDGm7V3HuuKQpFk1bD_ji9UZYRpnYQzSa7D71taZFqyWUmJWrX7vmBcQv_VN7PkLsFN7
 5sAQHk0sECA0_fB_g.iQ9WymiEErRe0kN7smNXq4tH.aejcBKLjJ24APkm4dTV1YtYomr_bMNfIv
 nCFfXnwwZJlekUqNVA2hf35UraNh2atZDH4TiV59UQA.MCuGRsJYJqKAN_.CsrXt4u.vY4xBMxSR
 0u8G8TDu93_d3KzrzuvQ8XAvJl5mGkARGoICNoUrt_93L0kweQfUu97iBOpE7GlVkQXISdhck.eb
 uG3dpWlu2E.v.iFKX4QlMWTlQoWgIfInZY4EB5qlB42SWHhNnJVPQOjEVWIP8ifbVbsZe1l5D04S
 zkOUkmqknYyJhcamDu4OZHYL2IEPc5uiCroAgyfnYpJyyIeebSuq34rjsMoyh7tRQJpuWzizAbyu
 bzNKtWQSCidx6SSyCGFQOCkA_8jUU04P_Xc0CmQk2ex_ev.N6JN3Y.4DoJD1jrqVUt5aphZ6taBL
 hzeQ_wzrLft1yBBY0l2yuxwtSmxLiWmggDDoJA0Ii4HDpiqvKaRUenUxclO3D08BliBCrSyjvWbQ
 sI.Mt6vM9CMIzGrRat4F_GcnzV65o3Y6a4UQ0BR49h2i8dZ9ibBUDd4ZOnCKmgu5ihRalDhHq.Lh
 rDkyZs1_j2MiXKArIEu9GpzofL3tW2XdoYrwJ26iDh.EzUD03dUjgh4I0p0qEw4T4ahxw5BqeoOw
 4FHGancMHvTfphor.ZGF1SlwVQsXdsYbNebOirRY98B8SaXUn8n0EVeBYFTbp9WnTV_er1Z_HOo6
 e4OSDMPR5Je3vjvIkLFrvbJzkAY5i2ZgAqaqyTn3Qx3ps2lX.ezpy64VwRHmfHzpt_jI2wElf24c
 g4qW1E2DfMNs_nVIhc9rNzqBLSBtdAvROBR18UrN.ss97iy5jq0l.tL1OlKryQTzuvn9Z5oeeg6d
 5taNSsD3C8P83uZ5Nmlr4jusTx_GmTYgQrZVwfwIPG4piGX3vXgcpSuDdUSLCJqMSr2vUtELUu0N
 iaXJ.aM7Zy3DgaMbDGql5Lp4CxMtioPoU.ZHG.XyM4z5fpCXl_pwMrMic2cooJQ_ylp09Z6_MEB9
 j1_dDjzqt2Yo.6W58FqK16PgxUbxQG6_rkZpUVbZBZ0pvRlI58g--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Apr 2022 14:50:01 +0000
Received: by hermes--canary-production-bf1-665cdb9985-zm65g (VZM Hermes SMTP Server) with ESMTPA ID 7d2721fd225af1eb62abd539103a7a7f;
          Tue, 05 Apr 2022 14:49:54 +0000 (UTC)
Message-ID: <385e4cf4-4cd1-8f41-5352-ea87a1f419ad@schaufler-ca.com>
Date:   Tue, 5 Apr 2022 07:49:49 -0700
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
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <c2e57f10b62940eba3cfcae996e20e3c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20001 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/2022 10:20 AM, Roberto Sassu wrote:
>> From: Djalal Harouni [mailto:tixxdz@gmail.com]
>> Sent: Monday, April 4, 2022 9:45 AM
>> On Sun, Apr 3, 2022 at 5:42 PM KP Singh <kpsingh@kernel.org> wrote:
>>> On Sat, Apr 2, 2022 at 1:55 AM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>> ...
>>>>> Pinning
>>>>> them to unreachable inodes intuitively looked the
>>>>> way to go for achieving the stated goal.
>>>> We can consider inodes in bpffs that are not unlinkable by root
>>>> in the future, but certainly not for this use case.
>>> Can this not be already done by adding a BPF_LSM program to the
>>> inode_unlink LSM hook?
>>>
>> Also, beside of the inode_unlink... and out of curiosity: making sysfs/bpffs/
>> readonly after pinning, then using bpf LSM hooks
>> sb_mount|remount|unmount...
>> family combining bpf() LSM hook... isn't this enough to:
>> 1. Restrict who can pin to bpffs without using a full MAC
>> 2. Restrict who can delete or unmount bpf filesystem
>>
>> ?
> I'm thinking to implement something like this.
>
> First, I add a new program flag called
> BPF_F_STOP_ONCONFIRM, which causes the ref count
> of the link to increase twice at creation time. In this way,
> user space cannot make the link disappear, unless a
> confirmation is explicitly sent via the bpf() system call.
>
> Another advantage is that other LSMs can decide
> whether or not they allow a program with this flag
> (in the bpf security hook).
>
> This would work regardless of the method used to
> load the eBPF program (user space or kernel space).
>
> Second, I extend the bpf() system call with a new
> subcommand, BPF_LINK_CONFIRM_STOP, which
> decreasres the ref count for the link of the programs
> with the BPF_F_STOP_ONCONFIRM flag. I will also
> introduce a new security hook (something like
> security_link_confirm_stop), so that an LSM has the
> opportunity to deny the stop (the bpf security hook
> would not be sufficient to determine exactly for
> which link the confirmation is given, an LSM should
> be able to deny the stop for its own programs).

Would you please stop referring to a set of eBPF programs
loaded into the BPF LSM as an LSM? Call it a BPF security
module (BSM) if you must use an abbreviation. An LSM is a
provider of security_ hooks. In your case that is BPF. When
you call the set of eBPF programs an LSM it is like calling
an SELinux policy an LSM.

>
> What do you think?
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
