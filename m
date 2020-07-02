Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97521211F02
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGBIkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgGBIki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:40:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED39C08C5C1;
        Thu,  2 Jul 2020 01:40:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x3so6704178pfo.9;
        Thu, 02 Jul 2020 01:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=AeaSQtniWWM8/+wvy+sNNOb5mUXTofHpZfTaKxLBkbQ=;
        b=kTA4ijKUtPHNOdbN4/HxBECG3ezs51LEBwwhOeipwdFlT36npD9ZKZ2+qmhO1450ps
         RL/Dem+OAh+3tbDe+BCkAOcuyXCFAninLQcVRea4hlxR8Fe8uo+nCvtfq43NJ4DEWYEU
         w7kD9FGt7st0z+uIplB/Es5l7RQh+PlaC/kdZYNPFDSFSNi7AkenrrEvglQ5w8OxS4m4
         3Oc53SufLILp0GEgwJd5+5xHMJ46N+lTccv22o8rFf+ecZLfK1R62Mk33tEai8Uhmphu
         PRJVK3NE87HKldsnSF6D1Q35G8Pl9eo3VO0GzolZHZhzztTA6xqNcO1wSY1BvfxLxtnL
         /E/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=AeaSQtniWWM8/+wvy+sNNOb5mUXTofHpZfTaKxLBkbQ=;
        b=uRaZ9ci+rMRWfys6hSH8Vlcs+vHX4wHlQKwvhvctu9AHQMZk3Mciwk7FmlFf3FLgNo
         ACDvx4GgaGA3eVOKTajI18okM8IcKNHng7ArJZpJBR/GslSJZBvUaaHflqTLJk9dNqkj
         2kjijBWHmdXdJREfRQLudPVoig1gg7wB1MyWY4YkikPZ7Gg7Ok6bPcszhyx6iSv5QsOc
         qYGTTfbMJJat9DY+sgVjbAlib06Op5QeyXhzsPq82NHSEelyyDwI91NisXG2TX4871Hv
         8y1cQjo+fOLY4JuZI9ehXkV9tTDIZCbmbox/v2qEHpQitjxT6Llg/+t7pCSUJK6ZWvj8
         h9Gw==
X-Gm-Message-State: AOAM530y2NIiHTynDlcj+gRvaewyKWvDgkm9TJS2casWpgs+sy2dOtn1
        7drIx6j4QXwft+uJsZgNWgg=
X-Google-Smtp-Source: ABdhPJz/MSY1IXTrNWGABV1mCQ83a+iIMGDqFayYtGn8InuPZTa1IJZ+Y39vR35ar8BjH5EGMNm9nA==
X-Received: by 2002:a62:c584:: with SMTP id j126mr4164201pfg.213.1593679237913;
        Thu, 02 Jul 2020 01:40:37 -0700 (PDT)
Received: from blackclown ([103.88.83.142])
        by smtp.gmail.com with ESMTPSA id ia13sm7153883pjb.42.2020.07.02.01.40.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jul 2020 01:40:37 -0700 (PDT)
Date:   Thu, 2 Jul 2020 14:10:22 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, gregkh@linuxfoundation.org
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_ethtool.c: Proper indentation.
Message-ID: <20200702084022.GA1586@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Remove extra indentations from if-statement.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlg=
e_ethtool.c
index 949abd53a7a9..16fcdefa9687 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -528,8 +528,8 @@ void ql_check_lb_frame(struct ql_adapter *qdev,
 	if ((*(skb->data + 3) =3D=3D 0xFF) &&
 	    (*(skb->data + frame_size / 2 + 10) =3D=3D 0xBE) &&
 	    (*(skb->data + frame_size / 2 + 12) =3D=3D 0xAF)) {
-			atomic_dec(&qdev->lb_count);
-			return;
+		atomic_dec(&qdev->lb_count);
+		return;
 	}
 }
=20
--=20
2.17.1


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl79nW0ACgkQ+gRsbIfe
746epxAAqhB9h48Tx5kPCpUxqOqszOxrTaar0H8mC+KqZmVXOyjquvNRKpeV6Lg/
D5ImRvLVMkWzMu7hqxFY0S89Mg/CQznGJJeaBaU8WyVfR7UJJOTk5mlRDMPc5IlW
E++xnUQtf786os2G7DZBYoBWGompSWFVb8/aI+nef9yBPaUSJVmxcp3HNM+UW3pb
Sl0h7oiHfHVDSgvV1mWNurUSX9u6sGutK0DXPkeeJEbt33x3GPRNcKbIDTH19mfA
GHYY+aE+xpLim9Jt9oVFjR2d/Q2YGz7bgxoQaEIBmRpHU4xTPKwph31cTmO/e6PJ
ebHHsFaeEQVIEWYoSKZI+1fi1FY2NWk8ySnbclCqG/itFLCDlXomV9rhBeEYT0KY
xEEPZYTtmTuECjPuDAyw5ii7KwTDWE0ja2rqrt515kEr5uV5RCHNucmzUn9kH6+3
HLsk8JfzQU2y1uCwI8QfXSF5nSJSOFp4QWoScF5vHvhpC3u4TSQELzXv7iyunXNV
Cy2OBT9HgdK+HF/XvmyQ/dQUHkAH+UB5sif8Pdjod7z+KKnqjTO1vHR7sCqTjrUO
wB/zIJWiSd4mz4aMoDiLyoHE9HiBLvDFbSwF2ueqGGEEGMQv9nn7EG7FaGN9vQ1P
cSpXrKQ2zwfG2HrLjZ7SB5bAx26rhnd/cCgvwvzveuQlfhOnUIM=
=blIl
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
