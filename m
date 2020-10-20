Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F2C29397E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392381AbgJTK7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390480AbgJTK7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:59:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1BFC0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 03:59:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kUpMY-00034O-TE; Tue, 20 Oct 2020 12:59:31 +0200
Received: from [IPv6:2a03:f580:87bc:d400:c351:f59d:74d9:d207] (unknown [IPv6:2a03:f580:87bc:d400:c351:f59d:74d9:d207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D031257E169;
        Tue, 20 Oct 2020 10:59:29 +0000 (UTC)
To:     yegorslists@googlemail.com, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <20201020101043.6369-1-yegorslists@googlemail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH] can: j1939: fix syntax and spelling
Message-ID: <3e015bbe-0e00-c53f-5103-594a8922476c@pengutronix.de>
Date:   Tue, 20 Oct 2020 12:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201020101043.6369-1-yegorslists@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="dGKhFvo7cDX8k10bjtCqaoXYwdzu7LaMe"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dGKhFvo7cDX8k10bjtCqaoXYwdzu7LaMe
Content-Type: multipart/mixed; boundary="kr33aiIfc3OFxAc5F8PjRaHs5X6uiUrGG";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: yegorslists@googlemail.com, linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Message-ID: <3e015bbe-0e00-c53f-5103-594a8922476c@pengutronix.de>
Subject: Re: [PATCH] can: j1939: fix syntax and spelling
References: <20201020101043.6369-1-yegorslists@googlemail.com>
In-Reply-To: <20201020101043.6369-1-yegorslists@googlemail.com>

--kr33aiIfc3OFxAc5F8PjRaHs5X6uiUrGG
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/20/20 12:10 PM, yegorslists@googlemail.com wrote:
> From: Yegor Yefremov <yegorslists@googlemail.com>
>=20
> Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> ---
>  Documentation/networking/j1939.rst | 34 +++++++++++++++---------------=

>  1 file changed, 17 insertions(+), 17 deletions(-)
>=20
> diff --git a/Documentation/networking/j1939.rst b/Documentation/network=
ing/j1939.rst
> index 65b12abcc90a..8b3f4fbc3bbb 100644
> --- a/Documentation/networking/j1939.rst
> +++ b/Documentation/networking/j1939.rst
> @@ -10,9 +10,9 @@ Overview / What Is J1939
>  SAE J1939 defines a higher layer protocol on CAN. It implements a more=

>  sophisticated addressing scheme and extends the maximum packet size ab=
ove 8
>  bytes. Several derived specifications exist, which differ from the ori=
ginal
> -J1939 on the application level, like MilCAN A, NMEA2000 and especially=

> +J1939 on the application level, like MilCAN A, NMEA2000, and especiall=
y
>  ISO-11783 (ISOBUS). This last one specifies the so-called ETP (Extende=
d
> -Transport Protocol) which is has been included in this implementation.=
 This
> +Transport Protocol) which, has been included in this implementation. T=
his
                           ^^^
A comma before which, not after?

>  results in a maximum packet size of ((2 ^ 24) - 1) * 7 bytes =3D=3D 11=
1 MiB.
> =20
>  Specifications used
> @@ -32,15 +32,15 @@ sockets, we found some reasons to justify a kernel =
implementation for the
>  addressing and transport methods used by J1939.
> =20
>  * **Addressing:** when a process on an ECU communicates via J1939, it =
should
> -  not necessarily know its source address. Although at least one proce=
ss per
> +  not necessarily know its source address. Although, at least one proc=
ess per
>    ECU should know the source address. Other processes should be able t=
o reuse
>    that address. This way, address parameters for different processes
>    cooperating for the same ECU, are not duplicated. This way of workin=
g is
> -  closely related to the UNIX concept where programs do just one thing=
, and do
> +  closely related to the UNIX concept, where programs do just one thin=
g and do
>    it well.
> =20
>  * **Dynamic addressing:** Address Claiming in J1939 is time critical.
> -  Furthermore data transport should be handled properly during the add=
ress
> +  Furthermore, data transport should be handled properly during the ad=
dress
>    negotiation. Putting this functionality in the kernel eliminates it =
as a
>    requirement for _every_ user space process that communicates via J19=
39. This
>    results in a consistent J1939 bus with proper addressing.
> @@ -58,10 +58,10 @@ Therefore, these parts are left to user space.
> =20
>  The J1939 sockets operate on CAN network devices (see SocketCAN). Any =
J1939
>  user space library operating on CAN raw sockets will still operate pro=
perly.
> -Since such library does not communicate with the in-kernel implementat=
ion, care
> -must be taken that these two do not interfere. In practice, this means=
 they
> -cannot share ECU addresses. A single ECU (or virtual ECU) address is u=
sed by
> -the library exclusively, or by the in-kernel system exclusively.
> +Since such a library does not communicate with the in-kernel implement=
ation,
> +care must be taken that these two do not interfere. In practice, this =
means
> +they cannot share ECU addresses. A single ECU (or virtual ECU) address=
 is
