Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B39C21D59E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgGMMP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgGMMP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:15:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA7C061755;
        Mon, 13 Jul 2020 05:15:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e8so5942490pgc.5;
        Mon, 13 Jul 2020 05:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8Bd18iG9vCcX0nUpR3BP+ydXyAf6vRysHhu6KUZ92qc=;
        b=PYbQPk6ScnkaZ4g/BA4ZnrmiKRDnyFP1vGNS51TnxTLOaf/FhXfGQCPiInMeMhInUw
         YWGPgDiD8owQvMxBBSP8JfZGshWG4OhVT7bTlhkY/dvIrMzVYsbEHdSOOi4cQ9LqIseY
         VkmdUczIMpynaZWH2CpC72K8FL3LPVFRwG0AKrDfrRmg/Vix6kPRhljczObw2Gjh+0p/
         VGKMuMKdaVXs02GVks/+TqVIG/Kln1w5RrYwjDa8eCt4+N8mvc6YU5NT3393qDnEv6s5
         JTy/6KjGc7TlEbjpQltup3qWFFsC5oQoJka2nLLTPSHH0KZAocKSj2jvQ8i5armd4nVt
         YhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8Bd18iG9vCcX0nUpR3BP+ydXyAf6vRysHhu6KUZ92qc=;
        b=jck0cBasBN/gy6BxAjCdFFlVzeXOcmzqyf1/z4NBxVNre5IvxXw9XaHKiqRo59tFk8
         3rqKowCLYDqj3RFkSKoMUrUvrFi7PmYriCuQpoDnUG4MmJtl3EGXtwxqzRct0nr0cmz+
         XUEP+zsZ/WCfJ2Ewyrt5L7bc92EVF3wJ0Kbmffk7QKw3zXNZhrBhF50qeP3M/85EtzAk
         Upg3OAulEvRrqGqQ++uIvpDnd35E0rR6jSMI/mTeLp4DVrtWvOWIfLr0k0Y0aS0gcixG
         JyJdkYN6VP/nrI5gB54ZVRWWIRUnMLMoLyN4FtxxUTydc2KbZWS/iG39k8DYg+30nUAz
         p9Wg==
X-Gm-Message-State: AOAM533qCLMvEjEnx4ys+X6ZTL6ITmYJliCca8YG5fk+LHQoQ6dnb5iV
        gb9znDjBaX/1k979/JFm+l8=
X-Google-Smtp-Source: ABdhPJyJRRXa0cl7yhntHQcF3oG/uPqhQK13oumMobVmU8Mqr++7rCVUKqBoOrNVCddrm3coSm4lrg==
X-Received: by 2002:a65:5c43:: with SMTP id v3mr31606569pgr.214.1594642558445;
        Mon, 13 Jul 2020 05:15:58 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id s6sm13986189pfd.20.2020.07.13.05.15.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:15:57 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:45:45 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: qlge: qlge.h: Insert line after declaration.
Message-ID: <d14343ed4ea3d4428f93a63bf1f52804ed5938e9.1594642213.git.usuraj35@gmail.com>
References: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <cover.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Issue found by checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 48bc494028ce..483ce04789ed 100644
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
2.17.1


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUHAACgkQ+gRsbIfe
745RYBAArLDStnRrNs1xqDmmdNjPhVZIoGicIdNlVVrpmanuab3e5V36Ey3JlE2D
xk1NmfPNHTh1OwJylsAJA/CyRUDU+prtrIdoAMkkGsuxH6tKv9u8XeWXkQW6aO9p
EHRsqF+b1CMSz9k9ZAPI05ctRCJlXwaGMIkg5AJkjTni8pOVzibPchXJt3GmnSjo
roWck+1OkwWfxT9D4MXVYNncJx/ztiwfGb+rdWRhvWbi4XUU2d+5n+5SkV7gz/71
oBrpxwEf2GP5u6iHmY9F0YMMGC0HxDX7GpMeiNoRQiCHxCiKvyWT1PeFpRZ7wBPO
BwED/l0kPMeGT+1E2YsJCouLbZ9/9VaHBibL1SVous2/vyfa0ajXWU5keQhIDZX9
UmvdBw0xLCaYOKfYhmsAzIOSsG1DnZnGSNz3ND4QLvS6vgA/Y6iCzrLLZCWOHaFo
sSEdQi2iGfNp9qb6qRQ1l3nvZj923KdkbbIkGKJ8Gv3dKJAXhK5yKe2NnAf1bTlC
jBvkmRD9NWHSgQ7NcvEOWbvG/XiXwZkAfaZ/OBrrmz4d12u7r+K2X/SsMRQib4Vh
b3XAvIXLI/6y4cJg0XGhWvf+xH8hIYsK0olbZWG9KLGiMgvzL0sNikzy2A38+LoO
p1J386gnLtIiWis1K1UBtAKWXRqx3kfVztnWtGxsW3LgOk9Sq88=
=zD9S
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
