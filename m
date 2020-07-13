Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE7C21D592
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgGMMOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGMMOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:14:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E67C061755;
        Mon, 13 Jul 2020 05:14:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t15so6160737pjq.5;
        Mon, 13 Jul 2020 05:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2P82DVa0uA6ZsAd3NB4q4eF6eR6EDSKhk3gZmaYEnrI=;
        b=OY1u+H7TOfRirjsCn6YZ4ohxeV6a0pnQ8m6WWhPNUDRlvXcaIj2MdZ0bIJ7+lMr5H5
         mi+DErEvZIBa7esEYaKuMK333QVLsFQEwO7baTFTH/6sq9xwUL2hKD+X/dBRNg+WlZ5F
         HQH7T1i2KCC1N0vlTy7cJWKYzdsWPLtY6WpRDF9ZUQp3HhxYCFklkqhOZoZpKCGbPBwZ
         QJF0T8HSWxscPIEocZP0eQxckDS6xq3GJM4F3SKP0YTZiBDAzwlBi06T8FxYUb8rv1uv
         bNj7sI/h3oobmnw4zOWTdd+Ybpv+YXgFdX5G9W6L6LKyCgnmkpPqgwqBYdjAZhwqEz2V
         5DSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2P82DVa0uA6ZsAd3NB4q4eF6eR6EDSKhk3gZmaYEnrI=;
        b=VaDgl3bWrkYOVjRI3/UWeU2ob7G+fDRgCv8IfLjf0bQfNs4Et6gbeXwDgpV3Vrhhf8
         kPBM1tMFOPNOGEl3s5Pl+MM/dUy2CqUDqz9H/gIo1x40yBNPQNzjlVy18KdA2Piexaus
         u8qOAqMDYnOf5MTdtJI5KqGJT2iIjdBz2md8XdE/otw2XPU0lwlLtaOE76VHjSU8BaPN
         a88MwOOpJaIt9j5y40lXu3wKzaAQGb0KHiKDAYNuK3vVt7bxYmBCOl3ootUU3hzHNGY2
         LsiikxeJRXYNV05dXKdPEgBDeZeQbuvnvjf+B3+mULuThDFZl9j2gNDjVmyaXtdXb4ec
         0Acw==
X-Gm-Message-State: AOAM532QFEGqzU1wLgAee4HexltCWgeGRX1+2qib1P0ArF7IdcZ1+TAM
        pYrFPTVSVMLhnrfhhYYlQHtfj2WxeLaPZQ==
X-Google-Smtp-Source: ABdhPJzH/Mg6FFnMjQPexZV+clQXflYEUbtTrxhI8RnnXsVRT+zfTStVRzLh9stkH84cILUtqvIocw==
X-Received: by 2002:a17:90a:f206:: with SMTP id bs6mr20065510pjb.48.1594642483042;
        Mon, 13 Jul 2020 05:14:43 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id v11sm16230393pfc.108.2020.07.13.05.14.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:14:42 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:44:27 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] staging: qlge: General cleanup and refactor.
Message-ID: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hii,
	This patchest aims to remove several of the checkpatch.pl
warnings and refactor some ugly while loops into for loops for better
readability.
Some of the issues are found with checkpatch and others were listed in
qlge/TODO.

Thanks,

Suraj Upadhyay (6):
  staging: qlge: qlge.h: Function definition arguments should have
    names.
  staging: qlge: qlge.h: Insert line after declaration.
  staging: qlge: qlge_dbg: Simplify while statements
  staging: qlge: qlge_main: Simplify while statements.
  staging: qlge: qlge_mpi: Simplify while statements.
  staging: qlge: qlge_ethtool: Remove one byte memset.

 drivers/staging/qlge/qlge.h         |  7 +++--
 drivers/staging/qlge/qlge_dbg.c     |  5 ++-
 drivers/staging/qlge/qlge_ethtool.c |  4 +--
 drivers/staging/qlge/qlge_main.c    | 49 +++++++++++++----------------
 drivers/staging/qlge/qlge_mpi.c     | 32 +++++++++----------
 5 files changed, 45 insertions(+), 52 deletions(-)

--=20
2.17.1


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUBoACgkQ+gRsbIfe
7454sg/8DJM1+74HINhkyKxsOhUgvby6VzO0B0iFGVivi796N9MMSjLGpth9dl29
PLvjRCYwqpFriYMpzPJPI++RXoPXKXHrIlYgUi0kKQmB8hmYc+bhfcTNuSMEJRgF
+34nRwTJEruI8aOczBnqD3t/fNsXXappC8GIaOhqAvkZIGmw/oAHss7oNc83qgRW
YajyFoZt1zcw2zBbch9PHFpgj/9zOZfSuy47/irzeioqYLfXSs4HcZJB08Nan5Hn
NZc4QgW5ggu/fCg80BCaKCwiQXl7df6dKQ62+eAgt/KGKg24oGbYfYc7yNgMTYVo
c/ihaAV3NzZPZAEnwgVU4yS3ygBavS/Dnoas5hsl/cqzdXJFiu5lewIriRl6/ldk
y7xp71Vyxm1O22iMwZGuHCt0JUc9UsXxp8+4lROo5sz42rqD0RZnXYVT5OVSYsfF
09mvC2u9xMvxOt4kFsPQXYeYF6nqAU0yDZJ0xpCXCrZ3d5chy3lMbxN178KH843A
YBQ6xTsopIHEvCMaM55KckzdmKF5zwFTFlVSBsRGtQhjHGF+q/DwwTvYV58YXC0W
3K5j2SIcWgHeA0ThmQOTkIQogHmSS2nJTh6g4mAAFXOXjGO1C4N/TigPj0G1EHsn
oyQd0Icgj/uS/uNK+92otBPkL2J6EVHdoJaUS+gJM13WzlYAznw=
=FhHN
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
