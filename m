Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D82E21A7B7
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGITYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:24:30 -0400
Received: from sonic310-22.consmr.mail.bf2.yahoo.com ([74.6.135.196]:33916
        "EHLO sonic310-22.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgGITY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594322667; bh=FYfjZ85HXtLZM9ebIJlA3barURXdjru9T/57aeLLEgY=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=VuEdRGoDDat/qnAQ3kSBhrnwJ/b9skrkENsv7Fw0aKOM3l+AsLkTpKjhQWl5eTJfyX60vzwsgki7iUBCZXT7cEd0mD5qZmvpvI+/6WWKZcd+A+CKafHNQERNpC8lbGj6PTkcgB6zUC4cdP/F+mOyRDiLibyPSWSj4whgJgxU8dwKXqw4+kGoMuMpAa6z3zaZp4mx5UWNHsgPfMYmAknPEtZxgOy6dnbMEUkkIyKk209QjEpj9cSssZ3rAsARGTp7VISyj/5zpWKcdrbhtyDAqjkCxATtYJON2PI7HhrqkSjwOD9N/9xoNEEYaOcZG1D4ApfDvRAp3sWRXzuuXvP4Sg==
X-YMail-OSG: poo4ukgVM1k7KQkgX.kTKgyZje.8.s4WbffVVxuWXCtQvnxV94pXLgCeLFGz_0i
 ksYxdguhzG9xN1_vak3foLmfBY0vX1K5UtTJ1j55EilY.1I.aiVXpf05kFAY73PyGXEqeMJSCgbk
 yoS2h6lANS2hrK7qTxUK2tqxy1E6Sp67BR1H23hV202Xl0iLsW.sS7aYyvWjgNB5rxwqK524hBpu
 gW0dz71RM67bMA1uKwyvgZYnyG2Vyr5shynh.GUZyED_pFcZl4G9JlNUicxlZFAWFB4hewPCEa7t
 iBjM.WngE8RIAXjSsqUl3xUnrlJHP9I7L9XsoO4SwUBzi2k9CCmr0xBVmQpbwZ5hh_BIgV_IB80C
 Oi4J8SJ62NCo18o2eE_FWRAw.Lj21lkG6xw7Rl2HNJhXnF1w40yUlSzrC6J3YNuyBaVL..tjFG2i
 Mm5iHiidypB6r8UAsqCM8ayD8e3BaKx1sP5hG6zAE_OCg41vDBI.kT.UyuJkUVZksVG.Fq4UsBUh
 bLH_HhAd7QQ6dojIgioAuAVNjtUH2p_qgzBtovag4Vg2Dekc7uPBwNIv8rW6ViarXRpDV3hD4c89
 wfSFExaYXlcVI3hZavvsb3vGjFiZ5b6euN_TY.BywzHPDOH88Xb42kNg5wQnX8Ht1UIPev4Nk7Zj
 Ket6oDis0fnvhIMh7g4YrLk9KUYBMeb.SSVajsLuLqINev1LZvb51HKZK1ar5OJl5F.g7Nfbu5H4
 5avDuQPk_zPsN7boOIFoRqeyjDIxoOcwPN8cyD.bZZmyYVowvJEF3HCtA96ka50w6wgtvwl_wYxy
 _GBmnf7KSDPGAdnpcQg0X1PLkuy5Ugda3iDoSbZQVsX_OLXv99Bw4oQCVAtau41xrxe_TkDH7kzc
 Vz4GDCgfL1Y_CKKTE0OeKfYQVcna3Bl4ohIV892NAFzgzsdK_9Ptxl9Z5Bx_eUr4EhRv7hhyM7vD
 XHYwr77A3BZ7t59IIyeybuK.LT7dla2kB4SSjGfA_SW0.Dlfk8PWxgutJaF6oefLTpNWGz4f8GCp
 npzewwCap0iwfyz5DRs6jMUngxRJXkuNJLBmf1j05EUrNOJafbc7pVmsoTLXbq5EEGSPUGOMENvJ
 kS7C6M1IcgFkagfaVgiSJOfiJMA37L4nTSzJIlClzgrN2QM8RlQn9EE1U9pb81LfQnUYrbxEJlmY
 QnRRPou2rdpmWgzKqhuI4bl_HZCUWZsBBim3qhHewyLsDVss9ah4e_sce4ILatPbFsHccBppO5RW
 azSeqVZOs9CFv88eraHMRufFuk7XSwM3cLfwhbQhttRqzBr.8Cbx4DzAmk5foWMscGouAzltgI9o
 cqs52l5ZYxEFC77.S0UnDHy403JX6y2FH2Y2suqof0nT0KiseHVAnuV39vXsKrGk7J0Vmgx5JGPe
 GhaqZR8R_9o9rOhkCQdGu_rJ3uc_6_CbYeqc-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Thu, 9 Jul 2020 19:24:27 +0000
Received: by smtp427.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 63bfc061d179a6024efc34672b4b09ff;
          Thu, 09 Jul 2020 19:24:22 +0000 (UTC)
Subject: Re: [PATCH v18 05/23] net: Prepare UDS for security module stacking
To:     John Johansen <john.johansen@canonical.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Cc:     Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20200709001234.9719-1-casey@schaufler-ca.com>
 <20200709001234.9719-6-casey@schaufler-ca.com>
 <CAEjxPJ4EefLKKvMo=8ZWeA4gVioH=WQ=52rnMuW5TnyExmJsRg@mail.gmail.com>
 <8a5a243f-e991-ad55-0503-654cc2587133@canonical.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <8445ebdb-e85b-a8d5-5b69-8d0aee2918fd@schaufler-ca.com>
Date:   Thu, 9 Jul 2020 12:24:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8a5a243f-e991-ad55-0503-654cc2587133@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.16197 hermes_yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/2020 9:28 AM, John Johansen wrote:
> On 7/9/20 9:11 AM, Stephen Smalley wrote:
>> On Wed, Jul 8, 2020 at 8:23 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>>> Change the data used in UDS SO_PEERSEC processing from a
>>> secid to a more general struct lsmblob. Update the
>>> security_socket_getpeersec_dgram() interface to use the
>>> lsmblob. There is a small amount of scaffolding code
>>> that will come out when the security_secid_to_secctx()
>>> code is brought in line with the lsmblob.
>>>
>>> The secid field of the unix_skb_parms structure has been
>>> replaced with a pointer to an lsmblob structure, and the
>>> lsmblob is allocated as needed. This is similar to how the
>>> list of passed files is managed. While an lsmblob structure
>>> will fit in the available space today, there is no guarantee
>>> that the addition of other data to the unix_skb_parms or
>>> support for additional security modules wouldn't exceed what
>>> is available.
>>>
>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>> Cc: netdev@vger.kernel.org
>>> ---
>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>> index 3385a7a0b231..d246aefcf4da 100644
>>> --- a/net/unix/af_unix.c
>>> +++ b/net/unix/af_unix.c
>>> @@ -138,17 +138,23 @@ static struct hlist_head *unix_sockets_unbound(=
void *addr)
>>>  #ifdef CONFIG_SECURITY_NETWORK
>>>  static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff =
*skb)
>>>  {
>>> -       UNIXCB(skb).secid =3D scm->secid;
>>> +       UNIXCB(skb).lsmdata =3D kmemdup(&scm->lsmblob, sizeof(scm->ls=
mblob),
>>> +                                     GFP_KERNEL);
>>>  }
>>>
>>>  static inline void unix_set_secdata(struct scm_cookie *scm, struct s=
k_buff *skb)
>>>  {
>>> -       scm->secid =3D UNIXCB(skb).secid;
>>> +       if (likely(UNIXCB(skb).lsmdata))
>>> +               scm->lsmblob =3D *(UNIXCB(skb).lsmdata);
>>> +       else
>>> +               lsmblob_init(&scm->lsmblob, 0);
>>>  }
>>>
>>>  static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk=
_buff *skb)
>>>  {
>>> -       return (scm->secid =3D=3D UNIXCB(skb).secid);
>>> +       if (likely(UNIXCB(skb).lsmdata))
>>> +               return lsmblob_equal(&scm->lsmblob, UNIXCB(skb).lsmda=
ta);
>>> +       return false;
>>>  }
>> I don't think that this provides sensible behavior to userspace.  On a=

