Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C1E54CD9C
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347627AbiFOPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346021AbiFOPzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:55:37 -0400
Received: from sonic316-26.consmr.mail.ne1.yahoo.com (sonic316-26.consmr.mail.ne1.yahoo.com [66.163.187.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC704340FE
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655308534; bh=tKXZOSW+rCggK4tmMM0+06TKBO7wswzabCTCRNXsBhc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=lZfFWkSjhQbMXIDwPR/vSXPS8txg/aIdCiH99K/WKEGkivC7KbjYctBYz7bmYlFMGyFAw+5/EO70Y2KcWNWNdNUiElp2bKdz+BtHxboa8NCCC8jxoSxpNTcRnVXuNzUMiKfNoNfGsnUmetngJ0K1cmbbxrl1tRq+SRxaGmD7/uW98dLGX+TaSmzfJufUHUUsebWMv21GHRPMdGlz2vvpG/Zs4q+qOdp4LTp/lM9pX3ra/zfIOMkVTE0+pbiBk9eSWihirtybbEXXmBk50G+i2arJj5NT5VIXLTGhokEL+SA+4Wh+MKzbm8QQO1Mtlv+TgsivDcic6IREvOuiW9r+ig==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655308534; bh=DcasrK3Ao+uO7dv08ByHIA6gNyoX3cBO6RPIFwgZ0GF=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=P43cJCGEerBt9uDPLGhS6GCkC+nIVTHPXe+tIyjO6qKPnY5/WU7EGEGIXeUwU6JU+OHeJmY4TXkXC3uspiTga0itpEyHbiKd4ZFJ2Vfujw7i8yu29hKll7kjLzi+QVKkzawRd7/Wm3xhp7kdJQvfTwTsCJi+lC+ywSi48z0MuRmiw8GtVpeDgUDmQ0+jQPf6ePv1Oqf/ErM04mTnyrnEG5O0jPbhNwUQwrvMTOqwZR/9/lgxQ9iRkHx1pvCkzNJpOESpIc5nQ05jGwvQpxERCqn9z4Vhdn0y4ZldTxR6kxuGSGQVGOFeOB/HBiaL9JqlHT1zRhjcIiISATH+I2BP8Q==
X-YMail-OSG: 3.kxmMUVM1kALftCQOBOMDo0pwNt7N.gDwuaeG9n5J_gI6pT9kPEZctmfUZnpQN
 sj2P4HrPTnoRepKNiEiLv1xEV33fsgijjYcverCyhETE.8TeWydBXEmsKLdPjbs_x4u0ESMF7wio
 hzpfoJJadZ49RcVNHXe3XesQwRh.9Jr38oywKbpq.46hIucoXsGQmfBNEIDjXOo9bfNd5LqavkQ6
 ERdKJDJRqVfrfOO4_91Yobz3LnvShHzVtNCWTdeyyYtvpnWjjswG9zWLpLYoeU6ZOKTwtHFRLJfR
 W560sfptAJE.w918ny4Wa308w8e0lkCkAa6N1vxZNOSlms95DzcIgswYZxT..eC4VVnc6NbWaq_L
 Mr2bOHIryUCP.qo3oSGT7jrnNQ4Tv3OJDSlJZWcCz0LQEBGtGrkr5xegqgLtnoNXvCssr31GRozz
 gN005oHtmPy5eH1EZkTtx1M7Gz5.IKKMPCXZ5LGeJML5tRVy9AWQxp5lX_5CMlzFhyibPgUGi9LR
 BF8Vajr5yh97X6rzAOnIOckonNdkQyWRIuDSYixwQMP7XzdmrrYk79pIUgqB8H60B2FIvsjfKD5R
 l_IYZ_dZLMJ5dNmSs8.NcS1mV4GX7BdaodJXYZq1K4MD7EVFFJ04ybNSSwsTWV9j6YZKB85mxJar
 pXwRLvXQK8FzmSJ7Mb6Tq2z1.VtDYB1v2hOMducQQ12PP3mjWd2HYQvOgqBE7hCa5kqLSd8kQ7Bd
 M7i_GVuIQH9WSE_R9mSI89zHGMH24l6hc3Ig.b7i3R9Aht8Nci0BTeML5nOprafi6Fkb6z3VHIys
 sUAGHO55Y2h5Pe5mc4KOuN0G68IeGoGawKA.0d.UKiPMMdxe2ZuC0BWShlH5iZfWgQC1qNgVuJqe
 FgJFPYXe7y8HCkqklwZyGwhpe86OkSa390EyEFyCOHqOMlSth7XiOCUIdxI_mYT5h9VaCqrIZeoS
 t4w2NonhvVZI4tbV20Ytl5g.VVmjl1wjMqzj2xwGzrDYS5mAZ44M3H7tDBkZksnsoPdoz.x6x11G
 rvfiZixYchKYZsFUxOr3WO2UiOTMlJYd8yS4NC9eJ5hVWetnPoCa5EcCwwmBOTFkdLrDmAS0VhuD
 wqRPssrf4rJ7lJprdLziI5lZxEuV9AjEBx61CAzMhNvRVZJhI3wRENPpd6amAE3K53.HMjjwY5TA
 rhNb_m3KSlOcLK3WSeS.JUpjOBCHPfAgXLBdcvH0.LfmGVnLGlzAN.6cvffkeBHL9SDx_JQ6MZMv
 r32puXUCaqd2M6kAXstBWlsxNazPtWW0WyKEtD.A6epsaVeTXk6iNPLRxN5xCaXyZ1J.Yj71LPtS
 EmyHs0X3T7MSTgEUI5H92AY_ONrlBWnbSmdOk9d0AN2Pkrj7GPNw3bi0wzFPchsCqkUxejO2KlGN
 ReixQqwNpnhruPswKUHoxMojY75XYCJWrWz0Tphft_DsL529CGzKD7wnDgLktSfEVEzBCzJOq.2C
 FktretqsYCkfrAYwRPI2AFE02VsUoBGHeRKfv1ATxxyIyyP4wpNC2tucBriI3_vDnXEGdE75v3eQ
 z0DfJ1dF2t8Z8jhd1ApFFQaC4BsSPZIxWe9dC_lmeqUgGQGOMvcuFN7FlJ5lzasBpbP9yx8bhvXu
 cc1G6KZF7Ew.iGNU6esZnuAFrgr66dtw9P9b14qxTBwrOyJBzsq.ipPPSosa_TIJ4YHdIhdMo8N3
 Cw4j74AihIsCg150KpQ48QC4I0q_lY82cq3kDUKvA8B55OPjW5bKepKcxJWWpRiBXn9P.rgAzG7b
 ZagNnBMsfNfg5EV3u4P0rqgBMEia6cQLbQEUbScDEjB4KEN_kx4KlhzrIVc5fBgF18dxgUGpI1aY
 HFpQsYfPjGsLqVBvBc8LZl42At8Gt4m2YHVLBWCJPxC9TE0rfcwzPkWPevyy8kE7fNhP5lpQqANO
 Fefz4FKrLD2OwR6hDnnIWyb92ru22Hokk77jelyiRuZhgQ6DlUvuOZnalYISpjg7zyq9w6KMbtpg
 mg2EyBXe6vAPZgiolrQjFoXaCRvNLoPMLEhg2SzfePcMKcyiizbKKfnaZ5tk9ZRxWtf9M3UVt0Ds
 ypnw2Iw9X2ecIrwEl6iPTPbq9VvBKDelLNGr_6ujN6mjpV8U4Elb6132EdclVmcc5u5AuWz1lLWh
 WVGI.FR2LF4sAInFbD9lW9d4d4ZOhiGPbeNrNxuJNlui6AtUqMyGJfar3Ni2LZBvcnovcxzhj6Du
 woOHuP3sWOm5T2kRagJI8RBdazpZ4KmxpzyJdoS2CP99LADeT9FH3LKX1U4hhBGiDRO0.bKPzbfv
 RHnbGbCQ.eSw-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Wed, 15 Jun 2022 15:55:34 +0000
Received: by hermes--canary-production-ne1-799d7bd497-fg7z7 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 75078b18cfc3ccad112c2b90a6626809;
          Wed, 15 Jun 2022 15:55:31 +0000 (UTC)
Message-ID: <1c4b1c0d-12f6-6e9e-a6a3-cdce7418110c@schaufler-ca.com>
Date:   Wed, 15 Jun 2022 08:55:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederick Lawler <fred@cloudflare.com>,
        linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        selinux@vger.kernel.org, serge@hallyn.com, amir73il@gmail.com,
        kernel-team <kernel-team@cloudflare.com>,
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
 <CALrw=nGZtrNYn+CV+Q_w-2=Va_9m3C8PDvvPtd01d0tS=2NMWQ@mail.gmail.com>
 <CAHC9VhRSzXeAZmBdNSAFEh=6XR57ecO7Ov+6BV9b0xVN1YR_Qw@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhRSzXeAZmBdNSAFEh=6XR57ecO7Ov+6BV9b0xVN1YR_Qw@mail.gmail.com>
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

On 6/15/2022 8:33 AM, Paul Moore wrote:
> On Wed, Jun 15, 2022 at 11:06 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
>> On Wed, Jun 15, 2022 at 3:14 PM Paul Moore <paul@paul-moore.com> wrote:
>>> On Wed, Jun 15, 2022 at 6:30 AM Christian Brauner <brauner@kernel.org> wrote:
> ...
>
>>>> Fwiw, from this commit it wasn't very clear what you wanted to achieve
>>>> with this. It might be worth considering adding a new security hook for
>>>> this. Within msft it recently came up SELinux might have an interest in
>>>> something like this as well.
>>> Just to clarify things a bit, I believe SELinux would have an interest
>>> in a LSM hook capable of implementing an access control point for user
>>> namespaces regardless of Microsoft's current needs.  I suspect due to
>>> the security relevant nature of user namespaces most other LSMs would
>>> be interested as well; it seems like a well crafted hook would be
>>> welcome by most folks I think.
>> Just to get the full picture: is there actually a good reason not to
>> make this hook support this scenario? I understand it was not
>> originally intended for this, but it is well positioned in the code,
>> covers multiple subsystems (not only user namespaces), doesn't require
>> changing the LSM interface and it already does the job - just the
>> kernel internals need to respect the error code better. What bad
>> things can happen if we extend its use case to not only allocate
>> resources in LSMs?
> My concern is that the security_prepare_creds() hook, while only
> called from two different functions, ends up being called for a
> variety of different uses (look at the prepare_creds() and
> perpare_kernel_cred() callers) and I think it would be a challenge to
> identify the proper calling context in the LSM hook implementation
> given the current hook parameters.  One might be able to modify the
> hook to pass the necessary information, but I don't think that would
> be any cleaner than adding a userns specific hook.  I'm also guessing
> that the modified security_prepare_creds() hook implementations would
> also be more likely to encounter future maintenance issues as
> overriding credentials in the kernel seems only to be increasing, and
> each future caller would risk using the modified hook wrong by passing
> the wrong context and triggering the wrong behavior in the LSM.

We don't usually have hooks that do both attribute management and
access control. Some people seem excessively concerned about "cluttering"
calling code with security_something() instances, but for the most
part I think we're past that. I agree that making security_prepare_creds()
multi-purpose is a bad idea. Shared cred management isn't simple, and
adding access checks there is only going to make it worse.

