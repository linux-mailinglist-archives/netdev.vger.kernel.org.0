Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1A1F3DC6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgFIOSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:18:36 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:34378 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgFIOSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:18:35 -0400
Received: from [192.168.2.100] (pub082136126227.dh-hfc.datazug.ch [82.136.126.227])
        by mail.strongswan.org (Postfix) with ESMTPSA id 4177640F5D;
        Tue,  9 Jun 2020 16:18:32 +0200 (CEST)
Subject: Re: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Yuehaibing <yuehaibing@huawei.com>,
        Andreas Steffen <andreas.steffen@strongswan.org>
References: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
 <70458451-6ece-5222-c46f-87c708eee81e@strongswan.org>
 <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b93d9e68-c2da-bb1c-e1f9-21c81f740242@strongswan.org>
Date:   Tue, 9 Jun 2020 16:18:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_cw0yeTdVuNfbc8MJ6+9+1RgnW7XGw1AgQQM7ybnbdaDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

>> I guess we could workaround this issue in strongSwan by installing
>> policies that share the same mark and selector with the same priority,
>> so only one instance is ever installed in the kernel.  But the inability
>> to address the exact policy when querying/deleting still looks like a
>> problem to me in general.
>>
> For deleting, yes, but for querying, I think it makes sense not to pass
> the priority, and always get the policy with the highest priority.

While I agree it's less of a problem (at least for strongSwan),  it
should be possible to query the exact policy one wants.  Because as far
as I understand, the whole point of Steffen's original patch was that
all duplicate policies could get used concurrently, depending on the
marks and masks on them and the traffic, so all of them must be queryable.

But I actually think the previous check that viewed policies with the
exact same mark and value as duplicates made sense, because those will
never be used concurrently.  It would at least fix the default behavior
with strongSwan (users have to configure marks/masks manually).

> We can separate the deleting path from the querying path when
> XFRMA_PRIORITY attribute is set.
> 
> Is that enough for your case to only fix for the policy deleting?

While such an attribute could be part of a solution, it does not fix the
regression your patch created.  The kernel behavior changed and a
userland modification is required to get back to something resembling
the previous behavior (without an additional kernel patch we'll actually
not be able to restore the previous behavior, where we separated
different types of policies into priority classes).  That is, current
and old strongSwan versions could create lots of duplicate/lingering
policies, which is not good.

A problem with such an attribute is how userland would learn when to use
it.  We could query the kernel version, but patches might get
backported.  So how can we know the kernel will create duplicates when
we update a policy and change the priority, which we then have to delete
(or even can delete with such a new attribute)?  Do we have to do a
runtime check (e.g. install two duplicate policies with different
priorities and delete twice to see if the second attempt results in an
error)?  With marks it's relatively easy as users have to configure them
explicitly and they work or they don't depending on the kernel version.
 But here it's not so easy as the IKE daemon uses priorities extensively
already.

Like the marks it might work somehow if the new attribute also had to be
passed in the message that creates a policy (marks have to be passed
with every message, including querying them).  While that's not super
ideal as we'd have two priority values in these messages (and have to
keep track of them in the kernel state), there is some precedent with
the anti-replay config for SAs (which can be passed via xfrm_usersa_info
struct or as separate attribute with more options for ESN).  Userland
would still have to learn somehow that the kernel understands the new
attribute and duplicate policies with different priorities are possible.
 But if there was any advantage in using this, we could perhaps later
add an option for users to enable it.  At least the current behavior
would not change (i.e. older strongSwan versions would continue to run
on newer kernels without modifications).

Regards,
Tobias
