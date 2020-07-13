Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39021D5C5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgGMMWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgGMMWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:22:37 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B7EC061755;
        Mon, 13 Jul 2020 05:22:37 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l63so5935903pge.12;
        Mon, 13 Jul 2020 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0RMDbjaPD2Rgozcz6NNzoKM+l4091XQ9SNeTMWL0Djo=;
        b=ppdYDAQatitZqfG1im4awtx1FD2ZWYLFRQ4caN3iGHDAnmexJuv1UdgtD7sIQ56iig
         GS/uH9soZQseDl03wLejO4gbd9nP6oTvbTvKbN54kvarJ7E1iVirTNKwOj1t1GjaupEj
         hVknIgqFmpYo9Ojr5PVhnroM9s39cUtPzXId76W1sJy/sVyKCRPyNv18WIHyEJ0/3vIi
         7RCo4m1ru+NSmfsoysQT641FbqJnxQ3Z+eg9QLI//y3ihz8zHTfsYtnyk9jw3PT8PB7Z
         ttolZHnBmeAHYC494ciIuw0GwhFMyWZU6BmUMNxD4bvTB69KMPSTlGU0Z7vuR5IB5Kh/
         SSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0RMDbjaPD2Rgozcz6NNzoKM+l4091XQ9SNeTMWL0Djo=;
        b=ZFVdQ53uVh7rMJY8Nyi+Q+IYOYNsQ+KuSWzriY2ZkqgoKdEelpBqUkNukvTMw9RWWF
         FE77sIgaCSkjVCcC9fh/JXJcuoTFMLdGRlMek+URE0AKUH2bSUrR/mPFwKU4fA6xCoAT
         hrbkRJwAympv/0IDvysWEqgdj395SB96i21CJR8BZ7QEJz/+W158+svj1G37u+bwU1s1
         1HXJTIjIHYB5LIOrqXZeNotZasZzCEQaELBDoXQMqt6zLmsB+MjsATXyycnGaZXLAg8P
         yDTagxkzjYYdp9ReJ30g5QjzsA6r3Chw1e9Ys7BuRVCzkARVWkB7yltfiPxfRYUql1xt
         NDwA==
X-Gm-Message-State: AOAM5305uigY8zc3DHOc6UhOHc/IqjxH+qIxpeDy14xOtv64vgNgJg9Y
        EBNd5DYg/agBpiN5MLC0W4Gz01PZvVVBZw==
X-Google-Smtp-Source: ABdhPJw8t3H2TIVAP/iCVBWVk67F2HutQVfsdtkW++vfH6Goo3lwW01UFXj5eDxTuDeQuD0JRh2yLw==
X-Received: by 2002:a63:fc43:: with SMTP id r3mr69027673pgk.423.1594642956799;
        Mon, 13 Jul 2020 05:22:36 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id z11sm14572417pfg.169.2020.07.13.05.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:22:36 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:52:22 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: qlge: qlge_ethtool: Remove one byte memset.
Message-ID: <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
References: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <cover.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Use direct assignment instead of using memset with just one byte as an
argument.
Issue found by checkpatch.pl.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
Hii Maintainers,
	Please correct me if I am wrong here.
---

 drivers/staging/qlge/qlge_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlg=
e_ethtool.c
index 16fcdefa9687..d44b2dae9213 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -516,8 +516,8 @@ static void ql_create_lb_frame(struct sk_buff *skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &=3D ~1;
 	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
-	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
-	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
+	skb->data[frame_size / 2 + 10] =3D (unsigned char)0xBE;
+	skb->data[frame_size / 2 + 12] =3D (unsigned char)0xAF;
 }
=20
 void ql_check_lb_frame(struct ql_adapter *qdev,
--=20
2.17.1


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUf4ACgkQ+gRsbIfe
745MeA//eOPYUZZBvikSwuQ7vENTroFg8ffHtqpBbvzHEJA2XVt7DVijXmBYLAaR
Le2O0Ytq+m5UiqehER9G6cHZaNa0094RPbJN9l/cuRwcdk/C68djuKXHUb4Y7Jbp
Dq8obmx1k+PvJlxnXVYuT3731oKdVH9nmtOKtVa0np+Kk2qBugL7cxYGpQZdV8dw
gfqr472+YOhZCfH3yjo2LqUQECmhsJaLLTn5yN7Y9Zok1UhgsBxF0jj7uh+545iW
zuY/EfWmj2AmDA8YcwuqngQ80z6OFJZuxkRUEDDep860IVhWszgNaWEhVSgV8hb8
e4ey6AeefyVzEhXg3j/1slrCkt++o0lRCuAEm49H5mMx/1qF3122Y8/OQH2P1RMo
mK0Kvowu3wlS+pYsSfh8hLtpAcig2/lvuAB/GR9wmsS7uChNguuwtv7u41u2iwNR
OQ+PJicb+IDOHo7qQ1LN7NHnseeFVwqBfeLfoX6O8zvQ6TpkWI+nfZwidLhWaAIP
aGPqrA9yS/Bkg/J/uOtnQFNcMBzw36PS78yM/NNBQil6x5cp67zf2Gbjt3//xfmZ
fT8yx4akaNZDd5lSjLZeN2ruDo65Kodp94ldBTNJm/rnrDzZphkLOlA6nXtzUtfb
vcBY5NlTXg6nflu3SKQPCT4+mg8CB4MJBjl3Vs1FconaBmZxQGA=
=DaQ8
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
