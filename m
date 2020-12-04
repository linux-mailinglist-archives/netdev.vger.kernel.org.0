Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D100B2CEE6C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgLDMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgLDMyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:54:06 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96369C0613D1;
        Fri,  4 Dec 2020 04:53:26 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CnXgm0gFjzQlKv;
        Fri,  4 Dec 2020 13:53:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1607086402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BO7VfKCWGW08gqptjnC2mLYopzbWJ6BdgIeLCZkkrXQ=;
        b=CvJiKwR+NQcgFuHQxKETwOZLsHoOhksik7CcVo/B0yHIKKrlQ2ieCzmDWPiwDZiBWI1XU1
        EJpS/IluU29f2fxvE1wG9R1DTYqw7Gv8RiYW0TN8yK+y0WTJqiYqvcOO9OlTaX+VTj96j6
        XYUqkjofRhim7qElEcZew/dBb/oB+EyrU+SOOfkwDbYJOoCaw44QMWKwsURNS0N0Jua3sI
        vnVbeWPEtKuxy1pB5ynXKeXIZZvbv9pSPBqsLCxRmAeOVKLMIgiuyHTGuKFGsMJEI0C9UL
        y1R64PwDGvUX5Fu6QUqWvc2O4oHVy7uHTmBQzrlRUANaQO21lgLlRj0GFLhPCg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id Zi8zTU8vcc6q; Fri,  4 Dec 2020 13:53:20 +0100 (CET)
Subject: Re: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
To:     Andrew Lunn <andrew@lunn.ch>,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
References: <20201203220347.13691-1-olek2@wp.pl>
 <20201204014957.GB2414548@lunn.ch>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <905ee9b3-f84e-8af0-d50e-822166c0969e@hauke-m.de>
Date:   Fri, 4 Dec 2020 13:53:07 +0100
MIME-Version: 1.0
In-Reply-To: <20201204014957.GB2414548@lunn.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FqehhgEyt89ukMK1WBwN6pwbGJ9eg19SY"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.37 / 15.00 / 15.00
X-Rspamd-Queue-Id: F3EEC91E
X-Rspamd-UID: 6229a3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FqehhgEyt89ukMK1WBwN6pwbGJ9eg19SY
Content-Type: multipart/mixed; boundary="1NTyCNIrVpbpDNdzPKP5hDcI8CYC18zEC";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Andrew Lunn <andrew@lunn.ch>, Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
Message-ID: <905ee9b3-f84e-8af0-d50e-822166c0969e@hauke-m.de>
Subject: Re: [PATCH 1/2] net: dsa: lantiq: allow to use all GPHYs on xRX300
 and xRX330
References: <20201203220347.13691-1-olek2@wp.pl>
 <20201204014957.GB2414548@lunn.ch>
In-Reply-To: <20201204014957.GB2414548@lunn.ch>

--1NTyCNIrVpbpDNdzPKP5hDcI8CYC18zEC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/4/20 2:49 AM, Andrew Lunn wrote:
>>   static const struct of_device_id gswip_of_match[] =3D {
>>   	{ .compatible =3D "lantiq,xrx200-gswip", .data =3D &gswip_xrx200 },=

>> +	{ .compatible =3D "lantiq,xrx300-gswip", .data =3D &gswip_xrx300 },
>> +	{ .compatible =3D "lantiq,xrx330-gswip", .data =3D &gswip_xrx300 },
>>   	{},
>=20
> Is there an ID register which allows you to ask the silicon what it
> is?

Yes there is, see GSWIP_VERSION.

> It would be good to verify the compatible string against the hardware,
> if that is possible.
>=20
>     Andrew
>=20



--1NTyCNIrVpbpDNdzPKP5hDcI8CYC18zEC--

--FqehhgEyt89ukMK1WBwN6pwbGJ9eg19SY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl/KMTQACgkQ8bdnhZyy
68cQQQf+IiyFcabIdJO7RApnpRD46grc0ooClszZ+P8aSQcI6El7F7DRIqrI5/xE
dUdkYxO33VNiHfR1K2xXTGn9/lR58HL8eiA4MpJ9nKgmOgyTksUZkHcBYVj+WK5P
+YEpEmt3cH7eI8Iq+/9IhYIrzRXs4kGSvuGEYUNGxnEKJlDDc+DOHjg9MRFjUvBr
tE54v6m7dq6SM9hNZuRo5eyyRGs20bfVfMv4Qx9aWahRP2wNXY6DGQ5XJxBQvfKc
vsUI7yT3YUOS8hPswm77oQ5vUsiti1i2qcw3LcbInJa1oo5EROiVfj/8F1iHyO3N
+1isSxnvOOhKhpgl4plqPu/iSTb9Uw==
=2x8/
-----END PGP SIGNATURE-----

--FqehhgEyt89ukMK1WBwN6pwbGJ9eg19SY--
