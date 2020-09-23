Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D93275363
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgIWIha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIWIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:13 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8ZKh3000893;
        Wed, 23 Sep 2020 04:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=kl5apJys3Ojk43U/5pOREdjnPwPI777VH70N9m6ryJU=;
 b=mOmlotRHD49ooZ4vXllJEK++22BpCSxqDIIbE3bSqOuMLaGBTphN2cP9VbUyo1l8PT2U
 YVMF3mlPZhX9dgJQ46QXGTZb6RArVOaRqf8cZLcmjD8d4hcbo+eKE2XaH27cYZrbzwT8
 ms19uvf9PUrjnSaBIxr8D61bCWbhXCuf6t53KmEQhl07qoXdnMi3zieHFHN/6tyjjnHf
 d/tI/v75NoUaZ0j9RDdsyKH//s1wOkIgwR0FE+126sicIPKCE/7Frvg+k6ZedXllbEtY
 WF0G2idTp3KAyC3qfWdK1wYSBDWpgYCIrL+pZnCm8Vt1TqsN3IhKjfwJQUVMk3MkxNdH UA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r27u1fsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8asYW027670;
        Wed, 23 Sep 2020 08:37:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8bxfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b6g112189988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4414E11C052;
        Wed, 23 Sep 2020 08:37:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE4AF11C054;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/qeth: remove forward declarations in L2 code
Date:   Wed, 23 Sep 2020 10:37:00 +0200
Message-Id: <20200923083700.44624-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuffle some code around (primarily all the discipline-related stuff) to
get rid of all the unnecessary forward declarations.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2.h      |   7 +
 drivers/s390/net/qeth_l2_main.c | 378 +++++++++++++++-----------------
 2 files changed, 188 insertions(+), 197 deletions(-)

diff --git a/drivers/s390/net/qeth_l2.h b/drivers/s390/net/qeth_l2.h
index cc95675c8bc4..296d73d84326 100644
--- a/drivers/s390/net/qeth_l2.h
+++ b/drivers/s390/net/qeth_l2.h
@@ -31,4 +31,11 @@ struct qeth_mac {
 	struct hlist_node hnode;
 };
 
+static inline bool qeth_bridgeport_is_in_use(struct qeth_card *card)
+{
+	return card->options.sbp.role ||
+	       card->options.sbp.reflect_promisc ||
+	       card->options.sbp.hostnotification;
+}
+
 #endif /* __QETH_L2_H__ */
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index fd6891494c69..1852d0a3c10a 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -28,17 +28,6 @@
 #include "qeth_core.h"
 #include "qeth_l2.h"
 
-static void qeth_bridgeport_query_support(struct qeth_card *card);
-static void qeth_bridge_state_change(struct qeth_card *card,
-					struct qeth_ipa_cmd *cmd);
-static void qeth_addr_change_event(struct qeth_card *card,
-				   struct qeth_ipa_cmd *cmd);
-static bool qeth_bridgeport_is_in_use(struct qeth_card *card);
-static void qeth_l2_vnicc_set_defaults(struct qeth_card *card);
-static void qeth_l2_vnicc_init(struct qeth_card *card);
-static bool qeth_l2_vnicc_recover_timeout(struct qeth_card *card, u32 vnicc,
-					  u32 *timeout);
-
 static int qeth_l2_setdelmac_makerc(struct qeth_card *card, u16 retcode)
 {
 	int rc;
@@ -587,49 +576,6 @@ static u16 qeth_l2_select_queue(struct net_device *dev, struct sk_buff *skb,
 				 qeth_get_priority_queue(card, skb);
 }
 
-static const struct device_type qeth_l2_devtype = {
-	.name = "qeth_layer2",
-	.groups = qeth_l2_attr_groups,
-};
-
-static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	int rc;
-
-	if (IS_OSN(card))
-		dev_notice(&gdev->dev, "OSN support will be dropped in 2021\n");
-
-	qeth_l2_vnicc_set_defaults(card);
-	mutex_init(&card->sbp_lock);
-
-	if (gdev->dev.type == &qeth_generic_devtype) {
-		rc = qeth_l2_create_device_attributes(&gdev->dev);
-		if (rc)
-			return rc;
-	}
-
-	INIT_WORK(&card->rx_mode_work, qeth_l2_rx_mode_work);
-	return 0;
-}
-
-static void qeth_l2_remove_device(struct ccwgroup_device *cgdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&cgdev->dev);
-
-	if (cgdev->dev.type == &qeth_generic_devtype)
-		qeth_l2_remove_device_attributes(&cgdev->dev);
-	qeth_set_allowed_threads(card, 0, 1);
-	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
-
-	if (cgdev->state == CCWGROUP_ONLINE)
-		qeth_set_offline(card, false);
-
-	cancel_work_sync(&card->close_dev_work);
-	if (card->dev->reg_state == NETREG_REGISTERED)
-		unregister_netdev(card->dev);
-}
-
 static void qeth_l2_set_rx_mode(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
@@ -1110,130 +1056,6 @@ static void qeth_l2_enable_brport_features(struct qeth_card *card)
 	}
 }
 
