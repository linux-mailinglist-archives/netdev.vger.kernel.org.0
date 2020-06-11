Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637A51F63C8
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 10:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgFKIkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 04:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgFKIkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 04:40:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925E8C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 01:40:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x13so5238126wrv.4
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 01:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCcqRvufHngdnLtX1g/5ePoPBfY/9UU3Id3Da3Dtz0U=;
        b=L8/REVikw1NvXnAUbkc6SQmnyL2eo0jiY7xhCpdjo6krKNt/r4qN/lIjquF6Np6xvD
         CpAB87S3EKTsuIVAHQGIZifTX1+xUnh+zPXfpZeislHcWHb3zJk1U13+l/kJmygzHUJh
         XbNJ/NbeKmc4cT8gOueoG96G70rB2NVsx2TV2xieb9hIa7uYPAe9VkwUMy5Iei5fQ3uy
         kN3QszlaquWx6olylOVWC4IeHmBB0gDDeAh1pN/+BONd34Cc0c33QSIx/8//Qw7SVA/1
         TvjRXmxgx6d8UDquYTOYGpI69w+ucoin0mYBmTIVVe0mYsCST/Nsok7jh0IseL11xuwz
         0aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCcqRvufHngdnLtX1g/5ePoPBfY/9UU3Id3Da3Dtz0U=;
        b=jGlkY+vWt2DN3BIGYlHLu1qBjNLe2G/qd1EC9B2V/buVBGX6Lguuonk0buYe8Ii5dc
         xn/Xn6VcZVCAPN+SqHx8CJP3gD+NefJxziRKIInZZuBhL8hFZE8/LCJ5CwYdFeUrP1f1
         ffNhGuScFnZC+AMdKAcyavJPKyM6iYMZ42AyhZBR+9wYZQvTYhc4/txc1iDTXFlmyrhv
         31Mvo/mlTa8cI1aRWQomLIJl38VRXNIhqEnIxCeyHksAsfs70PFC5Et5sW+x1MY3eZSN
         y1NBBjFaJGtKcAMQJid+W3gNcOIc3LQeHRtuFbKj7tu1l1SwFjzQIAdJnT52K9rNsQDx
         YGDw==
X-Gm-Message-State: AOAM530MhJQ6mcMf83u+EfCoyMv6iQxGBf1Q/CEl/NOwkAgP+qQIckJW
        zbrdQKEpf19zSKF1RpWx2XSHsQUjm7aP0QVhd7/eFWqfDrI=
X-Google-Smtp-Source: ABdhPJweSqhaw1XI8OLtHJY00Egv6l9qeTOzaqwSCN/1NOqib1ixoZO5XzXpL+czf3qHVZxocp/Vq+zzFGRWO4Sy9Hk=
X-Received: by 2002:a5d:6b83:: with SMTP id n3mr8301918wrx.395.1591864808168;
 Thu, 11 Jun 2020 01:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
 <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org> <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
 <b93d9e68-c2da-bb1c-e1f9-21c81f740242@strongswan.org> <CADvbK_egkEe0Pw-Yy8eQggS-cfvndOnj7W2hqvpdNxS2xJ50xg@mail.gmail.com>
In-Reply-To: <CADvbK_egkEe0Pw-Yy8eQggS-cfvndOnj7W2hqvpdNxS2xJ50xg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 11 Jun 2020 16:48:17 +0800
Message-ID: <CADvbK_faty7VayrEfgJ-Hcr2Ah-2au6uFvq1hU0ofdNZHODNHA@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>,
        Andreas Steffen <andreas.steffen@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 12:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Jun 9, 2020 at 10:18 PM Tobias Brunner <tobias@strongswan.org> wrote:
