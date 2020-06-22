Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D942036DC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgFVMch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgFVMch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:32:37 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC87C061794;
        Mon, 22 Jun 2020 05:32:37 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnLco-00006V-Jv; Mon, 22 Jun 2020 14:32:34 +0200
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
In-Reply-To: <20200619134218.GD304147@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-7-kurt@linutronix.de> <20200618173458.GH240559@lunn.ch> <875zbnqwo2.fsf@kurt> <20200619134218.GD304147@lunn.ch>
Date:   Mon, 22 Jun 2020 14:32:28 +0200
Message-ID: <87d05rth5v.fsf@kurt>
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
>> > Are trace registers counters?
>>=20
>> No. The trace registers provide bits for error conditions and if packets
>> have been dropped e.g. because of full queues or FCS errors, and so on.
>
> Is there some documentation somewhere? A better understanding of what
> they can do might help figure out the correct API.

No, not that I'm aware of.

Actually there are a few more debugging mechanisms and features which
should be exposed somehow. Here's the list:

 * Trace registers for the error conditions. This feature needs to be
   configured for which ports should be traced
 * Memory registers for indicating how many free page and meta pointers
   are available (read-only)
 * Limit registers for configuring:
   * Maximum memory limit per port
   * Reserved memory for critical traffic
   * Background traffic rate
   * Maximum queue depth
 * Re-prioritization of packets based on the ether type (not mac address)
 * Packet logging (-> retrieval of packet time stamps) based on port, traff=
ic class and direction
 * Queue tracking

What API would be useful for these mechanisms?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7wpNwACgkQeSpbgcuY
8KZw0Q//aX5+sEx9mWsmbYMxC3/HQPjHUjLpvOOOU3sXM8nFn7WBRn6T35TaNY1r
4il/Bw40S9f+UYy2AAm7rmxPYpf7EGOWmyl1GnwmlfpVc6VOtUWIg8umTVd8TIC6
6YdTLmwwtAdCbcGXJikcvd59EzzJ9n5G7NnQMI3OLQ/4h7SzIWYa4KkK1KT9jtFn
7TLxfLJmPI/2VzmacqN8RrfjKUJxnHCDjTykaio4RWYhYwYMxVapebmz8Prdk6WY
tpkYW2qkw6rWfi/mSfXURd7QWYxpiPHx8Is0I9QIDqcG2W7RsJgamKNE8MT9ehX/
6D3YGOsXawpjQjzkrcp8rb5fIpdxrRBRJxK7iAHQS1FxA6OtNr7iGNyBFWVe8MM5
Sdq7Rn5QNUzf4M9Vbn+OI0q5RsLTBP1xaGJHAcSPB+SB673rAC+apjVVVed2I4AP
PnDJ20aGoVe1fZoovWx+fx/aC5nKejU42C0HJm0m5mx9OfJ3FcW8HxbXe/EAa9a8
RIP65ZpAmqDDkBt/JeJ3UHdBWaA5ck7uTIZtwHFKhIbeB/QIe3vLQZn55Bf5WPe3
O8ddQa54ox27rb5mUKHSi+1DoYWxDaa7Ple0LugktCxH9Zxied8mHd9IkqDeb9yy
/B615DopQgEeG/cpKfqvZQJxFx4yaVi0DiLi4uAJpySXiJoTJns=
=EEtE
-----END PGP SIGNATURE-----
--=-=-=--
