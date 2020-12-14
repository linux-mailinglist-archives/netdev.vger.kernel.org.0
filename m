Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93622D949B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439559AbgLNJLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:11:11 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:36371 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439520AbgLNJLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 04:11:11 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CvbFw10pjz9sT6;
        Mon, 14 Dec 2020 20:10:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607937029;
        bh=PDG6JSDdtPktsFNTARHXebEfEli9d/astnM3G34yPy8=;
        h=Date:From:To:Cc:Subject:From;
        b=qO99sknO93yPJOyqCRiG8N+kOi6ZyTlwmZ5md0msWl224WHRrERDbAcVLStxM9DQ0
         0mZze9n3xtJGI3B1ZP1OtmGPUTb1n4D2zpOvtZMCQq5tk4SZs1Ru+6ONSLpsVLAX4c
         5fjlX7mS5KvREwyx8Ws/nxhZPVS7Qh/5nOYALhva+W0kcWitLe+HBgOLWUzEURBZlA
         bb+TXJty7qf4ibW44CSnV2HcBeKtFA3bjbxKM1W6VDvw+4tVseXs79Mch1r/L/1wDu
         jrk86BbtRLL0ksktnZpIr8Vsjjx6jNkV+lDAIWs8VRoQGx5KS0NrvuQ8iu7nIOKD89
         zOzpNtrViL1pw==
Date:   Mon, 14 Dec 2020 20:10:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Brian Norris <briannorris@chromium.org>,
        Abhishek Kumar <kuabhs@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net-next tree
Message-ID: <20201214201025.60cee658@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kib+qnEosyn4/=Li5UJxQ2q";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kib+qnEosyn4/=Li5UJxQ2q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced these warnings:

include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:1759: warning: Cannot understand  * @struct cfg80211=
_sar_chan_ranges - sar frequency ranges
 on line 1759 - I thought it was a doc line
include/net/cfg80211.h:5073: warning: Function parameter or member 'sar_cap=
a' not described in 'wiphy'

Introduced by commit

  6bdb68cef7bf ("nl80211: add common API to configure SAR power limitations=
")

--=20
Cheers,
Stephen Rothwell

--Sig_/kib+qnEosyn4/=Li5UJxQ2q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XLAEACgkQAVBC80lX
0GwIywgAoa+CIaZPMbl9ubWpFlac+dtc6sfpAahMvl7/K9ADTVfxRUqpA5Rxzkj/
ks9AP0Uhqg4zI9bEQ25VOQ28QmLx/49D1+sHBQRhGNteu/4hqfXkGrIffi04N4WZ
xp9AgOn4Y8sdDK/lMEhQ8pdBuIXAGGjNCxsxiggip8V/VIclq3TLCeiu6pZdh2RU
ntzWmoc5zioT/r6vye8uUdboG3HlNrgLIb2lUybebolj0QKk1fvOudSyrjD2bfB6
5TYLGH4iePRJ79ml3msKJxOSZdCKvafA2PKcc+uRWD6RoUKfGxBv1bdMQul4AxON
/nU47etfkaC5J7eQSy/gCyGxzyO7QA==
=CFmK
-----END PGP SIGNATURE-----

--Sig_/kib+qnEosyn4/=Li5UJxQ2q--
