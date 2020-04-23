Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1011F1B584E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDWJiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 05:38:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCD9C03C1AF;
        Thu, 23 Apr 2020 02:38:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v8so6994953wma.0;
        Thu, 23 Apr 2020 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nbLO8r/iK5OcRq21TFw4ZPZ4SFzyr29wACufnkCY5x8=;
        b=HKPXfYY86nyuqY/lKxPkbsCiL7I90IOMXAjOgJIDPjGa0iQ7fnY4hVEPXj6RbXGg2f
         6fMlOdUk9TFTX7SSnJ5dDVhW4k7jk6j3RLWJdEZoP4bk93gvUSpJCmpf+7g11mryMFDI
         rsQZmA8wer72XPrgBAAmc02v1rmVa3gDOsfio459tp8lccsyURxRwl1juAdzFE8Sj8m6
         v3x2VObUSXOfpjdvL26RRM0ln3x6UVlXGWwI8iQso2k/bZSW2kW74kuKmu9L0YlYny5v
         Jt0GpriMuOWxrWNMKbtKzCarrlUve16CDaqC7U+YYWdCIQ+DeKkOngYpjnwFMF2QzYDB
         WhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nbLO8r/iK5OcRq21TFw4ZPZ4SFzyr29wACufnkCY5x8=;
        b=Tk7BvigoL+EXpgofXHB5SvVtIliBUSrviONC86j8T8YbK9cqFv5zyO0ABn2qyplbOt
         sNsdmMppsZf1VG7YvTkchrqTp6gLvObevjs9dkc1OoMsqsonvgMnyeOeRDDGEa/Rh+MK
         TxfzXD7YjCrm5kXo9Wa4yxsibaSPAKhTaP0lZW28dAlGfTOUX909znKeJ3uhe4YnJv+N
         tjCthGj7nx4yP7K7EmSQLD6Pv3IL07+EO2bVW2BFhX4pyG+DN7ESTR+b0Ce+R0Hn2dNQ
         nVPV7FBRkqDROA6PXSj6HYXmsgLKvR+KwVaxDvq7eycoIRlRbYlWM7Iw5lhGrWIm7z3f
         42Pw==
X-Gm-Message-State: AGi0PuZul72CX147XbgcgTbAJYiO59GnRPDDnNzsuWtqpC22LXxUo2wu
        omUzy/+k9ag04mqTNZUZ5vaweTHqRHqlU6CNllk=
X-Google-Smtp-Source: APiQypKqgJVGSUCL4kTZwpYcKv86jvVnugicODNkRj1WDHUgWAYXA85Jjx7hwZwL9QuAQE37tfE41aKtPzRMKAgSpkY=
X-Received: by 2002:a7b:c927:: with SMTP id h7mr3148921wml.122.1587634696137;
 Thu, 23 Apr 2020 02:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200421143149.45108-1-yuehaibing@huawei.com> <20200422093344.GY13121@gauss3.secunet.de>
 <1650fd55-dd70-f687-88b6-d32a04245915@huawei.com> <CADvbK_cEgKCEGRJU1v=FAdFNoh3TzD+cZLiKUtsMLHJh3JqOfg@mail.gmail.com>
 <02a56d2c-8d27-f53a-d9e3-c25bd03677c8@huawei.com> <CADvbK_cScGYRuZfJPoQ+oQKRUk-cr6nOAdTX9cU7MKtw0DUEaA@mail.gmail.com>
 <b392a477-2ab5-1045-a18c-4df915f78001@huawei.com>
