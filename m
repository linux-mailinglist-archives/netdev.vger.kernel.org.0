Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D353854CD0C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbiFOPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348988AbiFOPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:31:25 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com (sonic308-15.consmr.mail.ne1.yahoo.com [66.163.187.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D4B4BB8A
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655307059; bh=11B5WPKRY2tRkgjEYdRBoSPOFjo4BPsuubkByd9K7pg=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=uGNI+knegf36LS4/r95FCmH1OIO2Qb7UoKt59iyF9oikWgwwSFTNvEG4yEcuvdPbE4qEN30i2ESCGNqKdEBkCQevJWzdR8hnoVEFp7RNBY3BFtrQG1vbPgYxYxeFBPRbyqOzl5gDjaqNNQjH/0R59eMZmjGvrZEHeJ7hTbWYSa8qplr8G3o+vj81scd4W3g5iiY1Ve4sz4GaEftb/VAFiSvZMfHRUJceQlMkRPJFgxymltmBobijwlKn8q8wQ8fwXbAj8wE8NLbJV4k31+1wfmDCB0Q4TTSNw+pSz9Akl5ljtPPMpg60PfE0/SnpND/X3yZlhzwn2eqYjMj/ggi1Dw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655307059; bh=nzKto+wf34xdzo8rg3XPBlWBO9kgnMZLItskjrwj2CE=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Yc5aFKrEXaFCh4wchT1b09se8uPrVACQgkGheVE4AoXgMIA42FPmEN0Dpw835oqyJWjW01kz+11n1+D8Z3xgD8Io1+4IBmy/Z1dVoNgQT8h2JEQGL3lSo91kO4RgSKHiW0MrHtJvPb2g2oD0XEafPlbRBwi1Yx6CKs9AhzZ9peBOXVAASD79R5EWIxGlytOfldu1ZJhUqFyO4fQQ2afa8eb1tmJHFB9YJSdkSspd7jJ3BATR1LWD17WxHWIrbhES2AYmmFEAV9QK/pkVOdUZq/puuh7CTqces8z5US3XtdeKgwRiRN2/zYtme/WTKRZGApgqKccgZCN4n6kaOzmruQ==
X-YMail-OSG: AseB.CwVM1lua8AHdkQZIKwEJdX_bZzUQV8HgtUBvx0Mg_SfHvpBIc6pZZH9LXf
 wyXgW0rCD7nJ4uPONHyoFEKvBFXq.yPgrTIZa8NGqFu0MILuC4b3Gx2mROZ6uf53ulvOJASnLYA7
 _zCrAHkUzALzqmwnYc33X_ICuSYNOpimxSFmYP9efuI3hMwkPPBgaVefkmTMBUeyB8oQFiy.kT6Z
 WYzyudW2VD9ddTngqReoriFwL95.sEytpCyp.htP3IGynjA1gyz73sr77PumPFLNcE.IEVu4Vgpu
 KDfODNGPmCyvgN_4h4mtisujqykszeZfYcQN7QMSErEwO3hQ5MW8YL47zCkKEuR.6Me_kcgqAEcP
 KIHRclwrCVC31vbQxfkzCOmZLuPVjw5y4AhRZPBlCQ4L0VVfoc7y3rxz1QQMOkT_NYm1V.NXN169
 rvKnNA19OA6s6JXG5HHOJMNWRywVQvwWZeFLmDMJSxvCOuCuQLVMdg76BM6KianWZpBFKOob6Ofb
 UGIXsbnMNuD.yypTe7OQzBSqIqqbzB0.JygaX2VND0B2PonxVYf_8vIA17WCUWiXSLYNQu9bk9LS
 VDGaEhMOwEIy4nXKA7sZs8eB1h_bFVzv3JLDTgFbngULyVpfFBMCiz2S2np0jE9w7HCn33VkKUWz
 mUrzzD5cfkqpXn.t8whrWT_oK6SYmuNoZqjgnIzWk7rB4xG38GHLslC5t8aB8ofxbUyKoO3iVI96
 EgN_hwGjsIT37PvtKAjtY9blTQdqML8eigG0920hcI7IFi2G4CoSV5rI7EtIzgqquYd6pc9lE66o
 FJ9R.IF1vv6mdQzWUFUR53ZK4vfMyIXA1oDeFifdnmzq3capG.Pb7o_9xHczQSviWBbiDDfvuOfx
 qAQF.NA40IcvamGhBe1BsGmNSmOFQzet9tqu8KwGjmansTVaoxOU2aZAhPKOJCHR4IxSm6tQ6oJA
 aPzHFbl5N79lNHGmCCcnYhQto9zw23Mm6kQc9IknliN6ZPKCPQ0rX3xC1UUCV2PLsSY0ZHiIJvhr
 lNP0.JsxOJ_hEtvhPydbRjZB12PAZOPNiydVPwYAtH9NyrLsBnwvU3.QLiZrvIs4hajXln3qGeon
 dLNa.WOmngl2SOCZ4Qa1vRj.jFE8Eg2clfVTOhsg_.299VXThtQtMu7pO4RO6XXDAAqd2PGjoawd
 wRd0d0SI.X8ZDzJkesTDx_xSOQwEL4aCVWBm3jVOX0LSjiwpOk.GuBgOzmbEeLSGndx_HfUrpXA5
 A2llzWWNUYpAYOvl_bFys5A8F6RLW6Ue87UrN142ds4EEDrD8DqvQajzx9bpGKaAezx.HA.hmMwI
 a7yLo_X6.GX_z5__tavYNig3PD6BZM6lyAkBSh9YiHK9TAFooYrQ8WQzcaqucVIKk9DSd5icebJu
 J9D3GhyJa7zdYO2_SVRIwLtraSNW7z37513hJfk7uuaprYo3d8ErD387H8h5xhj2Tev4gPq9_W_1
 UzD6DPUK3pDDyyAn1BMZymK37ij_MBTsVAOwY8huf3FUw2aeAmA6c2T9kJCLXcwZ.PMwiOfLpbfZ
 QPeK97LxwAJ_uodGGJh5UEgjHtJ5GECNL.JeVGcBgM8vcuAAz2Jv0aocoSpZ8AQn4GIKaAlqTXGL
 Ka6ECAeUuS16THNML6ZFLQuMWLAY9KBamB9Z0kdWos7b_AMVFKRGANgnp0aFgn4D8JO_18SSHQSZ
 PyTrEQ95Kfq7shdqXiuyQK95gK.h0HwPokYTN0jOci6w8sS9XAD2W5gWVDCq1b_0mqVXfy84LjBA
 NUIXjk7ydO.hAINr..M1hRxUB0ebFBb4YcVH.vY2YBbWFpu9e5UCQGwD86l6hW6BKsBConQlv3UD
 K9VkKCc0jG9Vu4SDHdsfUhWOR8fAysCdXB8s_1.se1l7ghTbb9Ql6qoR9UCEFNPDdCo7vAFxSXMe
 VREPR84HeJVTV3dta.d2MPhJFr2ajoQiBUZXrcoTj5gR3w7wIAWBqu20blWJcc2EMIXDZi8h2wXi
 vuo9Hi9WvGCxijTIre_nRzhzRXp86Kt95yBsU4Xh0iDK4XKLGzU94.VbO8gtm3BCYBDn5ZGlEweQ
 omaQ9qGgyEic3yam_bIVJgJg7xo94yFspVXAgu8Cox_ej6h3DxTeC5l0TVGlSdjnm7JdQoATrUV.
 Hw9N1i5YC0x8ErfCum0UydcmQDKKSKg66rWVUrv3DjMacblpM67paHjsL1siq0kttGs7WR.3AlS8
 1KiwLPp8ssYXQo.k5HsJx8CUCEugSt7S1O65sEjf6j3HtbuSJznQ_YV99ZX7fru3DYWorF4SYp5R
 gtNldRQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Wed, 15 Jun 2022 15:30:59 +0000
Received: by hermes--canary-production-ne1-799d7bd497-nrsk4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 031fc72c838fb57df744484e20b11ff5;
          Wed, 15 Jun 2022 15:30:58 +0000 (UTC)
Message-ID: <4ae12ee6-959c-51cb-9d7a-54adb3a0ea53@schaufler-ca.com>
Date:   Wed, 15 Jun 2022 08:30:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220608150942.776446-1-fred@cloudflare.com>
 <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
 <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
 <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com>
 <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
 <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com>
 <20220615103031.qkzae4xr34wysj4b@wittgenstein>
 <CAHC9VhR8yPHZb2sCu4JGgXOSs7rudm=9opB+-LsG6_Lta9466A@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhR8yPHZb2sCu4JGgXOSs7rudm=9opB+-LsG6_Lta9466A@mail.gmail.com>
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

On 6/15/2022 7:14 AM, Paul Moore wrote:
> On Wed, Jun 15, 2022 at 6:30 AM Christian Brauner <brauner@kernel.org> wrote:
>> On Tue, Jun 14, 2022 at 01:59:08PM -0500, Frederick Lawler wrote:
>>> On 6/14/22 11:30 AM, Eric W. Biederman wrote:
>>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>>
>>>>> On 6/13/22 11:44 PM, Eric W. Biederman wrote:
>>>>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>>>>
>>>>>>> Hi Eric,
>>>>>>>
>>>>>>> On 6/13/22 12:04 PM, Eric W. Biederman wrote:
>>>>>>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>>>>>>
>>>>>>>>> While experimenting with the security_prepare_creds() LSM hook, we
>>>>>>>>> noticed that our EPERM error code was not propagated up the callstack.
>>>>>>>>> Instead ENOMEM is always returned.  As a result, some tools may send a
>>>>>>>>> confusing error message to the user:
>>>>>>>>>
>>>>>>>>> $ unshare -rU
>>>>>>>>> unshare: unshare failed: Cannot allocate memory
>>>>>>>>>
>>>>>>>>> A user would think that the system didn't have enough memory, when
>>>>>>>>> instead the action was denied.
>>>>>>>>>
>>>>>>>>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>>>>>>>>> return NULL when security_prepare_creds() returns an error code. Later,
>>>>>>>>> functions calling prepare_creds() and prepare_kernel_cred() return
>>>>>>>>> ENOMEM because they assume that a NULL meant there was no memory
>>>>>>>>> allocated.
>>>>>>>>>
>>>>>>>>> Fix this by propagating an error code from security_prepare_creds() up
>>>>>>>>> the callstack.
>>>>>>>> Why would it make sense for security_prepare_creds to return an error
>>>>>>>> code other than ENOMEM?
>>>>>>>>     > That seems a bit of a violation of what that function is supposed to do
>>>>>>>>
>>>>>>> The API allows LSM authors to decide what error code is returned from the
>>>>>>> cred_prepare hook. security_task_alloc() is a similar hook, and has its return
>>>>>>> code propagated.
>>>>>> It is not an api.  It is an implementation detail of the linux kernel.
>>>>>> It is a set of convenient functions that do a job.
>>>>>> The general rule is we don't support cases without an in-tree user.  I
>>>>>> don't see an in-tree user.
>>>>>>
>>>>>>> I'm proposing we follow security_task_allocs() pattern, and add visibility for
>>>>>>> failure cases in prepare_creds().
>>>>>> I am asking why we would want to.  Especially as it is not an API, and I
>>>>>> don't see any good reason for anything but an -ENOMEM failure to be
>>>>>> supported.
>>>>>>
>>>>> We're writing a LSM BPF policy, and not a new LSM. Our policy aims to solve
>>>>> unprivileged unshare, similar to Debian's patch [1]. We're in a position such
>>>>> that we can't use that patch because we can't block _all_ of our applications
>>>>> from performing an unshare. We prefer a granular approach. LSM BPF seems like a
>>>>> good choice.
>>>> I am quite puzzled why doesn't /proc/sys/user/max_user_namespaces work
>>>> for you?
>>>>
>>> We have the following requirements:
>>>
>>> 1. Allow list criteria
>>> 2. root user must be able to create namespaces whenever
>>> 3. Everything else not in 1 & 2 must be denied
>>>
>>> We use per task attributes to determine whether or not we allow/deny the
>>> current call to unshare().
>>>
>>> /proc/sys/user/max_user_namespaces limits are a bit broad for this level of
>>> detail.
>>>
>>>>> Because LSM BPF exposes these hooks, we should probably treat them as an
>>>>> API. From that perspective, userspace expects unshare to return a EPERM
>>>>> when the call is denied permissions.
>>>> The BPF code gets to be treated as a out of tree kernel module.
>>>>
>>>>>> Without an in-tree user that cares it is probably better to go the
>>>>>> opposite direction and remove the possibility of return anything but
>>>>>> memory allocation failure.  That will make it clearer to implementors
>>>>>> that a general error code is not supported and this is not a location
>>>>>> to implement policy, this is only a hook to allocate state for the LSM.
>>>>>>
>>>>> That's a good point, and it's possible we're using the wrong hook for the
>>>>> policy. Do you know of other hooks we can look into?
>> Fwiw, from this commit it wasn't very clear what you wanted to achieve
>> with this. It might be worth considering adding a new security hook for
>> this. Within msft it recently came up SELinux might have an interest in
>> something like this as well.
> Just to clarify things a bit, I believe SELinux would have an interest
> in a LSM hook capable of implementing an access control point for user
> namespaces regardless of Microsoft's current needs.  I suspect due to
> the security relevant nature of user namespaces most other LSMs would
> be interested as well; it seems like a well crafted hook would be
> welcome by most folks I think.

Smack isn't going to be interested in such a hook with the current
user namespace behavior. User namespaces are a discretionary access
control and privilege (capabilities) feature. Smack implements only
mandatory access control. I would still endorse adding the hook
as I could see MAC aspects (e.g. general xattr mapping) being
implemented as part of user namespaces.

