Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF6221F27
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgGPI62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgGPI62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:58:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26812C061755;
        Thu, 16 Jul 2020 01:58:28 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ch3so4463895pjb.5;
        Thu, 16 Jul 2020 01:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=rU2AvrUF1MSQNhOVtZSsFfE23nrV3JkloSDmiaF1rgQ=;
        b=K3HTu2ZmadRX8xzBvryPFb5wAdcUVb0mZ4VBzLUH2tP6diUz22RvUOt0KI03cqJtva
         ZKtTG4JRONNq9vH0+R6FxNCksupFsjlIpa25bMtCP4y3ZUrUwo8MVneh2tUtcYpMofRx
         CanUgsDK2xXw7GQQNnQQ1jZ8rcejE41OwnkDhu2iMGSzWq9CaLgW5RJEleHjDLGHNkKs
         NKiPdNCvxIUlWh6UdqPWeaiZ0Ur36VLTQl+Z6E9SIA+G43rD7GQN/Ftc1+kI4Ixfd139
         aBPbkXRGA/iBXQSsnpAJQ8lqLB/wHeqaC21gyFRZmzpyi4kltB4hQiko1yM4JqIjxG8p
         uraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rU2AvrUF1MSQNhOVtZSsFfE23nrV3JkloSDmiaF1rgQ=;
        b=PWMNTlJSNlauN2AGGYaV1IlYg4LsZq7jyddRTZK1Y9yve7DNFqqVdGFvm8t4NKruD/
         u10NXTFG4oF1tFZ7XbYnMNJlYd0Zs/ElKNODTRLnZtAMmziRzN2NLwQLEGSjYJas35pj
         RK7Bhr4Qu1GQ9+uwhOC27Mtahf7912wxa2fiqdofRArTxl34wmTHx/eROGNq4EEy6R1q
         nK+ZIPWLsS8IwXZ0PfKA44omif8K1hLp6SmoEEAoDByGf3754un8xbZpGZri35uqTAnU
         /y5lQ1AKWJv8SfXo9pu8+R43lPkh5bBVUkmvNiEhWCdFtW9HpK1TCN2H+/UQWmxY0UxV
         FN4A==
X-Gm-Message-State: AOAM532CXs1q3yhg0s9ONIusYVkU0dvaiPpVCwc4vEDaQqeEt7oSGJsP
        Pb+Tm+V7u4GRQFJgWBULsMwmEmM5ezI=
X-Google-Smtp-Source: ABdhPJw5wys6nZkU2EwXlUQZltuw00zMlClC9BBY3XvLGB5xWrjt9v+5HR5AWIyGOo0u67fCgTVgsA==
X-Received: by 2002:a17:90a:6448:: with SMTP id y8mr3846953pjm.142.1594889907702;
        Thu, 16 Jul 2020 01:58:27 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id t187sm4364244pgb.76.2020.07.16.01.58.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jul 2020 01:58:26 -0700 (PDT)
Date:   Thu, 16 Jul 2020 14:28:11 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     gregkh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        manishc@marvell.com
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge/qlge_main.c: Replace depracated MSI API.
Message-ID: <20200716085811.GA29239@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace the depracated MSI API pci_enable_msi()
with pci_alloc_irq_vectors().

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_m=
ain.c
index f7e26defb844..44ef00f1f8ee 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3181,7 +3181,7 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 msi:
 	qdev->intr_count =3D 1;
 	if (qlge_irq_type =3D=3D MSI_IRQ) {
-		if (!pci_enable_msi(qdev->pdev)) {
+		if (pci_alloc_irq_vectors(qdev->pdev, 1, 1, PCI_IRQ_MSI) >=3D 0) {
 			set_bit(QL_MSI_ENABLED, &qdev->flags);
 			netif_info(qdev, ifup, qdev->ndev,
 				   "Running with MSI interrupts.\n");
--=20
2.17.1


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8QFqMACgkQ+gRsbIfe
747zow//ZLAF3gs132hkWk5iOyoAp9G/oCE0GXRsND9P4To3CoYUuX5be27oZdzR
+JGvWRf2sraAene3fa+VweceoGu4kEX5mRVzRSRfAP9r/ah6Vug1bAAZ6zPFeeTx
XFjiRqGFIDev2h5WNnGEnQQZWCtzCJbHu3+cImEkgMnfQjGOy+iPU/xJieBBQkY7
/zMTb3+C//3VG7y1KhsW8+Wet+zv8xuPRtn+bUrNoja8Ak9pY32IThgyRu3UiNE7
eiVvXnCz+VRF2lHP0J5lGBssZHjqni6IZ500rYxWLkATtEbN3nC73CuAx1XgIIMV
+cm/a+3y4aY8XBbPnXsG0OkxIXI5B/vsEJtGUyR5to7DVv2oPsLTPp24QVHFftqM
vQk0wS7cZmOCTYtOJcaGMVWo8wvY2TNk4U5L7KGu5BEXHRxFkkFtD6uARS5CcciR
lyOkNQH2dcwm+9/JD5fvGJAHL3XMnI9C3v9ludnW+GiyOrM7wZPH+6rayh+pgb/K
PF2Ts5a/cdyjX3bfOk/xlTZZdbPT7kr4ML6AKu3+smZVoU4Jq2wLUrykuZqxcB/N
fBIl0bSPNsqAGxKDAIN9/GYX85nlNrHoRBEgX5HYS+6lSxHBIqOmEv1YvrxmvOa5
pcrR9R17bWpX9uW6Ndjggi4VXkfSRPfaexAUxP48zdNhA8LiaMg=
=0UMt
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
