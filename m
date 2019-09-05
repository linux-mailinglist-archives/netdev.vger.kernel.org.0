Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23D4AAA91
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbfIESHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 14:07:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:20501 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfIESHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 14:07:45 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 11:07:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="asc'?scan'208";a="382983113"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga005.fm.intel.com with ESMTP; 05 Sep 2019 11:07:44 -0700
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.119]) by
 ORSMSX102.amr.corp.intel.com ([169.254.3.129]) with mapi id 14.03.0439.000;
 Thu, 5 Sep 2019 11:07:44 -0700
From:   "Rustad, Mark D" <mark.d.rustad@intel.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: rtnl_lock() question
Thread-Topic: rtnl_lock() question
Thread-Index: AQHVYqJNX0fhsn8qT0SzmT0mxtlDA6cbl76AgACWmQCAAHFSgIABOguA
Date:   Thu, 5 Sep 2019 18:07:43 +0000
Message-ID: <FFDA0C01-0608-4A4A-B612-8964287D8E0A@intel.com>
References: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
 <3164f8de-de20-44f7-03fb-8bc39ca8449e@gmail.com>
 <C46053D2-6BF5-4CFE-BF76-32DDCAD7BC10@gmail.com>
 <867cf373f204715aec3b2e04ef9f65454cf25a2e.camel@mellanox.com>
In-Reply-To: <867cf373f204715aec3b2e04ef9f65454cf25a2e.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.233.99.21]
Content-Type: multipart/signed;
        boundary="Apple-Mail=_E2A1B686-45D0-4ACE-81AC-0B6321B33107";
        protocol="application/pgp-signature"; micalg=pgp-sha256
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_E2A1B686-45D0-4ACE-81AC-0B6321B33107
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed

On Sep 4, 2019, at 4:23 PM, Saeed Mahameed <saeedm@mellanox.com> wrote:

> some allocations require parameters that should remain valid and
> constant across the whole reconfiguration procedure such
> params.num_channels, so they must be done inside the lock.

You could always check if those parameters have changed once under the lock  
and, if they did, drop the lock, reallocate and try again. Since such  
changes should be very infrequent, this is something that really should not  
loop multiple times.

--
Mark Rustad, Networking Division, Intel Corporation

--Apple-Mail=_E2A1B686-45D0-4ACE-81AC-0B6321B33107
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEE6ug8b0Wg+ULmnksNPA7/547j7m4FAl1xTu8ACgkQPA7/547j
7m704g/+NNurCjTB3J2ILgNoj84TiT3eUJ7KofmgwWwvpijPsimzn+FySyXdZu68
7ARZC+z1z0exIYJ5RxETBvG4SXlc1d0W9aS3fl1SBO3kIgqQmHglp63mh0JzXc5o
D57370FSpST3IM3kbIjqEmZx5bPoxYnL7mD0lyZ8nb2gxHi2mRBU6SQbnYRfIN8b
SH4INmomIz2WV3V7zp4UoVslhEG+/laiEndnZD4L6SXWFS9XMdHShisfoDdQWtWZ
PhI/64KgrbzvRivWqI/WC0FwOxTB0czylskbiAmRtD2gxrka/fNq2D6QA74WXlpf
OYNXLZ7F1qfBtpJsBue4x/Y3jo7Mfiar6SEq6wXVCzskjMBw9IzRlcgNzQhVoVTf
ZW6c6wqia/6RgK46HH28kh8kexsbpl5WwwxPZNEelfCjZZcw6yDEN1VE1WpfFEuj
FQ0jYyoxXe5GGY7MeriFHcllg3ue4B1NCYH+LsTAtYTwTNK/mYHrrU60T1TV/rD0
DoB5vD/1tNl57QaA/Nj9sDoWSKHy4yo5oMPmKCMbDF7KZv1/a05gDxROMt5ryiQ2
tfK/IKhmsO20xPf30OJyBrgLXm67s+UdCBUuY6MzZXONLSHeeQXWVZP5OdSZSpJM
1E97/9d//1fiNHQuG75FKo7anbJOdJyC9zjXb4c3F80W3oty/8s=
=nrv/
-----END PGP SIGNATURE-----

--Apple-Mail=_E2A1B686-45D0-4ACE-81AC-0B6321B33107--
