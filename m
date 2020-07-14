Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00D321FDAB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgGNTm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgGNTm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:42:26 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BED1C061755;
        Tue, 14 Jul 2020 12:42:26 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so8017344pfm.4;
        Tue, 14 Jul 2020 12:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=PQoiTk/94i+cEQXK8JsAB0AkTjYJXwZwOn4dJ+xwUDg=;
        b=AXt6kevxd3MbkPZ1VCvIa7CWEeXW1Hnzu9JlVFfg+1OzvgzUAs4ASun5mkK+0k500o
         54P7OkAxIMaeRNbb/vjw0CL+AutZpp0r7vyr5oyUq4ShbS2sVv/2A0MWOOff+TCUY+GK
         pKhZ2JjaGSpeJShOUUlm56WAoCdzjQg0SPcnrkLVptvoSMr5T1Sf0HXgY2zsFwfsPWm7
         8xSYOIfbXa2kgyKX++hsK8Zo0qwamVWWPEzJ9ZaztPc5qb4phTanBGehRlouMu37JdT2
         E1mOz3JeXHs6zZyqFIEezDNeKtT8bcUCsxRPjyv/6wcz6xCO27uD+xryOUOnbqiuvk3/
         s5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=PQoiTk/94i+cEQXK8JsAB0AkTjYJXwZwOn4dJ+xwUDg=;
        b=DESTiRP7FsW38nmw1gQZbi3qU8xRLcn71EQXmRD5PyMl6Myay80O6zjOZ9c7TqFjU6
         j+wLU/+kBEMs9x5pqrBamK8lKJkUi5xorzW7eMaWwPlajXxKz04W/KUUOqz0IKA9UmL4
         0TZpxxacJ/CW3hOM9jK3Jw8ibWPIz+u5fCx8wrSecRWWbJigL6CiKskrvC8dfjodVy0g
         DKrx7/oBmOW3GJ7626jGHYcPEbZktjs8w2UUX6vCGdW+c/nrGaQM324liUAtphPLK5W7
         yT2DXWPkIxLD424E+u6vbOu5zXVRg8y2CsQk6aM0x7q62bmoPJvXSbWgTLYlwiZwTIBP
         DQBQ==
X-Gm-Message-State: AOAM5323sFKUVeqHJAVqZsecNnmo+Rdj+nIAURbDUOhKFhZQhzj8dArv
        ysEUxseC+GZIf7pm54nw9bc=
X-Google-Smtp-Source: ABdhPJwAec0PSq8vCkDHhMwK5e+77YkqFKNDRznTfSIalx/Ujpnz4QHpwP48pufGGWmOeeKFrr9t7g==
X-Received: by 2002:a05:6a00:f:: with SMTP id h15mr5547490pfk.193.1594755745915;
        Tue, 14 Jul 2020 12:42:25 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id g6sm10805pfr.129.2020.07.14.12.42.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:42:25 -0700 (PDT)
Date:   Wed, 15 Jul 2020 01:12:13 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] ixgbe/ixgbe_ethtool.c: Remove unnecessary usages of
 memset.
Message-ID: <20200714194212.GA21612@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace memsets of 1 byte with simple assignment.
Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net=
/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 6725d892336e..71ec908266a6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1951,8 +1951,8 @@ static void ixgbe_create_lbtest_frame(struct sk_buff =
*skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size >>=3D 1;
 	memset(&skb->data[frame_size], 0xAA, frame_size / 2 - 1);
-	memset(&skb->data[frame_size + 10], 0xBE, 1);
-	memset(&skb->data[frame_size + 12], 0xAF, 1);
+	skb->data[frame_size + 10] =3D 0xBE;
+	skb->data[frame_size + 12] =3D 0xAF;
 }
=20
 static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
--=20
2.17.1


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8OCpQACgkQ+gRsbIfe
747X5hAAmO9wn96MNt3fhAqcRyBhBhOvp01FWsT+wzrwjc+1bw4lkhROTDcrOjpf
1efjH5SijYmhpe5WwtmmW82lLLBf8Dz1P3z50LDW/P/Y4LJBJa401d+iUubw8VNI
an0hcZ7RqJuxO9P4LI1HT+xa7OlI5nZB1bYEPToeQRdbutLXZg7KmIP/mlMYK76i
2e4cj0oVCkKtYcsPTK6tMCAmWFhR58uxoiS5OVIqz2r6kyISMplwF0rzv3uUbz8Q
hUBh3dtQfoAENaSTlvcWCb8Bpdgp/DoaQOPgRD97nxbWmaX+byg9elyzElMjtvKv
6oU5D9FuDSnO4Z+qciTkajLE+hq2rBpN44WA55DDBcT2q7wbaVtfu18+GJQyUhqb
4PBKeGLLnVORKGhbEtofmDV1mSt+GjvW60YIkaJlF084Our7850xWdqO7jpd5Wtc
jfGQph7TTC7Myqk6xi7foWRe7kuTZNuProC7DFN9z6idow/q9+PVrO2YKEI8pDwi
xj6g3DLurusKneJR1wMFv4T1iU7/Aafc5q90xwSGAku7/W155CO7LR6OkA6Tv/Wg
AcFMBtKyTrUL+1q0zb3eg36DjpH2Tr7T40mtyK5XPo31Bv4PIx8Q1XjLXbCFaDtD
pST0Sam3+M5Ng88ktcGITfbvLzHQ6bNJhGbDstTbW/tqCRZ9peg=
=mpgA
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