In-Reply-To: <b392a477-2ab5-1045-a18c-4df915f78001@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Apr 2020 17:43:11 +0800
Message-ID: <CADvbK_dAjP-Qa1L0zDyzG_25bwr-3xtiPLzY4_CeimKcarp9Tg@mail.gmail.com>
Subject: Re: [PATCH] xfrm: policy: Only use mark as policy lookup key
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, kuba@kernel.org,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 4:41 PM Yuehaibing <yuehaibing@huawei.com> wrote:
>
> On 2020/4/23 14:37, Xin Long wrote:
> > On Thu, Apr 23, 2020 at 10:26 AM Yuehaibing <yuehaibing@huawei.com> wrote:
> >>
> >> On 2020/4/22 23:41, Xin Long wrote:
> >>> On Wed, Apr 22, 2020 at 8:18 PM Yuehaibing <yuehaibing@huawei.com> wrote:
> >>>>
> >>>> On 2020/4/22 17:33, Steffen Klassert wrote:
> >>>>> On Tue, Apr 21, 2020 at 10:31:49PM +0800, YueHaibing wrote:
> >>>>>> While update xfrm policy as follow:
> >>>>>>
> >>>>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>>>  priority 1 mark 0 mask 0x10
> >>>>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>>>  priority 2 mark 0 mask 0x00
> >>>>>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
> >>>>>>  priority 2 mark 0 mask 0x10
> >>>>>>
> >>>>>> We get this warning:
> >>>>>>
> >>>>>> WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
> >>>>>> Kernel panic - not syncing: panic_on_warn set ...
> >>>>>> CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
> >>>>>> Call Trace:
> >>>>>> RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
> >>>>>>  xfrm_policy_inexact_insert+0x70/0x330
> >>>>>>  xfrm_policy_insert+0x1df/0x250
> >>>>>>  xfrm_add_policy+0xcc/0x190 [xfrm_user]
> >>>>>>  xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
> >>>>>>  netlink_rcv_skb+0x4c/0x120
> >>>>>>  xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
> >>>>>>  netlink_unicast+0x1b3/0x270
> >>>>>>  netlink_sendmsg+0x350/0x470
> >>>>>>  sock_sendmsg+0x4f/0x60
> >>>>>>
> >>>>>> Policy C and policy A has the same mark.v and mark.m, so policy A is
> >>>>>> matched in first round lookup while updating C. However policy C and
> >>>>>> policy B has same mark and priority, which also leads to matched. So
> >>>>>> the WARN_ON is triggered.
> >>>>>>
> >>>>>> xfrm policy lookup should only be matched when the found policy has the
> >>>>>> same lookup keys (mark.v & mark.m) no matter priority.
> >>>>>>
> >>>>>> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
> >>>>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> >>>>>> ---
> >>>>>>  net/xfrm/xfrm_policy.c | 16 +++++-----------
> >>>>>>  1 file changed, 5 insertions(+), 11 deletions(-)
> >>>>>>
> >>>>>> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> >>>>>> index 297b2fd..67d0469 100644
> >>>>>> --- a/net/xfrm/xfrm_policy.c
> >>>>>> +++ b/net/xfrm/xfrm_policy.c
> >>>>>> @@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
> >>>>>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >>>>>>                                 struct xfrm_policy *pol)
> >>>>>>  {
> >>>>>> -    u32 mark = policy->mark.v & policy->mark.m;
> >>>>>> -
> >>>>>> -    if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >>>>>> -            return true;
> >>>>>> -
> >>>>>> -    if ((mark & pol->mark.m) == pol->mark.v &&
> >>>>>> -        policy->priority == pol->priority)
> >>>>>
> >>>>> If you remove the priority check, you can't insert policies with matching
> >>>>> mark and different priorities anymore. This brings us back the old bug.
> >>>>
> >>>> Yes, this is true.
> >>>>
> >>>>>
> >>>>> I plan to apply the patch from Xin Long, this seems to be the right way
> >>>>> to address this problem.
> >>>>
> >>>> That still brings an issue, update like this:
> >>>>
> >>>> policy A (mark.v = 1, mark.m = 0, priority = 1)
> >>>> policy B (mark.v = 1, mark.m = 0, priority = 1)
> >>>>
> >>>> A and B will all in the list.
> >>> I think this is another issue even before:
> >>> 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and
> >>> different priorities")
> >>>
> >>>>
> >>>> So should do this:
> >>>>
> >>>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> >>>>                                    struct xfrm_policy *pol)
> >>>>  {
> >>>> -       u32 mark = policy->mark.v & policy->mark.m;
> >>>> -
> >>>> -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> >>>> -               return true;
> >>>> -
> >>>> -       if ((mark & pol->mark.m) == pol->mark.v &&
> >>>> +       if ((policy->mark.v & policy->mark.m) == (pol->mark.v & pol->mark.m) &&
> >>>>             policy->priority == pol->priority)
> >>>>                 return true;
> >>> "mark.v & mark.m" looks weird to me, it should be:
> >>> ((something & mark.m) == mark.v)
> >>>
> >>> So why should we just do this here?:
> >>> (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m &&
> >>>  policy->priority == pol->priority)
> >>
> >>
> >> This leads to this issue:
> >>
> >>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir in mark 0x00000001 mask 0x00000005
> >>  ip -6 xfrm policy add src fd00::1/128 dst fd00::2/128 dir in mark 0x00000001 mask 0x00000003
> >>
> >> the two policies will be in list, which should not be allowed.
> > I think these are two different policies.
> > For instance:
> > mark = 0x1234567b will match the 1st one only.
> > mark = 0x1234567d will match the 2st one only
> >
> > So these should have been allowed, no?
>
> If mark = 0x12345671, it may match different policy depends on the order of inserting,
>
> ip xfrm policy update src 172.16.2.0/24 dst 172.16.1.0/24 dir in ptype main \
> tmpl src 192.168.2.10 dst 192.168.1.20 proto esp mode tunnel mark 0x00000001 mask 0x00000005
>
> ip xfrm policy update src 172.16.2.0/24 dst 172.16.1.0/24 dir in ptype main \
> tmpl src 192.168.2.100 dst 192.168.1.100 proto esp mode beet mark 0x00000001 mask 0x00000003
>
> In fact, your case should use different priority to match.
Sorry, but it does match your above policies now, like in xfrm_policy_match(),
when fl->flowi_mark == 0x1234567b:

(fl->flowi_mark & pol->mark.m) != pol->mark.v
0x1234567b & 0x00000005 == 0x00000001

and when fl->flowi_mark ==  0x1234567d:
0x1234567d & 0x00000003 ==  0x00000001

am I missing something?


>
> >
> > I'm actually confused now.
> > does the mask work against its own value, or the other value?
> > as 'A == (mark.v&mark.m)' and '(A & mark.m) == mark.v' are different things.
> >
> > This can date back to Jamal's xfrm by MARK:
> >
> > https://lwn.net/Articles/375829/
> >
> > where it does 'm->v & m->m' in xfrm_mark_get() and
> > 'policy->mark.v & policy->mark.m' in xfrm_policy_insert() while
> > it does '(A & pol->mark.m) == pol->mark.v' in other places.
> >
> > Now I'm thinking 'm->v & m->m' is meaningless, by which if we get
> > a value != m->v, it means this mark can never be matched by any.
> >
> >   policy A (mark.v = 1, mark.m = 0, priority = 1)
> >   policy B (mark.v = 1, mark.m = 0, priority = 1)
> >
> > So probably we should avoid this case by check m->v == (m->v & m->m)
> > when adding a new policy.
> >
> > wdyt?
> >
>
