Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49D8CC48
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfHNHFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:05:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:58296 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfHNHFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:05:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:05:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="asc'?scan'208";a="184152538"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2019 00:05:38 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
In-Reply-To: <20190813180628.GA4069@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-5-felipe.balbi@linux.intel.com> <20190716163927.GA2125@localhost> <87k1ch2m1i.fsf@linux.intel.com> <20190717173645.GD1464@localhost> <87ftn3iuqp.fsf@linux.intel.com> <20190718164121.GB1533@localhost> <87tvalxzzi.fsf@gmail.com> <20190813174821.GC3207@localhost> <20190813180628.GA4069@localhost>
Date:   Wed, 14 Aug 2019 10:05:34 +0300
Message-ID: <87ef1ob51d.fsf@gmail.com>
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

> On Tue, Aug 13, 2019 at 10:48:21AM -0700, Richard Cochran wrote:
>> > +		if (copy_from_user(&req.extts, (void __user *)arg,
>> > +				   sizeof(req.extts))) {
>> > +			err =3D -EFAULT;
>> > +			break;
>> > +		}
>> > +		if (req.extts.flags || req.extts.rsv[0]
>> > +				|| req.extts.rsv[1]) {
>> > +			err =3D -EINVAL;
>>=20
>> Since the code is mostly the same as in the PTP_EXTTS_REQUEST case,
>> maybe just double up the case statements (like in the other) and add
>> an extra test for (cmd =3D=3D PTP_EXTTS_REQUEST2) for this if-block.
>
> Thinking about the drivers, in the case of the legacy ioctls, let's
> also be sure to clear the flags and reserved fields before passing
> them to the drivers.

makes sense to me. I'll update per your requests and send only this
patch officially. Thanks for the pointers.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1Tsr4ACgkQzL64meEa
mQY/fBAA1obiuJSATwvkuWN25olDVsu1Y+uAYGYOtjTp80GHFrIuxBDIUVMLQHLD
y4rBjB/TZIHzPwDdyPsOVXKzAgmTalTIqqlTBwcNX8RsaBYl2QShxal60kKKUOLo
8kpAZwqFq4X0uts3iESlDOHsoLz1+aywKzrpevXCYLH8QjRg4I6ZmWxzmrIBUZca
6gskf00KydB5H7VyUa4PHEVUMM/vbF/JSkxKZao7py0J1fNdUH0AfQDhiMlBDjGI
MOBf5Qubn5lLvJgXstBDDhGkpiFMqY/+E1LiB05P6b2IpeC31y4cuNqV0bInXhHo
l8A2pzvhh8FlmPj4JEvO/k+3IKlqYew9ESKwcA1SL8ijK0oVcWk4evvva1202eKI
RLFamaD6+nO+HuLxp1/8h45PRkWMw0EDg+vM8gwsm/tP0EmV3YNe2C4oCqI82WBu
ZoDHJPy0eGgW97vr3R3YymwP5vwzrZMDSHgtsLPYFzYx2ScJysgqnwwYhflP8bv0
WSFtshQMCPbi2aTBv91MsEWiyizQtFzkFqGFciXmfV9e9iElol8v+lFgfcQRBGkR
gwvH7hiS7oCYqmhzkWdnsUDJZ6zDpwiA6jwCEtSg/Uswm9lHGc1wfa7U2qkgvdS1
Z0X61581VgGsRRWRrdjonf926wh9I1dzi72N+UdHoFyHrT4uuFY=
=ReYO
-----END PGP SIGNATURE-----
--=-=-=--