-static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
-{
-	struct net_device *dev = card->dev;
-	int rc = 0;
-
-	/* query before bridgeport_notification may be enabled */
-	qeth_l2_detect_dev2br_support(card);
-
-	mutex_lock(&card->sbp_lock);
-	qeth_bridgeport_query_support(card);
-	if (card->options.sbp.supported_funcs) {
-		qeth_l2_setup_bridgeport_attrs(card);
-		dev_info(&card->gdev->dev,
-			 "The device represents a Bridge Capable Port\n");
-	}
-	mutex_unlock(&card->sbp_lock);
-
-	qeth_l2_register_dev_addr(card);
-
-	/* for the rx_bcast characteristic, init VNICC after setmac */
-	qeth_l2_vnicc_init(card);
-
-	qeth_l2_trace_features(card);
-
-	/* softsetup */
-	QETH_CARD_TEXT(card, 2, "softsetp");
-
-	card->state = CARD_STATE_SOFTSETUP;
-
-	qeth_set_allowed_threads(card, 0xffffffff, 0);
-
-	if (dev->reg_state != NETREG_REGISTERED) {
-		rc = qeth_l2_setup_netdev(card);
-		if (rc)
-			goto err_setup;
-
-		if (carrier_ok)
-			netif_carrier_on(dev);
-	} else {
-		rtnl_lock();
-		if (carrier_ok)
-			netif_carrier_on(dev);
-		else
-			netif_carrier_off(dev);
-
-		netif_device_attach(dev);
-		qeth_enable_hw_features(dev);
-		qeth_l2_enable_brport_features(card);
-
-		if (card->info.open_when_online) {
-			card->info.open_when_online = 0;
-			dev_open(dev, NULL);
-		}
-		rtnl_unlock();
-	}
-	return 0;
-
-err_setup:
-	qeth_set_allowed_threads(card, 0, 1);
-	card->state = CARD_STATE_DOWN;
-	return rc;
-}
-
-static void qeth_l2_set_offline(struct qeth_card *card)
-{
-	struct qeth_priv *priv = netdev_priv(card->dev);
-
-	qeth_set_allowed_threads(card, 0, 1);
-	qeth_l2_drain_rx_mode_cache(card);
-
-	if (card->state == CARD_STATE_SOFTSETUP)
-		card->state = CARD_STATE_DOWN;
-
-	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
-	if (priv->brport_features & BR_LEARNING_SYNC) {
-		rtnl_lock();
-		qeth_l2_dev2br_fdb_flush(card);
-		rtnl_unlock();
-	}
-}
-
-static int __init qeth_l2_init(void)
-{
-	pr_info("register layer 2 discipline\n");
-	return 0;
-}
-
-static void __exit qeth_l2_exit(void)
-{
-	pr_info("unregister layer 2 discipline\n");
-}
-
-/* Returns zero if the command is successfully "consumed" */
-static int qeth_l2_control_event(struct qeth_card *card,
-					struct qeth_ipa_cmd *cmd)
-{
-	switch (cmd->hdr.command) {
-	case IPA_CMD_SETBRIDGEPORT_OSA:
-	case IPA_CMD_SETBRIDGEPORT_IQD:
-		if (cmd->data.sbp.hdr.command_code ==
-				IPA_SBP_BRIDGE_PORT_STATE_CHANGE) {
-			qeth_bridge_state_change(card, cmd);
-			return 0;
-		} else
-			return 1;
-	case IPA_CMD_ADDRESS_CHANGE_NOTIF:
-		qeth_addr_change_event(card, cmd);
-		return 0;
-	default:
-		return 1;
-	}
-}
-
-struct qeth_discipline qeth_l2_discipline = {
-	.devtype = &qeth_l2_devtype,
-	.setup = qeth_l2_probe_device,
-	.remove = qeth_l2_remove_device,
-	.set_online = qeth_l2_set_online,
-	.set_offline = qeth_l2_set_offline,
-	.do_ioctl = NULL,
-	.control_event_handler = qeth_l2_control_event,
-};
-EXPORT_SYMBOL_GPL(qeth_l2_discipline);
-
 #ifdef CONFIG_QETH_OSN
 static void qeth_osn_assist_cb(struct qeth_card *card,
 			       struct qeth_cmd_buffer *iob,
@@ -1953,12 +1775,6 @@ int qeth_bridgeport_an_set(struct qeth_card *card, int enable)
 	return rc;
 }
 
