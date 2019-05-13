Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C7A1B58C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbfEMMLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:11:05 -0400
Received: from mout.web.de ([212.227.17.12]:36133 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfEMMLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1557749463;
        bh=MYKXbqsGSphU/4v357nCXeJwCQeaC+JBfgl25mYRy+g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=aAdfmw2B+nL7N65kyBG6wYcv2JtcGRnzR2O286I2Mb/WjaMOW0fwrCc9azpd6PFMj
         Drhz347vh0Koh6QxhLrqszeMlrZXTlFEIxQ5VQk/br06y6BKIOscKoh8ihE/g2fw6G
         OMXz8s0uohAxgmnwXTHl5NbuegUwdzxxak24pXag=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from schienar.cern.ch ([128.141.85.100]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LdEsP-1gzekQ15lp-00iQlZ; Mon, 13
 May 2019 14:11:03 +0200
From:   Julian Wollrath <jwollrath@web.de>
To:     netdev@vger.kernel.org
Cc:     Julian Wollrath <jwollrath@web.de>
Subject: [PATCH] e1000e: Disable runtime PM on SPT+
Date:   Mon, 13 May 2019 14:10:28 +0200
Message-Id: <20190513121027.2039-1-jwollrath@web.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uVuIIU+sg/Zh2DLW53FYZuDAuY75Fo/FI7E0qJTSky9cXbCs/kC
 pKxix+p9R+ewwbz3ZPcNqbn2l2ovK0KkEMZ2A+rwEfvpQ9KUnuoevhL7FMh6cO42ER3pQ/R
 OiEtSNU/wEvOT4pR/tPKKjEixEYMxEOA5h7+1P8kypSIJ04073pVFZcw+zqQ5voW7Htr2bE
 DU2/Ge8rPZ0nZzVvBT6eA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:v3X1MTDEtoA=:Pr44oa+1KB79L6Vfg7QY2l
 32BTueruJaMdmKt6s4KmHbgqxXnPnQzfftq5cD5RWrNg+ECtkK57n1kGONr0CgR6+ZMpn1Iql
 G76BIefm1ACHyfj5pQc9h+0Qm5b8HKEvBS3NxMkrf5yuQ3nr2Dt/UQJLz4kcazBMWk4hedT73
 NMVEqR/BcPf380lhku58P4qVAiZHhwfnig2Waec6XoL+gh50VCPC42oN/+iWiUUc522TFqhcC
 nco8CLBbXrfaUdQqEngujr9N4vEP0fEhTIjES0I542m6AG6gDFLv/1bVpuNx9Sq+Mnu09wQEw
 5KanPeymcYqyVs5hEgXBkbuzQStSOLt2W6RaqBYdjmDCEaiwu3rOvHiZa1z8+cgklASPd8m62
 KIm7E7HvmKislgJjiJkKjUZa4qsd4Xw4O04LCF1JPINkvXxYxlCfKxP7HKXogH9dQ4r6qNnSS
 9u+zICNcKB5rxcWUcyhrBEVjDNzX9oQThHOJPl1ZZyGPKi+JfTZgUfCwmi6g8jUXT7Z46ulBh
 HZwyivE621jMiqTNpviIo9fBzDO6lN0mdrUFAEug48wW9M0TwnTOsiRDKrbuEUJv7GowB70H8
 kerTWDmQ0y/H7iCf4vawbboIhSvrsDWSasRVYd/fY24pCf+YpsetLfIt0XJoyNDIi0exqoaDV
 NOm6kTFNaY81fmK9P21j0jZdUALDoomzlQJXj5K+3dNRUfBGWsUgQW2/qZlTzPIPmdefGxHYk
 YzhIyYO6b5U8UreILwLtYhSe3q7wpwsRJk4MwUxWVVBtqZ9qo/DxdZ99Gc29T1h5ix/9n2da/
 9VGhVpeufFSsedNH891XI5Ipvl+3BibLTSE/yBSEEnw2/rYR561XJTDZSvqfv1hMIRAX/z/dH
 GrzB3V/oAPE7Q12BwMABV22bhCRXSYy3fH7jDy6Wpiqf/3Um/cknMLQAqqLOd0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

459d69c407f9 disabled runtime PM for CNP+ chips. This broke my I219-LM
on a SPT chip. So disable runtime PM also for SPT.

Signed-off-by: Julian Wollrath <jwollrath@web.de>
=2D--
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethe=
rnet/intel/e1000e/netdev.c
index 0e09bede42a2..24c1946139cf 100644
=2D-- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7343,7 +7343,7 @@ static int e1000_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)

 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NEVER_SKIP);

-	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
+	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_spt)
 		pm_runtime_put_noidle(&pdev->dev);

 	return 0;
=2D-
2.20.1

