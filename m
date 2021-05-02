Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEB8370FB9
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhEBXW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:22:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhEBXW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 19:22:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27CBEADDC
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 23:22:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 0554F607D5; Mon,  3 May 2021 01:22:03 +0200 (CEST)
Date:   Mon, 3 May 2021 01:22:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.12 released
Message-ID: <20210502232203.urc43paetto2gyza@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7lv2h4epe6nksqhw"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7lv2h4epe6nksqhw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.12 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.12.tar.xz

Release notes:

	* Feature: support lanes count (no option and -s)
	* Fix: fix help message for master-slave parameter (-s)
	* Fix: better error message for master-slave in ioctl code path
	* Fix: get rid of compiler warnings in "make check"

Michal

--7lv2h4epe6nksqhw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmCPNBQACgkQ538sG/LR
dpW5wwf/UAwRZhmiHvUdrkqCHIZ9we/16Ix+Ps/qWEoQyWHesIwErGKzYGehBBUF
TA/OXCksDw4QYMVBIbwOx9r561XJFv3CAMQF/AIQxwCYZpUNQeqyheovUndezFuJ
T6H/e+JoM9Sv13k64qobYeOFJ87DeC3k+JpVG8Sn+pchxxTxwpl/rlWkP3eL2GuH
QQMitFEY4nMrO7WLpuhkmId/j2Rpyh6IV3C8jOXJkaXv3zSIDHIbPRLOrBtTjMcT
Z6iS+zFu2e+gjgypv77M/8hmU1+A2XAJ07ejKaE3AJMj3ijoBSxNGX3k/l3d+jE8
W5g2nGq+rUTEZgtGS8DBYlSTcgqrqw==
=8NSs
-----END PGP SIGNATURE-----

--7lv2h4epe6nksqhw--
