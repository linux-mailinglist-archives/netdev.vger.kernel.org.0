Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF12E2B3B21
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 02:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgKPBMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 20:12:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42602 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgKPBMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 20:12:12 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201116011209epoutp01b4ae6178553a3a21ac624f3919166e69~H19tztuA02375623756epoutp01k
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201116011209epoutp01b4ae6178553a3a21ac624f3919166e69~H19tztuA02375623756epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605489129;
        bh=JHbfhQmZY2Kdf9uCqVWWi/pKiuSfpP7K0ZJj50SZUM0=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=Sj7BqonbIBGAHQz2fHC7z7K6ep1nqPfCwRcej9eg8I3IyTNfq3231KzP8VHZ6XKMx
         METiEXeFSOidMeLvIcuecRAwzssjKj6xSeIFH7fTJx5HcT1r693OrTssrwSIXyrHZb
         ldU7AVV3niBWHe/tE6jKWXrsq5AAb3osmwBVVokk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201116011209epcas2p1a3b5e55645a2cc736315a93e787cac5a~H19terjmG1868518685epcas2p1g;
        Mon, 16 Nov 2020 01:12:09 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CZ9yv6qqDzMqYkb; Mon, 16 Nov
        2020 01:12:07 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-aa-5fb1d1e5d539
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.16.10621.5E1D1BF5; Mon, 16 Nov 2020 10:12:05 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 1/3] nfc: s3fwrn5: Remove the max_payload
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
Message-ID: <20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33@epcms2p5>
Date:   Mon, 16 Nov 2020 10:12:05 +0900
X-CMS-MailID: 20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmhe7TixvjDbZsMbPY0jyJ3eL2xGls
        FufPb2C3uLxrDpvFnA2b2S2OLRBzYPPYtKqTzaN79j8Wj74tqxg9Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyeiY2cBUcEK4
        4v2NtYwNjBsFuhg5OSQETCRmn5zH3MXIxSEksINRovvlCvYuRg4OXgFBib87hEFqhAWcJKbe
        ucYCYgsJKEr87zjHBhHXlXjx9yiYzSagLbH2aCMTSKuIQIjEx75akJHMAqsZJTp/djJD7OKV
        mNH+lAXClpbYvnwrI4StIfFjWS9UjajEzdVv2WHs98fmQ9WISLTeOwtVIyjx4OduqLikxNt9
        89hBlkkItDNKnP/5gw3CmcEocWrzX6gOfYnF51YwQTzmK3HxUBFImEVAVaJ/w0SoEheJKdv/
        gC1mFpCX2P52DjNIObOApsT6XfogpoSAssSRWywQFXwSHYf/ssO8tWPeEyYIW1Wit/kLE8yL
        k2e3QJ3pIfF81342SBAGSry8cJdtAqPCLERAz0KydxbC3gWMzKsYxVILinPTU4uNCgyR43YT
        IzgZarnuYJz89oPeIUYmDsZDjBIczEoivC4mG+OFeFMSK6tSi/Lji0pzUosPMZoCfTyRWUo0
        OR+YjvNK4g1NjczMDCxNLUzNjCyUxHlDV/bFCwmkJ5akZqemFqQWwfQxcXBKNTCtCtjEz8Zz
        YOKTB0frc45tmbXzrMZOORuz9SXsxdmXGnTvif7N4L90ktHVMqesLi+xk1vr+cz/CVtP+x5Z
        7NFZ/SvB135+zXLT/3kxlg3C8RMnfc9+52AZ+8no1lyeqBx9G6OAc68XTuxS7AzUPrMr0tFF
        6J75vdeXau1y9j6bX3lyK89UTl593uhTy+TmVTxuXXv50rWk3UyVHyYtXdmhMj910gaWBQlC
        +q5ap55eebbf83DcoVt90+Uq9s8r83WL2Nq0ddK2qa6l27k8a/02/lQ6PZcvYqbqkWR/fodZ
        zxef+K/Ls5T/Uds12zfLy1oKT7c3PFrnVH7PcGVj2Xv+mSkSrB2O8RpKv86zfluixFKckWio
        xVxUnAgAMtbRag8EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33
References: <CGME20201116011205epcms2p566dbc946d6c7a0198d09b3a872e85f33@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

max_payload is unused.

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

