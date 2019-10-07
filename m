Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33639CE0C6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfJGLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:45:39 -0400
Received: from intcom-lb2.vshosting.cz ([78.24.10.182]:49712 "EHLO
        intcom.vshosting.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbfJGLpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:45:39 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 07:45:36 EDT
Received: from [IPv6:2a00:1ed0:3c::a0a0] (ondrej.vshosting.cz [IPv6:2a00:1ed0:3c::a0a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by intcom.vshosting.cz (Postfix) with ESMTPSA id D30951BE97
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 13:39:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=vshosting.cz; s=mail;
        t=1570448355; bh=7Ayzv13kQdMXOcET/YCGTRVlrg1SrUPnC0TEvtYq+E4=;
        h=To:From:Subject:Date;
        b=h32n3XYzKKoUjIhOsncNThbbS2tS1R8Q3mHDKu9k6v+2ISH8DDpU5u9Tikwrj3+Bi
         bK9GKPq3ncFzQec3JCVnHx4nXwVMWginYdTUjaq9mmMEPydGGjKwJHl6f+UKHw5HK0
         eaTKrbMl1pw8aQi/qBkiL6l15wFHIirtp6NWHE+U=
To:     netdev@vger.kernel.org
From:   =?UTF-8?B?T25kxZllaiBGbMOtZHI=?= <flidr@vshosting.cz>
Openpgp: id=E9F29DC8FCF042C7E2BBF5AC181C57851A343EC3
Autocrypt: addr=flidr@vshosting.cz; prefer-encrypt=mutual; keydata=
 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
Subject: ip doesn't handle vxlan id and group correctly
Message-ID: <6761460a-6cd7-ec86-da72-db1efb4a0dd9@vshosting.cz>
Date:   Mon, 7 Oct 2019 13:39:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="FKdM5nHG7vzpnFCV2y7ZfBzedBzZV9AvS"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FKdM5nHG7vzpnFCV2y7ZfBzedBzZV9AvS
Content-Type: multipart/mixed; boundary="1ouE2PYIQDAcTf1BvcPlswymw9OGGmLRt";
 protected-headers="v1"
From: =?UTF-8?B?T25kxZllaiBGbMOtZHI=?= <flidr@vshosting.cz>
To: netdev@vger.kernel.org
Message-ID: <6761460a-6cd7-ec86-da72-db1efb4a0dd9@vshosting.cz>
Subject: ip doesn't handle vxlan id and group correctly

--1ouE2PYIQDAcTf1BvcPlswymw9OGGmLRt
Content-Type: multipart/mixed;
 boundary="------------E0F9EE58B921170B074A3063"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------E0F9EE58B921170B074A3063
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

it seems that ip doesn't handle combination of vxlan id and group
correctly. As you can see in attached script, I'm trying to create
multiple vxlans all with different combination of group and vxlan id. I
can create vxlans with different ids in same group, different ids in
different groups but I cannot create vxlan with same id in different
group, creation ends with "Error: A VXLAN device with the specified VNI
already exists.". Tested on current version 5.3.0 on arch linux.

Best regards,

Ondrej Flidr



--------------E0F9EE58B921170B074A3063
Content-Type: application/x-shellscript;
 name="vxlantest.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="vxlantest.sh"

IyEvYmluL2Jhc2gKZWNobyAidnhsYW4gMTAxIC0gZ3JvdXAgMTAsIGlkIDEwMSIKaXAgbGlu
ayBhZGQgdnhsYW4xMDEgdHlwZSB2eGxhbiBpZCAxMDEgZ3JvdXAgMjM5LjAuMy4xMCBkc3Rw
b3J0IDg0NzIgcG9ydCAzMjc2OCA2MTAwMCBkZXYgYm9uZDAKc2xlZXAgNQplY2hvICJ2eGxh
biAxMDIgLSBncm91cCAxMCwgaWQgMTAyIgppcCBsaW5rIGFkZCB2eGxhbjEwMiB0eXBlIHZ4
bGFuIGlkIDEwMiBncm91cCAyMzkuMC4zLjEwIGRzdHBvcnQgODQ3MiBwb3J0IDMyNzY4IDYx
MDAwIGRldiBib25kMApzbGVlcCA1CmVjaG8gInZ4bGFuIDIwMSAtIGdyb3VwIDIwLCBpZCAx
MDEiCmlwIGxpbmsgYWRkIHZ4bGFuMjAxIHR5cGUgdnhsYW4gaWQgMTAxIGdyb3VwIDIzOS4w
LjMuMjAgZHN0cG9ydCA4NDcyIHBvcnQgMzI3NjggNjEwMDAgZGV2IGJvbmQwCgo=
--------------E0F9EE58B921170B074A3063--

--1ouE2PYIQDAcTf1BvcPlswymw9OGGmLRt--

--FKdM5nHG7vzpnFCV2y7ZfBzedBzZV9AvS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElpotYuOkmArrR2AdI6hSVyqnLLgFAl2bI90ACgkQI6hSVyqn
LLitNg/+IJcZsZPc5NshEgZOqbvvEGMosNpTi1wq4qclZKdevODzw3bW1aR95NmF
iYg/wJLiImF5tc8RgOxqxVHXktNHTGaxkjfNKP75A5YiracgoKt8JnKNdqFBcxay
TWLeno1CQBjcC9OotWDBETFpJ+FHodi7FPGI1t7BwEaC62I8usr+GnQlkKcdw5CT
hPyc9XPkVLSxK7hnu4q2PmEKp+BJVcrDypuEDHh/UhjajQBT7V38V1QGsaE8OeXV
X0ow3b31XVY5DpkaWTY7pZJU/kwpJ4aQ09PmQkexvMy9fXUrageXCynYESGUXDs1
TM7dxy1z3fcL24kq38mmk+4MDo/kOWDaY6djqduT1iwEwk1p+DuBM0CULdx8TX39
Vd50uD2iJT+6S9+BQNnF68CetjnSuwwiWc4PKZCgLx6+H/CkKJ7l5m4dVtHbiroc
baf46lwrHRyO44OClGRYU/buuJSehuaNLs0BU0EsdY1Gc5JWoXnkd80unF792Qx8
IPzX3r/WWskRKIenIXlXvxC0B7kvipjmSmXB4Uj58ZrB7XIJRLGvXOJVVbgrBySg
2GFRoHbhp5s3xY+Xx+HtyUnjjVp+MzDXCyS5ZY++7hNNRIHyKrejNv1Q591WWU+8
NCnhl4GkRIKNcg9BLV1GkMI6y9+rUNRnnAXOC03ARXG/I0NSOPc=
=M32p
-----END PGP SIGNATURE-----

--FKdM5nHG7vzpnFCV2y7ZfBzedBzZV9AvS--
