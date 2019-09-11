Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A321AF59A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 08:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfIKGIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 02:08:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:32425 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfIKGIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 02:08:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 23:08:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="asc'?scan'208";a="187086206"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga003.jf.intel.com with ESMTP; 10 Sep 2019 23:08:16 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] PTP: introduce new versions of IOCTLs
In-Reply-To: <20190910154452.GB4016@localhost>
References: <20190909075940.12843-1-felipe.balbi@linux.intel.com> <20190910154452.GB4016@localhost>
Date:   Wed, 11 Sep 2019 09:08:12 +0300
Message-ID: <87h85jnz5f.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Richard Cochran <richardcochran@gmail.com> writes:
> On Mon, Sep 09, 2019 at 10:59:39AM +0300, Felipe Balbi wrote:
>
>>  	case PTP_PEROUT_REQUEST:
>> +	case PTP_PEROUT_REQUEST2:
>
> ...
>
>> +		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
>> +			req.perout.rsv[0] || req.perout.rsv[1] ||
>> +			req.perout.rsv[2] || req.perout.rsv[3]) &&
>> +			cmd =3D=3D PTP_PEROUT_REQUEST2) {
>> +			err =3D -EINVAL;
>> +			break;
>
> ...
>
>> +/*
>> + * Bits of the ptp_perout_request.flags field:
>> + */
>> +#define PTP_PEROUT_VALID_FLAGS (~0)
>
> I think you meant (0) here, or I am confused...

Argh. What a brain fart!

Sorry about that. I'll go fix that ASAP.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl14j0wACgkQzL64meEa
mQaROxAAwYSzWNaWJpQhoKv07ei+YmJcT2fS0MB/KBwDiEpNoHGCVmOEb9feMWFh
f+8ukRVkRIn8a8okSChN6+CXV8AVXg5p4o23o23WCEbm4an+BgZinKdNKBRHUpqY
rXGu2RiWll55PmJERJ9gtb1vEmU3fMZFVovAJg++VPvgTr3vy/0q6/J89ldIXPKp
XeHsTTEeqjs5gnz6Nu5436/JslFKNTJtt09loNqAhUY9GPNfThp3V/o0WTGvFaHz
HauDeLvZ5677jukO6ZnslzL+Q+cwh2A1L4md7o6W4RQfjz2g4KInuf4woL8msuDc
3j4pXNUsiae8Fhuy+WFE9+yzjZp1Wo6gB5xJ4utO0JWUvtR9y3v9oy8fDY8kqeY9
CxmoR6abJ3f+w476kG49NUTtlfjmDhYs8cE+41LXwWuoATttICQMhdBrBXlYda6X
bTPnp2kUSAWz53qtFUyRntvNSjr6exbhZ7esU8bvOrJxnD31BOIxlax2mnGW9PkO
+7I1Ct2z8qEkV6sEyloZrhldCP6On9U79kPak6v+NxUAewnYBalElJ70x9EsDjjW
4Na/Bi+gKlCcujV1DaAhqNaGjbtRNCsyWV+93L/zEhbpX6Taw0UOhJznH36MlCFu
Cg/bP9pqqp5Yp6SMyo1iLxk/EyGMc5Mm0aJNlokEApvnJvByo6k=
=9ECB
-----END PGP SIGNATURE-----
--=-=-=--
