Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1889A27392B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 05:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgIVDRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 23:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728374AbgIVDRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 23:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600744621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=E1FrgnT73f1I3GcchMDzc1CmjIu4+GPiYz+qAyIWjmw=;
        b=VH+NxMZ13M4NnnYMDCHI5oU2jalvdKbesyqBMWFWKqa++m/jLLM/oDb28P4i9fFCnxtOuF
        XMn8pNk0ZMYxBqxYPGOz9vFPU3yF67GoqBNP0SPjIgIo3Ll2PKqxvs1t4amPuxlKoKee0h
        6arc2nIRiYxbDbUbL4BZyWifIKAxvDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-fgIzlDpnPpehmOU7BUzqww-1; Mon, 21 Sep 2020 23:16:58 -0400
X-MC-Unique: fgIzlDpnPpehmOU7BUzqww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11EA01084C86;
        Tue, 22 Sep 2020 03:16:56 +0000 (UTC)
Received: from [10.10.115.46] (ovpn-115-46.rdu2.redhat.com [10.10.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E68378827;
        Tue, 22 Sep 2020 03:16:53 +0000 (UTC)
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-2-nitesh@redhat.com> <20200921234044.GA31047@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <fd48e554-6a19-f799-b273-e814e5389db9@redhat.com>
Date:   Mon, 21 Sep 2020 23:16:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921234044.GA31047@lenoir>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rWMZpENy2JXtixdCR2Q8UXdNmnZ2CCR0V"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rWMZpENy2JXtixdCR2Q8UXdNmnZ2CCR0V
Content-Type: multipart/mixed; boundary="Yl9iv8fzA3hBXL78rnM0sgz9M6jEuIwcJ"

--Yl9iv8fzA3hBXL78rnM0sgz9M6jEuIwcJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/21/20 7:40 PM, Frederic Weisbecker wrote:
> On Wed, Sep 09, 2020 at 11:08:16AM -0400, Nitesh Narayan Lal wrote:
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
> So the problem here is that it takes the whole cpumask weight but you're =
only
> interested in the housekeepers who take the managed irq duties I guess
> (HK_FLAG_MANAGED_IRQ ?).

IMHO we should also consider the cases where we only have nohz_full.
Otherwise, we may run into the same situation on those setups, do you agree=
?

>
>>  =09free_bootmem_cpumask_var(non_housekeeping_mask);
>> =20
>>  =09return 1;
>> --=20
>> 2.27.0
>>
--=20
Thanks
Nitesh


--Yl9iv8fzA3hBXL78rnM0sgz9M6jEuIwcJ--

--rWMZpENy2JXtixdCR2Q8UXdNmnZ2CCR0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9pbKMACgkQo4ZA3AYy
ozlyJBAAsYZ6ty//fnP9eKkhSCXRPQa4F+TiKOYzDEE2rVLrGePTyFeL5myvmzCB
tG5o16+rToTlx9SfwaxPUl5Auvc5moKwmRv9eX1+c1l+RF7SlD2gBO53GE+MipuK
58kUg66GmZcc2eonYeJqTCVJCbYQSk24oA3m4nvy+YtzGcDUG6PWsRBrg6U3E55S
YG61GlGuHGIURjYxXm2oBoU180B48k5EuR8dSAzz3Isr3TzNwrUHbkgDmlolPs0O
myzBgbXDcE+KjRSYF5d1dSO4xUA7F7hTSnWwyKGiSAfHOLFA6omV4IGh1f7TYckA
sMPvOWeF7h28TuZYN2N5LfcGu5lboXK+QHjWM0XxZBRVRdLopLTreURNO64yskt2
fmZ1igQDxLRxSnkZSLR42hoGixk2FdPQ/opg/O8/m0SV+7ygphRIYBugFL+FTQiC
VDSU5w3k3/mY69fSVDpVBB/KkMVls6VS6qhKYgWDxV2iiEW2Ze7TaUd8jIGNo5Le
iz8TuoCQ5rMQB55BK48NOBoF/n9xnskMqhRYqYJqjFdfDghgLsxYtc8vUWSOXfeh
DZn6mJ8fHF8KCGJWs5pyZ363QGafJ+V+Z3UBVG52cJBWjQwx+sV4mvrcoIRePOWW
KBfLxoxwsec99FCGNJKI32ABYqJfgr1vKHk2IGQDMOxUDrh/WCU=
=Hk2/
-----END PGP SIGNATURE-----

--rWMZpENy2JXtixdCR2Q8UXdNmnZ2CCR0V--

