Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453FF26E454
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgIQSpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:45:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbgIQSot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600368286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=dZv9dt2ed12j3IyCoFGh5jr70B/K0OY49garRCUq3u0=;
        b=ffYkNw/RsNcSC8zzke/NUX3FewHlH7rTfMBzOJ7uamriKLi9l+hoUIxY4EzKB/R02MelpR
        ZEcKs7G88Lgs8KaidcGqvg6nQUUNkxhULVic5wTqw903G8Xr9EjxTqz9vCJO9H8SUXpbWN
        NFnrNRjb9WnGemfDww66HO2uAnOzxCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-AHZEaX63PWSWj8WezI2lUQ-1; Thu, 17 Sep 2020 14:43:32 -0400
X-MC-Unique: AHZEaX63PWSWj8WezI2lUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5F88107465C;
        Thu, 17 Sep 2020 18:43:28 +0000 (UTC)
Received: from [10.10.112.95] (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1759855761;
        Thu, 17 Sep 2020 18:43:26 +0000 (UTC)
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-2-nitesh@redhat.com>
 <20200917111807.00002eac@intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <801be69a-0881-aa84-16fb-4b5782d95860@redhat.com>
Date:   Thu, 17 Sep 2020 14:43:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917111807.00002eac@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sykWZyGOxPzNSXIvsAWNzG6mWTo7RX3SY"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sykWZyGOxPzNSXIvsAWNzG6mWTo7RX3SY
Content-Type: multipart/mixed; boundary="BkC94I1bakvFQJfqXdJVK6b9RIlJxfRoY"

--BkC94I1bakvFQJfqXdJVK6b9RIlJxfRoY
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/17/20 2:18 PM, Jesse Brandeburg wrote:
> Nitesh Narayan Lal wrote:
>
>> Introduce a new API num_housekeeping_cpus(), that can be used to retriev=
e
>> the number of housekeeping CPUs by reading an atomic variable
>> __num_housekeeping_cpus. This variable is set from housekeeping_setup().
>>
>> This API is introduced for the purpose of drivers that were previously
>> relying only on num_online_cpus() to determine the number of MSIX vector=
s
>> to create. In an RT environment with large isolated but a fewer
>> housekeeping CPUs this was leading to a situation where an attempt to
>> move all of the vectors corresponding to isolated CPUs to housekeeping
>> CPUs was failing due to per CPU vector limit.
>>
>> If there are no isolated CPUs specified then the API returns the number
>> of all online CPUs.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/sched/isolation.h |  7 +++++++
>>  kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
> I'm not a scheduler expert, but a couple comments follow.
>
>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isola=
tion.h
>> index cc9f393e2a70..94c25d956d8a 100644
>> --- a/include/linux/sched/isolation.h
>> +++ b/include/linux/sched/isolation.h
>> @@ -25,6 +25,7 @@ extern bool housekeeping_enabled(enum hk_flags flags);
>>  extern void housekeeping_affine(struct task_struct *t, enum hk_flags fl=
ags);
>>  extern bool housekeeping_test_cpu(int cpu, enum hk_flags flags);
>>  extern void __init housekeeping_init(void);
>> +extern unsigned int num_housekeeping_cpus(void);
>> =20
>>  #else
>> =20
>> @@ -46,6 +47,12 @@ static inline bool housekeeping_enabled(enum hk_flags=
 flags)
>>  static inline void housekeeping_affine(struct task_struct *t,
>>  =09=09=09=09       enum hk_flags flags) { }
>>  static inline void housekeeping_init(void) { }
>> +
>> +static unsigned int num_housekeeping_cpus(void)
>> +{
>> +=09return num_online_cpus();
>> +}
>> +
>>  #endif /* CONFIG_CPU_ISOLATION */
>> =20
>>  static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 5a6ea03f9882..7024298390b7 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -13,6 +13,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>>  EXPORT_SYMBOL_GPL(housekeeping_overridden);
>>  static cpumask_var_t housekeeping_mask;
>>  static unsigned int housekeeping_flags;
>> +static atomic_t __num_housekeeping_cpus __read_mostly;
>> =20
>>  bool housekeeping_enabled(enum hk_flags flags)
>>  {
>> @@ -20,6 +21,27 @@ bool housekeeping_enabled(enum hk_flags flags)
>>  }
>>  EXPORT_SYMBOL_GPL(housekeeping_enabled);
>> =20
>> +/*
> use correct kdoc style, and you get free documentation from your source
> (you're so close!)
>
> should be (note the first line and the function title line change to
> remove parens:
> /**
>  * num_housekeeping_cpus - Read the number of housekeeping CPUs.
>  *
>  * This function returns the number of available housekeeping CPUs
>  * based on __num_housekeeping_cpus which is of type atomic_t
>  * and is initialized at the time of the housekeeping setup.
>  */

My bad, I missed that.
Thanks for pointing it out.

>
>> + * num_housekeeping_cpus() - Read the number of housekeeping CPUs.
>> + *
>> + * This function returns the number of available housekeeping CPUs
>> + * based on __num_housekeeping_cpus which is of type atomic_t
>> + * and is initialized at the time of the housekeeping setup.
>> + */
>> +unsigned int num_housekeeping_cpus(void)
>> +{
>> +=09unsigned int cpus;
>> +
>> +=09if (static_branch_unlikely(&housekeeping_overridden)) {
>> +=09=09cpus =3D atomic_read(&__num_housekeeping_cpus);
>> +=09=09/* We should always have at least one housekeeping CPU */
>> +=09=09BUG_ON(!cpus);
> you need to crash the kernel because of this? maybe a WARN_ON? How did
> the global even get set to the bad value? It's going to blame the poor
> caller for this in the trace, but the caller likely had nothing to do
> with setting the value incorrectly!

Yes, ideally this should not be triggered, but if somehow it does then we h=
ave
a bug and that needs to be fixed. That's probably the only reason why I cho=
se
BUG_ON.
But, I am not entirely against the usage of WARN_ON either, because we get =
a
stack trace anyways.
I will see if anyone else has any other concerns on this patch and then I c=
an
post the next version.

>
>> +=09=09return cpus;
>> +=09}
>> +=09return num_online_cpus();
>> +}
>> +EXPORT_SYMBOL_GPL(num_housekeeping_cpus);
--=20
Thanks
Nitesh


--BkC94I1bakvFQJfqXdJVK6b9RIlJxfRoY--

--sykWZyGOxPzNSXIvsAWNzG6mWTo7RX3SY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9jrkwACgkQo4ZA3AYy
oznAWQ/+LNkoBk/opDhpsa3BUvZBuRu+Mp2kh8m0YneZxK9li3b9N6fM5GJBplXR
d380EKHI1vG7kNtpAezeAzqHNZdP0o6Ot2cdjRq63Czg+VL2j/BHmNxyUAZtJBtL
owamuPgrp5E4TQGr8en6KpdI0PnrzqFN+ZkwEOx4LzOr1xaTssYwLhN0bhrle0jm
uiImRTTxmmM2HhTKne4l3d9qzoS4ty79sbv/Tm6Gb/zIOQ5OXKlZKK7F6OWKk6iD
0zVSPUERIoLJcsSUah4qxc6OCdE5z2jyuex1YcXLyVpHc7g0GilIqS7FjdkvS8ja
tD9HJYivZvkFSukXpTn3DtlRdKIU6Bd16NdSsbx1WYCkf1IHhKDk66vpIo0MJNm/
Q/9fpXQvZxam6heCt2/q4iy3PeGzdeGYng6GeyfrBT+YafZIIbBwH/jFm9wBzaXa
4z1K3Pdx9Hr4ie+/XtaUoPXE/bT5QiJf4HAWlxDg3jrgj2UCpJhR9tWDYOYA29bR
cz11jmYhWZyiStM179jEh3gnesOCL8T1aLGqxaMrLnZq/JdxAT+xK10VBy9j4Fiu
Cr3JGvPZYGRriLMZXVR9/qiJbNVqEfgVAsasbE8VLsLjIgCggzuRUyj3OeUAJB4S
uffEQdi3B1u31+2GH2yXdIv4yq0X6rtPnfTxEv1ti2Xbor4U8yc=
=wCvB
-----END PGP SIGNATURE-----

--sykWZyGOxPzNSXIvsAWNzG6mWTo7RX3SY--

