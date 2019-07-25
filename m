Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD67747DE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 09:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbfGYHKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 03:10:04 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33359 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbfGYHKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 03:10:02 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqXsy-0005jA-N3; Thu, 25 Jul 2019 09:09:56 +0200
Received: from [IPv6:2003:c7:729:c79e:c9d4:83d5:b99:4f4d] (unknown [IPv6:2003:c7:729:c79e:c9d4:83d5:b99:4f4d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D4B054385F9;
        Thu, 25 Jul 2019 07:09:53 +0000 (UTC)
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
To:     Greg KH <gregkh@linuxfoundation.org>, Dan Murphy <dmurphy@ti.com>
Cc:     wg@grandegger.com, davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190509161109.10499-1-dmurphy@ti.com>
 <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
 <a8e3f2d3-18c3-3bdb-1318-8964afc7e032@ti.com>
 <93530d94-ec65-de82-448e-f2460dd39fb9@ti.com>
 <0f6c41c8-0071-ed3a-9e65-caf02a0fbefe@ti.com>
 <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
 <f236a88a-485c-9002-1e4a-9a5ad0e1c81f@ti.com>
 <437b6371-8488-a0ff-fa68-d1fb5a81bb8b@ti.com>
 <20190724064754.GC22447@kroah.com>
 <443fe5e5-5e5c-f669-1f4b-565d9f3dd6c8@ti.com>
 <20190725062834.GC5647@kroah.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <98b95fbe-adcc-c95f-7f3d-6c57122f4586@pengutronix.de>
Date:   Thu, 25 Jul 2019 09:09:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725062834.GC5647@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SyeBRhgR6Wi7a7a7T18A7SOMgbULzN3PG"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SyeBRhgR6Wi7a7a7T18A7SOMgbULzN3PG
Content-Type: multipart/mixed; boundary="QN5jWKS6cqhMz0iPtcqSdVweoxpAUyMl7";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>, Dan Murphy <dmurphy@ti.com>
Cc: wg@grandegger.com, davem@davemloft.net, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <98b95fbe-adcc-c95f-7f3d-6c57122f4586@pengutronix.de>
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
References: <20190509161109.10499-1-dmurphy@ti.com>
 <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
 <a8e3f2d3-18c3-3bdb-1318-8964afc7e032@ti.com>
 <93530d94-ec65-de82-448e-f2460dd39fb9@ti.com>
 <0f6c41c8-0071-ed3a-9e65-caf02a0fbefe@ti.com>
 <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
 <f236a88a-485c-9002-1e4a-9a5ad0e1c81f@ti.com>
 <437b6371-8488-a0ff-fa68-d1fb5a81bb8b@ti.com>
 <20190724064754.GC22447@kroah.com>
 <443fe5e5-5e5c-f669-1f4b-565d9f3dd6c8@ti.com>
 <20190725062834.GC5647@kroah.com>
In-Reply-To: <20190725062834.GC5647@kroah.com>

--QN5jWKS6cqhMz0iPtcqSdVweoxpAUyMl7
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 7/25/19 8:28 AM, Greg KH wrote:
> On Wed, Jul 24, 2019 at 10:36:02AM -0500, Dan Murphy wrote:
>> Hello
>>
>> On 7/24/19 1:47 AM, Greg KH wrote:
>>> On Tue, Jul 23, 2019 at 10:14:14AM -0500, Dan Murphy wrote:
>>>> Hello
>>>>
>>>> On 7/10/19 7:08 AM, Dan Murphy wrote:
>>>>> Hello
>>>>>
>>>>> On 6/17/19 10:09 AM, Dan Murphy wrote:
>>>>>> Marc
>>>>>>
>>>>>> On 6/10/19 11:35 AM, Dan Murphy wrote:
>>>>>>> Bump
>>>>>>>
>>>>>>> On 6/6/19 8:16 AM, Dan Murphy wrote:
>>>>>>>> Marc
>>>>>>>>
>>>>>>>> Bump
>>>>>>>>
>>>>>>>> On 5/31/19 6:51 AM, Dan Murphy wrote:
>>>>>>>>> Marc
>>>>>>>>>
>>>>>>>>> On 5/15/19 3:54 PM, Dan Murphy wrote:
>>>>>>>>>> Marc
>>>>>>>>>>
>>>>>>>>>> On 5/9/19 11:11 AM, Dan Murphy wrote:
>>>>>>>>>>> Create a m_can platform framework that peripheral
>>>>>>>>>>> devices can register to and use common code and register sets=
=2E
>>>>>>>>>>> The peripheral devices may provide read/write and configurati=
on
>>>>>>>>>>> support of the IP.
>>>>>>>>>>>
>>>>>>>>>>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>>>>>>>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>>>>>>>> ---
>>>>>>>>>>>
>>>>>>>>>>> v12 - Update the m_can_read/write functions to
>>>>>>>>>>> create a backtrace if the callback
>>>>>>>>>>> pointer is NULL. - https://lore.kernel.org/patchwork/patch/10=
52302/
>>>>>>>>>>>
>>>>>>>>>> Is this able to be merged now?
>>>>>>>>> ping
>>>>>> Wondering if there is anything else we need to do?
>>>>>>
>>>>>> The part has officially shipped and we had hoped to have driver
>>>>>> support in Linux as part of the announcement.
>>>>>>
>>>>> Is this being sent in a PR for 5.3?
>>>>>
>>>>> Dan
>>>>>
>>>> Adding Greg to this thread as I have no idea what is going on with t=
his.
>>> Why me?  What am I supposed to do here?  I see no patches at all to d=
o
>>> anything with :(
>>
>> I am not sure who to email. The maintainer seems to be on hiatus or su=
per
>> busy with other work.
>=20
> Who is the maintainer?

That's me.

>> So I added you to see if you know how to handle this.=C2=A0 Wolfgang A=
cked it but
>> he said Marc needs to pull
>=20
> Then work with them, again, what can I do if I can't even see the
> patches here?

The patches are included in a pull request to David Miller
(net-next/master, the CAN upstream), which has already have been merged.

>> it in.=C2=A0 We have quite a few users of this patchset. I have been h=
osting the
>> patchset in a different tree.
>>
>> These users keep pinging us for upstream status and all we can do is p=
oint
>> them to the
>>
>> LKML to show we are continuing to pursue inclusion.
>>
>> https://lore.kernel.org/patchwork/project/lkml/list/?series=3D393454
>=20
> Looks sane, work with the proper developers, good luck!

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--QN5jWKS6cqhMz0iPtcqSdVweoxpAUyMl7--

--SyeBRhgR6Wi7a7a7T18A7SOMgbULzN3PG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl05Vb0ACgkQWsYho5Hk
nSDmHQgAqjfWPPj6SIVuU5r1vwRl+igXIiKKf5wbNNThPsVrtWr/rUGl/RIDYCNr
UsAjTR2XxEte/MegGEJHF+ds+N5ObG8sQbLED6VqlKCcnip40VamkBVnRQD7xfsi
4mseg99aTg3ITp0VQoD241wbuh3mA/wrHYzBdHFF5lH2rRU4P6G+CxsgW/uyCU2T
SmrTsvka70aovp+8ixOOxWlUfZQ5rF/oBboCZ2DUTwJGIRtcdy1BP2WyP+lATRJ3
h8NP29gzo/V0ri1nDxX81N0qva+yMryRIkONE+mL956SCKhleXVtB+Qs4YFcbRfS
sDV5Jj+RP7+58G/SmcwupdZTdd0EQA==
=RQ+I
-----END PGP SIGNATURE-----

--SyeBRhgR6Wi7a7a7T18A7SOMgbULzN3PG--
