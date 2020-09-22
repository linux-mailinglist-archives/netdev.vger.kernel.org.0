Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861D8274AFC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 23:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgIVVPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 17:15:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgIVVPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 17:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600809339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=FCeiV6ln0rHsHV1M+bIrXLkKRFukeRr/+utdmm7upbY=;
        b=cqldDxe8q5X2j9uLXlrtM/32lfi/JnP0CIoAlOYhKZSSzdZ8l/QZXloFDT4gg3YJUJQ/rh
        QQonF9+WleK0Dlf3QXc47M/HDgRo86/oBv50mI6JKqGApz99rkDTNDrMfMeB05cX8/fefy
        seLIeXEaZEEsADJE+r1TX3OSgRqQVmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-a9caZSIMO2G-_FgdeKTWlg-1; Tue, 22 Sep 2020 17:15:35 -0400
X-MC-Unique: a9caZSIMO2G-_FgdeKTWlg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AADE8030B8;
        Tue, 22 Sep 2020 21:15:33 +0000 (UTC)
Received: from [10.10.115.78] (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29FCA5C1A3;
        Tue, 22 Sep 2020 21:15:31 +0000 (UTC)
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
 <fd48e554-6a19-f799-b273-e814e5389db9@redhat.com>
 <20200922100817.GB5217@lenoir>
 <b0608566-21c6-8fc9-4615-aa00099f6d04@redhat.com>
 <20200922205805.GD5217@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <6e48babd-bcaf-dfc8-2126-2b6c146af0aa@redhat.com>
Date:   Tue, 22 Sep 2020 17:15:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922205805.GD5217@lenoir>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QYzUDHNTb61HnSlFKTqgC3z0IwNPdzuvV"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QYzUDHNTb61HnSlFKTqgC3z0IwNPdzuvV
Content-Type: multipart/mixed; boundary="5tXC1a7iThP1XJYTIA1cJH8bOPBmCzdTQ"

--5tXC1a7iThP1XJYTIA1cJH8bOPBmCzdTQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/22/20 4:58 PM, Frederic Weisbecker wrote:
> On Tue, Sep 22, 2020 at 09:50:55AM -0400, Nitesh Narayan Lal wrote:
>> On 9/22/20 6:08 AM, Frederic Weisbecker wrote:
>> TBH I don't have a very strong case here at the moment.
>> But still, IMHO, this will force the user to have both managed irqs and
>> nohz_full in their environments to avoid these kinds of issues. Is that =
how
>> we would like to proceed?
> Yep that sounds good to me. I never know how much we want to split each a=
nd any
> of the isolation features but I'd rather stay cautious to separate HK_FLA=
G_TICK
> from the rest, just in case running in nohz_full mode ever becomes intere=
sting
> alone for performance and not just latency/isolation.

Fair point.

>
> But look what you can do as well:
>
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 5a6ea03f9882..9df9598a9e39 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -141,7 +141,7 @@ static int __init housekeeping_nohz_full_setup(char *=
str)
>  =09unsigned int flags;
> =20
>  =09flags =3D HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
> -=09=09HK_FLAG_MISC | HK_FLAG_KTHREAD;
> +=09=09HK_FLAG_MISC | HK_FLAG_KTHREAD | HK_FLAG_MANAGED_IRQ;
> =20
>  =09return housekeeping_setup(str, flags);
>  }
>
>
> "nohz_full=3D" has historically gathered most wanted isolation features. =
It can
> as well isolate managed irqs.

Nice, yeap this will work.

>
>
>>> And then can we rename it to housekeeping_num_online()?
>> It could be just me, but does something like hk_num_online_cpus() makes =
more
>> sense here?
> Sure, that works as well.

Thanks a lot for all the help.

>
> Thanks.
>
--=20
Nitesh


--5tXC1a7iThP1XJYTIA1cJH8bOPBmCzdTQ--

--QYzUDHNTb61HnSlFKTqgC3z0IwNPdzuvV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9qaXAACgkQo4ZA3AYy
ozmsIhAAhT1tTDjPDsnfQm5U2ZdjJGv7zbZ0MRpgKCalRL4pwiT3Yp1+7Z0FtgxD
1thqq21G8SdPOmXZq5AtHYU93JrWPqQIjbNV3y31QZBUhRc3WufMR2bOERBeXbwb
+8FueM/dwVsiNX3wjhx05W+6Q+AmPxI9u28Aqs56FYLUgqm53fZsaNIu72FMJMuD
2NuCk5QQfWHqePWCxeZpZCmxL7k4OjHdG7FVebyVlllQyyKOiTgFWKOYn7xLkXjG
dp0Ovn8b/q7x8wIRRQZos6L92M7weLzOxO2n0kcsaQDVcGh/LpOGotIWHRL6mDKK
QE6v+HwpOO4YxgBMPGaNiJbjiSwOuqvnVLjPNZZaFa2+HZ5yQeX6tHHVS4s+e6eR
rKNyQdhu3oZyvw3lI+oZmCa0dZeYwnGTqldv+555eNeDEPh6siE9d3vOBSXhCan9
3dRjo607Ew4/0prv+IzvGwWHN6fenxFPbSkLcgEK1SUiwFfY3yqGr23Yccxgb1Ro
VvEU4Hs0nm5vpzH3gndLpxXqTTuFaDxrshFea+nzvTtisrkljwR29gwAzyqfxaWU
KEXp+4PYImbepgV1+bPMSlsHb1QjsP1HS9+yiKgenMzOyNZ0H2zaZ/bTPf7mCVFU
0o5z2yYM1UkJ9WGCpMCEwKvv/z1+Z5eR40Bep1z/uHKwQyErpH0=
=x6M0
-----END PGP SIGNATURE-----

--QYzUDHNTb61HnSlFKTqgC3z0IwNPdzuvV--

