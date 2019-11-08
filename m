Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1E7F5B43
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKHWq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:46:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:7540 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfKHWq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 17:46:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 14:46:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="asc'?scan'208";a="206139841"
Received: from karaker-mobl.amr.corp.intel.com ([10.254.95.244])
  by orsmga003.jf.intel.com with ESMTP; 08 Nov 2019 14:46:28 -0800
Message-ID: <a9752e1b45b92956d91386cfa4649710c289ddde.camel@intel.com>
Subject: Re: [PATCH net 1/2] i40e: need_wakeup flag might not be set for Tx
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>, magnus.karlsson@intel.com
Cc:     bjorn.topel@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Date:   Fri, 08 Nov 2019 14:46:27 -0800
In-Reply-To: <20191108.141126.499156209602458565.davem@davemloft.net>
References: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
         <20191108.141126.499156209602458565.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-HZsBhx/tjGi2vx7jS/97"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-HZsBhx/tjGi2vx7jS/97
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-11-08 at 14:11 -0800, David Miller wrote:
> Jeff, please pick these up.
>=20
> Thanks.

Yep already have them queued up.  Just waiting confirmation from
validation.  I will have a 6 patch series of fixes for you in the next day
or two.

--=-HZsBhx/tjGi2vx7jS/97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3F8EQACgkQ5W/vlVpL
7c5dQxAAnEN4hhD73X3vWW+oL6DYFCX2TUZzzEnsdAr8xcJT44+jSV6fw7p7CZxE
DowJmyFSk/pJAxZE1EqbhDNyvgDxiWE8DteAIIDIyE3YKMJq0lrl5mk6tpqupGyo
0SBeLLIusxDNjsbUItD0NssDJnO+Otgv534ospNWl79cbUncyJ4uAVStIEl5G+hN
aMwGikuDwNFuQEjdS09oANAL+aTak5z9RdRHEkqb82MtUJ++vcZC7qPzHsGHIYMO
B1+UNzRLCCi3ebXBUR+VEecI3vDk+bBM1j7+JxPdBaFaSeNPwoRWzSMvwg91Q7Ga
Z7nUna9dFDy1kS2gFVChPXXfT7xXERcu25J2b94wz6LB/imeyVou+OYv7wiY0XQl
qVnEkd0DFYjGcCEDm1Uks66yjw5nhZpf42Kz8Gy72XX6RjtI+UuQBXVdjd2Ohouz
jt8Agml3oidS9kdboILB0HTAUZuR/Y64eYsUfSQ5hZZi45Ui8nbO+oCQcUkK1+UI
zu3kfx5++wKZodWX6jSZ2ecbjE+cm0oH5gm45ZIVLewnD+1GDbHfBPlhqFojUpL6
qXUfQXC+xR83xVN26C2k0uoIvmXKlZMNCa5UNBpdv8NctpNfCDxI1vNptarzNY8o
ThKGtE6cnu874P+9vZqwr0383xMAjez2oI9mAO+vjJrmJ9W9pyg=
=9P3X
-----END PGP SIGNATURE-----

--=-HZsBhx/tjGi2vx7jS/97--

