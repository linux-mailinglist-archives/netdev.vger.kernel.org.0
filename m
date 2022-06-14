Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F4954B3BE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351162AbiFNOji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347552AbiFNOjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:39:31 -0400
Received: from sonic316-26.consmr.mail.ne1.yahoo.com (sonic316-26.consmr.mail.ne1.yahoo.com [66.163.187.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B71C220C8
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655217569; bh=Gk+oETTOXCvl6hKJwiKfVQx247tk4GOZsL6eS8rtiko=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=fRFIaqLcfobn1LNVl0zrObgmf1hRdINcfRrUmpLcvSg3N0XuqRqgsWlZn5KxMH8l49l0D/abHlPhyAMUUO2GGCDJesuNH8Kpmaa3YgqX0v4VvY06jPrF5HScxPs366YY2ONTePIsLO6+bsIrz/oFE0ETMPJwiL5Fc7l9A5O52eqlUVEn2u6Hv446oiu3mS7Em6viRQw0Eerb2KZ/WLQFgjnvwinwyVZgUZqVxvTHUHjPZlUOcpmI7z+3pcZ+UkItKYPlyw2PX6J4h25WWNn2cNwE4TCrQ8Jlmq2H+Rgpn+lDH1kZESTNcLpJSjPABDc+86KBFATzQZC91mBFay1TDw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655217569; bh=lRUBSB76OG5uRwjsyAtEUmfLb2iPR7sDD1HFxFWV66b=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Qf8RR/99yPxdxlUs+k9WbY66HCWw5zL3eg/AG/d8PaF2ZW7sRQsWq6gmO9A/l7NZTWI7UdRqKM5bDHbs6wupQkeVNnPnRU2E5aJ02Zk+dMR4zD7/s5cNknCyMX/GityW/LiHFvSd/XM7aartsEujYu09UY1GhHeq1D712AxFIJsY8aK/OlILZVF6egzn6sq8A7407LfIYkuACSJL8g1M/mmbhUgbiOsQ+CYK1mUY0RpwWvYX8gqa2sPB3WEOxqty1MukDjP2FW6rxr1jRuQBeQgVCqktKQ2g163zpXEobbQtJYRhHhj9nK4BnkDO+kDP4JBwDWeJ+g1U93EjktSC1Q==
X-YMail-OSG: l34EP_4VM1mCZNS.V_eCLpRm9dh5I1CsXixH4kuccuVcaljnubvC2j4A6MMQ129
 Y2Pi1pBZKWkGXaXj27i38I8ExPjiKP1Xgpcl4tm9xqnMiwV4KKbA3RIP0pHjrVRzdj7MRxTx9iBG
 YkdEQiInROMc3joMrXGCf9wmezHz6P8mJ.fFwD3SDeBlElgidwY8jLECc4hnW5TJm2DZ.k.jf483
 xuskZUVuBZ_.7nYZM3Q6oMDqD16BRAXdGDrt0RJ_foeLdgA5bonrmkWFCR3gASY_oflWZvXQixlq
 UF1m.qP9YXbSsWZFj812VhzLVpyQ.9F32n9h1HmEh69jx_hRtAaRIdgwaAfngbVWVJSKavMjVMfQ
 XSXz0eYuXsWCwdfhD196BTPVVtMbrJkHzY6Xk9iE5UHCsUBamqZuh8ubo3QILsuwtLsCNFKyzrlY
 vF4UN_H53gUTXszFFk2yLOyY55uNmgcqWwzFBPIfnM150R3f0Jfb8fh5Mzo_Cg0qaQvSchBKjCXj
 nTjHJJOq.fI2fCTCBN3A870QDzGDAkOKrM.MsNpsLweC7IaQy.BbmtdwUXg3AQDgxaX8sTWqySH_
 YK5rjqHBdeevCU9nZl2LemqBf.vLuvTdVi3q0_6s36rQkUJeC8EDY4s_ity57vDuikZT8YgGAV2k
 GQo4ZHWmnm4lDk7xTd50gp0t_DJ.Hafgjqy64gvtibxS1SHL0D9MqZg76zZNAcQl5zu0Exhv4OcW
 mDH5_kPytoYBvgcpDzUXj5OtiUT.rs03EresI6Qrd1muzCGUw99JUhwVKK40RSvSZXMM815o3TH6
 fIwQnXzwajujE9szKg5ZCG.oh8QawNsxRxn.qck.uP4fzRlaBP9DE545T2hkZSFslMoNmyD9YjDu
 DPyG49HGFuxQy6RMUV5D6tgRq2Jopfx_d.mJpEqNoUiuIWnKil4PEXFovbbhpvuyUhOL3VE2GmDX
 VDBVqCAZbiZhRu7UKrQLPpAf4FtH9tiEdWyHvyrkqbXg__AQJ_N3sxY4nnv6lAtDCk3xv8g4zA7q
 br.dMb13NA4a2TtcCtBHvVIzzWlvGv4U9JfN73FVEuv77CejNVNcPQ8XO0e3i2_eBbyDtuzTowpF
 r7tocTWs53b.gwK4kDv_pTqO0hkqXLBV9X.I0Z6r8V3u504t5eb2cOQisOd4Mhos8dnXyaAN9cvu
 7acgLpOpZcWqyW9UMNNm1ShkpPPdBQprBadtvMrLPJFHbWwRyzdUL1sXWTpogylt3tdIon.0FUKm
 rYQHTIZKXN0FbJz4FKuZgtnj76nzxXdow3yqiqKvKnjZ5MSJnwK0MtpYhCeyLNxltgJfN4K5iM2N
 7_UXaTuwcmiKL82RDIrVJ_m4tLhQSD0TMdB.C2.RuC3DLR6EZjR8icmJ5Pcyp1FBSAS.nzoMlvyG
 wQetEXAUX6UnRnxz4Y.joRItG62ICV6zPRT7DkNFqhLrhD49oEyY7OTpUAHfUzW96T3TjU.z.xtX
 BRJ59.VxAXDse4eqIhZpOo67ruAxITzCz2bwWgj9_3BVGoKrKa2hdF1EbK_wrXYCphFhgdP591BM
 8Dx4nw.OvDUtcFSmwaX38z91xvkNg2gGzURgEg.1aIahIoxGy.8HwC2Lo.9sDMjQ0LoYEOVKAezC
 pGYewkGVTBsGHmpazBNDJ2yGdk1YnZ2RsxVQ6cVhAQ9oSC.UcB_QDBHfOgxJ0tQNNGx1hsc2BMQ7
 fEPpEXJ8GKjioBsLIWpvl67R9boFpyk8B0YFa.DQk0VZ10896guGPPSX8tQw0bHPw998u2wOlfFK
 r4iYVN6y2wwWwSC6Fp.DmjY5e6rtZVgjns0R9CrneHrhI2xoZjTxHqHrwpBEtqFrzK3GFPPTQtAK
 8hT6WRqTR8iJ_lz5fcEMBfDgXpLb2mzq7IppLiwFTDPN0ML7c0cKS8RDnYr0QMe9gdGZvRZcaZ81
 oYqSjE5Ttah8mMWG6l3Obhj.YZXwg55XNndIG65ct.wK5BmQd6aYUN9KcjQYh._prdA3e2KLlb8V
 tqRYdouhudJUpS29Eru77mKyHJcKeNct9WUI81o1XVVm1AGD8KRjrhBrE7_R.Nf_EiTNWlcVA8hx
 BP.uDsYOJpVvf8mbQloJ5acD1I.TpGP2NfRbjr1FwYfk8z6l8gQUDe39HzYrWKeDUt_IRlNJ7_gD
 KwvB64DCfDs5Yr2pbiRmfb0WwIP2scfxv4AA1X3gcjY0nFjSemkRJmqKpJEA2xu5VIOqoZ9kt3Fy
 lGpmYgJNyn592qSxpIAHi28oenfQQFZhXz4JO5sR.3hWwhS2Z
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Tue, 14 Jun 2022 14:39:29 +0000
Received: by hermes--canary-production-bf1-856dbf94db-nwd6f (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 047d13c43786ba81a547ff9186866ac4;
          Tue, 14 Jun 2022 14:39:27 +0000 (UTC)
Message-ID: <b9d27b14-3b45-470d-9c7b-c6f7fb0ca8a5@schaufler-ca.com>
Date:   Tue, 14 Jun 2022 07:39:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederick Lawler <fred@cloudflare.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220608150942.776446-1-fred@cloudflare.com>
 <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
 <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/2022 9:44 PM, Eric W. Biederman wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
>
>> Hi Eric,
>>
>> On 6/13/22 12:04 PM, Eric W. Biederman wrote:
>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>
>>>> While experimenting with the security_prepare_creds() LSM hook, we
>>>> noticed that our EPERM error code was not propagated up the callstack.
>>>> Instead ENOMEM is always returned.  As a result, some tools may send a
>>>> confusing error message to the user:
>>>>
>>>> $ unshare -rU
>>>> unshare: unshare failed: Cannot allocate memory
>>>>
>>>> A user would think that the system didn't have enough memory, when
>>>> instead the action was denied.
>>>>
>>>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>>>> return NULL when security_prepare_creds() returns an error code. Later,
>>>> functions calling prepare_creds() and prepare_kernel_cred() return
>>>> ENOMEM because they assume that a NULL meant there was no memory
>>>> allocated.
>>>>
>>>> Fix this by propagating an error code from security_prepare_creds() up
>>>> the callstack.
>>> Why would it make sense for security_prepare_creds to return an error
>>> code other than ENOMEM?
>>>   > That seems a bit of a violation of what that function is supposed to do
>>>
>> The API allows LSM authors to decide what error code is returned from the
>> cred_prepare hook. security_task_alloc() is a similar hook, and has its return
>> code propagated.
> It is not an api.  It is an implementation detail of the linux kernel.
> It is a set of convenient functions that do a job.

Yeah, sort of. We still don't want to change it willy-nilly as it
has multiple users from both ends.

>
> The general rule is we don't support cases without an in-tree user.  I
> don't see an in-tree user.

Unfortunately, the BPF security module allows arbitrary out-of-tree programs
in any hook. While returns other than -ENOMEM may be nonsensical, they are
possible. This is driving the LSM infrastructure in the direction of being
an API, in that users of BPF need to know what they are allowed to do in
their hook programs.

> I'm proposing we follow security_task_allocs() pattern, and add visibility for
> failure cases in prepare_creds().
> I am asking why we would want to.  Especially as it is not an API, and I
> don't see any good reason for anything but an -ENOMEM failure to be
> supported.
>
> Without an in-tree user that cares it is probably better to go the
> opposite direction and remove the possibility of return anything but
> memory allocation failure.  That will make it clearer to implementors
> that a general error code is not supported and this is not a location
> to implement policy, this is only a hook to allocate state for the LSM.

The more clearly we define how a function is to be used the more it looks
like an API. The LSM security_ interfaces are not well designed. They have
appeared, changed and disappeared organically. This was fine when there was
one user and tolerable when there were a few, but is getting to be painful
as the number of security modules increases and their assumptions and
behavior diverges from subject/object mandatory access control.


>>> I have probably missed a very interesting discussion where that was
>>> mentioned but I don't see link to the discussion or anything explaining
>>> why we want to do that in this change.
>>>
>> AFAIK, this is the start of the discussion.
> You were on v3 and had an out of tree piece of code so I assumed someone
> had at least thought about why you want to implement policy in a piece
> of code whose only purpose is to allocate memory to store state.

I agree with both sides to some extent. The caller shouldn't assume that
the only possible error is -ENOMEM, but the LSM hook should never do anything
else, either. If there is a legitimate case where an different error may
be returned and a reasonable, different action the caller(s) would take in
that case, the change makes sense. Otherwise, no.

> Eric
>
