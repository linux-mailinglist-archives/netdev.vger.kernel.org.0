Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34C7203652
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgFVMC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgFVMC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:02:28 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0032C061794;
        Mon, 22 Jun 2020 05:02:28 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnL9e-00083K-0P; Mon, 22 Jun 2020 14:02:26 +0200
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
In-Reply-To: <20200619135657.GF304147@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-10-kurt@linutronix.de> <20200618134704.GQ249144@lunn.ch> <87zh8zphlc.fsf@kurt> <20200619135657.GF304147@lunn.ch>
Date:   Mon, 22 Jun 2020 14:02:19 +0200
Message-ID: <87imfjtik4.fsf@kurt>
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

On Fri Jun 19 2020, Andrew Lunn wrote:
>> > The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do you
>> > need some properties in the port@0 node to tell the switch to only use
>> > 100Mbps? I would expect it to default to 1G. Not looked at the code
>> > yet...
>>=20
>> No, that is not needed. That is a hardware configuration and AFAIK
>> cannot be changed at run time.
>
> I was wondering about that in general. I did not spot any code in the
> driver dealing with results from the PHY auto-neg. So you are saying
> the CPU is fixed speed, by strapping? But what about the other ports?
> Does the MAC need to know the PHY has negotiated 10Half, not 1G? Would
> that not make a difference to your TSN?

Indeed, that does make a difference. I've checked with the vendor. The
current version of the switch IP does not support configuring the speed
etc. at run time. It is hard wired to 100 Mbit/s or 1000 Mbit/s for
now. Later versions of the chip might support setting the speed etc. via
configuration registers. As a result the PHYs at the front ports should
be programmed to only advertise 100 Mbit/s or 1G depending on the
hardware setup.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7wncsACgkQeSpbgcuY
8KYXyA/8DLXlHC/IIVPn9Frz2Es51NLmJmUYxmNRdlFFtHNlVZ7OxyewgvGG4XBa
Y3+UMl9byjXzkHkgYAEBp98PKDtAf+wM2DYj/OP2CS9IvxKL6X1Sfductwxq3yg7
MFOUvHo/eeGd88vFvDddX6/z9NeV2TaXTBmnwLLxsXa06QjTedhM5bJTBRZcqZi/
aHzDXwXgr81HSF3rj2QwlcgjVtUF7NKeSq42AnnuQyw2sfyNEObN0x/85+/FlaWx
C7kNUIX/gB8mRjEBDwWb4Ic7K+X2Fry16yMvaSLzDO9oKXeefRt1fAaIL5/e+/MZ
HYifNcPEHczfd3SxWQf7qNdm3ulvHTVkbFbAqrENtaqEH7nw6YGgpAjSpAKFynM8
DPp8W9wE+No5Bvm4zxarR/eERItRjruRXwot/tx0D7/Of1QVpPqf1Rt3CfTKphDC
ZHvkeZoJAnm6wo6Ig5v7Bq44oTRFTbXjkXgl681BNLk4xJnU0Akvam3nVMDzapH+
rOGyFlcsNk6QE08W2maQjOKmjEclWzXxNpuEc80CgKzseYJOmuvT1Nbt6B7SymZY
hdlKz2A9h2rZgMxIlKVGH5QNEE0iLc1wr5N4XQYcZKftveJc6hbx+KIg1HvPcfH5
nWKuH/lHl98iBpzVow48vMcA0++wcy+TCVBM3blbL8ACiMa792Y=
=CdRP
-----END PGP SIGNATURE-----
--=-=-=--
