Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F581DABD1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETHSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:18:39 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:62452 "EHLO mx01-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETHSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:18:38 -0400
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-sz.bfs.de (Postfix) with ESMTPS id 36D40202F0;
        Wed, 20 May 2020 09:18:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1589959116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JBJnQwwXS3UggHe+Z7eE2kLsZ1TLEKk2PsFJwj6UHFU=;
        b=VROaVp+PqPSOCQyG9KLMcaxSwlDtB/xyZkUstK+zngZJfmKWgh5EsDGzH7UCDY6LKfIsS6
        ix3KYKp4kLni/MFHop9XB4syiLOQrlzHMW8s94AGbcwNiPOmV3zY/LuvfkuLhQuC4fwWaz
        KqQSCcmdJMBsfOz56tZD6CU4Yyzdr+v+6em0lHDbUBTKclSTSGJsdNzNWYIVU+zJXzTuSO
        4t+stYtjV9zf2XIXGTgglAkhaj4hJ3RgzGNJYUUiXn76XNsc8MNxuiA3jaNLgvhOnBzFw8
        FSapJZM9ukN9+O+jOFu+nVyorcLPzRGsG/LAdARRjrQZ0/eEPBAB1vnSsj5KWA==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1913.5; Wed, 20 May
 2020 09:18:35 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%6]) with mapi id
 15.01.1913.005; Wed, 20 May 2020 09:18:35 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: AW: [PATCH 1/2 v3] net: ethernet: ti: fix some return value check of
 cpsw_ale_create()
Thread-Topic: [PATCH 1/2 v3] net: ethernet: ti: fix some return value check of
 cpsw_ale_create()
Thread-Index: AQHWLlgZsN6wqlDqqUKwhKXRFx1pTaiwkDuG
Date:   Wed, 20 May 2020 07:18:35 +0000
Message-ID: <2ff811c27a7e43a2a6f2b1744a735f26@bfs.de>
References: <20200520034116.170946-1-weiyongjun1@huawei.com>,<20200520034116.170946-2-weiyongjun1@huawei.com>
In-Reply-To: <20200520034116.170946-2-weiyongjun1@huawei.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.50
Authentication-Results: mx01-sz.bfs.de;
        none
X-Spamd-Result: default: False [-2.50 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-1.038];
         FREEMAIL_TO(0.00)[huawei.com,vger.kernel.org,ti.com,wanadoo.fr,canonical.com,kernel.org];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-2.50)[97.72%]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

just a notice:

from my casual observation i noticed that most people expect
a function to return NULL on error (as seen here). So i would suggest
to return NULL and (if needed) the error code otherwise.

jm2c,
re
 wh
________________________________________
Von: kernel-janitors-owner@vger.kernel.org <kernel-janitors-owner@vger.kern=
el.org> im Auftrag von Wei Yongjun <weiyongjun1@huawei.com>
Gesendet: Mittwoch, 20. Mai 2020 05:41:15
An: netdev@vger.kernel.org; Grygorii Strashko; Christophe JAILLET; Colin Ia=
n King; Jakub Kicinski
Cc: Wei Yongjun; kernel-janitors@vger.kernel.org; Hulk Robot
Betreff: [PATCH 1/2 v3] net: ethernet: ti: fix some return value check of c=
psw_ale_create()

cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
the caller only check NULL for error handling. This patch convert
it to only return PTR_ERR() in all error cases, and the caller using
IS_ERR() instead of NULL test.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on ho=
st port")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c    | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c   | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/c=
psw_ale.c
index 0374e6936091..8dc6be11b2ff 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -955,7 +955,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params=
 *params)

        ale =3D devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
        if (!ale)
-               return NULL;
+               return ERR_PTR(-ENOMEM);

        ale->p0_untag_vid_mask =3D
                devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/=
cpsw_priv.c
index 97a058ca60ac..d0b6c418a870 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -490,9 +490,9 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __i=
omem *ss_regs,
        ale_params.ale_ports            =3D CPSW_ALE_PORTS_NUM;

        cpsw->ale =3D cpsw_ale_create(&ale_params);
-       if (!cpsw->ale) {
+       if (IS_ERR(cpsw->ale)) {
                dev_err(dev, "error initializing ale engine\n");
-               return -ENODEV;
+               return PTR_ERR(cpsw->ale);
        }

        dma_params.dev          =3D dev;
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/t=
i/netcp_ethss.c
index fb36115e9c51..fdbae734acce 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3704,9 +3704,9 @@ static int gbe_probe(struct netcp_device *netcp_devic=
e, struct device *dev,
                ale_params.nu_switch_ale =3D true;
        }
        gbe_dev->ale =3D cpsw_ale_create(&ale_params);
-       if (!gbe_dev->ale) {
+       if (IS_ERR(gbe_dev->ale)) {
                dev_err(gbe_dev->dev, "error initializing ale engine\n");
-               ret =3D -ENODEV;
+               ret =3D PTR_ERR(gbe_dev->ale);
                goto free_sec_ports;
        } else {
                dev_dbg(gbe_dev->dev, "Created a gbe ale engine\n");
--
2.25.1

