Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEABD21FDA0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgGNTmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgGNTmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:42:00 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FF2C061755;
        Tue, 14 Jul 2020 12:42:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s189so2993840pgc.13;
        Tue, 14 Jul 2020 12:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=U6wnNdQGYzjTM+8H6Cnp8bIF9ECNSsdex0J9VIEDN8k=;
        b=WEBXB6igBdu6ROj5Tdt64QJhL9xOAqNkJGXW4MpgsabaGHtlIGrooBXTq2dhm+LkN8
         s5ZXTb3KBqo7i+kWvyGCtH390hxDCSYK4tJfuN9GR5b8UOq1qxOE5tclLpgxfiRt/jLN
         fexCwCWqOc/97/UfokXolHj9N/jgDWsCahnzPR8tURwoHDXh9BG6AModtiVlIrhpnm6P
         UlRVg3weGUgWq4TV8OZArK7KTH22VzL8415ELf9x7TATwVBhKRUPQtEHuekmIEqztx5R
         LMTt528AWoPrcr3bBZzx70w+ZsP+2l8Bx3omLxio+wt2l/IqwUdd86x+AKeqxbihbTmr
         gXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=U6wnNdQGYzjTM+8H6Cnp8bIF9ECNSsdex0J9VIEDN8k=;
        b=Ip15Brb4hB8KMM+zCbcWP661PDpCxpOOhzsrQj0D4oPM2bd+cTS72E5Ns1I2sBB0I9
         l7VlNQkkVyWk4WCpe4hMP58JKRLimxg5kkGueKhoRwceecwcApz9Xd1pRdzXVnMa3qT3
         iBnXsy1OdqVxSNP7CsKt1GwtIByDyFAfc2wywVKIypZ4SkuM+eB4hnU34PR7KFbx1Dba
         tik1oKoJBujwDeLnyhMhIrmJr6MSU+ZhIZQnBhX33t8XHSAtQg/1D/nI120dBfw0eC8d
         lJjw62dvmak2tQjLnVTjLHlUT25VEt3Sp6n2PPYTU3IjLYdIh8RB9hxL4F6DR5p4M14A
         jopw==
X-Gm-Message-State: AOAM530fnhSQgtAFpllmj449sseP3bbAbF0/OiFOET72xWuzSrj57xOd
        XlVjUH2PQ40txJf/LSoXWiA=
X-Google-Smtp-Source: ABdhPJybSvB/F9GjQ0jmE43Re8wHuZG9KV1oJjCCUTGugBHRSsDGybtJm4nzTYbu5nOAY0VAf9qYGQ==
X-Received: by 2002:a62:8f50:: with SMTP id n77mr5343854pfd.259.1594755720063;
        Tue, 14 Jul 2020 12:42:00 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id z1sm16815171pgk.89.2020.07.14.12.41.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:41:59 -0700 (PDT)
Date:   Wed, 15 Jul 2020 01:11:47 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] igb/igb_ethtool.c : Remove unnecessary usages of memset.
Message-ID: <20200714194147.GA21537@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace memsets of 1 byte with simple assignment.
Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/eth=
ernet/intel/igb/igb_ethtool.c
index c2cf414d126b..6e8231c1ddf0 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1782,8 +1782,8 @@ static void igb_create_lbtest_frame(struct sk_buff *s=
kb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size /=3D 2;
 	memset(&skb->data[frame_size], 0xAA, frame_size - 1);
-	memset(&skb->data[frame_size + 10], 0xBE, 1);
-	memset(&skb->data[frame_size + 12], 0xAF, 1);
+	skb->data[frame_size + 10] =3D 0xBE;
+	skb->data[frame_size + 12] =3D 0xAF;
 }
=20
 static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
--=20
2.17.1


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8OCnsACgkQ+gRsbIfe
7475jQ/5AdsAUEVRQdc0hTq29NBB9KUt2H2J6niOmK0ZE2cvKvt2rxRQ76d4r6pt
rWTD6v4FckiDuyoazjH5tZUlIVxVCFoybnpsS4a0aq6rQZyjZXKpTVwCwQH1tqDf
QxojbKNVKORdyI/u3x7hsxSKdKALPVQVYpUvNKGE2hSIm2+/jWIjXnyPlyCBmZOn
VesYzQ1PA2rPDccWHCXp3ijtGOXXqEu+hDOZbmzgtn8yc2KPSmb0zutbObL2Nl/m
OYTLUtDzNOMGeksmqzX+4EZ2ZrwaZ397zqGuKdxDKHKup5LWVf0qLaWWIYZiLdhD
mzWAbSWOKzVd6jOn/e2WKKin1TTN0wC4qgN84XXkyfrSE3ufpGAQsW2zhfgqA8jD
XPPfu+SHRXuqLhYApiNuhZh3ePOQjmcwCZ9TA7/YOMLrgIRNpwqRDY0PeFpWjjr3
OUbsPnCrRx3w1JkmslRaFwSE98wGDTmWZovT5bf6jdkl5i0xyHtXNWF4d/gg3Sre
0+EFSerViO1nMFW/w1qizuuSgwJBP0jFSxoM6RAl28gTH+Bj3g9TKC9YO49RM41G
tO1GrK/JksnXEkjQf3Orjv4hdqB7efDfYKG8kha6wchPfIbNM/N9yEenvZjUi9PN
NIw2hW64PEoYg4CDPDHISme5YPt4j20Sb3XhWU+lzUCvaNFY1+k=
=cAMq
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
