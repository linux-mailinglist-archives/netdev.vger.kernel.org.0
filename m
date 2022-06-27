Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6769155C8CE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbiF0XTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 19:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiF0XSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 19:18:36 -0400
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEA023BF2
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 16:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656371914; bh=W9G4BRUXrYyHy/fL9kE3Gz6JGXZON37Y6BgjR9WiqNg=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=af2huk8//LP1jowzqHktqqU6oyLe1w7/mdB0/YhaGwzqBI0p7oevBY+1o75SYqYuEkQ+xAsSBOk/4wTsa9VshcHCZbn7ZYDcLVQIvcgyYMW4horu1xcijp1AZKMZIk4gZsHkDY2mqg8E8lELkqigRxNaj8YeEiq0lSMFxRljfshmwX8/frZEtd750lG3fZU5FvyRbyQhM1jQtLsem31lEGSoc2vJXhq+Qi+kG2s9Ru++YgumyutFjfWp6GEI4RICNeUSQDyqA9qBokMQsx272fnnZFmczhCyqxJRkmbJNZE15CgTCAZT0XFWFKX0U2V6OjDZJsS1yzpZ300ueFcJEQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656371914; bh=rnWRp+Ywl1FabmSbU70QtlJvqFOBBp4XohA0P811DGQ=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Eqvlb5S14VyLlduJLv0sEYw6EYQL3SHPyNPBWzGXZSmpiLHBWAYCT3fGqVJLhtD/RiKGPc3j7Dz13ToPmSnuIE1dj2DbUZuvlwsj6eF51kBez9QPXaM09mA/EQ/YczhZ0n/enN44O57sgRPLXaARVEfUmCmgJmziJMlKHTUceU4t0fe9rxuSZPuvSN8mtPeJuRYaqJBMyWhfpSdAzsptcCM2aFFuFU7i/i0bjW6p6WAS3kt2CqjV6KszmyhA31t5xBIE5kaprFpW6eQsNSx79Vamfy142EkbQfYwaeG5a3ESl0G+GKa1qoSBD0LsJRM37tUwXzFnuJLK3Y4HXvAaQQ==
X-YMail-OSG: 134ctasVM1laPjpVUto9SEFM8huWE_uWVwQ2vrMJhuis4MwUZkjl2op0tzYvt7S
 P6VHYjYEH.48pLNH4PzXlrKtniHDo8l12XJ95rCXzAmP5ukTCXB6_jMOZ9gbxzbKxE0F75ADp1o1
 wQEKYnKjgHJ9Gn.kaizkvxS5iib7M9D3gHnTyQCOuYhPyjPlLbGE.cTHHuRMVDqbHFl_6XxR.I7X
 ye8vOpZurcMrc.8HB4YCtbdTWqF.UUrzVPlUWJuNX9y6939SJzjknjxNfSMRPTNWtYfcRq0ju9FT
 Xy8dU0J0o8K6uCAq9OF8PKijeapFsYxy3RQAHFZ23FH5u.k6BZus5Bm2N5l9FXquSh.mTKVcuzhh
 BAcPbT9XBNAOXgZEhVIwaMA51AWF4ET_Q1.aHOIF8TOQS2HYVI7dGsfSQa8_QQmGPEM_VvWsvKp5
 a__Qqo.j1eDTuLZEI10.okZXX13VEi7tdnxuhmwAVOLbQCatEW4TGP4iZ56Bh1FoIkDhPix4a.rT
 lwDl5_qgrrz31rwdjkjiyvtDfYKgJcGeBekpOvLOzQ0FYiAs9iYYjykn91umcARXN67TvDlVSS1Q
 CBwt5pLF9vBUFLQBNf3yU_24LcAR_5uw0VA5.21zKKeqNtgO8wm.OXFiZH1Wtwx7low7jevBZ0oT
 4cByKcAx1kJJveth6Mmu8cSpY0nCOOQPJr4LcdyWqnMD4kTbF3GO.GljOwauD4baOEOD_eSeqac.
 VoPeQ5mkZlcrCGys6.oBDTI1cAFQ1B2xh5ITn8J8k.R6jMIyvGEPy.G.ikUJuzKiuL_HMniUlLHB
 Pvarnnrt7_UbMIQM3tf2eoOBb3Wuzx.mlxCnXf6hRDPLDLMwdXf.5DK_tOOrw85dRqOS.Kl8Ehku
 lQ166BpE_M0E2eofJ5tJsnvfVo5P7h8nT0_iOWCOxTAlEN7CiI7qQRtnt5MMFVis26A3zHE9wMz3
 tEuWLLbQObHedUVDWWQ5GXx60aZQN.ayOqA7XqccpXGHMpZTWsf.2h6EHppn9WWzXAtgzeIwJBeB
 O4_vdmNej2MEyKYgAWBzMbA5D6P._7TfYbYDZawr_gNd3KUNy4xycvHbRL7sG5LN0_odHzMxPjah
 0SNt5qMW1JYIX4vCtnxbpE1MiiGd8GR08pQXMAD4qXw2aX1sl9a1IZcYYfEUOeqYMHpoozYynzmH
 aGEzA9zpRrccBpWuJMTuXa0dj_KZo_yP_JlsJmHf.MXuBTP9Rw4fTY6FbLHsOxxGPhDjYgChR5tb
 .D.PLlZaJXD3_7evI1N9O9B4tylFFNB1ZmhNgEkTEP2.oiSUY7anD.q5H68j63r9.ISsddpG5mPh
 BXoTp3dMmft6Of1Xzk3wfJBt4QbnMoHZDqnr.0lgxW3mwKV.bRQ1iuE2ZbZRUiT56U5jACJj0YWy
 b5ZN.GjCsIsB1PEud.bVZE0CYc_6roP.JSwxGita1pEBhECDH44OidbG.l_2N_6nVnCngwlFrlVS
 3XJ1ZophE3Th8vHIZ7OR69LV88bbhboRvHKcJk.v_jC0huFPwmonVxYUHM19AgG0abnYVkm5jOxT
 Jl_UaCZFCh1VQeth28AIft6A39tDjD7TrdHNg3JEMARJJHvltyCUvzcehaGaY6tr20ftZgboRvcy
 zngXsIRcLGwsOuQjPXKbr87JRldLj1gpO5aiEptvFcg4P4Nzz6cM9yOrxI._MN3xs1vwJqlOKk3m
 3g2cli3_bTZCek8UFGO_WR24bUKkEkj_XKjKlAir2Qptb96Xmd61oyzjXiwGv37ffcyyuhyJMWiN
 DVg91W.KczPSC.kSGXblBAM4tioYG.TLxnpRDVc8YPv_kddFnDq0BkepdOedOHCCi0i_jWCJLyLm
 KUd2McF.Daj0m_bFUpVZ9jJIYBy7HK0dJLFrBIwMRQ5uyfEmZhN7Tu3yfFfTqcTB1zdLU1EUJ.w1
 bXlCaiJiuSmfpFvjbZkMALLQBWVPlCCLdYBwoNwqKrzE..Vz4sajA4PrL5_ZJVUUTe9Ip5mgrbLN
 dl.TdFUP3g90SawgTvPZecBNj3njsTbfzDxwyMHLzXO3p1c2AnBWDJ1UDZAwl_6WirJcNQlhuAcH
 D6khFQuxKLi_Ir_r6WhsFT6Moe57VKo9XsRcFP47ClTgyd_PFgrvY8hgjx1jYquR35n6ZqcA5qVc
 0WYHPSTkCT4VWSFLNH889GjhLbVB57oggyjj40UzWFsqoNkbQ.6Wmj1vXdegcevOz8MAh_UiSCxJ
 ycn5ugGiBqSmoyRTpp5xaZJSn2a.JkqjgUgp_TgyKZNUNfVyQJq_HQHH6mz64ua4f3VL3kZAO
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 27 Jun 2022 23:18:34 +0000
Received: by hermes--production-ne1-7459d5c5c9-f2z7w (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 02129b765be2893dad7a914f0328e08a;
          Mon, 27 Jun 2022 23:18:33 +0000 (UTC)
Message-ID: <685096bb-af0a-08c0-491a-e176ac009e85@schaufler-ca.com>
Date:   Mon, 27 Jun 2022 16:18:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christian Brauner <brauner@kernel.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
 <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
 <CAHC9VhQQJH95jTWMOGDB4deS=whSfnaF_e73zoabOOeHJMv+0Q@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQQJH95jTWMOGDB4deS=whSfnaF_e73zoabOOeHJMv+0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/2022 3:27 PM, Paul Moore wrote:
> On Mon, Jun 27, 2022 at 6:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/27/22 11:56 PM, Paul Moore wrote:
>>> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
>>>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
>>> ...
>>>
>>>>> This is one of the reasons why I usually like to see at least one LSM
>>>>> implementation to go along with every new/modified hook.  The
>>>>> implementation forces you to think about what information is necessary
>>>>> to perform a basic access control decision; sometimes it isn't always
>>>>> obvious until you have to write the access control :)
>>>> I spoke to Frederick at length during LSS and as I've been given to
>>>> understand there's a eBPF program that would immediately use this new
>>>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
>>>> infrastructure an LSM" but I think we can let this count as a legitimate
>>>> first user of this hook/code.
>>> Yes, for the most part I don't really worry about the "is a BPF LSM a
>>> LSM?" question, it's generally not important for most discussions.
>>> However, there is an issue unique to the BPF LSMs which I think is
>>> relevant here: there is no hook implementation code living under
>>> security/.  While I talked about a hook implementation being helpful
>>> to verify the hook prototype, it is also helpful in providing an
>>> in-tree example for other LSMs; unfortunately we don't get that same
>>> example value when the initial hook implementation is a BPF LSM.
>> I would argue that such a patch series must come together with a BPF
>> selftest which then i) contains an in-tree usage example, ii) adds BPF
>> CI test coverage. Shipping with a BPF selftest at least would be the
>> usual expectation.
> I'm not going to disagree with that, I generally require matching
> tests for new SELinux kernel code, but I was careful to mention code
> under 'security/' and not necessarily just a test implementation :)  I
> don't want to get into a big discussion about it, but I think having a
> working implementation somewhere under 'security/' is more
> discoverable for most LSM folks.

I agree. It would be unfortunate if we added a hook explicitly for eBPF
only to discover that the proposed user needs something different. The
LSM community should have a chance to review the code before committing
to all the maintenance required in supporting it.

Is there a reference on how to write an eBPF security module?
There should be something out there warning the eBPF programmer of the
implications of providing a secid_to_secctx hook for starters.

