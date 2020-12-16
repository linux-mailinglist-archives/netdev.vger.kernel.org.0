Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2492DC7CE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgLPUfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:35:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:41668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgLPUfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 15:35:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C39EAC93
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 20:35:09 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 14B1F603C4; Wed, 16 Dec 2020 21:35:09 +0100 (CET)
Date:   Wed, 16 Dec 2020 21:35:09 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.10 released
Message-ID: <20201216203509.gjebz7ezpfbtiwrz@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5c46gfzylfien36i"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5c46gfzylfien36i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.10 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.10.tar.xz

Release notes:

	* Feature: infrastructure for JSON output
	* Feature: separate FLAGS in -h output
	* Feature: use policy dumps to check flags support
	* Feature: show pause stats (-a)
	* Feature: pretty printing of policy dumps
	* Feature: improve error message when SFP module is missing
	* Fix: use after free in netlink_run_handler()
	* Fix: leaked instances of struct nl_socket
	* Fix: improve compatibility between netlink and ioctl (-s)

Enjoy,
Michal

--5c46gfzylfien36i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl/ab3cACgkQ538sG/LR
dpUR2wf/XXw5D6zixCpUUtvbp4w6ue1T8BKxe69sxGeWUjuxLCJkXpyLqSFdn/Mt
hoMVUILFrno7eLxv6E1TMIm0rJ2g7v8lgEqjW9MIVt/ouzdb8KTqa5URoWK4cKAe
0wL57oCrr2VHNTCZ8O46PKlHkzBP0efik2g8g67vLPKjem9OTmAobKSaHGkriYF0
N3nO5QR1G93qmlOtfz94q2kTtXTyANhdzFFa2g6wC/YOWtGvBv3Wyu8u7DJbhv8d
KT57zJVUntKJqDfAAYhecVqUSSHrkImBu177l46e3KaG8BOovCtPt790MDk4EJPz
oGiBCnDfPV9dPEiUsnZMl7tDGDYfxA==
=qKsx
-----END PGP SIGNATURE-----

--5c46gfzylfien36i--
