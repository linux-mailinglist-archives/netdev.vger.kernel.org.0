Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDD226E7F8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgIQWJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:09:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60337 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726037AbgIQWJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 18:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600380558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=/6zFeSGPAG8xBPGsswa+zaFQxvJLetl2hxSyTaDI24g=;
        b=RTEWp4fAmop83NsWw9d0v/lqxy58jn572zwv/+93HeKL5c2fWLKNnxm1XVcK5ndL9YJASj
        RdOfQEsBnnK7LWEkGqxy7kPBFAWqachzaIgMXhJELnDX3awCWcX8B0EC27wHXJ0hXss81a
        nn6qmbWwxpCT692lGST5rqrOXZxByvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-RM-hK7SZOwSS_3T8EivU9Q-1; Thu, 17 Sep 2020 18:09:16 -0400
X-MC-Unique: RM-hK7SZOwSS_3T8EivU9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19C9E10A7AE4;
        Thu, 17 Sep 2020 22:09:14 +0000 (UTC)
Received: from [10.10.112.95] (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F416955761;
        Thu, 17 Sep 2020 22:09:05 +0000 (UTC)
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <20200917201123.GA1726926@bjorn-Precision-5520>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFl4pQoBEADT/nXR2JOfsCjDgYmE2qonSGjkM1g8S6p9UWD+bf7YEAYYYzZsLtbilFTe
 z4nL4AV6VJmC7dBIlTi3Mj2eymD/2dkKP6UXlliWkq67feVg1KG+4UIp89lFW7v5Y8Muw3Fm
 uQbFvxyhN8n3tmhRe+ScWsndSBDxYOZgkbCSIfNPdZrHcnOLfA7xMJZeRCjqUpwhIjxQdFA7
 n0s0KZ2cHIsemtBM8b2WXSQG9CjqAJHVkDhrBWKThDRF7k80oiJdEQlTEiVhaEDURXq+2XmG
 jpCnvRQDb28EJSsQlNEAzwzHMeplddfB0vCg9fRk/kOBMDBtGsTvNT9OYUZD+7jaf0gvBvBB
 lbKmmMMX7uJB+ejY7bnw6ePNrVPErWyfHzR5WYrIFUtgoR3LigKnw5apzc7UIV9G8uiIcZEn
 C+QJCK43jgnkPcSmwVPztcrkbC84g1K5v2Dxh9amXKLBA1/i+CAY8JWMTepsFohIFMXNLj+B
 RJoOcR4HGYXZ6CAJa3Glu3mCmYqHTOKwezJTAvmsCLd3W7WxOGF8BbBjVaPjcZfavOvkin0u
 DaFvhAmrzN6lL0msY17JCZo046z8oAqkyvEflFbC0S1R/POzehKrzQ1RFRD3/YzzlhmIowkM
 BpTqNBeHEzQAlIhQuyu1ugmQtfsYYq6FPmWMRfFPes/4JUU/PQARAQABtCVOaXRlc2ggTmFy
 YXlhbiBMYWwgPG5pbGFsQHJlZGhhdC5jb20+iQI9BBMBCAAnBQJZeKUKAhsjBQkJZgGABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEKOGQNwGMqM56lEP/A2KMs/pu0URcVk/kqVwcBhU
 SnvB8DP3lDWDnmVrAkFEOnPX7GTbactQ41wF/xwjwmEmTzLrMRZpkqz2y9mV0hWHjqoXbOCS
 6RwK3ri5e2ThIPoGxFLt6TrMHgCRwm8YuOSJ97o+uohCTN8pmQ86KMUrDNwMqRkeTRW9wWIQ
 EdDqW44VwelnyPwcmWHBNNb1Kd8j3xKlHtnS45vc6WuoKxYRBTQOwI/5uFpDZtZ1a5kq9Ak/
 MOPDDZpd84rqd+IvgMw5z4a5QlkvOTpScD21G3gjmtTEtyfahltyDK/5i8IaQC3YiXJCrqxE
 r7/4JMZeOYiKpE9iZMtS90t4wBgbVTqAGH1nE/ifZVAUcCtycD0f3egX9CHe45Ad4fsF3edQ
 ESa5tZAogiA4Hc/yQpnnf43a3aQ67XPOJXxS0Qptzu4vfF9h7kTKYWSrVesOU3QKYbjEAf95
 NewF9FhAlYqYrwIwnuAZ8TdXVDYt7Z3z506//sf6zoRwYIDA8RDqFGRuPMXUsoUnf/KKPrtR
 ceLcSUP/JCNiYbf1/QtW8S6Ca/4qJFXQHp0knqJPGmwuFHsarSdpvZQ9qpxD3FnuPyo64S2N
 Dfq8TAeifNp2pAmPY2PAHQ3nOmKgMG8Gn5QiORvMUGzSz8Lo31LW58NdBKbh6bci5+t/HE0H
 pnyVf5xhNC/FuQINBFl4pQoBEACr+MgxWHUP76oNNYjRiNDhaIVtnPRqxiZ9v4H5FPxJy9UD
 Bqr54rifr1E+K+yYNPt/Po43vVL2cAyfyI/LVLlhiY4yH6T1n+Di/hSkkviCaf13gczuvgz4
 KVYLwojU8+naJUsiCJw01MjO3pg9GQ+47HgsnRjCdNmmHiUQqksMIfd8k3reO9SUNlEmDDNB
 XuSzkHjE5y/R/6p8uXaVpiKPfHoULjNRWaFc3d2JGmxJpBdpYnajoz61m7XJlgwl/B5Ql/6B
 dHGaX3VHxOZsfRfugwYF9CkrPbyO5PK7yJ5vaiWre7aQ9bmCtXAomvF1q3/qRwZp77k6i9R3
 tWfXjZDOQokw0u6d6DYJ0Vkfcwheg2i/Mf/epQl7Pf846G3PgSnyVK6cRwerBl5a68w7xqVU
 4KgAh0DePjtDcbcXsKRT9D63cfyfrNE+ea4i0SVik6+N4nAj1HbzWHTk2KIxTsJXypibOKFX
 2VykltxutR1sUfZBYMkfU4PogE7NjVEU7KtuCOSAkYzIWrZNEQrxYkxHLJsWruhSYNRsqVBy
 KvY6JAsq/i5yhVd5JKKU8wIOgSwC9P6mXYRgwPyfg15GZpnw+Fpey4bCDkT5fMOaCcS+vSU1
 UaFmC4Ogzpe2BW2DOaPU5Ik99zUFNn6cRmOOXArrryjFlLT5oSOe4IposgWzdwARAQABiQIl
 BBgBCAAPBQJZeKUKAhsMBQkJZgGAAAoJEKOGQNwGMqM5ELoP/jj9d9gF1Al4+9bngUlYohYu
 0sxyZo9IZ7Yb7cHuJzOMqfgoP4tydP4QCuyd9Q2OHHL5AL4VFNb8SvqAxxYSPuDJTI3JZwI7
 d8JTPKwpulMSUaJE8ZH9n8A/+sdC3CAD4QafVBcCcbFe1jifHmQRdDrvHV9Es14QVAOTZhnJ
 vweENyHEIxkpLsyUUDuVypIo6y/Cws+EBCWt27BJi9GH/EOTB0wb+2ghCs/i3h8a+bi+bS7L
 FCCm/AxIqxRurh2UySn0P/2+2eZvneJ1/uTgfxnjeSlwQJ1BWzMAdAHQO1/lnbyZgEZEtUZJ
 x9d9ASekTtJjBMKJXAw7GbB2dAA/QmbA+Q+Xuamzm/1imigz6L6sOt2n/X/SSc33w8RJUyor
 SvAIoG/zU2Y76pKTgbpQqMDmkmNYFMLcAukpvC4ki3Sf086TdMgkjqtnpTkEElMSFJC8npXv
 3QnGGOIfFug/qs8z03DLPBz9VYS26jiiN7QIJVpeeEdN/LKnaz5LO+h5kNAyj44qdF2T2AiF
 HxnZnxO5JNP5uISQH3FjxxGxJkdJ8jKzZV7aT37sC+Rp0o3KNc+GXTR+GSVq87Xfuhx0LRST
 NK9ZhT0+qkiN7npFLtNtbzwqaqceq3XhafmCiw8xrtzCnlB/C4SiBr/93Ip4kihXJ0EuHSLn
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <ec44b017-fb54-b2aa-81a4-7f27ba7eaebc@redhat.com>
Date:   Thu, 17 Sep 2020 18:09:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917201123.GA1726926@bjorn-Precision-5520>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qPHOouy6gPmk35aXRjjLdKpe2k9JahaLW"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qPHOouy6gPmk35aXRjjLdKpe2k9JahaLW
Content-Type: multipart/mixed; boundary="z470jYo3zBx5K3PjRdsFarqxC09qC8piH"

--z470jYo3zBx5K3PjRdsFarqxC09qC8piH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/17/20 4:11 PM, Bjorn Helgaas wrote:
> [+cc Ingo, Peter, Juri, Vincent (scheduler maintainers)]
>
> s/hosekeeping/housekeeping/ (in subject)
>
> On Wed, Sep 09, 2020 at 11:08:16AM -0400, Nitesh Narayan Lal wrote:
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
> Totally kibitzing here, but AFAICT the concepts of "isolated CPU" and
> "housekeeping CPU" are not currently exposed to drivers, and it's not
> completely clear to me that they should be.
>
> We have carefully constructed notions of possible, present, online,
> active CPUs, and it seems like whatever we do here should be
> somehow integrated with those.

At one point I thought about tweaking num_online_cpus(), but then I quickly
moved away from that just because it is extensively used in the kernel and =
we
don't have to modify the behavior at all those places.

Thank you for including Peter and Vincent as well.
I would be happy to discuss/explore other options.

>
>> If there are no isolated CPUs specified then the API returns the number
>> of all online CPUs.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/sched/isolation.h |  7 +++++++
>>  kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
>>
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
>> +=09=09return cpus;
>> +=09}
>> +=09return num_online_cpus();
>> +}
>> +EXPORT_SYMBOL_GPL(num_housekeeping_cpus);
>> +
>>  int housekeeping_any_cpu(enum hk_flags flags)
>>  {
>>  =09int cpu;
>> @@ -131,6 +153,7 @@ static int __init housekeeping_setup(char *str, enum=
 hk_flags flags)
>> =20
>>  =09housekeeping_flags |=3D flags;
>> =20
>> +=09atomic_set(&__num_housekeeping_cpus, cpumask_weight(housekeeping_mas=
k));
>>  =09free_bootmem_cpumask_var(non_housekeeping_mask);
>> =20
>>  =09return 1;
>> --=20
>> 2.27.0
>>
--=20
Nitesh


--z470jYo3zBx5K3PjRdsFarqxC09qC8piH--

--qPHOouy6gPmk35aXRjjLdKpe2k9JahaLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9j3oAACgkQo4ZA3AYy
ozkFzhAAre38UgoNY3QsPxENtstDExHNr59GinuBuAQFl/fQz3WTaG3p9BWrLXxB
T1zP0C2xCWMS93UHReZWpRdkPSLqFMd35tmq6u5HyHBlvEUKMV6eX6By2LT7o52Z
2Uw2e21ZdQhXCj1WCq+3+OSvZvtlwr9oCSoAKibiKQUrVuofti43t5sJIaILxk4s
7pnzMiQZZJt2Ku6IaYpo5ydW9i2GEMLMmpSZt+9ZrS894GAp2NHPAzInp+yfyTRP
iWG3ER4EzS6FTcRMuZ2Gt2dcToKP5ap4e95pGOx9Zk2aLlte6vfsEutww85GbWrK
QaKWL9MEuYM3SSBt9NZ0Uo+6EptkK9w8WjRamW5FJPnaZ0TUDW0GAUXhV6PEb8+u
htujjTvbWtQSsxgH3hkByUV7QB52IcobSvCKX1OOpuhiccBkRJ5HpykyDcj61kcK
04ZcoYzy20nLE36bHTSWjsblEbnAEEScY0OnMvJEn7MNC1UKdlSRM5mSckQDSmCA
R7NFbxzzUFbGwltYDTEmq0Fs3M2nUptugn4qSU2A5k3mMh9QZdEi2cpH//tmA+hi
5a4OgzCQqvCoWM8s3fejSobgBn+QwUO20F2K2iskOp9vhXlleVDPYGpsVR8rr1Xg
cFite/wdu8coI1wEKxQVr+l6+IQJN/3gP4vrQZYw42c5yELZGXA=
=Ka3q
-----END PGP SIGNATURE-----

--qPHOouy6gPmk35aXRjjLdKpe2k9JahaLW--

