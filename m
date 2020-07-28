Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3598231660
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgG1XmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 19:42:06 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:35721
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728236AbgG1XmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 19:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595979724; bh=WL8hBTSi7deU3RUzsdTmhLxPbKtE2ao3+EyOF6pM0X8=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=RP5q35LXIfu4BnQ7yxn8C1+aPBu9qVnuktniaNubDoEynB6A/3pocB4x6Kb7P53kLMQ/ra+/x+BaG1FNqFFdqyp77rYfaRVDlGuim2SDUC5IkVJ4anfYstdfgUsCHVhNq0REMsA9C61/7zkOHisJhEqDUfS31E6MT1JK0PRuqhLspweACukxZGX4tqVBzbr02YCDggg0Wppqqu2To9Thq4UqJ6LCy+yxGa6taxrlKYacT84fPeIsmcxMqL95ZdvdIQrFB97Hjff/0fG/f5Lm2jvnwzaOIW4gkrALwmGdaGq4bKXCucp7rSd6lWaY/dLNmuJcza6WHI48lzFruQ/0MA==
X-YMail-OSG: h260Wr8VM1lhSDZiLfvkvM0OlUi0zst4DsT4LWHe1R3IXk2QobD6iNo8XR.8wqv
 hPjihA1A_w6O8KLM1Elv.jjfvqlCErNdGZJQZ84Ruh7hPv2BrfiAmGdO1WRbSID8ziiNOD2_Bv5k
 NTdHDnKFc5FYfW0l.rc69yRwE3I4oo7mr392kFMMtQn_TqUjvL9hk4sxAMawee74V3uDPgxndyH9
 APMTUbFM2wAsG8mjE58EJZNI2NwacRCJQhVpXzxO4of_6S2rceFpFevQHrhYgsgdDCsf_JkVupxQ
 o320yaGNDx0JmNz9_VJttG539eJ5dSvNb_yTcJD_k0mo_kwIHL1Hjvuw6IkdAzplDv1VdXV9jkQg
 K19a6BWlToID5yfAq0kNGkAl37SNf7K9i4C0xNE0RTDPgwkxA9XhPm0MFbfSIOP2_ToY4IdNUvWo
 SGIvbVlLLl0c8EXLruqmP2ZDI0CThc6DeqTUsdYh78svv32gj_eGui0VmsyI6yGeeNJ3FYVmmnMb
 larBb.o12zIUR49Lmd7BT8vY.UgjPAmJFHXehWtaSx1nPn7awucq9s8qt.Hao1ukhWYGtGN2A0iw
 y.AAnM430.IAbdI8x4t4B2iJ587rlU99MLXIrloykB8z3RqAkngF7Ve3eBySF2Y5JgmEFHQoZRYu
 CYYCMcKtuZARw8Vj9ATvOJRgy62Sbk0Yu6uaVcFpA3x0sVRJ._ZkVC4_3CMbq8PgsocdYzpmO5e_
 AWf4Ysn_Dh..0AUxNmYC33RychOwGVpTf5RWJDjcLGlHdxf_.soht2LMR.9R5XPSXFWnEHt1f7_J
 OJ.T5AuOuNSVc6Ui8CxzCcrybiGCISzNis3C7JKkmwlBVMV9kxoS8EAi4lzuEdVeXUMrUejZpePa
 AR76DokmJ3dN_SE_vB9VQKer9vbjhqyrNMDf9Qo12oLIed1Pe.4c._Vp6uX_Q2fXbpwwqNyFajfK
 kdhMRjTyTNpybzuA_sHZb1YYHUSpkNGScnXGpfneYJ0jzqLCAJoKfjJZYqJXb10wXGLgG1zi3Les
 B91nniYdzQEuWiF50mWHq9G6eS4CUFuhq.hkn.xwT7pZmTJIaS5YIDd36A1mhPE0fJfBEy7Sbnap
 eB55thwqplrAAt9tNMAk2wINL_vNLGn397P5j0BLALN2G3Iij6A4Z6HSCk8gRLRBSCyVaNOjbfy5
 BLeqMm3WnbK6L.7Ol_r_HGwG0jCtuX3SYPxneL62GfNrfyCNhCeh4EkZmQQ.6c4hFe5RI5HQBpG1
 yTZgnHs_CLZYcKKP_RTVwjdLGuL1oS2RHM9I5WZl7xnAI8Z.6Iufc5IykyXxDkkCZeceV50fUO35
 R9tZl5.pKDcwgkTRh4HaFWbqC9kDwxi22PWZVPktNpsx7YL3Vgefg7E3.ufx.PX8BvZf0FPSw6Sx
 .cUJIDQb4vaoZoT7xd0s-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jul 2020 23:42:04 +0000
Received: by smtp421.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID f6f1d93bb9d2ecbf675eab2dcdb1adff;
          Tue, 28 Jul 2020 23:42:00 +0000 (UTC)
Subject: Re: [PATCH v19 06/23] LSM: Use lsmblob in security_secctx_to_secid
To:     John Johansen <john.johansen@canonical.com>,
        casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     linux-audit@redhat.com, keescook@chromium.org,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20200724203226.16374-1-casey@schaufler-ca.com>
 <20200724203226.16374-7-casey@schaufler-ca.com>
 <bebdacdf-2ecb-8e07-1b0e-6e6bfb5960d0@canonical.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <8dd6f4e0-07f0-333e-0663-0bc0889cccf2@schaufler-ca.com>
Date:   Tue, 28 Jul 2020 16:41:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bebdacdf-2ecb-8e07-1b0e-6e6bfb5960d0@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.16271 hermes_yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2020 4:11 AM, John Johansen wrote:
> On 7/24/20 1:32 PM, Casey Schaufler wrote:
>> Change security_secctx_to_secid() to fill in a lsmblob instead
>> of a u32 secid. Multiple LSMs may be able to interpret the
>> string, and this allows for setting whichever secid is
>> appropriate. Change security_secmark_relabel_packet() to use a
>> lsmblob instead of a u32 secid. In some other cases there is
>> scaffolding where interfaces have yet to be converted.
>>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> Cc: netdev@vger.kernel.org
> one comment below, but its a nice to have so
>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
>
>
>> ---
>>  include/linux/security.h          | 30 +++++++++++++++++++++++----
>>  include/net/scm.h                 |  7 +++++--
>>  kernel/cred.c                     |  4 +---
>>  net/ipv4/ip_sockglue.c            |  6 ++++--
>>  net/netfilter/nft_meta.c          | 18 +++++++++-------
>>  net/netfilter/xt_SECMARK.c        |  9 ++++++--
>>  net/netlabel/netlabel_unlabeled.c | 23 +++++++++++++--------
>>  security/security.c               | 34 ++++++++++++++++++++++++++-----
>>  8 files changed, 98 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index d81e8886d799..98176faaaba5 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -189,6 +189,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
>>  	return !memcmp(bloba, blobb, sizeof(*bloba));
>>  }
>>  
>> +/**
>> + * lsmblob_value - find the first non-zero value in an lsmblob structure.
>> + * @blob: Pointer to the data
>> + *
>> + * This needs to be used with extreme caution, as the cases where
>> + * it is appropriate are rare.
>> + *
>> + * Return the first secid value set in the lsmblob.
>> + * There should only be one.
> It would be really nice if we could have an LSM debug config, that would
> do things like checking there is indeed only one value when this fn
> is called.

I can't see a CONFIG_LSM_DEBUG for this alone, but if you have
other places you'd like to see it I'm open to it.

