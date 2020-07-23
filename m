Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484F722AC8B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgGWK2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 06:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgGWK2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 06:28:16 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E006C0619DC;
        Thu, 23 Jul 2020 03:28:15 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1595500089;
        bh=XdDUktoEq0eoVi26hnjEGapwmVbihkj7cNA+4Qqus0Y=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=mWJKlEHPj2yXrqA8z9F1/LuEeFUNkcAGoBvDadGIx5lznrkbwLbhtACQjsHl+HF2H
         92Q2SqkPr52qiiY5vxr0Lt9+x4eGg2pU6ajtxgXH1BEIton5Wj9VvJj7R9Asyujte6
         Qu1jkWuKa8f/WAecl3RtqZ5BfnzITVHbWCMag6mbdjSTfVJWc3SXB49Tw4TYNZqTWr
         AZIbdH/257+fFRrunwo2JNcL6Ok4v11VwumewBUUKxQz2Kgn3bHzmF1u1ulFaDav06
         /v5/Z1+ZjUfTmn5zqf6Z7Yo7zBquOb+eG7uEL9U60VvHa+8NSGy8dxT5Pu/wkXfLDy
         1WSeW1+uCR6ow==
Cc:     gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
References: <20200720160614.117090-1-richard_siegfried@systemli.org>
 <20200722.170112.664348766467297694.davem@davemloft.net>
From:   Richard Sailer <richard_siegfried@systemli.org>
Autocrypt: addr=richard_siegfried@systemli.org; prefer-encrypt=mutual;
 keydata=
 mQENBE3hr2UBCACos1E12camcYIlpe25jaqwu+ATrfuFcCIPsLmff7whzxClsaC78lsxQ3jD
 4MIlOpkIBWJvc4sziai1P/CrafvM0DTuUasCv+mQpup6cFMWy1JmDtJ8X0Ccy/PH83e9Yjnv
 xJu0NhoQAqMZrVmXx4Q7DKcgpvkk9Oyd5u6ocfdb2GhF0Bxa7GySZyYOc4rQvduRLOdNMbnS
 6SM+cTAhMOHtoqKWCP4EogXKALg6LDFcx8yUoMzLRy/YXsnWa1/WayG8Zr6kX84VKhTGUrdG
 Pw4Zg1cQ6vqwMZ4RwaR/9RWK2WnYr7XyOTDBgmCix5c5lu+GeLqUYUIPTvdQ7Xgwx0UhABEB
 AAG0OVJpY2hhcmQgU2llZ2ZyaWVkIFNhaWxlciA8cmljaGFyZF9zaWVnZnJpZWRAc3lzdGVt
 bGkub3JnPokBVwQTAQgAQQIbIwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAIZARYhBAYAIbmK
 zp5fVAuyN/ZBOcwFm+HhBQJanueLBQkSYNKmAAoJEPZBOcwFm+Hh+ugH/2P0yClrZkkMK5y2
 L389qNPlF8i1H77S4NE9zxiHI38jnIFLqjD4F+KzGAXNmOXCw+QYqLL+TmsuGY+5LOLtp/M4
 lG6ajVC1JCcF2+bQrDc11g7AG7A+rySX5JpqSFO7ARfLTs3iW1DoyLN7lBUtL9dV+yx9mRUv
 fx/TcB9ItPhK4rtJuWy3yg6SNBZzkgc0zsCyIkJ4dEtdEW6IgW6Qk242kMVya8fytM02EwEM
 vBTdca/duCO2tEComPeF+8WExM+BfQ+6o3kpqRsOR6Ek6wDsnalFHy8NHaicbEy7qjybGOKZ
 IdvzAyAhsmpu+5ltOfQWViNBseqRk1H9ikuTKTq5AQ0ETeGvZQEIANRmPSJX9qVU+Hi74uvD
 /LYC3wPm5kCAS0Q5jT3AC5cisu8z92b/Bt8DRKwwpu4esZisQu3RSFvnmkrllkuokSAVKxXo
 bZG2yTq+qecrvKtVH99lA0leiy5TdcJdmhJvkcQv7kvIgKYdXSW1BAhUbtX827IGAW1LCvJL
 gKqox3Ftxpi5pf/gVh7NFXU/7n6Nr3NGi5havoReeIy8iVKGFjyCFN67vlyzaTV6yTUIdrko
 StTJJ8c7ECjJSkCW34lj8mR0y9qCRK5gIZURf3jjMQBDuDvHO0XQ4mog6/oOov4vJRyNMhWT
 2b0LG5CFJeOQTQVgfaT1MckluRBvYMZAOmkAEQEAAYkBPAQYAQIAJgIbDBYhBAYAIbmKzp5f
 VAuyN/ZBOcwFm+HhBQJanueQBQkSYNKrAAoJEPZBOcwFm+HhrCAH/2doMkTKWrIzKmBidxOR
 +hvqJfBB4GvoHBsQoqWj85DtgvE5jKc11FYzSDzQjmMKIIBwaOjjrQ8QyXm2CYJlx7/GiEJc
 F3QNa5q3GBgiyZ0h78b2Lbu/sBhaCFSXHfnriRGvIXqsxyPMllqb+LBRy56ed97OQBQX8nFI
 umdUMtt8EFK2SM0KYY1V0COcYqGHMRUiVosTV1aVwoLm2SXsB9jicPUaQbRgsPfglTn00wnl
 fhJ8bAO800MtG+LW6pzP+6EZPvnHhKBS7Xbl6bn6r2OW32T7TeFg0RJbpE/MW1gY0NjgmtWj
 vdhuvK9nHCRL2O/xLofm9aoELUaXGHoxMn4=
