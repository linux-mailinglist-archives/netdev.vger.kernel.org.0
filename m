Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5411954FD
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgC0KTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:19:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgC0KTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:19:47 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RA21Jv104634
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:47 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbtm7mvj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:46 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 27 Mar 2020 10:19:39 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 10:19:38 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RAJfjn55050270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 10:19:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DFD94C040;
        Fri, 27 Mar 2020 10:19:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 874704C046;
        Fri, 27 Mar 2020 10:19:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 10:19:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/3] s390/qeth: remove fake_broadcast attribute
Date:   Fri, 27 Mar 2020 11:19:32 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327101934.31040-1-jwi@linux.ibm.com>
References: <20200327101934.31040-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032710-0008-0000-0000-00000365325F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032710-0009-0000-0000-00004A86ABDF
Message-Id: <20200327101934.31040-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=987 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since commit 4a71df50047f ("qeth: new qeth device driver") introduced
this attribute, it can be read & written but has no actual effect.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h   |  1 -
 drivers/s390/net/qeth_l3_sys.c | 35 ----------------------------------
 2 files changed, 36 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 5f85617bdce3..acda230323d5 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -710,7 +710,6 @@ struct qeth_card_options {
 	struct qeth_ipa_caps adp; /* Adapter parameters */
 	struct qeth_sbp_info sbp; /* SETBRIDGEPORT options */
 	struct qeth_vnicc_info vnicc; /* VNICC options */
-	int fake_broadcast;
 	enum qeth_discipline_id layer;
 	enum qeth_ipa_isolation_modes isolation;
 	enum qeth_ipa_isolation_modes prev_isolation;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index a3d1c3bdfadb..dd0b39082534 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -133,40 +133,6 @@ static ssize_t qeth_l3_dev_route6_store(struct device *dev,
 static DEVICE_ATTR(route6, 0644, qeth_l3_dev_route6_show,
 			qeth_l3_dev_route6_store);
 
-static ssize_t qeth_l3_dev_fake_broadcast_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct qeth_card *card = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%i\n", card->options.fake_broadcast? 1:0);
-}
-
-static ssize_t qeth_l3_dev_fake_broadcast_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct qeth_card *card = dev_get_drvdata(dev);
-	char *tmp;
-	int i, rc = 0;
-
-	mutex_lock(&card->conf_mutex);
-	if (card->state != CARD_STATE_DOWN) {
-		rc = -EPERM;
-		goto out;
-	}
-
-	i = simple_strtoul(buf, &tmp, 16);
-	if ((i == 0) || (i == 1))
-		card->options.fake_broadcast = i;
-	else
-		rc = -EINVAL;
-out:
-	mutex_unlock(&card->conf_mutex);
-	return rc ? rc : count;
-}
-
-static DEVICE_ATTR(fake_broadcast, 0644, qeth_l3_dev_fake_broadcast_show,
-		   qeth_l3_dev_fake_broadcast_store);
-
 static ssize_t qeth_l3_dev_sniffer_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -305,7 +271,6 @@ static DEVICE_ATTR(hsuid, 0644, qeth_l3_dev_hsuid_show,
 static struct attribute *qeth_l3_device_attrs[] = {
 	&dev_attr_route4.attr,
 	&dev_attr_route6.attr,
-	&dev_attr_fake_broadcast.attr,
 	&dev_attr_sniffer.attr,
 	&dev_attr_hsuid.attr,
 	NULL,
-- 
2.17.1

