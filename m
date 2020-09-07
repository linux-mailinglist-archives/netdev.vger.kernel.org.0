Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAF325FE66
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgIGQPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:15:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:44860 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730490AbgIGQPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:15:32 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 54FEC6008F;
        Mon,  7 Sep 2020 16:15:27 +0000 (UTC)
Received: from us4-mdac16-22.ut7.mdlocal (unknown [10.7.65.246])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 533B9800A4;
        Mon,  7 Sep 2020 16:15:27 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E11B580051;
        Mon,  7 Sep 2020 16:15:26 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 98D44700066;
        Mon,  7 Sep 2020 16:15:26 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:15:21 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 5/6] sfc: remove EFX_DRIVER_VERSION
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <1e935241-f79f-ed5a-b90e-ecdd8e0632d6@solarflare.com>
Date:   Mon, 7 Sep 2020 17:15:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-3.309600-8.000000-10
X-TMASE-MatchedRID: KZs+m1wVwKlI4wna8AoJYDfu+RTlciXgeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsE4aBLis6ititw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ62+OflY2YjKV7Q5CwTjM06oex
        gGLUVYyM77ZXb57t/G3UJW3hxVXl59xb6r5VfoomL6q5RsNhv5LMiB//a6ucWxKLCLOyCW5BWXR
        dFScRW4tAaXEhW9X9ekZOl7WKIImrvXOvQVlExsGodc419PBJCxEHRux+uk8ifEzJ5hPndGcA8s
        vHCVHdBeB36GkuM8rpk2fa4F6U2qttxIw5N1A4YmpFhlfxtuRpDXVGg4bxk/85e6afRG1BaMNV9
        9ZVnrjRSwMEIv6jfKRoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ6Ol5oRXyhFEVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.309600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495327-f89nuIaQA3cl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-module versions for in-tree drivers are deprecated.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c            | 3 +--
 drivers/net/ethernet/sfc/ethtool_common.c | 1 -
 drivers/net/ethernet/sfc/net_driver.h     | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index aad6710c0afb..58b043f946b4 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1329,7 +1329,7 @@ static int __init efx_init_module(void)
 {
 	int rc;
 
-	printk(KERN_INFO "Solarflare NET driver v" EFX_DRIVER_VERSION "\n");
+	printk(KERN_INFO "Solarflare NET driver\n");
 
 	rc = register_netdevice_notifier(&efx_netdev_notifier);
 	if (rc)
@@ -1391,4 +1391,3 @@ MODULE_AUTHOR("Solarflare Communications and "
 MODULE_DESCRIPTION("Solarflare network driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, efx_pci_table);
-MODULE_VERSION(EFX_DRIVER_VERSION);
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 622a72eb153a..b18a4bcfccdf 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -106,7 +106,6 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, EFX_DRIVER_VERSION, sizeof(info->version));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
 	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index c3015f258ba0..3fd0b59107d1 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -38,8 +38,6 @@
  *
  **************************************************************************/
 
-#define EFX_DRIVER_VERSION	"4.1"
-
 #ifdef DEBUG
 #define EFX_WARN_ON_ONCE_PARANOID(x) WARN_ON_ONCE(x)
 #define EFX_WARN_ON_PARANOID(x) WARN_ON(x)

