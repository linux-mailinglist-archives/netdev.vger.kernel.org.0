Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC1223023
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGQA5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgGQA5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 20:57:14 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DE8C061755;
        Thu, 16 Jul 2020 17:57:14 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1594947425;
        bh=1+qQAd5vXtgxBAMVEs9m5q9rlmBN1vD54J71OpLPTKE=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=sXDuvDctnaq9FBQl18D8vZGkAkcsP9+pmninar20/miTlUqx4J7jjiAqOjKmRaaH3
         or7OUYHmScH9PH9m9yr9a+b/UsoVLZEjgA73IG39mR+CXbHHIFYBbe+DBa6JhD3iYw
         3vrAEb6ev6rCixOnP4dPU1Vc3/dcirWE2GT1M6yhp2Yks/lvV2HMW0qiIeez70xg4K
         sdI8bPowbXRDQTDAX9n2ogS6eR0laS4ervTYK2W/s5IJ5EpBVvKhJXbtJnNFBM6eqU
         FR5fNCLFkqH1weDL/Ho0+uePAzVeLng7pIRwJP/Gy/rNXjGQDPqPyQxEY+Lg160UA5
         f7e97dEfKG+IQ==
Cc:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200712225520.269542-1-richard_siegfried@systemli.org>
 <20200716125608.33a0589b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Subject: Re: [PATCH net-next v4] net: dccp: Add SIOCOUTQ IOCTL support (send
 buffer fill)
Message-ID: <a0b896e3-e422-4901-bfba-8634c0fe6f5e@systemli.org>
Date:   Fri, 17 Jul 2020 02:56:59 +0200
MIME-Version: 1.0
In-Reply-To: <20200716125608.33a0589b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="iwNExoDH9BubZexnCqmw2B1b8dd8T0v3w"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iwNExoDH9BubZexnCqmw2B1b8dd8T0v3w
Content-Type: multipart/mixed; boundary="tw1Sih1WHter9AROfY8v0CNwvu19ynKkd";
 protected-headers="v1"
From: Richard Sailer <richard_siegfried@systemli.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: gerrit@erg.abdn.ac.uk, davem@davemloft.net, dccp@vger.kernel.org,
 netdev@vger.kernel.org
Message-ID: <a0b896e3-e422-4901-bfba-8634c0fe6f5e@systemli.org>
Subject: Re: [PATCH net-next v4] net: dccp: Add SIOCOUTQ IOCTL support (send
 buffer fill)
References: <20200712225520.269542-1-richard_siegfried@systemli.org>
 <20200716125608.33a0589b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716125608.33a0589b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

--tw1Sih1WHter9AROfY8v0CNwvu19ynKkd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 16/07/2020 21:56, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 00:55:20 +0200 Richard Sailer wrote:
>> This adds support for the SIOCOUTQ IOCTL to get the send buffer fill
>> of a DCCP socket, like UDP and TCP sockets already have.
>>
>> Regarding the used data field: DCCP uses per packet sequence numbers,
>> not per byte, so sequence numbers can't be used like in TCP. sk_wmem_q=
ueued
>> is not used by DCCP and always 0, even in test on highly congested pat=
hs.
>> Therefore this uses sk_wmem_alloc like in UDP.
>>
>> Signed-off-by: Richard Sailer <richard_siegfried@systemli.org>
>=20
> Sorry for the late review
No problem, nothing compared to the information delays at university^^

>=20
>> diff --git a/Documentation/networking/dccp.rst b/Documentation/network=
ing/dccp.rst
>> index dde16be044562..74659da107f6b 100644
>> --- a/Documentation/networking/dccp.rst
>> +++ b/Documentation/networking/dccp.rst
>> @@ -192,6 +192,8 @@ FIONREAD
>>  	Works as in udp(7): returns in the ``int`` argument pointer the size=
 of
>>  	the next pending datagram in bytes, or 0 when no datagram is pending=
=2E
>> =20
>> +SIOCOUTQ
>> +  Returns the number of data bytes in the local send queue.
>=20
> FIONREAD uses tabs for indentation, it seems like a good idea to
> document the size of the argument (i.e. "returns in the ``int`` ...").

Agreed
>=20
>>  Other tunables
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
>> index c13b6609474b6..dab74e8a8a69b 100644
>> --- a/net/dccp/proto.c
>> +++ b/net/dccp/proto.c
>> @@ -375,6 +375,14 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned=
 long arg)
>>  		goto out;
>> =20
>>  	switch (cmd) {
>> +	case SIOCOUTQ: {
>> +		/* Using sk_wmem_alloc here because sk_wmem_queued is not used by D=
CCP and
>> +		 * always 0, comparably to UDP.
>> +		 */
>> +		int amount =3D sk_wmem_alloc_get(sk);
>> +		rc =3D put_user(amount, (int __user *)arg);
>=20
> checkpatch warns:
>=20
> WARNING: Missing a blank line after declarations
> #48: FILE: net/dccp/proto.c:383:
> +		int amount =3D sk_wmem_alloc_get(sk);
> +		rc =3D put_user(amount, (int __user *)arg);
>=20
> Could you please address that, and better still move the declaration of=

> "int amount" up to the function level and avoid the funky bracket aroun=
d
> the case statement altogether?

I found the funky braces disturbing too, but thought they were
convention, so happy to delete them.

Regarding "putting int amount at function level": well the problem is in
the other case statement is a unsigned long (and the pointer in
put_user() is (int __user *) ). I don't yet know if I can make that all
a simple int without losing correctness/security. I will send a v5 when
I figured that out.

Thanks,
-- Richard


--tw1Sih1WHter9AROfY8v0CNwvu19ynKkd--

--iwNExoDH9BubZexnCqmw2B1b8dd8T0v3w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBgAhuYrOnl9UC7I39kE5zAWb4eEFAl8Q91sACgkQ9kE5zAWb
4eGCSwgAnCO+7iLPMRj1aJsj/wQPjZiBQVNW0Jn7RfWiLeaDre8cAdZVSbwGnGw9
+elrnxBq2BMJCHlYiop/YyAMGKQVNIdLyp2qhJpgu4O5yNlUi5aKt3WE1HXvpsA5
jJeYFt8Gs6MCx3vgJ4COVZbmjdAuxD342okaFCRholRJGiMMLtoW8a4+YoDKcqmt
NyH6qNll4w9D+mT6/2ZlvgeuYrJPtv10gXhx3Q+LM55y+T6kFFDDJoS+67CfrNHv
w7CzcBJDvFlweKin9elCytRD4Gn2b6JFJUZLbWEUwXGxGoCo01C61yyV6zZh14qc
yAfhAQWPRLKLDezvJa+AIs5o7wM/ag==
=KCXz
-----END PGP SIGNATURE-----

--iwNExoDH9BubZexnCqmw2B1b8dd8T0v3w--
