Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9E760C5DB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiJYHx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiJYHxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:53:25 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16251166992;
        Tue, 25 Oct 2022 00:53:25 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P6QxqP025728;
        Tue, 25 Oct 2022 03:52:57 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kcac8kamg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 03:52:57 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 29P7quri019935
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Oct 2022 03:52:56 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Tue, 25 Oct 2022 03:52:55 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Tue, 25 Oct 2022 03:52:54 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Tue, 25 Oct 2022 03:52:54 -0400
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29P7qTrs022073;
        Tue, 25 Oct 2022 03:52:49 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lennart@lfdomain.com>
Subject: [net v3 1/1] net: ethernet: adi: adin1110: Fix notifiers
Date:   Tue, 25 Oct 2022 10:52:27 +0300
Message-ID: <20221025075227.9276-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025075227.9276-1-alexandru.tachici@analog.com>
References: <20221025075227.9276-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: 29d-f2udOwXqAnnRRhrKVKtJlqJM5RRl
X-Proofpoint-GUID: 29d-f2udOwXqAnnRRhrKVKtJlqJM5RRl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250044
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ADIN1110 was registering netdev_notifiers on each device probe.
This leads to warnings/probe failures because of double registration
of the same notifier when to adin1110/2111 devices are connected to
the same system.

Move the registration of netdev_notifiers in module init call,
in this way multiple driver instances can use the same notifiers.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 32 +++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 086aa9c96b31..73c08a523780 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1507,16 +1507,15 @@ static struct notifier_block adin1110_switchdev_notifier = {
 	.notifier_call = adin1110_switchdev_event,
 };
 
-static void adin1110_unregister_notifiers(void *data)
+static void adin1110_unregister_notifiers(void)
 {
 	unregister_switchdev_blocking_notifier(&adin1110_switchdev_blocking_notifier);
 	unregister_switchdev_notifier(&adin1110_switchdev_notifier);
 	unregister_netdevice_notifier(&adin1110_netdevice_nb);
 }
 
-static int adin1110_setup_notifiers(struct adin1110_priv *priv)
+static int adin1110_setup_notifiers(void)
 {
-	struct device *dev = &priv->spidev->dev;
 	int ret;
 
 	ret = register_netdevice_notifier(&adin1110_netdevice_nb);
@@ -1531,13 +1530,14 @@ static int adin1110_setup_notifiers(struct adin1110_priv *priv)
 	if (ret < 0)
 		goto err_sdev;
 
-	return devm_add_action_or_reset(dev, adin1110_unregister_notifiers, NULL);
+	return 0;
 
 err_sdev:
 	unregister_switchdev_notifier(&adin1110_switchdev_notifier);
 
 err_netdev:
 	unregister_netdevice_notifier(&adin1110_netdevice_nb);
+
 	return ret;
 }
 
@@ -1608,10 +1608,6 @@ static int adin1110_probe_netdevs(struct adin1110_priv *priv)
 	if (ret < 0)
 		return ret;
 
-	ret = adin1110_setup_notifiers(priv);
-	if (ret < 0)
-		return ret;
-
 	for (i = 0; i < priv->cfg->ports_nr; i++) {
 		ret = devm_register_netdev(dev, priv->ports[i]->netdev);
 		if (ret < 0) {
@@ -1688,7 +1684,25 @@ static struct spi_driver adin1110_driver = {
 	.probe = adin1110_probe,
 	.id_table = adin1110_spi_id,
 };
-module_spi_driver(adin1110_driver);
+
+static int __init adin1110_driver_init(void)
+{
+	int err;
+
+	err = adin1110_setup_notifiers();
+	if (err)
+		return err;
+
+	return spi_register_driver(&adin1110_driver);
+}
+
+static void __exit adin1110_exit(void)
+{
+	adin1110_unregister_notifiers();
+	spi_unregister_driver(&adin1110_driver);
+}
+module_init(adin1110_driver_init);
+module_exit(adin1110_exit);
 
 MODULE_DESCRIPTION("ADIN1110 Network driver");
 MODULE_AUTHOR("Alexandru Tachici <alexandru.tachici@analog.com>");
-- 
2.34.1

