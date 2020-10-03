Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F55282302
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgJCJWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJCJWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:22:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56319C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:22:07 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601716925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mXxk5WHnGrHWAiSDsTW6zGF23LHkjoRTm7qeXAOtj+I=;
        b=q1eZJw+21NeXDRha8H1RaX2wht2nG6FZeRrMbwTLgQHyLzs0sLGTtjpLnE6Vt/dx3DT4dY
        QTPXe6ccKsRlYRnuBzQh/UgDW5RjPQ5MKTJvIG9cWhAcWNxAORo8ZkbEd+8NBV0fUoiuke
        q4/XuziW92Mt2RZbH4bTBBbViXBMNwhTgf2LBki9zdWtunPMibV55n3FC0VUChhCDClSP4
        l+PLNS7uqLXyQjceRDWdOMrnyrc8w9LpP46GYdHgrRirj6ThsEO1gABXR0dxoa+vgLmlb+
        l+96CQZpqdlAKucJzTjuICIqDKYxO4LngLcotGKGbXETeA6J1j/p9C5dUrPZCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601716925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mXxk5WHnGrHWAiSDsTW6zGF23LHkjoRTm7qeXAOtj+I=;
        b=YoSkq8bHs/9cMmtmVIS4w6I00WR6E6sQoY1F89Zr+fSY6aSd0x/JvGdDl8n3ezc4yfkx6c
        SLbcxNmKsG7h3YDw==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: b53: Add missing reg property to example
In-Reply-To: <8d1e1eed-6cc2-3a83-8f7e-71ec63ebe9fd@gmail.com>
References: <20201002062051.8551-1-kurt@linutronix.de> <8d1e1eed-6cc2-3a83-8f7e-71ec63ebe9fd@gmail.com>
Date:   Sat, 03 Oct 2020 11:21:52 +0200
Message-ID: <877ds78y1b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Oct 02 2020, Florian Fainelli wrote:
> On 10/1/2020 11:20 PM, Kurt Kanzenbach wrote:
>> The switch has a certain MDIO address and this needs to be specified usi=
ng the
>> reg property. Add it to the example.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>   Documentation/devicetree/bindings/net/dsa/b53.txt | 1 +
>>   1 file changed, 1 insertion(+)
>>=20
>> diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documen=
tation/devicetree/bindings/net/dsa/b53.txt
>> index cfd1afdc6e94..80437b2fc935 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/b53.txt
>> +++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
>> @@ -106,6 +106,7 @@ Ethernet switch connected via MDIO to the host, CPU =
port wired to eth0:
>>=20=20=20
>>   		switch0: ethernet-switch@30 {
>
> This should actually be 1e because the unit address is supposed to be in=
=20
> hexadecimal.

OK.

>
>>   			compatible =3D "brcm,bcm53125";
>> +			reg =3D <30>;
>
> however this one is correct, if you want to resend with the unit address=
=20
> fixed that would be fine, if not:

Just noticed another problem in the example: The fixed link is specified
with "duplex-full" instead of "full-duplex" leading to half speed. So, I'll
send another patch and fix the above along with it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl94QrAACgkQeSpbgcuY
8KakKw/8CDBExg54NVbIbHdolvEZjnvtTf1NCaipmk2hv+yGbYu10aK/VFE64ZRY
R69Nh+BiEdZQDH5P72wRMZgyjG804cfYlCLhPILemSZUUOWpY2DTEjLey+JuKYFi
XtTp6QTjiCFsdTCg0ktRUz9LBTZDYLE9VxCgUvaSVHUqj0ErCy1dVsAjW7XrJcY8
eoOcpdD/CvwSdleYsIBuk1hYeUoCmsk5bYoWW5+s+Tor48umfWW+JFGOm2qaXO6U
NedElIG6r8gkAP6IASu+GnCpOZB7UX/RMBNzOMe2frfZxmMiR+n4pExzOcFmqbnH
u4G2LMTk2hLIgOmP4eY3SIfxJo2HNM4ehoMQWmK6+awTL0g9y3jo47nKEvjyBO2h
EMZPq/OqWSR0HsiUC+u19H7Fyu75P7ciLPODKO/wc/OOQaNWVB9t/x7LDbAA0wdq
DyB4nWkBoawikpKvFzNJYiAES1/IU7BJLh9Y7xJmmEkr4FIYNe0QZCU0ngb0ea1O
W7CI1ctQApOvBPKSz7agXbMNsW7qbHMekN0EOLDIW+c2dGfOUrec0ZuYtGUSDcov
WTBDWGk9NzRYE8M9Pc6pI7wdXW0Td7vIHJvaLFc+P+5e7PE/iHZCemBVxS3DJ9sT
XYa2NO5EzIP4cmXHvz3cGvSs1EFKr87wcfoBN+KX95MCc6DlR5Y=
=EhKL
-----END PGP SIGNATURE-----
--=-=-=--
