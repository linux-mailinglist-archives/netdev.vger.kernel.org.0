Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A404721D5BD
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgGMMV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgGMMV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:21:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CFBC061755;
        Mon, 13 Jul 2020 05:21:27 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d1so195163plr.8;
        Mon, 13 Jul 2020 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cki76ZmEeDDcGT7rOLoYZ50YvAXxj5RXIQZZO2QF6O4=;
        b=Ui1qy4dt4DSLu3bIckG7hxqFXy1PzL+ug7fWHvwhMDFAezX4UqKH1diYFKWQ84CnjC
         YU6uT9z3FFg05i45wRoGddN4yJgIo2l4YnnnzLEr2bxxbw1Pc+4MtJsdObrvlCzXv4eC
         F5QdElblavwOP/75FdDQg/Lo0YatOB6pN76PYAD1xz7WJ599Gc1zp+OjmrajhZunsn/S
         xDV6g22Ua2Vy8/c1GU3dQu/8AlMEFkbPhRPq2sjfl64Ks4GS0/fDoSpg1WFqWG5n9FC0
         xhHxcYcIgrRqnan/yFXY3/T/HPaQTfFZ+xT3J10Fp3ZyNSSQaPUIo27y5gCkGCxHaMpJ
         L3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cki76ZmEeDDcGT7rOLoYZ50YvAXxj5RXIQZZO2QF6O4=;
        b=Uwm0e56D/lsMUFns/XsCPH9Q1PGbYMTbZDkX9j/Fn99wm+jxu76qWVecJxJ4GI/eU0
         y201+8DCyLzGDx3Z+nAuRGJWeJohpstl/wSz/vLX3sBVuTkXrC3eKNHz9VrSSEXxlCWm
         F6llY27lBGCFVphmyizDEWDB/6q6+P/lfW7JDarIxwo2BsC2p8SNCTNbuad19FRC7CA6
         hz5YeBVqElhjt/nCqOWeFawGCf4i81ZCQRZuSG6RLfB0vbMTQCrvzJQRDjs71EO/111M
         XdtobJouu9qzQUYkzeLupcD/35pbPqiNJMqRHZCjioHts0JprSLV93AiPvVlAuCaPcqS
         VM5Q==
X-Gm-Message-State: AOAM532JppgAXItoAq7dH9rMPCubQowFEWjRx6aMbAkDiMYxybCn5JX8
        SUnC61fedXOucvwQ0uxPNXHI3JuEg0kHvg==
X-Google-Smtp-Source: ABdhPJxWJipx8fidhaPOMIo5epQw8qjFksBqB91xP2EBRad1jlJxdbzfpzn3/HfqmFS5QDZvnre7DA==
X-Received: by 2002:a17:90a:b901:: with SMTP id p1mr18254452pjr.134.1594642887495;
        Mon, 13 Jul 2020 05:21:27 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id n63sm13022690pfd.209.2020.07.13.05.21.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:21:26 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:51:13 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: qlge: qlge_mpi: Simplify while statements.
Message-ID: <6eb96e8c074bbdee3838b6421d25b50f1faffb3d.1594642213.git.usuraj35@gmail.com>
References: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <cover.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Simplify while loops into more readable and simple for loops.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge_mpi.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mp=
i.c
index fa178fc642a6..3b71e5fc2cd0 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -17,36 +17,34 @@ int ql_unpause_mpi_risc(struct ql_adapter *qdev)
 int ql_pause_mpi_risc(struct ql_adapter *qdev)
 {
 	u32 tmp;
-	int count =3D UDELAY_COUNT;
+	int count;
=20
 	/* Pause the RISC */
 	ql_write32(qdev, CSR, CSR_CMD_SET_PAUSE);
-	do {
+	for (count =3D UDELAY_COUNT; count; count--) {
 		tmp =3D ql_read32(qdev, CSR);
 		if (tmp & CSR_RP)
 			break;
 		mdelay(UDELAY_DELAY);
-		count--;
-	} while (count);
+	}
 	return (count =3D=3D 0) ? -ETIMEDOUT : 0;
 }