-static bool qeth_bridgeport_is_in_use(struct qeth_card *card)
-{
-	return (card->options.sbp.role || card->options.sbp.reflect_promisc ||
-		card->options.sbp.hostnotification);
-}
-
 /* VNIC Characteristics support */
 
 /* handle VNICC IPA command return codes; convert to error codes */
@@ -2104,6 +1920,19 @@ static int qeth_l2_vnicc_getset_timeout(struct qeth_card *card, u32 vnicc,
 	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, timeout);
 }
 
+/* recover user timeout setting */
+static bool qeth_l2_vnicc_recover_timeout(struct qeth_card *card, u32 vnicc,
+					  u32 *timeout)
+{
+	if (card->options.vnicc.sup_chars & vnicc &&
+	    card->options.vnicc.getset_timeout_sup & vnicc &&
+	    !qeth_l2_vnicc_getset_timeout(card, vnicc, IPA_VNICC_SET_TIMEOUT,
+					  timeout))
+		return false;
+	*timeout = QETH_VNICC_DEFAULT_TIMEOUT;
+	return true;
+}
+
 /* set current VNICC flag state; called from sysfs store function */
 int qeth_l2_vnicc_set_state(struct qeth_card *card, u32 vnicc, bool state)
 {
@@ -2274,19 +2103,6 @@ bool qeth_bridgeport_allowed(struct qeth_card *card)
 		!(priv->brport_features & BR_LEARNING_SYNC));
 }
 
-/* recover user timeout setting */
-static bool qeth_l2_vnicc_recover_timeout(struct qeth_card *card, u32 vnicc,
-					  u32 *timeout)
-{
-	if (card->options.vnicc.sup_chars & vnicc &&
-	    card->options.vnicc.getset_timeout_sup & vnicc &&
-	    !qeth_l2_vnicc_getset_timeout(card, vnicc, IPA_VNICC_SET_TIMEOUT,
-					  timeout))
-		return false;
-	*timeout = QETH_VNICC_DEFAULT_TIMEOUT;
-	return true;
-}
-
 /* recover user characteristic setting */
 static bool qeth_l2_vnicc_recover_char(struct qeth_card *card, u32 vnicc,
 				       bool enable)
@@ -2375,6 +2191,174 @@ static void qeth_l2_vnicc_set_defaults(struct qeth_card *card)
 	card->options.vnicc.wanted_chars = QETH_VNICC_DEFAULT;
 }
 
