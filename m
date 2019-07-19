Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7987F6E1C7
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 09:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfGSHfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 03:35:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:52769 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfGSHfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 03:35:22 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 00:35:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="asc'?scan'208";a="319892127"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2019 00:35:18 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
In-Reply-To: <20190718195040.GL25635@lunn.ch>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190718195040.GL25635@lunn.ch>
Date:   Fri, 19 Jul 2019 10:35:14 +0300
Message-ID: <87h87isci5.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Andrew Lunn <andrew@lunn.ch> writes:
> On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
>> TGPIO is a new IP which allows for time synchronization between systems
>> without any other means of synchronization such as PTP or NTP. The
>> driver is implemented as part of the PTP framework since its features
>> covered most of what this controller can do.
>
> Hi Felipe
>
> Given the name TGPIO, can it also be used for plain old boring GPIO?

not really, no. This is a misnomer, IMHO :-) We can only assert output
pulses at specified intervals or capture a timestamp of an external
signal.

> Does there need to be some sort of mux between GPIO and TGPIO? And an
> interface into the generic GPIO core?

no

> Also, is this always embedded into a SoC? Or could it actually be in a
> discrete NIC?

Technically, this could be done as a discrete, but it isn't. In any
case, why does that matter? From a linux-point of view, we have a device
driver either way.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl0xcrIACgkQzL64meEa
mQa0tg/+J7fidxNYOaArzBoo1pLsa5Tt1bxOiyzoSXYwQJXvgSsgMC5qeeh70BDP
vdtxrw17ruDUoudg/iv+Nx6FowGzcaHav1qiK09NB+7eAuwgwDP3bMecPxvDqLDA
/E9i5Pr3pFsP0MYX3qFzeOjXY2UuQ1GYqPhWcNPBSaGpCOgvmG1Zzq/njDtQ7qtq
0xxJ58a8lWzhMKzDLoU5XcLfT18JrDDwNvhkz1JtRBBxfPFw5ZknkdvSwfnYIQAn
dPDsiNHv059YP/gSrmR6M6yAF24yxrJ+6204UwoMrjdsWWPQx0QSnToZqBBitFl4
jrWBym2wQdotCRJ1fBw0cLs0Qxpfq8amCcfUgLGOu7ujrmwsO++iHSMz0bTTHIzr
icQtUNIJ1coRNG9E753CFvXZHV8JSyCBefiv5ZkKtBGXcN4fR09qqZy6bP3tFtVH
rmCNC2/sHPzz/4TBWQ0+DebrfPoqnxrJpIAOZ2cQ95xMlUFnA63OZEkaIATNViQc
G8aQRtEj5KidgZ0Zgke/FQg8BNS1f6RXgro/6XX4g5YXK8TP4DAqGDVbiwWJRKm8
tKsQ8XbZj0bz2L/dyNV98TBjrSnjDyUfOFpyTiSrfHuKKkubo9l7CuY8i3OhGzGq
n8VeWacLvBHCMHLuXJSBQ6EF1KUyfOUo2wasgf1SfJMDd8mTP7M=
=IZw4
-----END PGP SIGNATURE-----
--=-=-=--
