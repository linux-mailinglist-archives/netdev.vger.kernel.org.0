Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC444AA7A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfFRS54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:57:56 -0400
Received: from [195.159.176.226] ([195.159.176.226]:39312 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1730266AbfFRS54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:57:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gl-netdev-2@m.gmane.org>)
        id 1hdJIl-000wDw-Ef
        for netdev@vger.kernel.org; Tue, 18 Jun 2019 20:57:51 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: bonded active-backup ethernet-wifi drops packets
Date:   Tue, 18 Jun 2019 14:57:44 -0400
Message-ID: <0292e9eefb12f1b1e493f5af8ab78fa00744ed20.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fBUPa50ZZJMU5cD3ie/M"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-fBUPa50ZZJMU5cD3ie/M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

I have an active-backup bonded connection on a 5.1.6 kernel where the
slaves are an Ethernet interface and a wifi interface.  The goal is to
have network transparent (i.e. same and IP address on both interfaces)
interface which takes advantage of high-speed and low-latency when it
can be physically plugged into the wired network but have portability
when unplugged through WiFi.

It all works, mostly.  :-/

I find that even when the primary interface, being the Ethernet
interface is plugged in and active, the bonded interface will drop
packets periodically.

If I down the bonded interface and plumb the Ethernet interface
directly, not as a slave of the bonded interface, no such packet
dropping occurs.

My measure of packet dropping, is by observing the output of "sudo ping
-f <ip_address>.  In less than a few minutes even, on the bonded
interface, even with the Ethernet interface as the active slave, I will
have a long string of dots indicating pings that were never
replied.  On the unbonded Ethernet interface, no dots, even when
measured over many days.

My bonding config:

$ cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: enp0s31f6 (primary_reselect always)
Currently Active Slave: enp0s31f6
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: enp0s31f6
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 0c:54:15:4a:b2:0d
Slave queue ID: 0

Slave Interface: wlp2s0
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 1
Permanent HW addr: 0c:54:15:4a:b2:0d
Slave queue ID: 0

Current interface config/stats:

$ ifconfig bond0
bond0: flags=3D5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 10.75.22.245  netmask 255.255.255.0  broadcast 10.75.22.255
        inet6 fe80::ee66:b8c9:d55:a28f  prefixlen 64  scopeid 0x20<link>
        inet6 2001:123:ab:123:d36d:5e5d:acc8:e9bc  prefixlen 64  scopeid 0x=
0<global>
        ether 0c:54:15:4a:b2:0d  txqueuelen 1000  (Ethernet)
        RX packets 1596206  bytes 165221404 (157.5 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1590552  bytes 162689350 (155.1 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Devices:
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I219=
-LM (rev 31)
02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)

Happy to provide any other useful information.

Any ideas why the dropping, only when using the bonded interface?

Cheers,
b.



--=-fBUPa50ZZJMU5cD3ie/M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl0JNCkACgkQ2sHQNBbL
yKCw9Af8ClmWckxTha7/8NQpOH5RDugu8Vqx8lw3tgLTZ9Q7FPmPPPj3WKIkPd+u
Dr8g7bDPqynsB+7vVpqBKfqg9Aa1yFIl7weM/gm/e0BR1tdwtj7eVMHcbaO21m+N
NfcX3js0GkNhELHKKvibETerUUukjpFjUfQeX+0ZgbykwRf/0RJnGH7eHgexrrtN
fXdNc1MlPpn+EnnTGgOOZbzLVoSzk1jJCvPEpbyBgA3ZYnZD2FRaOesMxZFdidzR
toAXJj2JPcKv/o/IsXrXYQMXmhZBMlSZtB+3H5pSQ46OzKHHxZiiDULXTog5jfvN
avB4YGP1/KHA+Ie6yv1NkZ/pwrsJsA==
=+zDv
-----END PGP SIGNATURE-----

--=-fBUPa50ZZJMU5cD3ie/M--


