Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B660345D699
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 09:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353228AbhKYJBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349337AbhKYI7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 03:59:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505F8C06179F
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 00:49:59 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637830196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKccclW8cd8A67FhhyKtWmLI1MVSu+hW/6okC4mHcqs=;
        b=Z/QvRCBz4ocB+lmQUXeht66quQLSCLqBEE0BEhJM7BukECM/Sn7RoARZn06Py3bgMz5y1A
        kX7DSMIdpG2c/8hMgVBfzGHhfLyfpqE1JS7L56ryjiabIuMM+ARB/3i7CIGAucPrdRUIua
        qR0LiApwt1IKOK5bKTa2UVH8a3bYeeFkOmunjMxF/chtP9oM+LYXwg4NaR9mzqx645C8Y3
        V+ip+fhFd6Ouk0nZJkI5sU4lncyGdlCBSglbgCWEksZnFUUMTY3vMiGMFPkKj2ELfnMxg7
        t8gVGwbc+1IgJ/JTP5MXsOpStc52uRW2yqLU4bA5WviPUUAwvGENdSQJJ/00jw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637830196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKccclW8cd8A67FhhyKtWmLI1MVSu+hW/6okC4mHcqs=;
        b=eGUEDf0Co2/kdGqxubKkHluVauEy3bOryy/2+ACW1ClJuDa7FbbIqRBUUiD1JdnbOIxqio
        b5Wy3OW8JmHoECCg==
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 06/12] net: dsa: hellcreek: convert to
 phylink_generic_validate()
In-Reply-To: <E1mpwRx-00D8LQ-RG@rmk-PC.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRx-00D8LQ-RG@rmk-PC.armlinux.org.uk>
Date:   Thu, 25 Nov 2021 09:49:55 +0100
Message-ID: <874k80y5zg.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Russell,

On Wed Nov 24 2021, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the
> hellcreek DSA switch and remove the old validate implementation to
> allow DSA to use phylink_generic_validate() for this switch driver.
>
> The switch actually only supports MII and RGMII, but as phylib defaults
> to GMII, we need to include this interface mode to keep existing DT
> working.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Looks good and works.

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGfTjMTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwppAfEAC9labtEkXJvVLmY4IvJEaKQFNUg9CR
N+BR/sLr9x/NKWIw1Wgf+jT2jNt1DJQ2SKF0L1YDX15hRnAXu/mT3xgYmaH1Auma
IKOAj+LM6kn6ZEXFgaQ6m8O9DzfAB+BRFQfHtHnQbNEozqu+srngnspHNJ+9hibj
qNS8YM6A//KzrDkfvGS4J2EaHy7MioQPWhHIFdDZWy5MVDkiR9n1K6WQtagbALcW
9beZNaxVGQs+8XQ/BeNxLBIKsskkn/bIhC1Dhfj4UbxAv+YgxkuWuTAEf9j3E7Mw
bNGAFSvF2Zr/hem7zkFNvzevuQ2Hea7wlh+nM9Tx/bZeFX1JwfPMi1i+8ap6g8E0
oewRWuzFhpsdLua5e0ZtOVq4Xt09NySQGjQwdcKwTDUH5sF1wri2vJrKj3i+xCfu
aaShSnS2Few/EgOCaIvydrqW4uyJ3LQ7V7NlrpxUTdBtwTs962MtCA+uyVExm0x2
UD264Xp3vVk39MOjPcQQOTyA7lmzSnNvojoBO1tmqikJ1PE8ArhQuWeNPEryFMfr
Q+Mbufma1/TonIQ0dIs/aWaU3DoV0lnOeZrDPi5btJbduhl985ktoAPz8nyLzxyQ
soRKkvzganPrGIX7smay+26mcfLUk25ofCxRDmuY0QGYaDFm1oRijZjCt42I03sY
BerGQrPTuYpvyw==
=rjUF
-----END PGP SIGNATURE-----
--=-=-=--
