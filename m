Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF45220498C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgFWGJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgFWGJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:09:26 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F97C061573;
        Mon, 22 Jun 2020 23:09:26 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnc7Y-0001vL-Gb; Tue, 23 Jun 2020 08:09:24 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for Hellcreek switches
In-Reply-To: <20200622134946.GM338481@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-10-kurt@linutronix.de> <20200618134704.GQ249144@lunn.ch> <87zh8zphlc.fsf@kurt> <20200619135657.GF304147@lunn.ch> <87imfjtik4.fsf@kurt> <20200622134946.GM338481@lunn.ch>
Date:   Tue, 23 Jun 2020 08:09:18 +0200
Message-ID: <87eeq6nwj5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Jun 22 2020, Andrew Lunn wrote:
> On Mon, Jun 22, 2020 at 02:02:19PM +0200, Kurt Kanzenbach wrote:
>> On Fri Jun 19 2020, Andrew Lunn wrote:
>> >> > The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do =
you
>> >> > need some properties in the port@0 node to tell the switch to only =
use
>> >> > 100Mbps? I would expect it to default to 1G. Not looked at the code
>> >> > yet...
>> >>=20
>> >> No, that is not needed. That is a hardware configuration and AFAIK
>> >> cannot be changed at run time.
>> >
>> > I was wondering about that in general. I did not spot any code in the
>> > driver dealing with results from the PHY auto-neg. So you are saying
>> > the CPU is fixed speed, by strapping? But what about the other ports?
>> > Does the MAC need to know the PHY has negotiated 10Half, not 1G? Would
>> > that not make a difference to your TSN?
>>=20
>> Indeed, that does make a difference. I've checked with the vendor. The
>> current version of the switch IP does not support configuring the speed
>> etc. at run time. It is hard wired to 100 Mbit/s or 1000 Mbit/s for
>> now. Later versions of the chip might support setting the speed etc. via
>> configuration registers. As a result the PHYs at the front ports should
>> be programmed to only advertise 100 Mbit/s or 1G depending on the
>> hardware setup.
>
> Hi Kurt
>
> Are there registers which allow you to determine the strapping?

No, there are not.

> There are phylib/phylink calls you can make to set the advertisement
> in the PHY. It would be good to do this in the DSA driver.

I will. All the chips currently available are configured to 100
Mbit/s. So, we can assume that for now.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7xnI4ACgkQeSpbgcuY
8Kb4pBAA1R28pEnW5QEp7GfP1muC1V/LFkl2hJFIAHCp1xoXv3Jks3A15E9fXDu/
RTl/CQxEkJFdsxzLfcPlgFKV7RLqZRIEGabTw5CynFtDiKQ7q+dp3HrU239Sykhf
gJ1psGDeA0cyGVw7OBBrXUFMrdOg6fI5/3VpVpXj7v8/X4Qb2qYibi+pxRoAFSKQ
ljpMFQ2CL17lE1GMebTM8Gd7l8QZsBZU2kFojBVOeNfaIAJB+LxDjw5lSwAm2NvT
ET6Tqo0MlmpLQx2SQYrjrbQlgg20x40W0lXgqH0+TJEBRKm3iRoRB1AbwaV7+zcA
0Fd8iTMRFKTd/IZG5GjT4M2BWx6NCddMdTuTkqzakeOydwrg2U+P7gF/IM54nSf9
geC19badzb1ar4bD/lsTBsunFutCl7ZeJHgwu7XXq5SgyRbu1tY7iKssdkfgbqqa
q7u4rJY+t9g5F7dtzcZ5zpIkEm1ItTtESp8hz/HQJla14dV4EA+CM3FlU9AYBVQ1
JcVfyETZVQYtdDBrzOvtEbpHuobCe1sPwIrZX5sWlO/HFtQFiCXQqXHgvnKMSjK3
vpmICiQMMBVR41qdGrUryBxO3qIXcv09/ElktGdpV6axN4Rpe9ENCE3YmNg1ENlN
dZSaaugE0MFFU0n6ueYoo8AJdZCTh9PpSPD6A342tjPdo9jhwfU=
=2nM2
-----END PGP SIGNATURE-----
--=-=-=--
