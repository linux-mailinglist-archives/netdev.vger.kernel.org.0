Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C115FA7BA
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 00:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJJWj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 18:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJJWjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 18:39:24 -0400
Received: from sonic304-55.consmr.mail.ne1.yahoo.com (sonic304-55.consmr.mail.ne1.yahoo.com [66.163.191.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1BC3343B
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 15:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1665441563; bh=8mH4ph8zjNJh6d0t/NnJyVfxwE1EmbajgkJns1m6MhQ=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=a5HMG+HGYxEs3adu9idk84kgBnAFEt9lGaS7b1REfVJ+HR3ZZZyOJLcOl3nKerkbfBSaHytmUvQ1hUV77Uqlrku085n5oKSRymYxwLPBNErhclqCsGZpLCmXxuCh0710boITWH3BLl+Oxz2u8dh0gjS/dLGyZBADG/BOZ8OJYclMdBgzCsb7pOT+sJnF7ZwosrA1QCPJ2TabNNEWaL91pLp6kE42iaSzS1Qdm1xouAdRzTPVYMVN7NMBaGV5SAnsmpkaTUNIa5FujBqZu3wT4TEPmpQ+XOOKIjp3gWdV1NgyGB2vr0SB7DT23UTU/y3ySrCfehHBThhsnCoZ6Z9MLg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1665441563; bh=9/TYbeyAYuHHUplEGbNqNxnS1EQZKx1ekTU4yaNx89d=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=uFRU4poTge4ejtmiPzRcBNTDJS9S3bYxPLKe8AcG8724Zv236Akf2wA4ZDDQz/b2bRj9sa/2amap+3A+iM0+7OjBJFpDAiFOpOQhInOSFxaYTyiEHWc+eU8sScZxmYaSnFywCxBFmiDbbhYz5Is/yjZKWTjfpOIePzUj8UCkWbLACRQ6GXqMlkbxTmtLfiNxtq0/G8foq6SLgr8Sd/3w01zs3z0aJSJ+PPbk/hvT+4uCMYujj+fP3OkoDjIXmTJyT1oTh5cWqRQ4AkQb272ukrFeEPkQFHEnR8QONxyc91u8S1SdNCdQF06tZ9eEYUq2qyyvc78rPpMSbkg1E3MDJg==
X-YMail-OSG: 4U3MEyEVM1lKW1PW4AYV.IXcc2gfSAR4V5Zk8_LLbPBYUsgThtIQlj1m0J46a5G
 Yh.Hb1aEA0Pb8eweNjD0io_T.MbtYckvmRH9igkRDY1WFjTFGaaeGVLdTfqo0YDZs2k3.ZBOaJmV
 ySpDBROEnmrJJ28wxDzo6QDrlo7Fja3jRFfq24SD0iWgh0TQSyGTiftaP9rQU1HqXc0DxKhuYJxc
 iu1ZB1ospcBKQw_ycE8V5DCIsit1kD3zNzdHCggsOqi_FK23YYRKZXRtKAg8PMeKSHtRyH2nZQr.
 k9ocbFs_JWCAC6VAiGoYlLGHztJyv_UkJfgolIE0xEy.hFANtqCSzwx_QaIr8oFRWeBhtouRxpOJ
 GHlHWzbCTpco7qr5jkq8TtFN0KCxgh9pOPD4HKwObiR.1LQYxEXcSbqv9b94.juWWJh9gzwVd0by
 KRfLpzVp8SVE63GA05CVcT7pn1vKK_hl3QsC_P_a0WIKaqpzqDUzB6d8az_ax7_lCkH.Ir4d4qLf
 HG0ElHDG_tiTGYwti00kroY.uESoucOfIyhi9RVYqbq_DDhqy3brmf742SkC30z8JR70_6Q6ym2K
 5uenyAzg8xoyRlBAPAy7aUTsUWNmjxEbMYMJLIlmU0uCrb8o70Rlx_G8JF6slSdm66qvklbM.Viu
 QjOnarnG5GIoYzMFS4Z8fmc4JD_4Baq6dotw5YJoWIpK65eyTnWDuBpP_ba3hZk6m_pKsKh73jO7
 xUlhnXxJKEvmlR3VhWHHOq.C.wwqLVeXdQ2SUOho3qHyU4qoDjcz9nVidlFAzuZI4lZznPMk8zyS
 J0X0.a0gzGdGIkx1VejU7B58V4NzUdf2UFg5km30yhR5OSkbf9YbQmmjKu1a7QEZN3fKxtMLQi3U
 O2w_IYKYFM01vQ9cSrbzMAmF._iRrrFpiXzZf5TxSTu_8D11roSUvDUqLNbs0W0dLpwCCCKsv1qd
 fYowmeNvE04IV8INOBVW.u3DOvAg4qQAOGtdzELuBN47dEx1SNv9xm79WcznAiheiP9LLidHYnEl
 F6DK47BrfR5_WIRNBqlpIwr3uaEodzEwo.psCrJsLHmebtxRl0dYsqV2S2I3yYguIiwS9LGJaPT0
 b3337DkWVDeRrcWWYFjYd3uytXmb8FleFErcQ4UZx9cc0w1OevUtVQNmZcTA4Tf.94bEZpwLfJhV
 eoEMSt2eWb5MWM0EzO.hvHoa04XXgr_UCZNQvWblc5Ff3ucdc66Txf4mpkrBFsaOE_U5FhiTGz8S
 vI4.nR71v7gV3IpiuNWpVZBXxByS7z.rXRufeghp_qEGQJo7FsY_Kgu8w2Lssg0MIQyk5Vq.uHIK
 _qQBwJy_ySDzUDjN1WGmdEsTAbmrfM.RtHq5VcsJKr8ZwJjOodbkt1C7PY2vuAdnFsFKjfLYcFCe
 w5S54wh2PtChFxXuaF2v3eDTVTKYEJeE.nLhfoVd8LkgdZOokn8hNsh9NC124quEPW.DhgTTFBCa
 QVzMefse.OHsr3jH4gNfjpGaij1n1ieukkAt6P6FUv7URSuY83T8Oajd7FCY7nQdkd6z1lPqEXyF
 9CXiMvBBfzzaG8UrIXfOFu.7DFQG0IiTqeFtPVnGB7_rn5DEgzJCrEuLSQEe.Udk6pUbSeDGU042
 fiUyO8NT8CPJ1lQfOrIZ3G.pIgU6tmaXDBMhHqc1RJ2BlAdaO4cdwHzNhwBWLhNPmotZLAl7v2GW
 SqrBOGVczfHoTvAwDXva0IgsnCmMil6AuPA7fYsCrl0Jjk2RzbeKsu_Ny6XtGGh50KrQWJHEF64C
 uAKdJ9kT9so_j1z8Y5a3TCLQlHp.D.L_oCSEwSPvDDeAZQprbwRHQqFrwBZN7V6pXxbU_qRkIfRK
 39I7CXhkBp8OhzOP0C2HfmlzVQll.p2D0Mr_e_x0ytbg5ZohKbhL1qCkXNnCTlflIxIfVw2A6aoQ
 zR2ItxCqvBCTpT8b36TTPgX0QOAH0c.WYAlmoqsuzsBO50MmV9_eAWNcUtgpiyj632shtxjSObEg
 QBpy7KfHZj5EiQaDKOhVU3sBErhR5Qo6UkU5e.c7pd0e0jzvwO4XB3NiZl_Ok5cs_lPhSlbwDNpi
 lZeRICAvRyb.KTXFlstw9SJ31RJOOZjfYkAf4IC6jc2zZB5HsfvTMNy03QkvPAVu9xVgDyKiqk9_
 dnttFb7qjImAHfslmu6T0VfbvVaZkGZDcAhzXK2ogdELbkbXF6AojDQqPZRMrIbLVW_gPuNvke0q
 j4HVNohzfVhtwpj2QCSNU3L9kMo2qChlnEQAUceWx.f3DpimCUAjDryoInIXmVLFvzNEkTzyXQv1
 tgec2P5QfPxPI
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Mon, 10 Oct 2022 22:39:23 +0000
Received: by hermes--production-bf1-585bd66ffc-lv69x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6d7d3319e586f185fdd2f3c7fcc09e93;
          Mon, 10 Oct 2022 22:37:22 +0000 (UTC)
Message-ID: <4d29068f-2e42-5c3b-9b74-85dda8b50f6b@schaufler-ca.com>
Date:   Mon, 10 Oct 2022 15:37:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t
 safe
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        John Johansen <john.johansen@canonical.com>
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <166543910984.474337.2779830480340611497.stgit@olly>
 <CAHC9VhRfEiJunPo7bVzmPPg8UHDoFc0wvOhBaFrsLjfeDCg50g@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhRfEiJunPo7bVzmPPg8UHDoFc0wvOhBaFrsLjfeDCg50g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20740 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/10/2022 3:00 PM, Paul Moore wrote:
> On Mon, Oct 10, 2022 at 5:58 PM Paul Moore <paul@paul-moore.com> wrote:
>> Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
>> sockptr_t argument") made it possible to call sk_getsockopt()
>> with both user and kernel address space buffers through the use of
>> the sockptr_t type.  Unfortunately at the time of conversion the
>> security_socket_getpeersec_stream() LSM hook was written to only
>> accept userspace buffers, and in a desire to avoid having to change
>> the LSM hook the commit author simply passed the sockptr_t's
>> userspace buffer pointer.  Since the only sk_getsockopt() callers
>> at the time of conversion which used kernel sockptr_t buffers did
>> not allow SO_PEERSEC, and hence the
>> security_socket_getpeersec_stream() hook, this was acceptable but
>> also very fragile as future changes presented the possibility of
>> silently passing kernel space pointers to the LSM hook.
>>
>> There are several ways to protect against this, including careful
>> code review of future commits, but since relying on code review to
>> catch bugs is a recipe for disaster and the upstream eBPF maintainer
>> is "strongly against defensive programming", this patch updates the
>> LSM hook, and all of the implementations to support sockptr_t and
>> safely handle both user and kernel space buffers.
>>
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>> ---
>>  include/linux/lsm_hook_defs.h |    2 +-
>>  include/linux/lsm_hooks.h     |    4 ++--
>>  include/linux/security.h      |   11 +++++++----
>>  net/core/sock.c               |    3 ++-
>>  security/apparmor/lsm.c       |   29 +++++++++++++----------------
>>  security/security.c           |    6 +++---
>>  security/selinux/hooks.c      |   13 ++++++-------
>>  security/smack/smack_lsm.c    |   19 ++++++++++---------
>>  8 files changed, 44 insertions(+), 43 deletions(-)
> Casey and John, could you please look over the Smack and AppArmor bits
> of this patch when you get a chance?  I did my best on the conversion,
> but I would appreciate a review by the experts :)

I'm off the grid until 10/20, but will add this to my do-asap stack.

