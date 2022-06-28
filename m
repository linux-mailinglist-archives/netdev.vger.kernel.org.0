Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B8755E6A5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347914AbiF1QD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348304AbiF1QDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:03:15 -0400
Received: from sonic307-9.consmr.mail.ne1.yahoo.com (sonic307-9.consmr.mail.ne1.yahoo.com [66.163.190.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCD9387B0
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656432140; bh=NFgR5zMErQI+MFhX1BCxRPaLLs76pZr4D/3Kb0cfplE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=G1zQ3KF9/613EAeAbBue3kImcZusseETmmk8MjC4UMmtJDYKNFAlGNz9StxcWW8JylSMj/12yUyrH0BFEjzDFY/Qq+Y3R8drmwAcmifm6BYz0HQ8wRi4PLSrI/iZFwY66xLtnp7uQvd7VKTAYd/8stouQ9c1AHkbB08v7ZVN0i3dvhmmGMaQJ3qfRVmqipaOqCt1/ugm+3QBSIzaDbnFCvrc12iV8N0jnksWiDGrFR3yNmA8mGBdQcKOn6jtldy9VG1yQoIjML6megvHp3UfdMU4qFppGHMe16RmTfY45qYcigofeGUeeOWlx6m59jcL6cwX5w5m8bxshjJeoRlUuQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1656432140; bh=ytki79+iGuSfuH2jjue7pGvSWCRSKSybyuEWT20SfY2=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=OVvFxTDgI+0gt+UCoRlh1TfURSFJ9DXtqRQN76N7VQooCdMhTZOZ1zHV6FfouAz+Qq3rEW/NidvqNErmrBknfLuL9/tc2IpGjGjYBQu9RSeU/aoVRCZQDwAjoPJZURtT9cazXEZ1MoReP7gYAHEJ/oasoUQBvJEP3slo0XiE2aOD02tHl5gOQKxdQ/0Tkn4AzPQwhef2+g6bg5dKsthVnqFRpx9AK0Zoyex5RVmWfxEpTacryxkcSK0CLinErCmKdekfoKVaLDk46CUa4FS5MQyt0TQqxaubEUToV3QIDpxnBbXHYKQPYJZo6yVoY931hnFkZxcRjSMYOU7EUEQcVQ==
X-YMail-OSG: 4zB.uFcVM1kCIpVhDR9QhPx6E.JQQtvgPsq_JMAkkKUaBieex9PuCt_icoYdaoq
 bzKLMSD8biF1sKZZwDnNvogand_MKl9xnUyC3Hnkxut1EV5_47FdwCQ6QCTFdNYQKR69ESEG9Cq6
 5Lwj1QpuDEitISSBlb9DQrtNY51NdwUHX9IHCOVXVkMEcimn5EyrJA1EByeXQorNYP9DU_J.KWwF
 7BnesB7zvNMx_ba2lNk4eocs48HwfHgzQH34ooMORe5SkUWR7r13b4H3yHCYhWK8afQ8l6bq4neC
 fpantU_W..5okL9oEJvMrn1nTgZXkDgyRIf3owMK7JFpuZjJ_gzOCuWlwl_ba9N56bTLwCH0PfFu
 NP8f9RXQR3olDJhZU2LZ5a2ycavmErmzd_77fFAYLX0u2QkwWATd9PEOKyzno_vNnXo9fMh2EHsn
 GgkZR8Y3gE6g1MhbBsb5K8m66Zw0Ui0KL9gYER1O3uSRR3NHJlCxS403t8mUZ8j0CdS7UUbhdplr
 8nZkLouS2s8UfV5BMs3vJXPH5OrOZhMchCAWGM9KBRQrJdC9Z3VbWgjcjV_FsRxrD.ARIQM3cMaY
 mTyHDoxepeZ13_2IP8R7ONtVWDOK4SjNcCwGb9_BNM1nsjwLsHHBqf7Mz6mh5ypVTHpuxKvEVd9d
 kf5Fqjkd793QdHmIqsabtyVavYgYAFaRROfxyyInIOEm4cfUJMVgCMTDiGPRnL6B9SuRTpMw4EAT
 mNUsGOM.G4Zjv_Drj9T4Bb6_b3WahQdEvQnsRM8kt5T_ZRO0WtzVu_e1JngccZXSYKzCS2fvzc4S
 rK7.dDmMwHAl7ZafkX5oHQEwPF1bd_fralLVZG61OoTGCipqJUwxy2DX.qv91N_0SnuVxMtfj1p9
 H6zv.nzA5oRYWnPgpjVfkcMMX9xMpcdmqNBmT5tT5qc0vVDJW1NT.FiY1eJNRJ97PfctQF_hYMAV
 2X6gOx6aVjIcVe6TaDBJ_T.bTI5yg08WX3TwcD.gTI_z3dTG1KCka9bbFYHZ9vHx583HiDtSp8tA
 6JYh2wiGxwjzNJYmkSaFTgVooNiAj__aXZmC5vo.IARfHYW4AJRYimlftzAiHA_Cbf._Bui4L6Uy
 b6zq2g.dT6VFhR4bbnqBaiH4YboCkF26dWcUJE6IJYiUKp1YEkUgDG6I339PLc.hEczcHTJrTX8U
 ZbUSAhFbGHAbyBWLzmQEzgwXcpGjaGBWpO6Lf264pzWuS9BTy9v_UX8P8gClGgBO_BlEIkWetEn8
 EhIMeDKYO9Vu9lkvTIeSUOA_gsWu95GG6Mv8L47vVaK8vUHSIhc24i7N3zGPDlqHqYHuz.vennYZ
 ze4X4MuKd.Nxdw3mS_NiMSP3ZtIemTxzV5IbUUg_RgoVlGKPi.Y.xXeE7a8aVzFAv4DOer47SPf3
 .zDOe9jTfEWEhYsN8F0U7J2XruXlylU3_.U833O8GyiL0co59yBy8JZeFpbLedYVD1nzSVo4sesk
 O_xTjoKmgzJva.ca7U91Zp73EwTWpJeAPn2oQTntl2bMmxmW6eGio6Zje8TnqeLaa79TEureBTh.
 39GM_sd0oLT_hyg47Q7LPV4opr700QccPGdqoIHnsXZtAJGmncl37EFeYQoNOs4b.oNq4wyixJVz
 .QiZsBAIV7Ik56xFaGlE7ZOT8k8GbcUWpBBFCO4vURH8f2YqqIX6T7T9S_kiLFdAKgP8YWwd1spe
 jVQoytgEc7ZeVJJgTNy5ZHhtRebnuBA2AMIxSPsZZi4HCR0xcUZCnuKx0NTtJR8h.NCuFjF.QcoY
 gpGb12yCum4kic66tBpKAJZauW1lOFmxzAkLEuwAnCFp1vmqXjemEWVTWrtiHgW_hANqElmp39kB
 KKOi.on92I1Qo0wEEuOrwbJ_Lg51mzEMzJvh9l3trQQ17iHHZFnpMD6iy5SVdnlfSGFm3SopJFyW
 3JD.eWQ6IH9VV.0anIu2_Nt7tfRaXyKKrPRkvc.oRkkyHR3M2k5rZ7b7.BMxnRTtW9SPCQVq.7uA
 BXKZGxoMKZ0cK0r_4wFkjQJv4Xc.ikEfiOw--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jun 2022 16:02:20 +0000
Received: by hermes--production-ne1-7459d5c5c9-vbpdr (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b9a7850224cb4de8d716fcd4b3186b7d;
          Tue, 28 Jun 2022 16:02:15 +0000 (UTC)
Message-ID: <d70d3b2d-6c3f-b1fc-f40c-f5ec01a627c0@schaufler-ca.com>
Date:   Tue, 28 Jun 2022 09:02:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Frederick Lawler <fred@cloudflare.com>,
        Paul Moore <paul@paul-moore.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christian Brauner <brauner@kernel.org>, kpsingh@kernel.org,
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
 <685096bb-af0a-08c0-491a-e176ac009e85@schaufler-ca.com>
 <9ae473c4-cd42-bb45-bce2-8aa2e4784a43@cloudflare.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <9ae473c4-cd42-bb45-bce2-8aa2e4784a43@cloudflare.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 6/28/2022 8:14 AM, Frederick Lawler wrote:
> On 6/27/22 6:18 PM, Casey Schaufler wrote:
>> On 6/27/2022 3:27 PM, Paul Moore wrote:
>>> On Mon, Jun 27, 2022 at 6:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 6/27/22 11:56 PM, Paul Moore wrote:
>>>>> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
>>>>>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
>>>>> ...
>>>>>
>>>>>>> This is one of the reasons why I usually like to see at least one LSM
>>>>>>> implementation to go along with every new/modified hook.  The
>>>>>>> implementation forces you to think about what information is necessary
>>>>>>> to perform a basic access control decision; sometimes it isn't always
>>>>>>> obvious until you have to write the access control :)
>>>>>> I spoke to Frederick at length during LSS and as I've been given to
>>>>>> understand there's a eBPF program that would immediately use this new
>>>>>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
>>>>>> infrastructure an LSM" but I think we can let this count as a legitimate
>>>>>> first user of this hook/code.
>>>>> Yes, for the most part I don't really worry about the "is a BPF LSM a
>>>>> LSM?" question, it's generally not important for most discussions.
>>>>> However, there is an issue unique to the BPF LSMs which I think is
>>>>> relevant here: there is no hook implementation code living under
>>>>> security/.  While I talked about a hook implementation being helpful
>>>>> to verify the hook prototype, it is also helpful in providing an
>>>>> in-tree example for other LSMs; unfortunately we don't get that same
>>>>> example value when the initial hook implementation is a BPF LSM.
>>>> I would argue that such a patch series must come together with a BPF
>>>> selftest which then i) contains an in-tree usage example, ii) adds BPF
>>>> CI test coverage. Shipping with a BPF selftest at least would be the
>>>> usual expectation.
>>> I'm not going to disagree with that, I generally require matching
>>> tests for new SELinux kernel code, but I was careful to mention code
>>> under 'security/' and not necessarily just a test implementation :)  I
>>> don't want to get into a big discussion about it, but I think having a
>>> working implementation somewhere under 'security/' is more
>>> discoverable for most LSM folks.
>>
>> I agree. It would be unfortunate if we added a hook explicitly for eBPF
>> only to discover that the proposed user needs something different. The
>> LSM community should have a chance to review the code before committing
>> to all the maintenance required in supporting it.
>>
>> Is there a reference on how to write an eBPF security module?
>
> There's a documentation page that briefly touches on a BPF LSM implementation [1].

That's a brief touch, alright. I'll grant that the LSM interface isn't
especially well documented for C developers, but we have done tutorials
and have multiple examples. I worry that without an in-tree example for
eBPF we might well be setting developers up for spectacular failure.

>
>> There should be something out there warning the eBPF programmer of the
>> implications of providing a secid_to_secctx hook for starters.
>>
>
> Links:
> 1. https://docs.kernel.org/bpf/prog_lsm.html?highlight=bpf+lsm#
>
