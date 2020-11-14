Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCAC2B29C5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgKNARm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:17:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10865 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKNARl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:17:41 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201114001738epoutp042ccdd9275619d281d0e64ec9abbaeb9f~HN7i4dPv-0945609456epoutp04G
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:17:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201114001738epoutp042ccdd9275619d281d0e64ec9abbaeb9f~HN7i4dPv-0945609456epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605313058;
        bh=J2Ss3gXaivOMfsVVibcpB28cGPZCXhkB0HkiQoB0oto=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=gMmUn/xA8xp7w3F3JA2eMBDtETy1j9EJ62BQqEmX4IqeseY467cC9fu7YuAetYSh7
         sYzwjX46B87ZUDgMBFvJ9IWME4egnahAAKyFSYP/OntfuX9aEiXBeSq0IEGCXWLRjk
         44tnxZ9wGu8OB9BGhRCh/C0EvowNG8zt+hXTnnkY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201114001737epcas2p1ad9a4b6892fb920cfc712f19c29d6e2d~HN7iA4Gat1975519755epcas2p1N;
        Sat, 14 Nov 2020 00:17:37 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4CXwrw35GPzMqYkY; Sat, 14 Nov
        2020 00:17:36 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-93-5faf2220c17e
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.A0.52511.0222FAF5; Sat, 14 Nov 2020 09:17:36 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 1/3] nfc: s3fwrn5: Remove the max_payload.
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e@epcms2p2>
Date:   Sat, 14 Nov 2020 09:17:36 +0900
X-CMS-MailID: 20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7bCmma6C0vp4g2urhSxuT5zGZnH+/AZ2
        iwvb+lgtji0Qc2Dx2LSqk82jb8sqRo/Pm+QCmKNybDJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEqE3IyWm98ZyrYJ1wx5cdT1gbG1QJdjJwcEgIm
        EtuOXmbpYuTiEBLYwSjx9kAHkMPBwSsgKPF3hzBIjbCAs8SGsy+ZQWwhAUWJ/x3n2CDiuhIv
        /h4Fs9kEtCXWHm1kArFFBColDiw6zghiMwuYSjw7/ZYFYhevxIz2p1C2tMT25VsZIWwNiR/L
        epkhbFGJm6vfssPY74/Nh6oRkWi9dxaqRlDiwc/dUHFJibf75rGD3C8h0M4ocf7nDzYIZwaj
        xKnNf6E69CUWn1sBdh2vgK/Elbc/wWwWAVWJ9s27oWpcJB7d/MkGcbW8xPa3c5hBAcEsoCmx
        fpc+iCkhoCxx5BYLRAWfRMfhv+wwf+2Y94QJwlaV6G3+wgTz4+TZLVB3ekgs2faNDRKGgRKH
        di1mmsCoMAsR0rOQ7J2FsHcBI/MqRrHUguLc9NRiowIT5MjdxAhOeFoeOxhnv/2gd4iRiYPx
        EKMEB7OSCK+yw5p4Id6UxMqq1KL8+KLSnNTiQ4ymQB9PZJYSTc4Hpty8knhDUyMzMwNLUwtT
        MyMLJXHe0JV98UIC6YklqdmpqQWpRTB9TBycUg1M/UxhEsxH7zveCmIOYel6trzZu2XpJcPf
        jH4MiqYXH/k+vpsbo/xyhYWDEuu669MWf2R7vDPp3IqDklrFmaqTf+cof0yN2Mt1bSNzR/Pk
        S78f7Lk4u5TjuvHaS6yzp+uE5XscffNfgPmjZ/Qx7sobv5OP8xtc0JvLz1fuwjCtO2Kfm9ik
        2tk7HFIdv0c1vYw5Y14eua3lXfqh/UkdYWa203MeaJdf/1UjzhjGulh8j8mD1C/nJ/vq3p8V
        XShx3vZNi33OPdt008sHFv9vqhB9Gr18Y/6VXMlM9ql3n2k7nJLmCSnemsJttpn74hPxd+84
        zrireO2zbpr4szZ5smT87STWqC3Tl37We/pu2tQUJZbijERDLeai4kQAK41gLQEEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e
References: <CGME20201114001736epcms2p258c17155d29874c028e3cafcbcb0ee6e@epcms2p2>
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