Subject: Re: [PATCH net-next v5] net: dccp: Add SIOCOUTQ IOCTL support (send
 buffer fill)
Message-ID: <be70bbe3-4a8e-8a17-e808-1e1e668e3318@systemli.org>
Date:   Thu, 23 Jul 2020 12:28:08 +0200
MIME-Version: 1.0
In-Reply-To: <20200722.170112.664348766467297694.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="dZArhhPJOWWJ2NbiOMlJSpA9vDrVBNXJr"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dZArhhPJOWWJ2NbiOMlJSpA9vDrVBNXJr
Content-Type: multipart/mixed; boundary="45hY1hWy9uB2bEIuP8oW0BTiuWwSgICEd";
 protected-headers="v1"
From: Richard Sailer <richard_siegfried@systemli.org>
To: David Miller <davem@davemloft.net>
Cc: gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <be70bbe3-4a8e-8a17-e808-1e1e668e3318@systemli.org>
Subject: Re: [PATCH net-next v5] net: dccp: Add SIOCOUTQ IOCTL support (send
 buffer fill)
References: <20200720160614.117090-1-richard_siegfried@systemli.org>
 <20200722.170112.664348766467297694.davem@davemloft.net>
In-Reply-To: <20200722.170112.664348766467297694.davem@davemloft.net>

--45hY1hWy9uB2bEIuP8oW0BTiuWwSgICEd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


>=20
> Applied, but I wonder if you'll also need something like tcp's SIOCOUTQ=
NSD?
>=20
A good question. SIOCOUTQNSD is not mentioned in man 7 tcp and I didn't
know and consider it. Now that I looked it up (bytes of unsent packets
in send buffer) maybe this patch's ioctl should be renamed SIOCOUTQNSD,
since it returns the byte count of unsent packets.

I'm undecided here, this is also the only of these ioctl's that makes
sense for DCCP since DCCP does not keep sent but un-acked packets so
SIOCOUTQ does not exist for DCCP. Or SIOCOUTQ and SIOCOUTQNSD are the
same for DCCP, that's a viewpoint question. And it's anyhow correctly
documented in dccp.rst, it's about unsent packets.

So I'm undecided here, should I resend my patch renamed to SIOCOUTQNSD?

-- Richard


--45hY1hWy9uB2bEIuP8oW0BTiuWwSgICEd--

--dZArhhPJOWWJ2NbiOMlJSpA9vDrVBNXJr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBgAhuYrOnl9UC7I39kE5zAWb4eEFAl8ZZjgACgkQ9kE5zAWb
4eE7Xwf/e1lQO8XLn845lLFjA7Wm3W+kC+oAWSlNrO6jL4RZDsGW/C9tbIYnxIle
GSV1Lky4PzNiJD1pKaBJyA1XtkGEE5yZZ20wcVG1K5wuO0S0weAlhiR/JFc9kaDj
e/ycFkSQFtLzE0aAe8WmAHts53o6XwohZBEGV2Y8obruwANRbV0wSq5eeaLiKjSj
gGkYl7L7gnuwr2Kqv+4tWE56RlgzKv39EoT/AojJSrgAWCWolpi45MyJzABu98Hs
C2tQzn8F7+ilnTF/JZrT4fs8mHYqrnnnkxqYAzKD6MNcufnewFVXmy69YlJk/jp5
tSg7sC5upiCdHYZ/a2E7dW/8+n/chg==
=hdou
-----END PGP SIGNATURE-----

--dZArhhPJOWWJ2NbiOMlJSpA9vDrVBNXJr--
