Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A6021FD94
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgGNTlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgGNTlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:41:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BFCC061755;
        Tue, 14 Jul 2020 12:41:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k5so7428106plk.13;
        Tue, 14 Jul 2020 12:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=niAIjn+Een/amQTg5fN18KJRwMOstxeUEV0t203OE2I=;
        b=U4GSwduRBIN/yTj+kSe1e3FhlYu/eU+cNd3YvmhAgwNpYObKc0ECpYaCaH/2CfjvbC
         IpqBWb44SwRTcVaIf1U3pUOENQcwd2PTZYbEDJTHLSpmuY0BGenZJkq4l2PIrR89ANoB
         KbkmGpnvSUb4wdeuAZQFz0x/z6xk61MwIgK+JTRIyzEYluvVUM7IaXpHFL2F17LFh1/s
         npt0w4UMgdTBr3F3ba5j6MX2kRR8wzeANYFiwaXeHBQjb1+62g/LcMhLNBdJcZI0CVby
         DwwZcRJTa6pQoanI2h7/ji6UxrcUQ7/VHgftXOKvybMx/C5wwtuPZGGddVHWEolYWzsl
         Gupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=niAIjn+Een/amQTg5fN18KJRwMOstxeUEV0t203OE2I=;
        b=SUnl8mtgfjIHzPTeWNe0BFJF8+7V6wqJduFqwd1pWlXgBSCDv7U78dxxodJ/d5eILY
         9JZus02DTRizUdUBgeuUFDTU/4CtxP5oBnSg0oSkwzohJ2VgGKlCQjHNVcCjHaIsOdpG
         IT0ZSrwVoAJapSzzQAv3kkjsWIkypFxQFmBpnnezQgTvOEjbljZZvEkfrXqBqrK6se45
         s8TxSo2wJp7fDiC7bWnvwMNVA1iHYj7iQ86uvHd0E8N9aX9MXrVMEO5XS6i+uEmCyy2w
         mG3+ogD3UfW+3RRsTPrc/fD2D1gO9M90TyMvw5UKngNI+eCC8Jqdat49O3ykQ1ygDHWP
         7scg==
X-Gm-Message-State: AOAM531XZN5jn0j20THUqq76qL8o48LI6gcOyNQAI3sM1UABGpI02sJ5
        MNizwmRgmFRKvjMFSPOMLKk=
X-Google-Smtp-Source: ABdhPJxnqN8nrX9Fqfy1W5R/qQtza/2Q/DP10I0i1HHBCyZOqj/LDHNKzVdELgVVBxO9fEp/MDav7g==
X-Received: by 2002:a17:90a:72c7:: with SMTP id l7mr6645940pjk.34.1594755690151;
        Tue, 14 Jul 2020 12:41:30 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id r204sm9234pfc.134.2020.07.14.12.41.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:41:29 -0700 (PDT)
Date:   Wed, 15 Jul 2020 01:11:17 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] e1000e/ethtool.c : Remove unnecessary usages of memset.
Message-ID: <20200714194117.GA21460@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace memsets of 1 byte with simple assignments.
Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethe=
rnet/intel/e1000e/ethtool.c
index 64f684dc6c7a..a8fc9208382c 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1608,8 +1608,8 @@ static void e1000_create_lbtest_frame(struct sk_buff =
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
 static int e1000_check_lbtest_frame(struct sk_buff *skb,
--=20
2.17.1


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8OCl0ACgkQ+gRsbIfe
746ntw//Up63f9QJZQqL9+A+8jZ6A99A9PBee7fkjHVtAiLdaVg/xQMJD3lvbrPS
MtdWfUsVOwvSkPGyGd8+v1XH3Xk/7mj2lFrG28fR4z2BxS8u3Kzu8ufiB0bAJH9n
8F5hGTzwJkplP20bPcsqq6z5ffvZicoIGmIOZra3tHRNM3+3TurVJi7zJw8Xnl03
PL5+EHQm5qbAG3iXsrx1nvUyPCHH6rX6fQH9PegcEt172CisnWx9/6gS2cF/U8Ba
dWMozeK11DnPt1z2bV+oGxsPiFc+L+y/SwhkV46FDmKasHwBCWTBClJW3royGu4u
O7PriCh8HYYqu0vu8CWRBPrwF7Ube5/ZBhnKmyjA7zUTF1LQyaoDSdTHajeaONaa
/uRuaqgI7GGioLkIXUxh4XdZQJE2WuuCl3sDW4bRidMI1VHliUNtqtXJ2ALzhxuH
bkh0cJY7WxYoDBbI1G6HVHcD4a9hxITTku13Dcg21Il5uKZ36WXzzb0a1RG5kuxx
5jAtEpxK4cW4kXipXPOXcEYoKmnKYFmTmY5hc+QLe0AOWsDUJdDP51Q/r7/eKS4X
swVlV0gyubhsZ36BL5sebGiM/IYCYvocv00PA8/9fRebNbw5nsd8nC/glcT2ekgR
+ISpehIiCZo3kmMmOQ/p/3beK4B5ZH0x/VdAWh7+vqIqfMHbzxg=
=eUcI
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