> +used by the library exclusively, or by the in-kernel system exclusivel=
y.

I've kept the line endings as as, to the a better readable diff.

> =20
>  J1939 concepts
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> @@ -77,13 +77,13 @@ is composed as follows:
>  8 bits : PS (PDU Specific)
> =20
>  In J1939-21 distinction is made between PDU1 format (where PF < 240) a=
nd PDU2
> -format (where PF >=3D 240). Furthermore, when using PDU2 format, the P=
S-field
> +format (where PF >=3D 240). Furthermore, when using the PDU2 format, t=
he PS-field
>  contains a so-called Group Extension, which is part of the PGN. When u=
sing PDU2
>  format, the Group Extension is set in the PS-field.
> =20
>  On the other hand, when using PDU1 format, the PS-field contains a so-=
called
>  Destination Address, which is _not_ part of the PGN. When communicatin=
g a PGN
> -from user space to kernel (or visa versa) and PDU2 format is used, the=
 PS-field
> +from user space to kernel (or vice versa) and PDU2 format is used, the=
 PS-field
>  of the PGN shall be set to zero. The Destination Address shall be set
>  elsewhere.
> =20
> @@ -96,15 +96,15 @@ Addressing
> =20
>  Both static and dynamic addressing methods can be used.
> =20
> -For static addresses, no extra checks are made by the kernel, and prov=
ided
> +For static addresses, no extra checks are made by the kernel and provi=
ded
>  addresses are considered right. This responsibility is for the OEM or =
system
>  integrator.
> =20
>  For dynamic addressing, so-called Address Claiming, extra support is f=
oreseen
> -in the kernel. In J1939 any ECU is known by it's 64-bit NAME. At the m=
oment of
> +in the kernel. In J1939 any ECU is known by its 64-bit NAME. At the mo=
ment of
>  a successful address claim, the kernel keeps track of both NAME and so=
urce
>  address being claimed. This serves as a base for filter schemes. By de=
fault,
> -packets with a destination that is not locally, will be rejected.
> +packets with a destination that is not locally will be rejected.
> =20
>  Mixed mode packets (from a static to a dynamic address or vice versa) =
are
>  allowed. The BSD sockets define separate API calls for getting/setting=
 the
> @@ -153,8 +153,8 @@ described below.
>  In order to send data, a bind(2) must have been successful. bind(2) as=
signs a
>  local address to a socket.
> =20
> -Different from CAN is that the payload data is just the data that get =
send,
> -without it's header info. The header info is derived from the sockaddr=
 supplied
> +Different from CAN is that the payload data is just the data that get =
sends,

=2E..that gets send...

> +without its header info. The header info is derived from the sockaddr =
supplied
>  to bind(2), connect(2), sendto(2) and recvfrom(2). A write(2) with siz=
e 4 will
>  result in a packet with 4 bytes.
> =20
> @@ -191,7 +191,7 @@ can_addr.j1939.addr contains the address.
> =20
>  The bind(2) system call assigns the local address, i.e. the source add=
ress when
>  sending packages. If a PGN during bind(2) is set, it's used as a RX fi=
lter.
> -I.e.  only packets with a matching PGN are received. If an ADDR or NAM=
E is set
> +I.e. only packets with a matching PGN are received. If an ADDR or NAME=
 is set
>  it is used as a receive filter, too. It will match the destination NAM=
E or ADDR
>  of the incoming packet. The NAME filter will work only if appropriate =
Address
>  Claiming for this name was done on the CAN bus and registered/cached b=
y the
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--kr33aiIfc3OFxAc5F8PjRaHs5X6uiUrGG--

--dGKhFvo7cDX8k10bjtCqaoXYwdzu7LaMe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+OwwwACgkQqclaivrt
76lkKAf/XIbPWVKmBSf1Q4DeIJqWknIV5f65+2xoEXhh1Y4kmVyYrjCeUSg26uf3
sij1SKDH5CYMp2Jj94DzHWhmod13YliDU8PDZLMteSFGLMgmzA5LGPx4tYMBLcbZ
GLdzAOCSYuE5WBtsulUNjWLcfBvwZSL2bu/zMZ6lpQE73Tm216fMq/j0leBeV7+W
bUqVnUKd19qtJyCqHTYX83H2TIYhoEQ+h3FQcGS890t1ZR2gkLn36/qAmWjxv8Sk
N0ekdL1/YTtb4xcG+ll2DCGdmVzQU5tI1+IPSfaxQ+xDTkv77atGmX297jI0oN9r
zSRPCI7EBZCsZfUnHKsAQW6ZVcd/Xw==
=aQZp
-----END PGP SIGNATURE-----

--dGKhFvo7cDX8k10bjtCqaoXYwdzu7LaMe--
