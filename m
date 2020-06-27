Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2320BEEF
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 08:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgF0GIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 02:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgF0GII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 02:08:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D042C03E97A
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 23:08:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j4so5096136plk.3
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 23:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=gtmGpW21SyNiDgvXMh+8DiMIETkQ9kJybZA1frDwgbo=;
        b=pDNCTrB3ZFp49fu1m/cIDeOovHxi7U2+qFg3Y1RBH1bVnUf4jiE4QdPPtF5aT9cuDs
         5Y855FtE7yLDZrDbsrqVZlk+PLkC1bkU1WxXdm1yj7u+D6efBtITTOdp1iJJIiTxG3FC
         uRLHn/PNBZwwZG1fbYA1WBy0xHVWLDHfY4RbyczyvfMCmQVGahZ1OZ+ftk0ZSZd3KQre
         LBsrRUdVl4ZXr9Uao4E2lHEBSwm7gqqlOI3yzD/Va2VLn7fNTkU5S+bEKWJMzL4iNZS8
         /miqRlnZHNXhHe6/94aUYx5Kyq+jNsnGQaCMrblKS5Z3vnvdXnuhh0lFyhwD1qYEcvBF
         KbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=gtmGpW21SyNiDgvXMh+8DiMIETkQ9kJybZA1frDwgbo=;
        b=bh3UAuXdV6YO3Ol9h6+PBSZyKseACiT9G1uut5CCfikrQbC9kA6jYRzzQuoR455zQm
         JLy4NMEtjgCQbnJ8TFMZ0uIhr6qsEq6j7QY8yUcBnjCvWm9gSTPVSlboLZ0rsD3dIqah
         wBmKJlzerlkJFT9LfWj1g8ISlBgKdkkd5YWCfxm6xXnfzroXUc22KqDli74qTYW1b392
         VAJOuM/TupLfNk0m6psH+t2qkqldSwrmIBu8cmAeP0LL36AlgOf6MHC1uZ/RaUAXWyHB
         RHbutvxB5MHoIWyjJ6KXPGd8FJa+h5P7wYud30dbn9tc7xl7GRbwuSEe8USWvqSakaoV
         RcoA==
X-Gm-Message-State: AOAM533C08somfVOD4eg8l1lKw0z0l/vBSAGN1tl0RGPlUIyaVZYwxw+
        hcbm9Use7wEJq+e6HytQX2LKAA==
X-Google-Smtp-Source: ABdhPJzOj7jeZpv1+qG45pcMxryGt8tD6hrSSPeZ1vjoz3D7oBfTKsDKIdE57PLoNbpgdqliPbyhJQ==
X-Received: by 2002:a17:902:854c:: with SMTP id d12mr5535900plo.343.1593238087725;
        Fri, 26 Jun 2020 23:08:07 -0700 (PDT)
Received: from localhost ([2406:7400:73:59a9:908:f18a:1156:5c38])
        by smtp.gmail.com with ESMTPSA id x17sm12623639pjr.29.2020.06.26.23.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 23:08:06 -0700 (PDT)
From:   B K Karthik <bkkarthik@pesu.pes.edu>
X-Google-Original-From: B K Karthik <karthik.bk2000@live.com>
Date:   Sat, 27 Jun 2020 02:07:58 -0400
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qlge.h: Adding the missing blank line after declarations
Message-ID: <20200627060758.aqcqs763rjoxn6cp@pesu-pes-edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uc3xmhwmmyrchpyj"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uc3xmhwmmyrchpyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: B K Karthik <karthik.bk2000@live.com>
---
 drivers/staging/qlge/qlge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index fc8c5ca8935d..0b971a633001 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2224,6 +2224,7 @@ static inline void ql_write_db_reg_relaxed(u32 val, v=
oid __iomem *addr)
 static inline u32 ql_read_sh_reg(__le32  *addr)
 {
 	u32 reg;
+
 	reg =3D  le32_to_cpu(*addr);
 	rmb();
 	return reg;
--=20
2.20.1


--uc3xmhwmmyrchpyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEpIrzAt4LvWLJmKjp471Q5AHeZ2oFAl724j4ACgkQ471Q5AHe
Z2qsiwv/ePdacbSqM7HjdTGbMfaQorE4XMc5+PfBqp9J4zHmenJXvSWW5dBhoS3r
PikmkdGfXpx95NW4V9i6FKWvikrMv/4wSwhkA9IwzLX8UXm/hK+qUBd8axHf2lxI
TQiqvIZYRi29CveRcxedUk1ABBARBCG4ULtleTJ6SSS8ISWUGRFek52FkKaoM0Pg
eHQqZJvBo3bQjpZdq4337knL0Xt3la1ZZxfz8ku6Ihd3CcQ/qa3Sq+eVzPtr/qpG
E90WoWBKMpjbyzjPpcZymW0nEHroIvryPRCUdGYomoHq+ep+VllFAxANTlOKpS+z
UnylebC5mFe8YZsvleF4Sj5fR0VUp8q0NIqCfnEQdhdESn5hX5SfutLXE5hcWOhI
l0AzFcaknLaTUXAHPfJ4vsQaGaCS2yKal07y2y55urwe7Vv9AnbZAjg2ZF4AzVRm
gRJfNEToUoYSFP7MAhQu6zLvToI7m4Mu6XV0yfKPX5c39a/7p68WaBGNrzN+Ybaa
yy7DoEiq
=35Tf
-----END PGP SIGNATURE-----

--uc3xmhwmmyrchpyj--