>> transient memory allocation failure, instead of returning an error to
>> the sender and letting them handle it, this will just proceed with
>> sending the message without its associated security information, and
>> potentially split messages on arbitrary boundaries because it cannot
>> tell whether the sender had the same security information.  I think
>> you instead need to change unix_get_secdata() to return an error on
>> allocation failure and propagate that up to the sender.

Can't say that I think that would go over especially well.
You're right about that being a better, or at least more correct,
change.

>>   Not a fan of
>> this change in general both due to extra overhead on this code path
>> and potential for breakage on allocation failures.  I know it was
>> motivated by paul's observation that we won't be able to fit many more=

>> secids into the cb but not sure we have to go there prematurely,

Paul wasn't completely against the original approach. His objection
was that using a struct lsmblob, which was already close to the maximum
size it can be and that can grow over time, might be a hard sell.

>> especially absent its usage by upstream AA (no unix_stream_connect
>> hook implementation upstream).  Also not sure how the whole bpf local
> I'm not sure how premature it is, I am running late for 5.9 but would
> like to land apparmor unix mediation in 5.10

Which means that scaffolding around the UNIXCB.secid wouldn't
suffice for very long.

>
>> storage approach to supporting security modules (or at least bpf lsm)
>> might reduce need for expanding these structures?

I think the allocation failure case would still be an issue,
and it could be much more complicated to deal with using the
local storage model. The fundamental problem comes back to fitting
more that 32 bits of information into 32 bits without having to
perform an operation that might fail.

At this point I'm inclined to revert to the original implementation
and see if it doesn't turn out to be acceptable after all. I remain
open to better ideas.


