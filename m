Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7735FAB2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfGDPMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:12:31 -0400
Received: from 195-159-176-226.customer.powertech.no ([195.159.176.226]:60542
        "EHLO blaine.gmane.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGDPMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:12:30 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gl-netdev-2@m.gmane.org>)
        id 1hj3PP-0009xm-N3
        for netdev@vger.kernel.org; Thu, 04 Jul 2019 17:12:27 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: bonded active-backup ethernet-wifi drops packets
Date:   Thu, 04 Jul 2019 11:12:20 -0400
Message-ID: <8d40b6ed3bf8a7540cff26e3834f0296228d9922.camel@interlinx.bc.ca>
References: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+KktmK/afZu1Y6Zgx3Wz"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
In-Reply-To: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-+KktmK/afZu1Y6Zgx3Wz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-06-18 at 14:57 -0400, Brian J. Murrell wrote:
> Hi.
>=20
> I have an active-backup bonded connection on a 5.1.6 kernel where the
> slaves are an Ethernet interface and a wifi interface.  The goal is
> to
> have network transparent (i.e. same and IP address on both
> interfaces)
> interface which takes advantage of high-speed and low-latency when it
> can be physically plugged into the wired network but have portability
> when unplugged through WiFi.
>=20
> It all works, mostly.  :-/
>=20
> I find that even when the primary interface, being the Ethernet
> interface is plugged in and active, the bonded interface will drop
> packets periodically.
>=20
> If I down the bonded interface and plumb the Ethernet interface
> directly, not as a slave of the bonded interface, no such packet
> dropping occurs.
>=20
> My measure of packet dropping, is by observing the output of "sudo
> ping
> -f <ip_address>.  In less than a few minutes even, on the bonded
> interface, even with the Ethernet interface as the active slave, I
> will
> have a long string of dots indicating pings that were never
> replied.  On the unbonded Ethernet interface, no dots, even when
> measured over many days.
>=20
> My bonding config:
>=20
> $ cat /proc/net/bonding/bond0
> Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
>=20
> Bonding Mode: fault-tolerance (active-backup)
> Primary Slave: enp0s31f6 (primary_reselect always)
> Currently Active Slave: enp0s31f6
> MII Status: up
> MII Polling Interval (ms): 100
> Up Delay (ms): 0
> Down Delay (ms): 0
>=20
> Slave Interface: enp0s31f6
> MII Status: up
> Speed: 1000 Mbps
> Duplex: full
> Link Failure Count: 0
> Permanent HW addr: 0c:54:15:4a:b2:0d
> Slave queue ID: 0
>=20
> Slave Interface: wlp2s0
> MII Status: up
> Speed: Unknown
> Duplex: Unknown
> Link Failure Count: 1
> Permanent HW addr: 0c:54:15:4a:b2:0d
> Slave queue ID: 0
>=20
> Current interface config/stats:
>=20
> $ ifconfig bond0
> bond0: flags=3D5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
>         inet 10.75.22.245  netmask 255.255.255.0  broadcast
> 10.75.22.255
>         inet6 fe80::ee66:b8c9:d55:a28f  prefixlen 64  scopeid
> 0x20<link>
>         inet6 2001:123:ab:123:d36d:5e5d:acc8:e9bc  prefixlen
> 64  scopeid 0x0<global>
>         ether 0c:54:15:4a:b2:0d  txqueuelen 1000  (Ethernet)
>         RX packets 1596206  bytes 165221404 (157.5 MiB)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 1590552  bytes 162689350 (155.1 MiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>=20
> Devices:
> 00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection
> (2) I219-LM (rev 31)
> 02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275
> (rev 78)
>=20
> Happy to provide any other useful information.
>=20
> Any ideas why the dropping, only when using the bonded interface?

Wondering if I have the wrong list with this question.  Is there a list
where this question would be more on-topic or focused?

Perhaps I didn't provide enough information?  I am happy to provide
whatever is needed.  I just don't know what more is needed at this
point.

Cheers,
b.


--=-+KktmK/afZu1Y6Zgx3Wz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl0eF1UACgkQ2sHQNBbL
yKCcugf/XKeYdjFWq+X/Rz62D2MDvAK4KjdlYzAkxZna594I6MJnG7cGXmXEmAfF
0d+PycOvmzozT2EXgnoJzOenRXJ6jVuEvMCcJXZOk8lpzA1olKLZcWlgxzQA/scY
7RA5cIti+TXZqmy8ibVR+zsppivs4+JeaCq2DkapK/cF1Q3vvPo01eB3NbgqnNiU
E8uT0KQ/ZjsX3u6Sfa82zwmQGEzw9jWw88adTGPLF+tkGKvoBTU05baJtkLDL4el
SbqUum+piXqPzhdzdIG5QYOf4ekrMxkI6Ks/yVz9nBTwz8uX8wHeIQX0ujMalLBI
1wn284BTKLH/74jOoWtcuk1vMyQHnQ==
=Dy1T
-----END PGP SIGNATURE-----

--=-+KktmK/afZu1Y6Zgx3Wz--


