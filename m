Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249AC2770DA
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgIXMXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:23:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727696AbgIXMXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600950226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=EfF0VJoTz3X4gMwjR4W/vZ6CUVCDhIUIyTFew1L1K7w=;
        b=fHJSTaSBWI6DBM/L2wmy8/vNrfL8qWyQxB1Syrup7BBAtjEeyU+9eyUFA4ohOIuBq2sli4
        rZ00RxY176VTLCEYNfU0pHj0Fq2S+oP66uvGPDFocWHmbhn9YmhD4L8vsMt7ummgWBK2hk
        s7fQhH/Y8Ked9Oz9Y/dUO1ItqUT2eIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-hQ0IoHhNNpGfJM9unZ5udw-1; Thu, 24 Sep 2020 08:23:42 -0400
X-MC-Unique: hQ0IoHhNNpGfJM9unZ5udw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FFF21891E80;
        Thu, 24 Sep 2020 12:23:40 +0000 (UTC)
Received: from [10.10.115.120] (ovpn-115-120.rdu2.redhat.com [10.10.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4B04100238E;
        Thu, 24 Sep 2020 12:23:32 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
To:     Frederic Weisbecker <frederic@kernel.org>, peterz@infradead.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
References: <20200923181126.223766-1-nitesh@redhat.com>
 <20200923181126.223766-2-nitesh@redhat.com>
 <20200924084029.GC1362448@hirez.programming.kicks-ass.net>
 <20200924120956.GA19346@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <61d6870d-0749-6c89-38d2-49a2b1fbd569@redhat.com>
Date:   Thu, 24 Sep 2020 08:23:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924120956.GA19346@lenoir>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ENs0iGnX0dCzHsa0SwTlnZ5oY3o7qAb22"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ENs0iGnX0dCzHsa0SwTlnZ5oY3o7qAb22
Content-Type: multipart/mixed; boundary="1t5XNSwI6aMElhzhwWyxggO34oCsp0dMg"

--1t5XNSwI6aMElhzhwWyxggO34oCsp0dMg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/24/20 8:09 AM, Frederic Weisbecker wrote:
> On Thu, Sep 24, 2020 at 10:40:29AM +0200, peterz@infradead.org wrote:
>> On Wed, Sep 23, 2020 at 02:11:23PM -0400, Nitesh Narayan Lal wrote:
>>> Introduce a new API hk_num_online_cpus(), that can be used to
>>> retrieve the number of online housekeeping CPUs that are meant to handl=
e
>>> managed IRQ jobs.
>>>
>>> This API is introduced for the drivers that were previously relying onl=
y
>>> on num_online_cpus() to determine the number of MSIX vectors to create.
>>> In an RT environment with large isolated but fewer housekeeping CPUs th=
is
>>> was leading to a situation where an attempt to move all of the vectors
>>> corresponding to isolated CPUs to housekeeping CPUs were failing due to
>>> per CPU vector limit.
>>>
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>> ---
>>>  include/linux/sched/isolation.h | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isol=
ation.h
>>> index cc9f393e2a70..2e96b626e02e 100644
>>> --- a/include/linux/sched/isolation.h
>>> +++ b/include/linux/sched/isolation.h
>>> @@ -57,4 +57,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk=
_flags flags)
>>>  =09return true;
>>>  }
>>> =20
>>> +static inline unsigned int hk_num_online_cpus(void)
>> This breaks with the established naming of that header.
> I guess we can make it housekeeping_num_online_cpus() ?

Right, I can do that.

Thanks

>
--=20
Nitesh


--1t5XNSwI6aMElhzhwWyxggO34oCsp0dMg--

--ENs0iGnX0dCzHsa0SwTlnZ5oY3o7qAb22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9sj8IACgkQo4ZA3AYy
ozn3Sg//Z6GkJhR5niXcOFKQBBbBS6hihHYSQlJGHN/mt+i5jwOz+7whwDaWJVop
JyR5RvY1ZilO7e1scNAEe2tOBa5PCKu+LH2fDyAw/pZUhJpVv63GZ+zlGq2yzbcO
UFlYXAJRz+Ap+fOwPMUiKwd2cvn32uDEZUY9xTberG7oJFCAoa040vDbbq6lA5sE
beGBtteKx2JrarrL7oEiiabMRIfM5T92xturicqlkLkmABiuzmykSkt6Ocks0RY0
UvT1a/bJuFXPb8fYHsPNVsaGnKxRKVNQtNUKseBR+4WCgzF2DaMQMTevZ4lIw3Bk
LP89h5Dbazgp8zwXJCYac25NUt13Yv7SFr5dW2ydDq/3C/GBfJKSWKh47KLLTVfu
5AmyZsdLnfOEVDDc4X2J4zEwmUjRViyAlYUkbmtnuGDm40H2KDR1eTq65+bCV6H9
Pzn/CNDMf2BwiYfqG42HTrMo5wB6N9n9y4RIelN89tujjJBUq+pB80MhaLL18j//
aSZbIDUnHwdwRtb1FszYMk85I+EVAhJDwGZx9Q0c+pAe5mbmWo2TR9+U+d//AKoX
pxu99YHnB1opVNn6q1GkOskHybllSXcuPICt+aQzjp/wiz5RMPzEjly9T7r7pVq2
LUQ+4PawUV4F/NxNAS3KJZlrtCnNd7L9MfkNTWIW6kFD1GJ3QTk=
=U0G3
-----END PGP SIGNATURE-----

--ENs0iGnX0dCzHsa0SwTlnZ5oY3o7qAb22--

