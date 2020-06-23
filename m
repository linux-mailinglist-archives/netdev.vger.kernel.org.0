Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA03204987
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbgFWGHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbgFWGHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:07:12 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673B0C061573;
        Mon, 22 Jun 2020 23:07:12 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnc5N-0001tj-Ii; Tue, 23 Jun 2020 08:07:09 +0200
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
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
In-Reply-To: <20200622135510.GN338481@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-7-kurt@linutronix.de> <20200618173458.GH240559@lunn.ch> <875zbnqwo2.fsf@kurt> <20200619134218.GD304147@lunn.ch> <87d05rth5v.fsf@kurt> <20200622135510.GN338481@lunn.ch>
Date:   Tue, 23 Jun 2020 08:07:03 +0200
Message-ID: <87h7v2nwmw.fsf@kurt>
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
> On Mon, Jun 22, 2020 at 02:32:28PM +0200, Kurt Kanzenbach wrote:
>> On Fri Jun 19 2020, Andrew Lunn wrote:
>> >> > Are trace registers counters?
>> >>=20
>> >> No. The trace registers provide bits for error conditions and if pack=
ets
>> >> have been dropped e.g. because of full queues or FCS errors, and so o=
n.
>> >
>> > Is there some documentation somewhere? A better understanding of what
>> > they can do might help figure out the correct API.
>>=20
>> No, not that I'm aware of.
>>=20
>> Actually there are a few more debugging mechanisms and features which
>> should be exposed somehow. Here's the list:
>>=20
>>  * Trace registers for the error conditions. This feature needs to be
>>    configured for which ports should be traced
>>  * Memory registers for indicating how many free page and meta pointers
>>    are available (read-only)
>>  * Limit registers for configuring:
>>    * Maximum memory limit per port
>>    * Reserved memory for critical traffic
>>    * Background traffic rate
>>    * Maximum queue depth
>>  * Re-prioritization of packets based on the ether type (not mac address)
>>  * Packet logging (-> retrieval of packet time stamps) based on port, tr=
affic class and direction
>>  * Queue tracking
>>=20
>> What API would be useful for these mechanisms?
>
> Hi Kurt
>
> You should take a look at devlink. Many of these fit devlink
> resources. Use that where it fits. But you might end up with an out of
> tree debugfs patch for your own debugging work. We have something
> similar of mv88e6xxx.

I see. Maybe I'll keep the debug stuff out of tree for now and will come
back to it later.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7xnAcACgkQeSpbgcuY
8KbQHxAAgZcr0iQIaehcDP9IzMyDmDkTa/MQTedcwzX18Q44z3ymcLm9UQe+kJ/7
JyQlZXWd3oBdK8KyLbb83T5xp1r0qhPw+6CNmGbSsbSNevFjloVxllDslZc9E0RB
80UYxlBJjFU3iRdU9NrbFCDeQqVeYc+AmJCtMZ2zrFpI9ywYmAP3zlUROTJ7OGgT
80IEAcIEJg5c0ibapPG/Kj3ds+XKzWBsDZHHRPh8uTjS3J/5aMr6/1+MW/PWnaJC
IJvCshKSywFJ60lYGcMOKmoUPFic4h/GELjli14qVzpz+0G9Y+LtoTLNTJ/t0nEg
K7BQHW4O4uSgeHmMQ+MK8CO0sdhAU+rvzPht+W6Ry8E51fssW4u0pcR2rOjLj4v3
Q8og31rn2vipuVy/oHQPzTkSogs/u83PId52bYp2VxHXQyoryZ23+Rh7O2QI/pCV
cZgjgNXDNHA959jDvjCbw8xrfCEer2fXk7HY40VeYeWIS4mDQwriO1j/hRK5YPoW
yrlGh4ejHvvLCgxbMDCHCV3erQnnLPLGjegTCgD8pLnznNVGuXuGfw09teQsadVc
VMiL9Dj4XizQZqmLigqHn7WbtCxJjq2bSwtsfXDbUYDlnva0mWnb8b/QdGziv3Xt
nbMBWUhNZxK+XkeA4BzIduwhoz4Dhy17vphf5NO8INVPmX6GKyI=
=pJj0
-----END PGP SIGNATURE-----
--=-=-=--
