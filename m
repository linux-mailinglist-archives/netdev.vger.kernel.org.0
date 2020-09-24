Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812EB277B4B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIXVwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgIXVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 17:52:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600984355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=55gvcOcuPkvetKnzYPSs0vPdhhkjAUFXh2VoSe6ikOg=;
        b=Y/ErjR938SsCu8PiteOJB+rietxvJuZjIyHLdxQeO9yR3SyYhsOyZ/5jJ5FYlefC52a4hR
        ZxAHN6Ab5lidJZu3ZOXHAR3Muhn1DAvemUwHjiTZNUp8fr6g+FzIF0WR0hJmaKQEZ1SzSC
        S2SD0bpSrRwTP4Frjud3KQFd/uETyRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-PuyteNK4PhWkWN3XRkaQpQ-1; Thu, 24 Sep 2020 17:52:32 -0400
X-MC-Unique: PuyteNK4PhWkWN3XRkaQpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99211186DD39;
        Thu, 24 Sep 2020 21:52:29 +0000 (UTC)
Received: from [10.10.115.120] (ovpn-115-120.rdu2.redhat.com [10.10.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2382C1002C07;
        Thu, 24 Sep 2020 21:52:20 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
References: <20200924204759.GA2342589@bjorn-Precision-5520>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <c19c4bc8-05d4-42a2-9469-2de79919c808@redhat.com>
Date:   Thu, 24 Sep 2020 17:52:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924204759.GA2342589@bjorn-Precision-5520>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GbfTiM6QGMwFGM7V57u3YLDc9THkNTYV6"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GbfTiM6QGMwFGM7V57u3YLDc9THkNTYV6
Content-Type: multipart/mixed; boundary="PqkWgqMEmSF4m1ZnA44cawYhl6Mg3QGNC"

--PqkWgqMEmSF4m1ZnA44cawYhl6Mg3QGNC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/24/20 4:47 PM, Bjorn Helgaas wrote:
> On Wed, Sep 23, 2020 at 02:11:23PM -0400, Nitesh Narayan Lal wrote:
>> Introduce a new API hk_num_online_cpus(), that can be used to
>> retrieve the number of online housekeeping CPUs that are meant to handle
>> managed IRQ jobs.
>>
>> This API is introduced for the drivers that were previously relying only
>> on num_online_cpus() to determine the number of MSIX vectors to create.
>> In an RT environment with large isolated but fewer housekeeping CPUs thi=
s
>> was leading to a situation where an attempt to move all of the vectors
>> corresponding to isolated CPUs to housekeeping CPUs were failing due to
>> per CPU vector limit.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  include/linux/sched/isolation.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isola=
tion.h
>> index cc9f393e2a70..2e96b626e02e 100644
>> --- a/include/linux/sched/isolation.h
>> +++ b/include/linux/sched/isolation.h
>> @@ -57,4 +57,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk_=
flags flags)
>>  =09return true;
>>  }
>> =20
>> +static inline unsigned int hk_num_online_cpus(void)
>> +{
>> +#ifdef CONFIG_CPU_ISOLATION
>> +=09const struct cpumask *hk_mask;
>> +
>> +=09if (static_branch_unlikely(&housekeeping_overridden)) {
>> +=09=09hk_mask =3D housekeeping_cpumask(HK_FLAG_MANAGED_IRQ);
>> +=09=09return cpumask_weight(hk_mask);
>> +=09}
>> +#endif
>> +=09return cpumask_weight(cpu_online_mask);
> Just curious: why is this not
>
>   #ifdef CONFIG_CPU_ISOLATION
>   ...
>   #endif
>     return num_online_cpus();

I think doing an atomic read is better than a bitmap operation.
Thanks for pointing this out.

>
>> +}
>> +
>>  #endif /* _LINUX_SCHED_ISOLATION_H */
>> --=20
>> 2.18.2
>>
--=20
Nitesh


--PqkWgqMEmSF4m1ZnA44cawYhl6Mg3QGNC--

--GbfTiM6QGMwFGM7V57u3YLDc9THkNTYV6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9tFRMACgkQo4ZA3AYy
ozl4/w/8CrO6/ptua+CGUhZZfc2jaRcCPXNJCMrtLTkJ00cgwl39W3zsnna9zmKy
E5h3vGDUCoWegf99MdJyJptSP84Q1XPTsqzripqUH411Pedgb0DADTl10a4+mZTy
NeQMLKghWPj00ZCn5ngqu3UAtnsgeYAblGtEB2zlGCay6XAegnw7eKCy8gOh2Rww
jOtrvWzmOaPerOCm2AEdR0cFu/UPsZxbnEEvgz4ndRLo9f9sqGyJV7CT+E6ppi0q
IxoZqFPBNsKqU97uy5nRzo0AbvCKaswqDvy20IMuOTvxjXySYYpuuG94ihN0mCey
1u985Rwah3XlD2aCaWNfFKgX5dy28lMZ7Ph3pNcVP4ck2dCLjn03cGR8xDToysqY
6iaoh+7Tbu9SLmkoKw5cQFz54L1fq9BDyeanlZTXoslaBdp+Crwk9uqsLlVi0WOf
90w3Sl7PbwI/A4s4L29Xmqa9JVdBDicrVM4RqNmtPZxmeoGWxVyu3PNm8qS2O5oW
MlyCXIfF8PXPrL72SSd49kYYMWnC/m/8dzNgsakO/SsyWWSLxpqcOvS5pN0luXwS
/pxLsRAemKpJ/Xj7FkjBgoj/f59Nzbgg1QhNR00OCTTW5XKChb613ZtWEtPoK3oI
f8H5etLehJzXW3YvMLKtBV7E5oBeRrcMaNx2K+6yWRTKeZpUxHg=
=x1J0
-----END PGP SIGNATURE-----

--GbfTiM6QGMwFGM7V57u3YLDc9THkNTYV6--

