Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44A20044F
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgFSIsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFSIse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:48:34 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00699C06174E;
        Fri, 19 Jun 2020 01:48:33 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmChM-0004dK-0I; Fri, 19 Jun 2020 10:48:32 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for Hellcreek switches
In-Reply-To: <e8085c6a-0b61-60f9-f411-2540dec80926@gmail.com>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-10-kurt@linutronix.de> <e8085c6a-0b61-60f9-f411-2540dec80926@gmail.com>
Date:   Fri, 19 Jun 2020 10:48:31 +0200
Message-ID: <87wo43phk0.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Thu Jun 18 2020, Florian Fainelli wrote:
> On 6/17/2020 11:40 PM, Kurt Kanzenbach wrote:
>> Add basic documentation and example.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  .../devicetree/bindings/net/dsa/hellcreek.txt | 72 +++++++++++++++++++
>>  1 file changed, 72 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.=
txt
>>=20
>> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.txt b/D=
ocumentation/devicetree/bindings/net/dsa/hellcreek.txt
>> new file mode 100644
>> index 000000000000..9ea6494dc554
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt
>
> This should be a YAML binding and we should also convert the DSA binding
> to YAML one day.

OK.

>
>> @@ -0,0 +1,72 @@
>> +Hirschmann hellcreek switch driver
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Required properties:
>> +
>> +- compatible:
>> +	Must be one of:
>> +	- "hirschmann,hellcreek"
>> +
>> +See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of s=
tandard
>> +DSA required and optional properties.
>> +
>> +Example
>> +-------
>> +
>> +Ethernet switch connected memory mapped to the host, CPU port wired to =
gmac0:
>> +
>> +soc {
>> +        switch0: switch@0xff240000 {
>
> Please remove the leading 0x from the unit address.

Sure.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7se98ACgkQeSpbgcuY
8KZihxAAtHIIeyTkZwx0/as7qVqW1wxxU3ChFFfTerlQKv/oj7YsPZygmcF2JQ3F
7EyOOQRfDCMtViZtrFnr+aOFpt0qtAWI5Qm1brhtSpc6CShIT4bYOKRurGj0cgD5
S6VD6YLSlQAtekxieQGHXYgbwhPeVuOAYiNTJtRd7aZUrlPjvCDNoCWbYMSR2CdU
MVRu1wWh/IyTfwx43XnRoEWQv24rZIkpJ2ZfA3UDeTZadE6lQlg54ixDjT0pfKZG
62YG8vITGVNWnQtU4RoBsRWvj5ZD9yGe+wjVAnI18V6vEdStIY6qSXUCI6qv0lPk
GL+jJF52Q2R7VXJbrt9nZxaKNUYGM6xmSTmm8opGpst9HrwVWQkjJ4K0CD90EPe6
Szgr6gC6WNB99O8XtZ2m9gW3FSHweEKDm8vpPehb1WvmiEq3x+8UQJpaWh44I9Az
RhCi8nnQ7Y0OY3DPO7HJCjMPJ6ILTF2pKNbx0q8RodrlXR++X658gC6HZrquJ/Rr
UaKnr1sXkpnwj5SJqLqMkFjtWfSSOMMmh7P8mizp28yy+ggVQGJbgAt/yCJ1Gu9W
+EbrliE8grwOv2oKDXLirC5P6UV/sZLHRypniKsofJ+nm91ovLET9beIw8dBY3N9
RU6IghxrTiey8rgKJsSaYdbNBnXXRcHJV6MIG5c4573RczcA9UM=
=bP+p
-----END PGP SIGNATURE-----
--=-=-=--
