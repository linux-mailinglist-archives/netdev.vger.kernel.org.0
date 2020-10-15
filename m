Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440DF28F956
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgJOTSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:18:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:35726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgJOTSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:18:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CB865B2C8
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 19:18:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8839D6078A; Thu, 15 Oct 2020 21:18:52 +0200 (CEST)
Date:   Thu, 15 Oct 2020 21:18:52 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.9 released
Message-ID: <20201015191852.bc3rghi4okucs5ex@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7w6vwwxm3vf2xnj6"
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7w6vwwxm3vf2xnj6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.9 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.9.tar.xz

Release notes:

	* Feature: extended link state
	* Feature: QSFP-DD support
	* Feature: tunnel information (--show-tunnels)
	* Feature: Broadcom bnxt support
	* Fix: improve compatibility between ioctl and netlink output
	* Fix: cable test TDR amplitude output
	* Fix: get rid of build warnings
	* Fix: null pointer dereference running against old kernel (no arg)
	* Fix: update link mode tables
	* Fix: fix memory leaks and error handling found by static analysis

Enjoy,
Michal

--7w6vwwxm3vf2xnj6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+IoJcACgkQ538sG/LR
dpUWtwf/fz56KiT0k4XfSbAEB1u0BgV9nBQ3a0vFe53QchwquzyjOQZPO4SnGjD4
KSPvl/GuaCkVVG79zbTrwFIfTyvqPlHo4KMXtV0INPO5GAliUMDi9YAMhI3O0Bfa
1MamaZH3w5tLYyOCoDHm+65gVvRlAMEoH28cjSzjhRURAnfKRZZpWoB1S/6S+Jwp
FDdujBf4uIkY/SQWN20CfC9P7YAMqOZL31GLpzQ98qdE90ILap99ovCuqpKdIZdo
o0tv3/Fqrwm1tbIRNUlrclAJ7HX8nDX5nlt8Xg0WUUCyGzDxInPmDkEclGdpeQcH
3ackF4a9vyu6tsW5m60UNiUvmlgpNw==
=U69F
-----END PGP SIGNATURE-----

--7w6vwwxm3vf2xnj6--
