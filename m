Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09543A8885
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhFOS0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:26:41 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:50967 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhFOS0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:26:40 -0400
Received: from [192.168.1.155] ([95.115.9.120]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MS4WT-1lixGP0g7H-00TTUD; Tue, 15 Jun 2021 20:23:58 +0200
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
References: <YLEIKk7IuWu6W4Sy@casper.infradead.org> <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <1745326.1623409807@warthog.procyon.org.uk>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <e47706ee-3e4b-8f15-963f-292b5e47cb1d@metux.net>
Date:   Tue, 15 Jun 2021 20:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1745326.1623409807@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:l1dWw5GINi5d9D6KdR/MfM5/FegWRbfl0vjxnR2yUdW9Vwv9oLT
 MEAHr8PyP8YcC6o+Yqn4LF4f1dF2zEYvYGt60YROchUahACz9shvV58vHwPsKWuLb8rGm3P
 IR2CxVWI5mN7CFH8hcq3ue3m5Nn8F7oX0u8tjkhXfP1fB4XQ+9VueDbHjcVaZZ82YsvanSM
 rftvqMwBTus20ymBQFk4Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ic+UfAApxeg=:xMi+C1LWXRsimoNEKsnwKG
 5mxcU0vHtj9Zm5HEjCy9h9sUq5qPtpjfzWgy0mhHsk86qbr9dJQfN7QAj9Quv1JbUcrcCRzdl
 bUfQvSEb0KC+9hi+WwMlV38TArCl/DAouSqiCQNao7pvtjN1M9CC8E86nLAHtrAMf6E9XI1dc
 tCA5UBAou1Z1Dm02ZUCUDV1JdZcL91ADBpOOiJ64NaVXgv2BB42jpmTg8pubJ2MJSkM4dDY1G
 wrLS0oWdW9mIun9Og6RY3Bg0NUo09Wl5QXxyzpWw8WVYkbSpnHxhumPCGcbJMAJyLToVBeWwi
 AC8dECaRBRfRBTG4medz4Eow5RSIuY6dBBIXI+dkdb/zBvt60HeWrL9FU76+szy+iBNrtxLYd
 Du0Z+O4kxMoxbR+xZ9b3KnABes+BV82fRKnWKuHb9E3I6whEmhwV3KVhx3wDjdJwqTyaMePQi
 zx08rCWC2amopXPxWcwFxvphs2Mox2d2bgIaZWix19xu5b2A6NEeZ9Y/RDvnpxnGWOKM5t0td
 cE2C39N+fJT2AJRCXYwZLE=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.06.21 13:10, David Howells wrote:

> One thing that concerns me about flying to the US is going through multiple
> busy international airports - take Heathrow which didn't separate incoming
> travellers from red-listed countries from those of amber- or green- until like
> a week ago.
> 
> Would it be practical/economical to charter a plane to fly, say, from a less
> busy airport in Europe to a less busy airport in the US and back again if we
> could get enough delegates together to make it worthwhile?

Wouldn't just taking prophylatic meds like CDS or HCQ and/or hi-dose
vitamins (C, D3+K2) be way more cost effective and flexible than to
charter a whole plane ?

Don't have personal experience w/ HCQ yet, but CDS is pretty cheap and
easy to use (prescription free). Of course, one should dig a bit into
the specialist literature, before playing around - and take a few days
for finding the right personal dose. especially when one's cumbered w/ 
parasites (herxheimer)


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
