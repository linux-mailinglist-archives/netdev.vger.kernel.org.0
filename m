Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4629F586DB5
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiHAPZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiHAPZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:25:32 -0400
Received: from sonic301-37.consmr.mail.ne1.yahoo.com (sonic301-37.consmr.mail.ne1.yahoo.com [66.163.184.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CD6A45F
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 08:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1659367529; bh=ydTZpaJWqAT9cjmUlXwwbM4irBM4gGoMQmHn2NJk1SA=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=H60WFCyrKRGVzG6CGZ7MrAtq1+frl1IMnkaQJHTelFSOSV5ADE/aAQpf6Uj/QojHksfI5dRQIvUQK3gImjD8Hbco7G96Jm0eBpFJqBlMdSv7JsW+f0ca2f9sdnHfNcHrRvwfESD2P4lOetJj0BfXcMh7sU2eeBS7HOLlAc4zz7sFCpd+oR0Ey2fC30fk44vd2DBI1TZ/J8hsysa7HtWIQWaPrZ+HTbIdHEopm0wgmKcnoi4dZo/C6H8kXC60naZgGHQslwY210lHXaArBg9fs/YxKbR+jYA49xEh2F8HWiVKLe0RFTDC8/8PPCwd6GfnSSo7JWAV19tOjaqG21MUJA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1659367529; bh=4PqTug5C/GPHgjqeMioDo3ZjyC0XwU8oiOivPVRkn0b=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=KfOt1BlczXizUYImPvLkHMP6Hl7/hkh7zNt2HAlGJ984QKbvoUGxYAiPCNZLKAP9bH27CLaz4gTv92qIWmjL6Ud486yCPZIDC9idor2L4g5iwxu+4vTLnjYuCd6aGfF56FV9QIKJ9Vj3IBBQvFaiC/ZW9d7fsIjTDij/74HcHaErDAzaxS2a6LA98730RcCthFoSlK5dgpGuT1vr+W40wPHML1qLkYI4Q9s5/pl/6MarGktILB8fzT8pp5khhJ261puRcmQXXqU7ZJo8HeIT8pM12jN1bhoEOJPBN4FdX82PAns42CoJYLs/Z/SMA58XhDIybCv8tYh07hJ7SyXynw==
X-YMail-OSG: pnHYgnQVM1mV8dN5XQN44IPbkFqQLDGFO8YwhKT.ObcP.oD4Y0seG9fmmesqXjS
 RizjCw1njM8ZJKgDHKnUczbn1oLl3Fv4hA68cpFzRQiyIbBdz0hO0V9uTlm5GvxWTplaiqe4w1EC
 aE.zLboSnYSrv2G1U0EfZrUT1lRi09Bu5meU5my_AVA1OtklkuKGl2W35A_DjgY6ydSCESNa9sQu
 tU9_HgpU_yAEB.6u89XOfEZEYG9nIGIn2mXC1r1E8WA20qiTnkrAG_RjhiGy9yMVE6jPs3QXJoNm
 HaGOxvsKavtNbig7SViy83k8gThBX5H2yU6F6eunfhZWt8Er3828H7zr9uZfS9DvUNraYklXrqe1
 0XfgMkOz3P8RKoC6bR3dlPHpuM2oCHYK.QTW5ShtzV1aNFF1vxJE_Ed_kTXXJ7GII0AdgNkEOTBO
 R0lrlJyvkOisIE9KP.t55acHc7nqDdmX55XkDT7N624I_dix7CI.IINOIwdPVgxHeUYNWoZCNSwZ
 rvYInA3WzqdwYIeSSg.JtB.L0LJqZc0TsPCDvGU1UQcnYHXxKbbS6fo.4KJ4CcTOa7a8bfXev4re
 d5j.fUempXQ6d9RqYPSGs2zLUO6jb8prEbFl6U9MvQGiZG.iDbTop3UZfMdalkmmDYzDkEcLAvd.
 ZP.E6VR4N4OsVmtLCPR5NRck6Lqa8q_HoYkkhbmifl.TYowheLpWq7OzvyQ_BgkffUkA2Rdisb7H
 oSDp9zfxGIAPF.ouhvXKoP7NHJpdUWaxzBGXVkEoDkfmAcsSX9gs3vIjStT3tCFsDs0.wAJHhuPV
 lt0PZXnPOB0d_aYlAEo.8r9uZkt35GBEeco5e6GHXDiMffbXZ3bI0o96RI8ZO19j6Pkb96aipPf3
 D9urdKEy1BxbJomIkCLgMMLbilsIZzYrK0vuS1z4LEZaeKCX5X11pYO3nQWSZ2U4DDnV5TJJB0_F
 PGeDzUobbDtO71jad9YjQLhlSQqsxTkTbaZ_4N.rr_mtXIGBO0Pi25oy8JIaMR.TTQUjy7JBSLdd
 zC59b42n41lb5erft6CAXjRnkwNJxoFnkBU2OquaAdwp6TOlyi5uY_xru2chQcIYZiQ_G0x3z8QA
 QPrM2X480_mm5Uharq6Bc1rmAL..Ciqr1yhgz1HFiUUWJnRONzzuNYNF6peKtjBm1dnPslR6Ipjr
 EO6KqFOgmLr.s_gBwPaGGjTv7RHy1bTK3LiqkfUatNGoO_1i0fGHVpLOZ4mRO.TpkZa1_Qk4alU4
 5uHkXxTQ2g4_w7X5tTpKfIB1cndGDFJeAFvQFvJZdGsett1fUCzjsYRENvxJXNW2MlvIzPPDZ442
 j6W7iwZkBuceTKJGezZV1YwZ.o89Jor2lVI_ghURghmQPSO1FrKNGPRbUNfN0WBWq1lIXsc6KUei
 GPLWCt6w.criQBbGrasI9HhkrXsrNPYv8_Cv5o9IIwk2OvLGe4nxDaW6.k9zKiDzLyqgKid5mQ.5
 BRpTY77Ovq2pCJj_ETMxG5pA3DRQlQzKzyCe_DstoeVfeTIw4ux7VPRg7Dm79XW96zdcWBNLpHKZ
 H.y_OHsxt65HBmuwevKDG.FxFYUMR8HF0IJV8g97u0Z0QCQVrFrq1ZPIj5YnaGUhPyuQYE3vHSVn
 eWHW7J6keuxRNSQi7_hEk9rvJrkphXnL8O66AzjHE7J8vulXVR.YLTmvAHv9mj65y9QLP.O8FqMW
 mTGWUOmQV4gz8pDM5A2buq9r6Y68H2tXgG6lBcPMT_eomOJkpBG0jHS79gsjW8zTNSim7UMraZu.
 5pbvNrNJHJJb6SwDEmohq9t7NhUXv9bf3D4AecS3UaSZop1u0jx1Xa22C..kp5G.MbUYpxBvcRSx
 50Fn81xzBFcupBNICA1HvFppBXHbTdB7_W985KjTPcXGH8WpBf9U2MRc4tlS69_ZJLmJ8cjzExNG
 vDdvrg8ZrEmcszUOLrXLzD0aD4OFVY1CcHNvstdK8YJm.r_PLvaU1GbDnQW3jlujWoipm.wlTSMh
 U7S8UpETMj8w.18Ps69iP8He35Zq15qXHHzmnU_QmxtqK7DD03WW7XZryqxtq5SMjPSsk9ivituL
 hcJlayr5AMXypBpqJ16pudyPTlsENqv7YxyjKlfOhBxcnoGBNt.D59ocPjdyTlT7hyMW6bk.aIxa
 1HjL9GT6NNuQOTDzrfH0zOO.Pe_nYoycbNClujvM2A81VNWc1U1YlqU055qN7Y1hPM04kHPYL65i
 Q4F4WBzRHltb_10b5pfbNKQflpJk_PFAZku_LPhBpPRD143k-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Mon, 1 Aug 2022 15:25:29 +0000
Received: by hermes--production-bf1-99ddd9c9c-2w8k9 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID dbbb92685cbe537e4f74d17fd5963314;
          Mon, 01 Aug 2022 15:25:28 +0000 (UTC)
Message-ID: <9eee1d03-3153-67d3-fe21-14fcb5fe8d27@schaufler-ca.com>
Date:   Mon, 1 Aug 2022 08:25:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     Frederick Lawler <fred@cloudflare.com>,
        Paul Moore <paul@paul-moore.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, ebiederm@xmission.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, casey@schaufler-ca.com
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
 <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <a4db1154-94bc-9833-1665-a88a5eee48de@cloudflare.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <a4db1154-94bc-9833-1665-a88a5eee48de@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20447 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/2022 6:13 AM, Frederick Lawler wrote:
> On 7/22/22 7:20 AM, Paul Moore wrote:
>> On July 22, 2022 2:12:03 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>>> On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
>>>> While creating a LSM BPF MAC policy to block user namespace
>>>> creation, we
>>>> used the LSM cred_prepare hook because that is the closest hook to
>>>> prevent
>>>> a call to create_user_ns().
>>>>
>>>> The calls look something like this:
>>>>
>>>> cred = prepare_creds()
>>>> security_prepare_creds()
>>>> call_int_hook(cred_prepare, ...
>>>> if (cred)
>>>> create_user_ns(cred)
>>>>
>>>> We noticed that error codes were not propagated from this hook and
>>>> introduced a patch [1] to propagate those errors.
>>>>
>>>> The discussion notes that security_prepare_creds()
>>>> is not appropriate for MAC policies, and instead the hook is
>>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>>
>>>> Ultimately, we concluded that a better course of action is to
>>>> introduce
>>>> a new security hook for LSM authors. [3]
>>>>
>>>> This patch set first introduces a new security_create_user_ns()
>>>> function
>>>> and userns_create LSM hook, then marks the hook as sleepable in BPF.
>>> Patch 1 and 4 still need review from the lsm/security side.
>>
>>
>> This patchset is in my review queue and assuming everything checks
>> out, I expect to merge it after the upcoming merge window closes.
>>
>> I would also need an ACK from the BPF LSM folks, but they're CC'd on
>> this patchset.
>>
>
> Based on last weeks comments, should I go ahead and put up v4 for
> 5.20-rc1 when that drops, or do I need to wait for more feedback?

As the primary consumer of this hook is BPF I would really expect their
reviewed-by before accepting this. 

>
>> -- 
>> paul-moore.com
>>
>>
>
