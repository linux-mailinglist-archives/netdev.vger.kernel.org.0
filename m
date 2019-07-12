Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3D066F31
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGLMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:52:08 -0400
Received: from 195-159-176-226.customer.powertech.no ([195.159.176.226]:58618
        "EHLO blaine.gmane.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfGLMwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:52:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gl-netdev-2@m.gmane.org>)
        id 1hlv1w-000NJt-Ne
        for netdev@vger.kernel.org; Fri, 12 Jul 2019 14:52:04 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: bonded active-backup ethernet-wifi drops packets
Date:   Fri, 12 Jul 2019 08:51:55 -0400
Message-ID: <dd8d8b77f45c988c8069c9e9a417ea27ef0bd8fa.camel@interlinx.bc.ca>
References: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
         <8d40b6ed3bf8a7540cff26e3834f0296228d9922.camel@interlinx.bc.ca>
         <6134.1562373984@famine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-t/hBvylfMjO1Kfgpdy/4"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
In-Reply-To: <6134.1562373984@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-t/hBvylfMjO1Kfgpdy/4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-07-05 at 17:46 -0700, Jay Vosburgh wrote:
>=20
> 	I did set this up and test it, but haven't had time to analyze
> in depth.
>=20
> 	What I saw was that ping (IPv4) flood worked fine, bonded or
> not, over a span of several hours.

Interesting.  In contrast to my experience.

> However, ping6 showed small numbers
> of drops on a ping6 flood when bonded, on the order of 200 drops out
> of
> 48,000,000 requests sent.

I wonder if that's indicative of what I'm seeing.  Strange that you
only see it on IPv6 though.  I'm seeing it on IPv4.

> Zero losses when no bond in the stack.

That's what I see for IPv4.

> Both
> tests to the same peer connected to the same switch.

Ditto.

> All of the above
> with the bond using the Ethernet slave.

Also ditto.  Wifi introduces latencies (at least) which mask the
underlying issue.

> I haven't tracked down where
> those losses are occurring, so I don't know if it's on the transmit
> or
> receive sides (or both).

Personally, I suspect it's on the receive.  I suspect the host I am
testing from sends the ICMP echo requests just fine.  It's just not
getting the ICMP echo responses back.

Any ideas on further avenues to debugging this?

Cheers,
b.


--=-t/hBvylfMjO1Kfgpdy/4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl0ogmwACgkQ2sHQNBbL
yKCwxwgAljahpHwvVoZo2+ByHcv5AbiaTFygf4WsavSHnm1owmh8j0t6qVFhzMKm
ajdwe1UTzI/VzqzFfbyl6/GsUYee2BP64NZO+Fkmq/XP1ID0U1REU4JtQtJd4a6d
inm26gGXUhJaJsDtvEn5BQBPUMHp6dO/exZNv8Xnm9HloJFuSMHox88ypPgdSifa
ZB1XHpqAqEVRIag5iA5kt9lSuJ21Rl0Gn6yGufCD7pIDZUMpEyqSkqjPd9Whz6pl
GnMdjMv1GFP9LZTAeH7F9gxaHGp4T6JiIWuOth9GTwRIUmsSaWowHPtt/M0sZCAb
a0jrL/afbpPtfhMojXxstGSeZpvkEA==
=fyAg
-----END PGP SIGNATURE-----

--=-t/hBvylfMjO1Kfgpdy/4--


