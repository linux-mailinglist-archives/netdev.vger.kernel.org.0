Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4582B3B2B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 02:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgKPBT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 20:19:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47882 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgKPBT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 20:19:56 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201116011954epoutp01bb3cdb8edcc6c34540cfb8fc7f293eea~H2EegBMAh3062230622epoutp013
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:19:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201116011954epoutp01bb3cdb8edcc6c34540cfb8fc7f293eea~H2EegBMAh3062230622epoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605489594;
        bh=HH/NqwyXdWOgWXZb8phOo0tVJ5pPS37tojmhBry9IvY=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=AJf1jrN+MPwj17Pebq7AFONzlWnIX58V4UIBqkHw1rwHpAKPLIGU5CEdURTqVcgoo
         3xrFKnp/nL1EmCSp5N1lXIABmKAtJGSSk7ZR5yujsoV3O96gEhO9u67G9GNnRwBl+R
         BMdSF2bztodBWkyQdpw7YENUqPEV3c1SflIrl/jw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201116011953epcas2p4bb2622adcfcb83d735de67dae93eee0f~H2Ed_hDkX1627416274epcas2p42;
        Mon, 16 Nov 2020 01:19:53 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CZB7q64bjzMqYks; Mon, 16 Nov
        2020 01:19:51 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-04-5fb1d3b7d007
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.2A.10621.7B3D1BF5; Mon, 16 Nov 2020 10:19:51 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 3/3] nfc: s3fwrn5: Change the error code
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
Message-ID: <20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955@epcms2p6>
Date:   Mon, 16 Nov 2020 10:19:50 +0900
X-CMS-MailID: 20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmqe72yxvjDVatZLPY0jyJ3eL2xGls
        FufPb2C3uLxrDpvFnA2b2S2OLRBzYPPYtKqTzaN79j8Wj74tqxg9Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyei6uJG5YB1P
        xZ/2V8wNjGu4uhg5OSQETCSuT7rA2sXIxSEksINR4vXCJ0xdjBwcvAKCEn93CIPUCAs4SrQs
        uc8OYgsJKEr87zjHBhHXlXjx9yiYzSagLbH2aCNYq4hAiMTHvlqQkcwCqxklOn92MkPs4pWY
        0f6UBcKWlti+fCsjhK0h8WNZL1SNqMTN1W/ZYez3x+ZD1YhItN47C1UjKPHg526ouKTE233z
        2EGWSQi0M0qc//mDDcKZwShxavNfqA59icXnVkA95itx8407iMkioCqx+Y4vRIWLRPf12WDV
        zALyEtvfzmEGKWEW0JRYv0sfxJQQUJY4cosFooJPouPwX3aYr3bMAwUaiK0q0dv8hQnmw8mz
        W6Cu9JD4cPcJNAQDJX58Xck0gVFhFiKcZyHZOwth7wJG5lWMYqkFxbnpqcVGBYbIUbuJEZwK
        tVx3ME5++0HvECMTB+MhRgkOZiURXheTjfFCvCmJlVWpRfnxRaU5qcWHGE2BHp7ILCWanA9M
        xnkl8YamRmZmBpamFqZmRhZK4ryhK/vihQTSE0tSs1NTC1KLYPqYODilGpg21l12f7dmdeNu
        9kfLeaYueHfs0pPzalI7jwUn9Eh2lllMPzjlq9yk298kSh5tD1E+drSa5Xn4wd/2CRuCubcu
        k9mZuCQ/xH3VPs+NJ+p5jvzRvcI+u4xF7JKQ8snzG+yOsZwPWTtxOsPr9FyNEPsJZzdtWF/2
        nGPaqufvIrZm9Sy3uvcm/4/cP7V2zjX1RW67K/aphhTLlV6LvCc4pbmIh8+8xVGwUPDQBhXm
        dQe/rTH9bv1TxdMuKfhp2eTKToYOroZQKZNPjIF+zYuzX35smjnt6oU9EwOna/5YY9R/1kfs
        7db+5TY31mu5fWW0TJq0bktfk5zFGcdHtx5NXbVfTqr22ZPLRoyufOc1jeJvKrEUZyQaajEX
        FScCAI8AYPcOBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955
References: <CGME20201116011950epcms2p68117cc4a7228db2baecb7d4a4840b955@epcms2p6>
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

