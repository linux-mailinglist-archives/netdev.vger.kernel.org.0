Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3968122705D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGTVa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:30:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:41374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgGTVa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 17:30:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B6066B6D0;
        Mon, 20 Jul 2020 21:30:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B594B6032A; Mon, 20 Jul 2020 23:30:22 +0200 (CEST)
Date:   Mon, 20 Jul 2020 23:30:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, govind.varadar@gmail.com, benve@cisco.com
Subject: Re: [PATCH ethtool v3 1/2] ethtool: add support for get/set
 ethtool_tunable
Message-ID: <20200720213022.rp42exbfdiqtwle4@lion.mk-sys.cz>
References: <20200719235928.336953-1-gvaradar@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jg3fvbhvaepq3viu"
Content-Disposition: inline
In-Reply-To: <20200719235928.336953-1-gvaradar@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jg3fvbhvaepq3viu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 19, 2020 at 04:59:27PM -0700, Govindarajulu Varadarajan wrote:
> Add support for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE options.
>=20
> Tested rx-copybreak on enic driver. Tested ETHTOOL_TUNABLE_STRING
> options with test/debug changes in kernel.
>=20
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
> v3:
> * Remove handling of string type tunables
>=20
> v2:
> * Fix alignments and braces.
> * Move union definition outside struct.
> * Make seen type int.
> * Use uniform C90 types in union.
> * Remove NULL assignment and memset to 0.
> * Change variable name from tinfo to tunables_info.
> * Use ethtool_tunable_info_val in print_tunable()
> * Remove one-letter command line option.
> * Use PRI* for int type in print_tunable().

Applied both patches, thank you.

Michal

--jg3fvbhvaepq3viu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8WDOgACgkQ538sG/LR
dpVN9Af9FmCg0NYelqPcZc4pydbcBNOjzyP7Yq/5UWEatRsfbJECGLtA2MgodkTV
voFqcyB2FNIbf/GomQAhcVqFJPLo0pmhHM8d6JR+8RzP14ZuKoK6OquHCFKo/cpJ
UYnhUu8lEYUVy2397SmX8CcSe2G7PpIwXcUOKShx6wHAJBC7m9leUqPwWFQM0fbu
FN/pDvPfP/ekixVS8VMbHqf1Pra+9KvInHMOxbitfji1mlNqFmAhqDlqSn44vgSs
iUWRLJViDZjx7rsNU53jAshUvDg583nEBBrV6HB4CPYJqzG5uNYZW1oWWE46QOSk
WXSU3xhMDH7D9yU1UKRXICXmUNNWoQ==
=FTZ/
-----END PGP SIGNATURE-----

--jg3fvbhvaepq3viu--