=20
 int ql_hard_reset_mpi_risc(struct ql_adapter *qdev)
 {
 	u32 tmp;
-	int count =3D UDELAY_COUNT;
+	int count;
=20
 	/* Reset the RISC */
 	ql_write32(qdev, CSR, CSR_CMD_SET_RST);
-	do {
+	for (count =3D UDELAY_COUNT; count; count--) {
 		tmp =3D ql_read32(qdev, CSR);
 		if (tmp & CSR_RR) {
 			ql_write32(qdev, CSR, CSR_CMD_CLR_RST);
 			break;
 		}
 		mdelay(UDELAY_DELAY);
-		count--;
-	} while (count);
+	}
 	return (count =3D=3D 0) ? -ETIMEDOUT : 0;
 }
=20
@@ -147,15 +145,15 @@ static int ql_get_mb_sts(struct ql_adapter *qdev, str=
uct mbox_params *mbcp)
  */
 static int ql_wait_mbx_cmd_cmplt(struct ql_adapter *qdev)
 {
-	int count =3D 100;
+	int count;
 	u32 value;
=20
-	do {
+	for (count =3D 100; count; count--) {
 		value =3D ql_read32(qdev, STS);
 		if (value & STS_PI)
 			return 0;
 		mdelay(UDELAY_DELAY); /* 100ms */
-	} while (--count);
+	}
 	return -ETIMEDOUT;
 }
=20
@@ -913,10 +911,10 @@ int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 =
enable_wol)
 static int ql_idc_wait(struct ql_adapter *qdev)
 {
 	int status =3D -ETIMEDOUT;
-	long wait_time =3D 1 * HZ;
 	struct mbox_params *mbcp =3D &qdev->idc_mbc;
+	long wait_time;
=20
-	do {
+	for (wait_time =3D 1 * HZ; wait_time;) {
 		/* Wait here for the command to complete
 		 * via the IDC process.
 		 */
@@ -946,7 +944,7 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 			status =3D -EIO;
 			break;
 		}
-	} while (wait_time);
+	}
=20
 	return status;
 }
@@ -1079,18 +1077,18 @@ static int ql_mb_get_mgmnt_traffic_ctl(struct ql_ad=
apter *qdev, u32 *control)
=20
 int ql_wait_fifo_empty(struct ql_adapter *qdev)
 {
-	int count =3D 5;
+	int count;
 	u32 mgmnt_fifo_empty;
 	u32 nic_fifo_empty;
=20
-	do {
+	for (count =3D 6; count; count--) {
 		nic_fifo_empty =3D ql_read32(qdev, STS) & STS_NFE;
 		ql_mb_get_mgmnt_traffic_ctl(qdev, &mgmnt_fifo_empty);
 		mgmnt_fifo_empty &=3D MB_GET_MPI_TFK_FIFO_EMPTY;
 		if (nic_fifo_empty && mgmnt_fifo_empty)
 			return 0;
 		msleep(100);
-	} while (count-- > 0);
+	}
 	return -ETIMEDOUT;
 }
=20
--=20
2.17.1


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUbgACgkQ+gRsbIfe
744j0BAAml5FSW/ygInduWmN/rnZuspzhKNrOe6M3jiw7lXtwmO1JLGN9oxZWn6+
aOhiNR1ZL0/DdEESgNtdoOKPsKKX36ozZzvZtwrgH+NBqWzY4FgQqh92uENydYKZ
vASJbd1WW5MvTl5FlRQJ6/8FQo3ZZZGOkwTXMT2Z+0KgiYoy1YQLIf+0wvU46BZ3
XL8xl6b4a/OtXFuab0kJfDfa3NFYJQIoJuchs8ryArNPuIMKcNpEdLI1uaxTBPw4
bCL0syflavmRZ1WrZbG4OPJTGwMiRH7sde9AXuuMXm91fD85zKRgvJ4NrNKL64XQ
s9UpQSt2v2dRDyRcv4UMgoHTyTv9FTwRm8gHk2CoayFSiQcJqg8M9cPz0oFrmjis
+8ys9vnr8kQ2C3bgZcf1G7VpwDH8qd9swbLYxPsQIMcTH6QAV4ZvZUB7X8zbwPxw
p8Dx2xjo5pl3Fk7jt4RhQojPO7A+C2AmJvEbhFbitTEPi0pq+ED99hodaqQ8XFDF
MX6HIXXq0JKSFv/8N+yzzDdV0pNOo8N0rMfudDYvvmW79kd2Uauu12SaqvWk7b2Y
meEwJMutjYf/zPl3EEEdup20r/qUBgiITlczoFsBBTLTvtmQEziAGh+yXOXWisDv
QGht9P45rOsI22yGPXCk7nktUmu6rWxQaNswpGD7tzzASY9uxeA=
=YpMj
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
