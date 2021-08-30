Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4C3FB0E5
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 07:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhH3FrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 01:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhH3FrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 01:47:19 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC6FC061575;
        Sun, 29 Aug 2021 22:46:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GyfSr2PrLz9sWS;
        Mon, 30 Aug 2021 15:46:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630302382;
        bh=SnXBCriVNg8rndcjlU3Npsts9JLWsexSg+Kzt2t1PO8=;
        h=Date:From:To:Cc:Subject:From;
        b=MSISmhZHSsfS8bwa0/tl8xufEyHq9aOGcaPh/Iufwi65GQLCX1KFraaMiL7E+Mk+e
         izTqNILNmelIvB3Vp9RE8kGwKwgxvbIxAvxt8KkSkDdV2xf3xhJMXMX7VaIvqX6nOz
         YZscPbqGwNgJh1Y9kAdL8/75q0UBRY+0pyikFCysgkaRv0qUfK04uuhY1MHH5FZZOy
         kVWPni1XOpxxvwQPu4+P2pLaUEXFy4a60oOfwT/0iqPR47ex2cWpTMey5FDIjHIP9I
         2GZlkrCtSxu8xoFSoe8389agJrVDkVI+/m0o+OsJIsHD8XtGCcLJQxi5fI5l5zT09O
         OBXA6D/EAGYyQ==
Date:   Mon, 30 Aug 2021 15:46:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: linux-next: manual merge of the net-next tree with the iio-fixes,
 staging trees
Message-ID: <20210830154618.204ac5c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ev9Apn7Ev0m7lSHRVv+K6bx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ev9Apn7Ev0m7lSHRVv+K6bx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/staging/rtl8188eu/include/osdep_intf.h
  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
  drivers/staging/rtl8188eu/os_dep/os_intfs.c

between commit:

  55dfa29b43d2 ("staging: rtl8188eu: remove rtl8188eu driver from staging d=
ir")

from the iio-fixes, staging trees and commit:

  89939e890605 ("staging: rtlwifi: use siocdevprivate")

from the net-next tree.

I fixed it up (I have removed these files) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/ev9Apn7Ev0m7lSHRVv+K6bx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEscKoACgkQAVBC80lX
0GwMSwf+J/FcrcpCqmECTRPuz6BsaF6fb7zh1keyak7Yg00fH5glirBv3qzpPXT/
jIqBKZI883lvnI66cnSX3fvJc7TRBzddhwFwiLjmjQ5VNhggrteMEThbwTlf4XdV
vz6XS/X7lLTliKJ63efbw66KClqD30r8qJw/fG6hbr3jFLphVZKlCbVdbwAXxtxd
61PEvSujFhzdjGKYMX11kQp7vTaz24cW+nKmqrF55Nz4wos7kdkEsv4Ey+bHWI7e
4tYN54KYCR2rJ1l7VqxyzP687zj0auWHVou8tkoDd/CXwr4/mLvmCX7RaORA33N1
gTSlVVCPWwqW/KNPeS7fFieA9UaDJw==
=uWps
-----END PGP SIGNATURE-----

--Sig_/ev9Apn7Ev0m7lSHRVv+K6bx--
