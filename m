Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDFA2770EE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 14:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgIXM0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 08:26:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgIXM0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 08:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600950398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=GFwnR9UycNy1oDIUGAN8i4fEjDMSf68GZffXYsCYHqE=;
        b=Urk+o9W1EO1hoLnqNYCe4m6hbOeWbl9iPxpo3luZACRYe3P62h33rCoLX0pfLE+Y1Sagmj
        he6+x9vuw/u5QyrHS9jiHLNgmp2fffK/vbXGlXt4H/Q1hsbPqrlgqDTKzc4Uak1wY66sYd
        Iy5SIRqt/YYsg5qPndxQouo6j1EuLJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-ykcPeZN1Oc2VwDfhZWc7wA-1; Thu, 24 Sep 2020 08:26:35 -0400
X-MC-Unique: ykcPeZN1Oc2VwDfhZWc7wA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A30F61074646;
        Thu, 24 Sep 2020 12:26:32 +0000 (UTC)
Received: from [10.10.115.120] (ovpn-115-120.rdu2.redhat.com [10.10.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEC8D55760;
        Thu, 24 Sep 2020 12:26:24 +0000 (UTC)
Subject: Re: [PATCH v2 1/4] sched/isolation: API to get housekeeping online
 CPUs
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
References: <20200923181126.223766-1-nitesh@redhat.com>
 <20200923181126.223766-2-nitesh@redhat.com> <20200924121150.GB19346@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <ce5b0ace-518f-e17c-38dc-083fccedbc9b@redhat.com>
Date:   Thu, 24 Sep 2020 08:26:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924121150.GB19346@lenoir>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="72MaNEbag39Db2lEW8tcVt79cQG44k8G1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--72MaNEbag39Db2lEW8tcVt79cQG44k8G1
Content-Type: multipart/mixed; boundary="GoWiIk5Gfq1KfDGPvs02C2lhYgrQgjSJI"

--GoWiIk5Gfq1KfDGPvs02C2lhYgrQgjSJI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/24/20 8:11 AM, Frederic Weisbecker wrote:
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
> HK_FLAG_MANAGED_IRQ should be pass as an argument to the function:
>
> housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ) because it's
> completely arbitrary otherwise.


Yeap that is more sensible, I will do that.
Do you have any other concerns/suggestions on any other patch?

>
>> +=09=09return cpumask_weight(hk_mask);
>> +=09}
>> +#endif
>> +=09return cpumask_weight(cpu_online_mask);
>> +}
>> +
>>  #endif /* _LINUX_SCHED_ISOLATION_H */
>> --=20
>> 2.18.2
>>
--=20
Thanks
Nitesh


--GoWiIk5Gfq1KfDGPvs02C2lhYgrQgjSJI--

--72MaNEbag39Db2lEW8tcVt79cQG44k8G1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9skGoACgkQo4ZA3AYy
ozlwQQ/8D0DZIkSC1XngXpOpenq1bY11v3CvrsnfLsLUmknHDo4xrCGEULJ9K65b
9fpkPwThDaGzhGqSo8jmQI/AprBs8y6B6ySOj2iSjvdZLxol2VEGKCxDoh+R8FeT
HD6kAeV7FJhHeGNrmNHGHNXYu1yP6l5kmik0luws32bQeZc8+o8uKwG6fsGqoVSz
A1N/p1+gT2ZpZDfLo5Nn11cv3NRxDlhcaQkHVnlTU2hJeH3WL1uTCx0TCbxQ4mo2
4hExQACOrfP6H6qJUP2g0iQfm+ylUB6mIa2i6WtDoFf0ZLfxE8NqRi2gxTY5k9QY
WF3R+JzVggkMUVJ731R8zRVUp9/WRTGkf/VPapLhZR+UWUZbAks6g1NmmyZ4Gg8U
UDJ4u3PR5Bjj55Bc62CqtdL9lW4eF65uJq8Yd4Q2L4mefsXlh9GaeOFjUxrwPehe
NBmahDZREbB20ZFkzOICkXkX2KcrwtYFIgw8nrtZas6FMJy5MeihnAlkRf5To+4t
TYSPCpabewRyAvDtfKTls4HWXWDn5CnwqjXRuJr1buHhUaJc3K2AwKRAF4se9sem
6T26tmiFVE7ZLBRznT848oYCv1dTVg+KNtrzTSiDiDdQlIXs92tIAVGq/dmU0omF
IrQ+vGJhYD8qZA/lC5HldoYjqSe2bVgdfwickj0jVFVhZVBquGA=
=DZW2
-----END PGP SIGNATURE-----

--72MaNEbag39Db2lEW8tcVt79cQG44k8G1--

