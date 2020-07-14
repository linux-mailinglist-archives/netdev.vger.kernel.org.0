Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7C921FD8D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgGNTkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbgGNTks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:40:48 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4B6C061794;
        Tue, 14 Jul 2020 12:40:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o22so2000715pjw.2;
        Tue, 14 Jul 2020 12:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=wNJ0xqiQMwf9wWolmo2V4dwfmbUBzz5d6DDV7wSVVDU=;
        b=eP79sZLCqJtSL9WEEFX5EaaYP2heGJfFeAyQ6tvZshn/yxxu+m+xqfmi+SdX3bhtrc
         RJtmkqNoiZ4yw9eYBsVPjYCkFllcW4K8ObnGQfh/R1lOCK8Su4l5gURpSSiFk2rkmAVJ
         7RIUwCO6eyIRY6MN4N14tUg+cToCHO7udjv1j2lfp64Qux6zmV1IrlV2PKhQ2I0g5krl
         RdYNQIyzhUxe3RAnSzwOv3XtTNf1bl4HVYmWCS7DA8imU9NDoGKww0s4k59+gaqSBFAJ
         qoudDtigrhf+aETbaGdAWu2aDXqH3fGt94qWSFsRDd6YT7essvT/eYq2uRyFJVYdFrxs
         6XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wNJ0xqiQMwf9wWolmo2V4dwfmbUBzz5d6DDV7wSVVDU=;
        b=S99DAi/hco5dTwOffn3aMk69OBd7Tf1EhVaySvxu8MHBqEuntWxKIVYc+AUrlll9YT
         YDP7x+SrSEfRrQpR4ZAkyoM5tRPHe/mlE1z6cpuilzjRxWPpYWXLDvXnBcuwo9Aymn/x
         cSLtYCckgtNNWo7SvTu1SzTZoljqFJuW56kEG2I4k+AgGRe3Wrt6OymrxGQB6HZmZ0aZ
         x/e8pvvASJ0do3y9t9HxaISXJRuxhWEAebeYm81oyIeR4EnwAvjhCy46eMcblRsRPTfi
         ZqwN8FDGgQMy4wb6HxFzgViTxUTDvPIz72lqT7jxfQONp1rzPu1ipyRCp/Nxp7NBrmxM
         oywA==
X-Gm-Message-State: AOAM532uRqLTtTRRL5cjd+3DFtiXqe9t0RX/3FOmpuz08mtAiY4XUWhg
        ENjSpJo6s8Zsd122JZs5bYc=
X-Google-Smtp-Source: ABdhPJyyflRxQgKU+fmkrQq4IN69SodmKNRAcSYeuyBMhZoOiLpFcwnXc5U0QG974Y1D0I4womwZ+g==
X-Received: by 2002:a17:90a:1f81:: with SMTP id x1mr5717456pja.115.1594755648184;
        Tue, 14 Jul 2020 12:40:48 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id h23sm5569pfo.166.2020.07.14.12.40.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:40:47 -0700 (PDT)
Date:   Wed, 15 Jul 2020 01:10:35 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] e1000/e1000_ethtool.c: Remove unnecessary usages of
 memset
Message-ID: <20200714194035.GA21382@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace memsets of 1 byte with simple assignments.
Issue reported by checkpatch.pl.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net=
/ethernet/intel/e1000/e1000_ethtool.c
index 0b4196d2cdd4..f976e9daa3d8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1356,8 +1356,8 @@ static void e1000_create_lbtest_frame(struct sk_buff =
*skb,
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &=3D ~1;
 	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
-	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
-	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
+	skb->data[frame_size / 2 + 10] =3D 0xBE;
+	skb->data[frame_size / 2 + 12] =3D 0xAF;
 }
=20
 static int e1000_check_lbtest_frame(const unsigned char *data,
--=20
2.17.1


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8OCjIACgkQ+gRsbIfe
747epg//conbuZWFS5h8Mh9FCzDGo6kg8I5K3s+UtdTWXSIX5OEy34KmJAYx81fw
qGMZaR4CyF4O/0vI8KxgUMTPGxf77keTsSDQhU4fE9IPPfI0MhGzLM+M5gjUiTfW
Ireu76SCme6orWv6Z7+q6CVbLFYMIL7hslLgLTFI9+6MbX/IBqEXKPpa3owthbsR
qHR8u8U2VAR9jEyB9CdND4oCsrF1GabZS/Dx01Uf2+3MQqEe4fdMTwqBkv1v4Nm6
XDE3FCLqWNWzc4cogFPWpDFGu0esbD7WV3X7pUuiGVIs2HNUslNKKOMyWfDwU9Cz
qvp8GHUWKARttcEgNUjgVyjtQuLmSWrpFUHFCrulI+8ZKidk7GF0RLZ0MB43ha5u
/CQWJCSPwuG9mJPrSfekRvv1zd/QvyKqzTY4JHLoCMY5VWM2gZHb7TCZua4ZaAWa
psq4itAML6IRbO7mQn+W2W8plFxAiBeDvcblH2gJwT9QMi1P16mTm3rZUV4e+0bS
9MGF3DmKTUY73oeMfkTuKSpuLFjpdTIaupRwN5vxozSRVJSV3vXhjSlwx/Ie0wd/
t8vO1TIfMYmNmDwxIJ3jnAGaMwDhckg0RjrONCMWZHDkvafftruUDrYvghYDbZDa
HPZ1+0dcgPi9nATBTZrVeW4ucr9Mb0+v0bH/CmC1Gwx1caoGA24=
=53mg
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