+static const struct device_type qeth_l2_devtype = {
+	.name = "qeth_layer2",
+	.groups = qeth_l2_attr_groups,
+};
+
+static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
+{
+	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	int rc;
+
+	if (IS_OSN(card))
+		dev_notice(&gdev->dev, "OSN support will be dropped in 2021\n");
+
+	qeth_l2_vnicc_set_defaults(card);
+	mutex_init(&card->sbp_lock);
+
+	if (gdev->dev.type == &qeth_generic_devtype) {
+		rc = qeth_l2_create_device_attributes(&gdev->dev);
+		if (rc)
+			return rc;
+	}
+
+	INIT_WORK(&card->rx_mode_work, qeth_l2_rx_mode_work);
+	return 0;
+}
+
+static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
+{
+	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+
+	if (gdev->dev.type == &qeth_generic_devtype)
+		qeth_l2_remove_device_attributes(&gdev->dev);
+	qeth_set_allowed_threads(card, 0, 1);
+	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
+
+	if (gdev->state == CCWGROUP_ONLINE)
+		qeth_set_offline(card, false);
+
+	cancel_work_sync(&card->close_dev_work);
+	if (card->dev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(card->dev);
+}
+
+static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
+{
+	struct net_device *dev = card->dev;
+	int rc = 0;
+
+	/* query before bridgeport_notification may be enabled */
+	qeth_l2_detect_dev2br_support(card);
+
+	mutex_lock(&card->sbp_lock);
+	qeth_bridgeport_query_support(card);
+	if (card->options.sbp.supported_funcs) {
+		qeth_l2_setup_bridgeport_attrs(card);
+		dev_info(&card->gdev->dev,
+			 "The device represents a Bridge Capable Port\n");
+	}
+	mutex_unlock(&card->sbp_lock);
+
+	qeth_l2_register_dev_addr(card);
+
+	/* for the rx_bcast characteristic, init VNICC after setmac */
+	qeth_l2_vnicc_init(card);
+
+	qeth_l2_trace_features(card);
+
+	/* softsetup */
+	QETH_CARD_TEXT(card, 2, "softsetp");
+
+	card->state = CARD_STATE_SOFTSETUP;
+
+	qeth_set_allowed_threads(card, 0xffffffff, 0);
+
+	if (dev->reg_state != NETREG_REGISTERED) {
+		rc = qeth_l2_setup_netdev(card);
+		if (rc)
+			goto err_setup;
+
+		if (carrier_ok)
+			netif_carrier_on(dev);
+	} else {
+		rtnl_lock();
+		if (carrier_ok)
+			netif_carrier_on(dev);
+		else
+			netif_carrier_off(dev);
+
+		netif_device_attach(dev);
+		qeth_enable_hw_features(dev);
+		qeth_l2_enable_brport_features(card);
+
+		if (card->info.open_when_online) {
+			card->info.open_when_online = 0;
+			dev_open(dev, NULL);
+		}
+		rtnl_unlock();
+	}
+	return 0;
+
+err_setup:
+	qeth_set_allowed_threads(card, 0, 1);
+	card->state = CARD_STATE_DOWN;
+	return rc;
+}
+
+static void qeth_l2_set_offline(struct qeth_card *card)
+{
+	struct qeth_priv *priv = netdev_priv(card->dev);
+
+	qeth_set_allowed_threads(card, 0, 1);
+	qeth_l2_drain_rx_mode_cache(card);
+
+	if (card->state == CARD_STATE_SOFTSETUP)
+		card->state = CARD_STATE_DOWN;
+
+	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
+	if (priv->brport_features & BR_LEARNING_SYNC) {
+		rtnl_lock();
+		qeth_l2_dev2br_fdb_flush(card);
+		rtnl_unlock();
+	}
+}
+
+/* Returns zero if the command is successfully "consumed" */
+static int qeth_l2_control_event(struct qeth_card *card,
+				 struct qeth_ipa_cmd *cmd)
+{
+	switch (cmd->hdr.command) {
+	case IPA_CMD_SETBRIDGEPORT_OSA:
+	case IPA_CMD_SETBRIDGEPORT_IQD:
+		if (cmd->data.sbp.hdr.command_code ==
+		    IPA_SBP_BRIDGE_PORT_STATE_CHANGE) {
+			qeth_bridge_state_change(card, cmd);
+			return 0;
+		}
+
+		return 1;
+	case IPA_CMD_ADDRESS_CHANGE_NOTIF:
+		qeth_addr_change_event(card, cmd);
+		return 0;
+	default:
+		return 1;
+	}
+}
+
+struct qeth_discipline qeth_l2_discipline = {
+	.devtype = &qeth_l2_devtype,
+	.setup = qeth_l2_probe_device,
+	.remove = qeth_l2_remove_device,
+	.set_online = qeth_l2_set_online,
+	.set_offline = qeth_l2_set_offline,
+	.do_ioctl = NULL,
+	.control_event_handler = qeth_l2_control_event,
+};
+EXPORT_SYMBOL_GPL(qeth_l2_discipline);
+
+static int __init qeth_l2_init(void)
+{
+	pr_info("register layer 2 discipline\n");
+	return 0;
+}
+
+static void __exit qeth_l2_exit(void)
+{
+	pr_info("unregister layer 2 discipline\n");
+}
+
 module_init(qeth_l2_init);
 module_exit(qeth_l2_exit);
 MODULE_AUTHOR("Frank Blaschka <frank.blaschka@de.ibm.com>");
-- 
2.17.1

