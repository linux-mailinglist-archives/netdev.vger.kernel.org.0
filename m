Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B2A55CE74
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiF0RZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiF0RZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:25:04 -0400
Received: from sonic316-26.consmr.mail.ne1.yahoo.com (sonic316-26.consmr.mail.ne1.yahoo.com [66.163.187.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6411274E
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656350701; bh=jxel8bTjG3W3h1RD32LktqNRvAXqoxtEjoNyKlu4UI4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Pw19L37gV+8n5LICrnZzd3+bB3AMwtQAi2ogf0LYs5ZxB6folivGMAYHOIKPC43HbETw240MYdQ+WnkBJhqBDLidr7xnWMqwEIT9u2zQOYDOOfBVuLepTrRhkaYWNdCo0JCtaYuR3beB5zhxi7TP05lunI72dEW9JHDiC3HdaAteCXwLNrPnb1pE1m8XAnSpJX3wb+2WQIgO+8xvLGFc5XMkNwWkikEJ2enWY/wQRwMcFqHi9sZbYfOTCF3fLaKGtyTdVELjtV0EhyK/a9qeRo0Z/1PqPw39Gbrpp6+SrOiO1/9IcSprPsXcVlG11IW4s9xJhO+fL8eiipHdU37VNw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656350701; bh=x8SDBHhPSDxecqI7yLXEoUaOYcPThrh5OOqkXQa5QMi=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=QNXKT4fgC45mMKDqHqt9oEx8DoZjn3bdWbWsA622BTgNXVUVuv4Q6mvgMy4GXxp3IGqBnH87fU5ccFlwV9B88zGBo6U8u57BFCHZYkxxVvHkF1+aqbxK9qIN2i1Fpz9bwf22v4UhyeBuzOeUKzoAG7UURD9rNJnK5JqMHadQc4gNC8iSYik2+mU60k+W0QOnpz2bxpU4tLKfO1xwys/yus3FTwSX3Un17CPPNfolkxagIjQbdCRV7aU8qsrpHNCmz0/WkRBp/85YwY00RoO/sYmG5pnUqAvu8vnu3eeNWdCWAHsrGkfb+GydnhDDnnKZaLKjZhUXEpmrBjR2nRgF2Q==
X-YMail-OSG: JMvsJk0VM1mX9Zcld89SIAeehjI8Fif.qvkNdYzMOvrTG_DThf1WAfzHUfMbgbw
 9QrQl0A1zrD815FiXJGhmZ87VfMFx0NoySGFrncX3v4fnapVh4lNTun3zMH8gU85utUwlIpom3IP
 Wn5u4gTryQeEgbgx8jglnqVfKhi07XBq7qsCnt9lu9JVkX9N78DG01xvpzxobq2HFg0q8h_KZpDX
 p69aaw4GeOcWZhdM9hgZX7DL8bUb3Snv4IbO03lymDOb0ISl_itLSxtoEnXiYLCu3MvRDQ63s5tY
 GJrTbAOg8YL_XXSQ6ZmI4Mi4lL8AcJsVSgT2wxj4YyeLxAQMPNvw9YL1QvP3r9zOaoFC.28yGAHQ
 iYKUSPRA5tb.lpclmGuV2dijok7nxaBzUcbmLcU0kAaH3FwCPk5tuMrQOy7g_D5pf78Pg06YErxJ
 htHhiVbR.CzrLU.ByqJ24MzgXqc2ReIkZYwCMStDUOULit8yhnIUvOjVaPzbsLkLEyxHK.6aEbCZ
 ibPajYXPE5B.Xcb8mPL6wOd3ySI8kyXQVILcELddVmQNTkmLkNI8V3VGAM1IUaPkP6Z5oSSM2GyK
 pFb8FYIUPbnFsv6p5JfAAj3juXiwtKFpc1vpUGbTTjDby38PbQLNAVZLuVKlUYLP8hvsyVrhApqH
 8ejU7OSWjdXGZWeQR7AsV77An8AvLJSmGWPQ_hfNhj1eXUOOP8bb2STvg1GvI0Q5RXN_H2jMGrYO
 nhmPtEnijIydxFBDtGyWPOdWjaCo3wacgnMGaITw7cgtaVJgotcl52Z7sZoRMGinMJMf5uL19WxC
 0TZaqp9.NzH6c2C8KHgLkE7j0eVila9ifK3JNjb3eqwtNFtILMkjAaroSgROduiNym6z8dAfEC6I
 WQ.2Pa41Lm4fsEZBmGpfmwbQ5lhLtLqSdTpT_K_pQbMyS2hz8r4.Z3cYdfSaKXjywNJq4tlt_y28
 OC4NCfSjRnxQthCaP8d5bGFv0JrIOw1GhTao7i0BnSjVp97PNQfS7A1LGP33DzGzS32PaaasqQ54
 YNfTQ_ioiicWiFxUsr47SoPqI8i1FIvcnC38w520ne5ek5hKy0sDPDHkhK3rqT9A8V1OIJdVKZqz
 tlPsbdEKTF_BwWIYC8okpnA3mkVM14a4wkeuAveKdvPByxm6IksY_oNR4uPMke3o3syXj76V9OUe
 Tq0zYHhKWy5ryw3sZ6rFONv50n4t4CKGDgY6vGlRUnapYHKevtw3ONUNmX_N8VnL.v5q20DguWnp
 7huKasCY5w5EiK7dFgooV0pKiwGvzmT8iBJ9.t5z659Heb6WvkjXwAOC9ltEDKiS.cA.dvaF4F1i
 lQG.HGAEZEgV8NMFV84KxJhHU4ag6_A8wtM9Gl4hD3HdVXy2UVW5Zys8hwYjEpG1JLvvYtYKusnS
 c16QehoAWxGH7eUn.DpiwLoys6QAWaUdj2pHHdz6qVWnNaV5y6E.FkhZht2j56EaqRph4Hy7EDmh
 FErLmvWPw2HPSCxIH9hdkDHWCqTvER8xsBZ.G3u8MWZDtP17Vcqv2xsDVDKDU_lAatgBWiiAuGQb
 9AA4j2sgBYJS74.n.0jpoN3kr2WbG1pCbNI5H4sLKMlPByYBse0VJQXEup63kgtMPQF2XzVjVPcR
 ryEYbzAyKblSHQX0ApQ0lrSr4PIwTdeJ_6gesPK7bvKZ3G9TypZ16Z3XPCY6nbB8.BnpIHbN0yux
 hbOBy3MkZfs1T4Wn8ZbafHACYlD9xm36WHjw8hHatALeS_ClAIrrg8gpOMPNIKpocUjI.dHmlgk3
 DfoW6VYBW83BAoTMa1EHnznfVSEEoVLr2qeVdxNkQvAQ_e1kZDyi_B_khxZQsiHuwDVY_r9Zhv9F
 EBhFRwE_WqqxPbXKufQXytzgQ9PbVTHiI3PDu2ONleVFr_zzPX88k4fLhi2qbRLxE.LDvxudSduj
 WlovE77tB4tAW8vLcZV7AuVvHHxObq7aKtnHlYqVaRNxHWA5yHh2T06lFDaLbaA8Z3ab9uNJTvGj
 nhZR1e794a2RNkTYIqStLQjzAYSPABFwF4PN8WzLRW2r9j1Czykt8ZvpyDckA14ZKS.DSOgyXpmk
 RondCQ1Msr4Zejta_NLWU7VrNJdNeFtgkNaO2TFsBG7VMVKolV7oIBmBxCi9gIEaMsNgNHxBOzc2
 f6r_bq6uyFern8spPEuODsWvWcKMNNsBwoKBuD2yHDwNABFFVuNy.yCde2dDw4lShVEKdnulTqVv
 HG7SNqXSHjUxsvhWugw4ZRwXIFlS29o56jyMr0fEUElOgt.zMhqwQKfsa6BuQ2VcIXFRI
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Mon, 27 Jun 2022 17:25:01 +0000
Received: by hermes--production-ne1-7459d5c5c9-fdkvw (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 220ceb13a755144268a58ef99922991a;
          Mon, 27 Jun 2022 17:24:57 +0000 (UTC)
Message-ID: <1c0be7d4-3f81-3117-6fb7-4fbd84aaeea7@schaufler-ca.com>
Date:   Mon, 27 Jun 2022 10:24:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        Frederick Lawler <fred@cloudflare.com>
Cc:     Paul Moore <paul@paul-moore.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
 <b7c23d54-d196-98d1-8187-605f6d4dca4d@cloudflare.com>
 <20220627155639.b5jky27loen3ydrz@wittgenstein>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220627155639.b5jky27loen3ydrz@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/2022 8:56 AM, Christian Brauner wrote:
> On Mon, Jun 27, 2022 at 10:51:48AM -0500, Frederick Lawler wrote:
>> On 6/27/22 7:11 AM, Christian Brauner wrote:
>>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
>>>> On Wed, Jun 22, 2022 at 10:24 AM Frederick Lawler <fred@cloudflare.com> wrote:
>>>>> On 6/21/22 7:19 PM, Casey Schaufler wrote:
>>>>>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>>>>>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>>>>>> used the LSM cred_prepare hook because that is the closest hook to
>>>>>>> prevent
>>>>>>> a call to create_user_ns().
>>>>>>>
>>>>>>> The calls look something like this:
>>>>>>>
>>>>>>>        cred = prepare_creds()
>>>>>>>            security_prepare_creds()
>>>>>>>                call_int_hook(cred_prepare, ...
>>>>>>>        if (cred)
>>>>>>>            create_user_ns(cred)
>>>>>>>
>>>>>>> We noticed that error codes were not propagated from this hook and
>>>>>>> introduced a patch [1] to propagate those errors.
>>>>>>>
>>>>>>> The discussion notes that security_prepare_creds()
>>>>>>> is not appropriate for MAC policies, and instead the hook is
>>>>>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>>>>>
>>>>>>> Ultimately, we concluded that a better course of action is to introduce
>>>>>>> a new security hook for LSM authors. [3]
>>>>>>>
>>>>>>> This patch set first introduces a new security_create_user_ns() function
>>>>>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>>>>> Why restrict this hook to user namespaces? It seems that an LSM that
>>>>>> chooses to preform controls on user namespaces may want to do so for
>>>>>> network namespaces as well.
>>>>> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
>>>>> CAP_SYS_ADMIN. There is a security use case to prevent this namespace
>>>>> from being created within an unprivileged environment. I'm not opposed
>>>>> to a more generic hook, but I don't currently have a use case to block
>>>>> any others. We can also say the same is true for the other namespaces:
>>>>> add this generic security function to these too.
>>>>>
>>>>> I'm curious what others think about this too.
>>>> While user namespaces are obviously one of the more significant
>>>> namespaces from a security perspective, I do think it seems reasonable
>>>> that the LSMs could benefit from additional namespace creation hooks.
>>>> However, I don't think we need to do all of them at once, starting
>>>> with a userns hook seems okay to me.
>>>>
>>>> I also think that using the same LSM hook as an access control point
>>>> for all of the different namespaces would be a mistake.  At the very
>>> Agreed. >
>>>> least we would need to pass a flag or some form of context to the hook
>>>> to indicate which new namespace(s) are being requested and I fear that
>>>> is a problem waiting to happen.  That isn't to say someone couldn't
>>>> mistakenly call the security_create_user_ns(...) from the mount
>>>> namespace code, but I suspect that is much easier to identify as wrong
>>>> than the equivalent security_create_ns(USER, ...).
>>> Yeah, I think that's a pretty unlikely scenario.
>>>
>>>> We also should acknowledge that while in most cases the current task's
>>>> credentials are probably sufficient to make any LSM access control
>>>> decisions around namespace creation, it's possible that for some
>>>> namespaces we would need to pass additional, namespace specific info
>>>> to the LSM.  With a shared LSM hook this could become rather awkward.
>>> Agreed.
>>>
>>>>>> Also, the hook seems backwards. You should
>>>>>> decide if the creation of the namespace is allowed before you create it.
>>>>>> Passing the new namespace to a function that checks to see creating a
>>>>>> namespace is allowed doesn't make a lot off sense.
>>>>> I think having more context to a security hook is a good thing.
>>>> This is one of the reasons why I usually like to see at least one LSM
>>>> implementation to go along with every new/modified hook.  The
>>>> implementation forces you to think about what information is necessary
>>>> to perform a basic access control decision; sometimes it isn't always
>>>> obvious until you have to write the access control :)
>>> I spoke to Frederick at length during LSS and as I've been given to
>>> understand there's a eBPF program that would immediately use this new
>>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
>>> infrastructure an LSM" but I think we can let this count as a legitimate
>>> first user of this hook/code.

Yes, although it would be really helpful if there were a recognized upstream
for eBPF programs so that we could see not only that the hook is used but how
it is being used. It is possible (even likely) that someone will want to change
either the interface or the caller some day. Without having the eBPF that
depends on it, it's hard to determine if a change would be a regression.

>>>
>>>> [aside: If you would like to explore the SELinux implementation let me
>>>> know, I'm happy to work with you on this.  I suspect Casey and the
>>>> other LSM maintainers would also be willing to do the same for their
>>>> LSMs.]
>>>>
>> I can take a shot at making a SELinux implementation, but the question
>> becomes: is that for v2 or a later patch? I don't think the implementation
>> for SELinux would be too complicated (i.e. make a call to avc_has_perm()?)
>> but, testing and revisions might take a bit longer.
>>
>>>> In this particular case I think the calling task's credentials are
>>>> generally all that is needed.  You mention that the newly created
>>> Agreed.
>>>
>>>> namespace would be helpful, so I'll ask: what info in the new ns do
>>>> you believe would be helpful in making an access decision about its
>>>> creation?
>>>>
>> In the other thread [1], there was mention of xattr mapping support. As I
>> understand Caseys response to this thread [2], that feature is no longer
>> requested for this hook.
> I think that is an orthogonal problem at least wrt to this hook.

Agreed. It was always a look deeply into the future sort of thing.
At this point I don't see anything blocking the proposed hook moving
forward.

>
>> Users can still access the older parent ns from the passed in cred, but I
>> was thinking of handling the transition point here. There's probably more
>> suitable hooks for that case.
> Yes.