> >
> > Hi Xin,
> >
> > >> I guess we could workaround this issue in strongSwan by installing
> > >> policies that share the same mark and selector with the same priority,
> > >> so only one instance is ever installed in the kernel.  But the inability
> > >> to address the exact policy when querying/deleting still looks like a
> > >> problem to me in general.
> > >>
> > > For deleting, yes, but for querying, I think it makes sense not to pass
> > > the priority, and always get the policy with the highest priority.
> >
> > While I agree it's less of a problem (at least for strongSwan),  it
> > should be possible to query the exact policy one wants.  Because as far
> > as I understand, the whole point of Steffen's original patch was that
> > all duplicate policies could get used concurrently, depending on the
> > marks and masks on them and the traffic, so all of them must be queryable.
> >
> > But I actually think the previous check that viewed policies with the
> > exact same mark and value as duplicates made sense, because those will
> > never be used concurrently.  It would at least fix the default behavior
> > with strongSwan (users have to configure marks/masks manually).
> >
> > > We can separate the deleting path from the querying path when
> > > XFRMA_PRIORITY attribute is set.
> > >
> > > Is that enough for your case to only fix for the policy deleting?
> >
> > While such an attribute could be part of a solution, it does not fix the
> > regression your patch created.  The kernel behavior changed and a
> > userland modification is required to get back to something resembling
> > the previous behavior (without an additional kernel patch we'll actually
> > not be able to restore the previous behavior, where we separated
> > different types of policies into priority classes).  That is, current
> > and old strongSwan versions could create lots of duplicate/lingering
> > policies, which is not good.
> >
> > A problem with such an attribute is how userland would learn when to use
> > it.  We could query the kernel version, but patches might get
> > backported.  So how can we know the kernel will create duplicates when
> > we update a policy and change the priority, which we then have to delete
> > (or even can delete with such a new attribute)?  Do we have to do a
> > runtime check (e.g. install two duplicate policies with different
> > priorities and delete twice to see if the second attempt results in an
> > error)?  With marks it's relatively easy as users have to configure them
> > explicitly and they work or they don't depending on the kernel version.
> >  But here it's not so easy as the IKE daemon uses priorities extensively
> > already.
> >
> > Like the marks it might work somehow if the new attribute also had to be
> > passed in the message that creates a policy (marks have to be passed
> > with every message, including querying them).  While that's not super
> > ideal as we'd have two priority values in these messages (and have to
> > keep track of them in the kernel state), there is some precedent with
> > the anti-replay config for SAs (which can be passed via xfrm_usersa_info
> > struct or as separate attribute with more options for ESN).  Userland
> > would still have to learn somehow that the kernel understands the new
> > attribute and duplicate policies with different priorities are possible.
> >  But if there was any advantage in using this, we could perhaps later
> > add an option for users to enable it.  At least the current behavior
> > would not change (i.e. older strongSwan versions would continue to run
> > on newer kernels without modifications).
> >
> Now I can see some about how userland is using "priority". We probably
> need to revert both this patch and 7cb8a93968e3 ("xfrm: Allow inserting
> policies with matching mark and different priorities").
>
> Thanks for the explanation, I will think more about it tomorrow.

The issue here in xfrm_mark only exists in xfrm user interface.
It's not consistent when doing get/del and new/update, see below:

NOW:
===
xfrm_get_policy (XFRM_MSG_GETPOLICY):
xfrm_get_policy (XFRM_MSG_DELPOLICY):
        xfrm_policy_byid
        xfrm_policy_bysel_ctx
                __xfrm_policy_bysel_ctx
                        (mark.v & pol->mark.m) == pol->mark.v <--

xfrm_add_policy (XFRM_MSG_NEWPOLICY):
xfrm_add_policy (XFRM_MSG_UPDPOLICY):
        xfrm_policy_insert
                xfrm_policy_insert_list
                xfrm_policy_insert_inexact_list
                        policy->mark.v == pol->mark.v &&
                        policy->priority == pol->priority;  <--


For 'new/update/del', we should do an exact match with
"mark.v == pol->mark.v && mark.m == pol->mark.m", as these are MSGs to
manage the policies, every policy should be able to be matched.

But for 'get', I'm not sure, shouldn't it be working as how it's used
in skb rx/tx path, like in xfrm_policy_match()?
(similar to 'ip route get')
But maybe for ipsec userland it may be different, what do you think?

So my suggestion for the fix is as below, which would also keep the
behavior in commit 7cb8a93968e3 ("xfrm: Allow inserting policies with
matching mark and different priorities").

WITH FIX:
========
xfrm_get_policy (XFRM_MSG_GETPOLICY):
        xfrm_policy_byid
        xfrm_policy_bysel_ctx
                __xfrm_policy_bysel_ctx
                        (mark.v & pol->mark.m) == pol->mark.v <--

xfrm_get_policy (XFRM_MSG_DELPOLICY):
        xfrm_policy_byid
        xfrm_policy_bysel_ctx
                __xfrm_policy_bysel_ctx
                        mark.v == pol->mark.v &&
                        mark.m == pol->mark.m;  <--

xfrm_add_policy (XFRM_MSG_NEWPOLICY):
xfrm_add_policy (XFRM_MSG_UPDPOLICY):
        xfrm_policy_insert
                xfrm_policy_insert_list
                xfrm_policy_insert_inexact_list
                        policy->mark.v == pol->mark.v &&
                        policy->mark.m == pol->mark.m;  <--
