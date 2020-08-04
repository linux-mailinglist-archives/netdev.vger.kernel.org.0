Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173D123BE73
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgHDQ6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:58:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:49218 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbgHDQ57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 12:57:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0DF33AE2C
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:58:13 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DC27F6030D; Tue,  4 Aug 2020 18:57:56 +0200 (CEST)
Date:   Tue, 4 Aug 2020 18:57:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.8 released
Message-ID: <20200804165756.cbwxoev3nuf5gitn@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="anaajtlripj67kys"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--anaajtlripj67kys
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ethtool version 5.8 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.8.tar.xz

Release notes:

	* Feature: more ethtool netlink message format descriptions
	* Feature: omit test-features if netlink is enabled
	* Feature: netlink handler for gfeatures (-k)
	* Feature: netlink handler for sfeatures (-K)
	* Feature: netlink handler for gprivflags (--show-priv-flags)
	* Feature: netlink handler for sprivflags (--set-priv-flags)
	* Feature: netlink handler for gring (-g)
	* Feature: netlink handler for sring (-G)
	* Feature: netlink handler for gchannels (-l)
	* Feature: netlink handler for schannels (-L)
	* Feature: netlink handler for gcoalesce (-c)
	* Feature: netlink handler for scoalesce (-C)
	* Feature: netlink handler for gpause (-a)
	* Feature: netlink handler for spause (-A)
	* Feature: netlink handler for geee (--show-eee)
	* Feature: netlink handler for seee (--set-eee)
	* Feature: netlink handler for tsinfo (-T)
	* Feature: master/slave configuration support
	* Feature: LINKSTATE SQI support
	* Feature: cable test support
	* Feature: cable test TDR support
	* Feature: JSON output for cable test commands
	* Feature: igc driver support
	* Feature: support for get/set ethtool_tunable
	* Feature: dsa: mv88e6xxx: add pretty dump for 88E6352 SERDES
	* Fix: fix build warnings
	* Fix: fix nest type grouping in parser
	* Fix: fix msgbuff_append() helper
	* Fix: fix unwanted switch fall through in family_info_cb()
	* Fix: fix netlink error message suppression
	* Fix: fix netlink bitmasks when sent as NOMASK
	* Fix: use "Not reported" when no FEC modes are provided
	* Fix: ioctl: do not pass transceiver value back to kernel
	* Fix: ethtool.spec: Add bash completion script

Michal

--anaajtlripj67kys
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8pk48ACgkQ538sG/LR
dpXHqAf/Xmh5rahYFCcXfkTNZl8UOdS7cHAd1idbOUf0QXVluW+vZ8SSkNnZfzuc
3QA0YIzibTMbRGAmz/QS+X8jkThHFWsEGTX5MPRhmy4dirZWyos0aLTATiXtKuoW
6XU/aIFPULnQ2ekndfNmnD4c5DpGX5VmVieEe/oEZBLYlhS0CGVx2GnZTdII/SxO
5cCMp79WTzCzBUpuBISkI6EZKSovsla6/QO1Nj6Qtu2JuUT84RTrpDRGndgRbYMi
0o4e7dfnoP4ab3BRwTXUWwTzha3kj41+wtREuovyan3mX2pV0wwMoKJcw3j7zSyr
PMs0d3TMxpisG4dE7erNoGnOUpXOmw==
=OjYA
-----END PGP SIGNATURE-----

--anaajtlripj67kys--
