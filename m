Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098749FCDE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 10:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfH1IXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 04:23:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:36809 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfH1IXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 04:23:39 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 01:23:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="asc'?scan'208";a="174838527"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga008.jf.intel.com with ESMTP; 28 Aug 2019 01:23:37 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Joe Perches <joe@perches.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
In-Reply-To: <0f1487356ae2e9ff185ede2359381630007538c7.camel@perches.com>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com> <20190817155927.GA1540@localhost> <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com> <20190818201150.GA1316@localhost> <83075553a61ede1de9cbf77b90a5acdeab5aacbf.camel@perches.com> <20190819154320.GB2883@localhost> <0f1487356ae2e9ff185ede2359381630007538c7.camel@perches.com>
Date:   Wed, 28 Aug 2019 11:23:33 +0300
Message-ID: <87k1axwvei.fsf@gmail.com>
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

Joe Perches <joe@perches.com> writes:

> On Mon, 2019-08-19 at 08:43 -0700, Richard Cochran wrote:
>> On Sun, Aug 18, 2019 at 03:07:18PM -0700, Joe Perches wrote:
>> > Also the original patch deletes 2 case entries for
>> > PTP_PIN_GETFUNC and PTP_PIN_SETFUNC and converts them to
>> > PTP_PIN_GETFUNC2 and PTP_PIN_SETFUNC2 but still uses tests
>> > for the deleted case label entries making part of the case
>> > code block unreachable.
>> >=20
>> > That's at least a defect:
>> >=20
>> > -	case PTP_PIN_GETFUNC:
>> > +	case PTP_PIN_GETFUNC2:
>> >=20
>> > and
>> >=20=20
>> > -	case PTP_PIN_SETFUNC:
>> > +	case PTP_PIN_SETFUNC2:
>>=20
>> Good catch.  Felipe, please fix that!
>>=20
>> (Regarding Joe's memset suggestion, I'll leave that to your discretion.)
>
> Not just how declarations are done or memset.
>
> Minimizing unnecessary stack consumption is generally good.

Originally I had memset only on the three cases where they were
needed. Richard, which do you prefer? I don't mind changing it back.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1mOgUACgkQzL64meEa
mQbvrhAAnskbpsrzKMjJ/1NPI5lhfGtbshqfMbi5e24sbZdcqYSprnBNv/0/KPiK
NGCYILncPi4PsTZ8bLoFG2/9vFhf0YqMgQ9q4MN/KolTaNxoq/IdNrr4CppyQ8Sb
H4LKPsjD9T+E24J2RcyTmZRiVvDvYgO3LwYL7iCuIWQuIgOLxsPZ1ZgCmw4pnwsh
/Yp/qCfSvWco2mdldjP6mw9SBFl0zidTBzHxI1re4evPPOmNb0P7Fsf0WrDNG3fU
WhP9bqQvs8r5INyiYLnSgcZVhyEMpK/N7J/jtW7wVmqT39794cystaelpVRQVUGr
Z6/YgWtvY9zuYsd4kCcR431beg4uK7KgXcvTKyqf4N1WBrOAZcg1nJ/XKSqJM7tA
iKPBm/3hVrM2iRfe71tCfzH/QbopMoIZSVKwm2ir4u5bia1H9hyir5VBWJWAa++v
yR+LC2/Ur+w+uzNn2DocxHDWhfFXshpZ2k8sDep+5kCJ9dqA4hvXjEe4POVTNaaH
dTxQjTu8VjVVqzOtJUB0xjF/zlzrPrSXD43Uudynhkh7O1RUJkMc2hH0B4Nc2Xk+
FnAg2swx2u96sKty34KGcjxNVwWYMmVvqNKbVPXxxX4RfCvO/2YNOIF6qHF1qkuB
DOqA0wQ/IY/vJnwUksrL6kjN2P7uTzTsHwDIjwU61/C+oTDnBEo=
=0XCJ
-----END PGP SIGNATURE-----
--=-=-=--
