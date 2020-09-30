Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD0627F455
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgI3VoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:44:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:58912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3VoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:44:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A24F1ABAD;
        Wed, 30 Sep 2020 21:44:14 +0000 (UTC)
Date:   Wed, 30 Sep 2020 23:44:07 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200930234407.0ce0b6d9@ezekiel.suse.cz>
In-Reply-To: <2e91f3b7-b675-e117-2200-e97b089e9996@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
        <20200903104122.1e90e03c@ezekiel.suse.cz>
        <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
        <20200924211444.3ba3874b@ezekiel.suse.cz>
        <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
        <20200925093037.0fac65b7@ezekiel.suse.cz>
        <20200925105455.50d4d1cc@ezekiel.suse.cz>
        <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
        <20200925115241.3709caf6@ezekiel.suse.cz>
        <20200925145608.66a89e73@ezekiel.suse.cz>
        <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
        <20200929210737.7f4a6da7@ezekiel.suse.cz>
        <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
        <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
        <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
        <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
        <20200930184124.68a86b1d@ezekiel.suse.cz>
        <20200930193231.205ee7bd@ezekiel.suse.cz>
        <20200930200027.3b512633@ezekiel.suse.cz>
        <2e91f3b7-b675-e117-2200-e97b089e9996@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ifv9FSNHijJpFU2eXAWU2n1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Ifv9FSNHijJpFU2eXAWU2n1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Sep 2020 22:11:02 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 30.09.2020 20:00, Petr Tesarik wrote:
>[...]
> > WoL still does not work on my laptop, but this might be an unrelated
> > issue, and I can even imagine the BIOS is buggy in this regard.
> >  =20
> A simple further check you could do:
> After sending the WoL packet (that doesn't wake the system) you wake
> the system by e.g. a keystroke. Then check in /proc/interrupts for
> a PCIe PME interrupt. If there's a PME interrupt, then the network
> chip successfully detected the WoL packet, and it seems we have to
> blame the BIOS.

Well, the switch does not sense carrier on the corresponding port while
the laptop is suspended, so I'm pretty sure nothing gets delivered over
that link. No, I suspect the ACPI suspend method turns off the RTL8208
PHY chip, maybe as a side effect...

But I don't need working WoL on this system - look, this is cheap old
stuff that the previous owner considered electronic waste. I even
suspect this was because wired network never worked well after resume.
With your fix, this piece can still serve some purpose.

Thank you!

Petr T

--Sig_/Ifv9FSNHijJpFU2eXAWU2n1
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl90/CcACgkQqlA7ya4P
R6fWqggAmC1S7XRZE243/oCFrYJiodejsNwHHTup/r0DbjujMPXdd6i+Fl/kVydj
YhnNJE6UsQ+VzYPooPl/STsSPDD2KtGav616HEHybEZEf3nd5Z0VuQIbJJO4cu/Q
nZgzO0nn3CuHZf2DOuZvJI+z7QXTDaz/Z5zqfZdjFQSw1FBlmOUfCmUUOZ1klHrm
nU3sPeNsDrSQuBgedLhp9i/R+FBDnqFunOG5xoXKQQAsF7mFdUTfzPFgKLeKrAWI
iqWZD5eCWZVPK5rfy1R948sWlcL79lU88vwkDNDLan+hprlgDlgxZAAvGlF6DidJ
awqWk4VrXQqVz53yJkQXe8/uWQqhog==
=Kkw8
-----END PGP SIGNATURE-----

--Sig_/Ifv9FSNHijJpFU2eXAWU2n1--
