Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ABC2B562C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKQBS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:18:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27458 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQBS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:18:56 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201117011853epoutp02ceec38b8b674522609d2cf7e85c5a18e~IJs4btEuH1574115741epoutp026
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 01:18:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201117011853epoutp02ceec38b8b674522609d2cf7e85c5a18e~IJs4btEuH1574115741epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605575933;
        bh=HH/NqwyXdWOgWXZb8phOo0tVJ5pPS37tojmhBry9IvY=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=dIABx3ZAVyQqIVCFRLvyTCBEo1AQYREtSbgbHKV2aeDAZKdpM4eK+TChezUI12uDu
         BVa/HQ6jFuTuHX0anXXgu3hYidWF2VqUOPa2/RovsgiGzobAHWAoJaDntu5iJWWKcW
         CxarGIcr8wvpv0gAyKprowK9u6/YS2dWKQaNGfT0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201117011853epcas2p1054586c2198805cb91d5cd0fcbe745ab~IJs38VKQD0664006640epcas2p1J;
        Tue, 17 Nov 2020 01:18:53 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CZp4D1HD7zMqYks; Tue, 17 Nov
        2020 01:18:52 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-d9-5fb324fa09cf
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.04.56312.AF423BF5; Tue, 17 Nov 2020 10:18:50 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next v2 3/3] nfc: s3fwrn5: Change the error code
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
Message-ID: <20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a@epcms2p5>
Date:   Tue, 17 Nov 2020 10:18:50 +0900
X-CMS-MailID: 20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJsWRmVeSWpSXmKPExsWy7bCmme4vlc3xBku7dCy2NE9it7g9cRqb
        xfnzG9gtLu+aw2YxZ8NmdotjC8Qc2Dw2repk8+ie/Y/Fo2/LKkaPz5vkAliiGhhtEouSMzLL
        UhVS85LzUzLz0m2VQkPcdC2UFDLyi0tslaINLYz0DC1N9Uws9YzMY60MDQyMTJUU8hJzU22V
        KnShupUUipILgKpLUotLilKTU4FCRQ7FJYnpqXrFibnFpXnpesn5uUoKZYk5pUB9Svp2Nhmp
        iSmpRQoJTxgzui5uZC5Yx1Pxp/0VcwPjGq4uRk4OCQETiSdnVrCC2EICOxglNk/W72Lk4OAV
        EJT4u0MYJCws4CLR++QqG0SJosT/jnNsEHFdiRd/j4LZbALaEmuPNjKBtIoIhEh87KvtYuTi
        YBZYzSjR+bOTGWIVr8SM9qcsELa0xPblWxkhbA2JH8t6oWpEJW6ufssOY78/Nh+qRkSi9d5Z
        qBpBiQc/d0PFJSXe7pvHDrJMQqCdUeL8zx9sEM4MRolTm/9CdehLLD63ggnE5hXwlTi9+QPY
        FSwCqhLndy6A2uYisf74PzCbWUBeYvvbOcwg3zALaEqs3wUOEwkBZYkjt1ggKvgkOg7/ZYf5
        a8e8J0wQtqpEb/MXJpgfJ89ugbrTQ2LT+RXskDAMlLjb1MM2gVFhFiKkZyHZOwth7wJG5lWM
        YqkFxbnpqcVGBUbI8byJEZw4tdx2ME55+0HvECMTB+MhRgkOZiURXheTjfFCvCmJlVWpRfnx
        RaU5qcWHGKuAPp7ILCWanA9M3Xkl8YZmBkZmpsYmxsamJqZkC5samZkZWJpamJoZWSiJ84au
        7IsXEkhPLEnNTk0tSC2CWc7EwSnVwFSUOr9NTIZTME7nRM1Z751Tz1kvlO2otviUZMQYPFn6
        7ymd5qdvs9+ctPjKxbTi+YPdCbPurhHNkj/DocvU220/nXPJ1+DPOgY+yXmrnTc5WNzfnhT1
        z61VRWZxQ26nYUrtmZXzps8QERUpNSz4uNy7/4lNmp7lLUM24cu9xj90X325ZHD4wcsZGoLT
        TrWJbVps1fvJ5vkG8QTHFf0tD+ycZ6Scfu9vkJQzKS/cSsHocMllxjVml373pbU1Tn56dUdU
        UcfkT/N09X9WSLzp3PRC6kvu15D/R6azftuxeLJ+Yf8s9/Qz7M0tit/1bh6MXZb3n2+e7ZEd
        M+fL6+XO8m4quyJV80z5UtPDH8YbpyixFGckGmoxFxUnAgB3Oy1zagQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a
References: <CGME20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/s3fwrn5.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/s3fwrn5.h b/drivers/nfc/s3fwrn5/s3fwrn5.h
index 9d5f34759225..bb8f936d13a2 100644
--- a/drivers/nfc/s3fwrn5/s3fwrn5.h
+++ b/drivers/nfc/s3fwrn5/s3fwrn5.h
@@ -44,7 +44,7 @@ static inline int s3fwrn5_set_mode(struct s3fwrn5_info *info,
 	enum s3fwrn5_mode mode)
 {
 	if (!info->phy_ops->set_mode)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	info->phy_ops->set_mode(info->phy_id, mode);
 
@@ -54,7 +54,7 @@ static inline int s3fwrn5_set_mode(struct s3fwrn5_info *info,
 static inline enum s3fwrn5_mode s3fwrn5_get_mode(struct s3fwrn5_info *info)
 {
 	if (!info->phy_ops->get_mode)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return info->phy_ops->get_mode(info->phy_id);
 }
@@ -62,7 +62,7 @@ static inline enum s3fwrn5_mode s3fwrn5_get_mode(struct s3fwrn5_info *info)
 static inline int s3fwrn5_set_wake(struct s3fwrn5_info *info, bool wake)
 {
 	if (!info->phy_ops->set_wake)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	info->phy_ops->set_wake(info->phy_id, wake);
 
@@ -72,7 +72,7 @@ static inline int s3fwrn5_set_wake(struct s3fwrn5_info *info, bool wake)
 static inline int s3fwrn5_write(struct s3fwrn5_info *info, struct sk_buff *skb)
 {
 	if (!info->phy_ops->write)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return info->phy_ops->write(info->phy_id, skb);
 }
-- 
2.17.1

