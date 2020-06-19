Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAEF200440
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731188AbgFSIpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730924AbgFSIpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:45:41 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B39FC06174E;
        Fri, 19 Jun 2020 01:45:41 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmCeX-0004ZM-D6; Fri, 19 Jun 2020 10:45:37 +0200
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
Subject: Re: [RFC PATCH 7/9] net: dsa: hellcreek: Add PTP status LEDs
In-Reply-To: <20200618174650.GI240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-8-kurt@linutronix.de> <20200618174650.GI240559@lunn.ch>
Date:   Fri, 19 Jun 2020 10:45:36 +0200
Message-ID: <87366rqw9b.fsf@kurt>
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

Hi Andrew,

On Thu Jun 18 2020, Andrew Lunn wrote:
> On Thu, Jun 18, 2020 at 08:40:27AM +0200, Kurt Kanzenbach wrote:
>> The switch has two controllable I/Os which are usually connected to LEDs=
. This
>> is useful to immediately visually see the PTP status.
>>=20
>> These provide two signals:
>>=20
>>  * is_gm
>>=20
>>    This LED can be activated if the current device is the grand master i=
n that
>>    PTP domain.
>>=20
>>  * sync_good
>>=20
>>    This LED can be activated if the current device is in sync with the n=
etwork
>>    time.
>>=20
>> Expose these via the LED framework to be controlled via user space
>> e.g. linuxptp.
>
> Hi Kurt
>
> Is the hardware driving these signals at all? Or are these just
> suggested names in the documentation? It would not be an issue to have
> user space to configure them to use the heartbeat trigger, etc?

These are more like GPIOs. If a 1 is set into the register then the
hardware drives the signal to high. The names are from the
documentation:

 * sync_good: This signal indicates that the switch is in sync
 * is_gm:     This signal indicates that the switch is the grand master

However, these signals have to be set by user space. Most likely these
signals are connected to LEDs.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7sezAACgkQeSpbgcuY
8KYItQ//WuzGiXCmAl0Vvl50s+TB4DA8vxcReegXm8ybaYRz3QqUD9/YCRV3V7CB
cPDYyVBxzsBuI3x5k88/cSgcyzh7LF56FftpOufBNfkfF50MGQVZ1HZeXjjmyyKF
3Hx1mNRAbQ1dBOzCT4F5AHHZjk08bf3hi9gsq3Lr16Mnbw8+fLRGQg3kZItsl/cG
T9wLbniEGygOteVkdU1NQS/xXUgXUOcm7JMvP+kWP1wbWCag+6+VJ2+61qbl6l+Y
4RIAPN/0esyo0hUR7rmIzWbAFJnPJVR9VHByjkaynfsSsm8G3wWcuRyf9kYH8VlA
gNT0wgNmYAJuHi8IwE239SaXWwA8tMjkwxztoL0dLxirOEanCSIRwGGl5wk8FQKQ
TYLlfbrJCOZgUi4cWnhWjFm/0ZLkwceikwM4jy4MxgszTGIodbSkNbfVI6aGI+p3
MKJoSQXG7aWJGRMkerTbsBR+3GKY7wmn4hljnECX76PKYDMZwkmk4Jd/c4pb6D5D
rD6b/9ndK6vIi5GTp8FvBGntAu/qaL+XhUhYzXsqjCOCUdveUxVuaGFb/H4roPXF
qXlO05qn80JyADHp3JGwZrpXD3HkgRon0sVyksnNXfKzoz9EyRgOlVpNH+s+Eqjm
T+Ui+83jrLCjQ2vrDnYU/CPcM7887aTF99kErP9WVNrphpcQUS8=
=bOet
-----END PGP SIGNATURE-----
--=-=-=--
