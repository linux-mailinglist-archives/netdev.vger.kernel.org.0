Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094C92B5ABE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKQIIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:08:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52040 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQIIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:08:30 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201117080827epoutp032b226f3ad435f2e735884f4d6b2dff82~IPSeqMj0e2711027110epoutp03X
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 08:08:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201117080827epoutp032b226f3ad435f2e735884f4d6b2dff82~IPSeqMj0e2711027110epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605600507;
        bh=zJSngcK/bFdgmZup9U49BIcrgy3X3io44G95eX4tVAc=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=vb+nLj+zJOXKX3mM9A8l4cpTJW8LpRmoFBDCI+05Zu178SthlWVW2YqQ8fqbi71MK
         Wk7eI3gh0jWSUoNS7bANu+dKAAIdYxznxf9SD31BGHnkWrFhDoIXjny/LnDDUr84bw
         VhMWFnD6wEqvIo6y7o0JqkrEJI1/W3ecbmfhyQR8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201117080827epcas2p391726673adeb25b98f6733fcd99e36e1~IPSeTqOs42488224882epcas2p3d;
        Tue, 17 Nov 2020 08:08:27 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CZz8n2xRPzMqYkg; Tue, 17 Nov
        2020 08:08:25 +0000 (GMT)
X-AuditID: b6c32a47-715ff7000000d2c4-8d-5fb384f84339
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.C5.53956.8F483BF5; Tue, 17 Nov 2020 17:08:24 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "krzk@kernel.org" <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
CC:     "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725@epcms2p3>
Date:   Tue, 17 Nov 2020 17:08:24 +0900
X-CMS-MailID: 20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmme6Pls3xBh/ua1lsaZ7EbnF74jQ2
        i/PnN7BbXN41h81izobN7BbHFog5sHlsWtXJ5tE9+x+LR9+WVYwenzfJBbBE5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
        6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoYGJkCVSbkZJydc5Cp4I9w
        xasDd5gbGB8IdDFyckgImEh82nCMvYuRi0NIYAejxOV7O1i6GDk4eAUEJf7uEAapERZwldh8
        fSUbiC0koCjxv+McG0RcV+LF36NgNpuAtsTao41MIK0iAiESH/tqQUYyC6xmlOj82ckMsYtX
        Ykb7UxYIW1pi+/KtjBC2hsSPZb1QNaISN1e/ZYex3x+bD1UjItF67yxUjaDEg5+7oeKSEm/3
        zQO7X0KgnVHi/M8fbBDODEaJU5v/QnXoSyw+t4IJxOYV8JX41/UHLM4ioCrR0n+IDeRqCQEX
        ib1rFUDCzALyEtvfzmEGCTMLaEqs36UPUaEsceQWC0QFn0TH4b/sMG/tmPeECcJWleht/sIE
        8+Lk2S1QZ3pIfJtwiQUShIESv//eYpzAqDALEdCzkOydhbB3ASPzKkax1ILi3PTUYqMCY+S4
        3cQIToZa7jsYZ7z9oHeIkYmD8RCjBAezkgivi8nGeCHelMTKqtSi/Pii0pzU4kOMpkAPT2SW
        Ek3OB6bjvJJ4Q1MjMzMDS1MLUzMjCyVx3tCVffFCAumJJanZqakFqUUwfUwcnFINTOm1+ekb
        pXjfaH9wyQyYc0htOdfHBxFP/VPvzM3l/1/247ybTuL37bOTq+/d+ZdlVVMql1kV9u7T7yNn
        zxd1vXVetX/LT1cPLqull51C41Y8vsfj94JT6774swreawIKKffWdsTO4FL4cYX50CPXzQ4T
        1e3EFjRZLpxreuXVvYs8h3T6364RUme/0DBZdYdOgJeD9NWALd4qktdVy2bJTGY12tJgcGjl
        5cQlD2yyTU+ZreQ8bi+QvuOhorn20ZiYMOPwj361P79mSWswf5pp2+WvfIBtznxGXqWXs/OO
        VuzaInot1vzd5O1X85wnmrgnMD3O6eDRfZ1qckayVT1IZrN4XqiV7A6HfP5v+3jylFiKMxIN
        tZiLihMBHW8PgQ8EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725
References: <CGME20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725@epcms2p3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

max_payload is unused.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/core.c    | 3 +--
 drivers/nfc/s3fwrn5/i2c.c     | 4 +---
 drivers/nfc/s3fwrn5/s3fwrn5.h | 3 +--
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index ba6c486d6465..f8e5d78d9078 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -136,7 +136,7 @@ static struct nci_ops s3fwrn5_nci_ops = {
 };
 
 int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
-	const struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload)
+	const struct s3fwrn5_phy_ops *phy_ops)
 {
 	struct s3fwrn5_info *info;
 	int ret;
@@ -148,7 +148,6 @@ int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
 	info->phy_id = phy_id;
 	info->pdev = pdev;
 	info->phy_ops = phy_ops;
-	info->max_payload = max_payload;
 	mutex_init(&info->mutex);
 
 	s3fwrn5_set_mode(info, S3FWRN5_MODE_COLD);
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index dc995286be84..0ffa389066a0 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -19,7 +19,6 @@
 
 #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
 
-#define S3FWRN5_I2C_MAX_PAYLOAD 32
 #define S3FWRN5_EN_WAIT_TIME 150
 
 struct s3fwrn5_i2c_phy {
@@ -248,8 +247,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops,
-		S3FWRN5_I2C_MAX_PAYLOAD);
+	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/nfc/s3fwrn5/s3fwrn5.h b/drivers/nfc/s3fwrn5/s3fwrn5.h
index ede68bb5eeae..9d5f34759225 100644
--- a/drivers/nfc/s3fwrn5/s3fwrn5.h
+++ b/drivers/nfc/s3fwrn5/s3fwrn5.h
@@ -34,7 +34,6 @@ struct s3fwrn5_info {
 	struct device *pdev;
 
 	const struct s3fwrn5_phy_ops *phy_ops;
-	unsigned int max_payload;
 
 	struct s3fwrn5_fw_info fw_info;
 
@@ -79,7 +78,7 @@ static inline int s3fwrn5_write(struct s3fwrn5_info *info, struct sk_buff *skb)
 }
 
 int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
-	const struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload);
+	const struct s3fwrn5_phy_ops *phy_ops);
 void s3fwrn5_remove(struct nci_dev *ndev);
 
 int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
-- 
2.17.1

