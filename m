Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5981F94
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfHEOyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:54:49 -0400
Received: from comms.puri.sm ([159.203.221.185]:41494 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfHEOyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:54:49 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2019 10:54:48 EDT
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D2931DF2AE;
        Mon,  5 Aug 2019 07:44:47 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wV_usbgEvWOB; Mon,  5 Aug 2019 07:44:47 -0700 (PDT)
Subject: Re: [PATCH 1/2] usb: serial: option: Add the BroadMobi BM818 card
To:     Johan Hovold <johan@kernel.org>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>
Cc:     kernel@puri.sm, =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190724145227.27169-1-angus@akkea.ca>
 <20190724145227.27169-2-angus@akkea.ca> <20190805114711.GF3574@localhost>
From:   Bob Ham <bob.ham@puri.sm>
Openpgp: preference=signencrypt
Autocrypt: addr=bob.ham@puri.sm; prefer-encrypt=mutual; keydata=
 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
Message-ID: <5fb96703-b174-eef1-5ad1-693e2bbce32f@puri.sm>
Date:   Mon, 5 Aug 2019 15:44:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
In-Reply-To: <20190805114711.GF3574@localhost>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aav2uDAIncbcoCkDxgmyhfPjctRCwvqu0"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aav2uDAIncbcoCkDxgmyhfPjctRCwvqu0
Content-Type: multipart/mixed; boundary="ePV71vOs0eSjkvx3iXjEuaaJV4NUkQxra";
 protected-headers="v1"
From: Bob Ham <bob.ham@puri.sm>
To: Johan Hovold <johan@kernel.org>, "Angus Ainslie (Purism)" <angus@akkea.ca>
Cc: kernel@puri.sm, =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5fb96703-b174-eef1-5ad1-693e2bbce32f@puri.sm>
Subject: Re: [PATCH 1/2] usb: serial: option: Add the BroadMobi BM818 card
References: <20190724145227.27169-1-angus@akkea.ca>
 <20190724145227.27169-2-angus@akkea.ca> <20190805114711.GF3574@localhost>
In-Reply-To: <20190805114711.GF3574@localhost>

--ePV71vOs0eSjkvx3iXjEuaaJV4NUkQxra
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 05/08/2019 12:47, Johan Hovold wrote:
> On Wed, Jul 24, 2019 at 07:52:26AM -0700, Angus Ainslie (Purism) wrote:=

>> From: Bob Ham <bob.ham@puri.sm>
>>
>> Add a VID:PID for the BroadModi BM818 M.2 card
>=20
> Would you mind posting the output of usb-devices (or lsusb -v) for this=

> device?

T:  Bus=3D01 Lev=3D03 Prnt=3D40 Port=3D03 Cnt=3D01 Dev#=3D 44 Spd=3D480 M=
xCh=3D 0
D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
P:  Vendor=3D2020 ProdID=3D2060 Rev=3D00.00
S:  Manufacturer=3DQualcomm, Incorporated
S:  Product=3DQualcomm CDMA Technologies MSM
C:  #Ifs=3D 5 Cfg#=3D 1 Atr=3De0 MxPwr=3D500mA
I:  If#=3D0x0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
I:  If#=3D0x1 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
I:  If#=3D0x3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dfe Prot=3Dff Drive=
r=3D(none)
I:  If#=3D0x4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)


--ePV71vOs0eSjkvx3iXjEuaaJV4NUkQxra--

--aav2uDAIncbcoCkDxgmyhfPjctRCwvqu0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE745irA8zXATsZwYpUxfwLpX1YkEFAl1IQNoACgkQUxfwLpX1
YkGLrw/8DdFrRqq2wSac4phcOPiDz/8DzQFDAn5BzUs9TfKiecHDJdycv0bFCjwY
aIRF/z+i8ltLnCdO3KMSqwTgqit8npZC+DLWNrY4wBAVc2EsfSi/aQeFgUjr5kMB
Z3y9IpfAn2dU16xg6+9XLBlHBj4qmpxtn7hnlPJOCJixcRaDoxrQ929kyfeDn2sr
ntltidTZ/jF7/tkrZ1IPDFOz2ahscYh7kMos9x1NPizRlWWWiOLGRihyQDANbfpt
VzScmlv/FjXuFDOjIhKlocimDccUYMAniPYfcQ9mL78GAfJKmAo0/MKsBWxNWih/
Sef1FKCihiBsHbcVGcUMoSkDoVh3J9PYo2hL3y8SQouQoJtZ5FI+0OlUgsF78nTs
8gJn6rvGIrb4l9FYX4fC3aP4QenyWj5TF4KNLEjxn0tHa6QPGds8Mbyl0RDB553l
kdC5fAeuJszZFm+mAcijb+bR+fQ6eVu25tcuOjk97EueQabveLpDbSf/fMD8xzSo
ejdFDydKqxZfeWbYRgKEAgnBufI/GfQLeI+NZN3An0C2pITt515he7o6ekUfaFeu
6jLKaGWsH97zWmRs6n36TGsZrLrA/6eloib2J7Y+r+3aBZnY9eCJs0/DXTJ6J+PC
6TylwPkZh3N7fINfKgtVt261Ga0vN8r2Q5T+8PNBamJCT2aDBrw=
=oTTh
-----END PGP SIGNATURE-----

--aav2uDAIncbcoCkDxgmyhfPjctRCwvqu0--
