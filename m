Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40FE2B29CC
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKNAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:21:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11451 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgKNAVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:21:42 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201114002139epoutp0483f4c953927a92dc3b7c0258199e76e8~HN-C5-lmJ1132811328epoutp04R
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:21:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201114002139epoutp0483f4c953927a92dc3b7c0258199e76e8~HN-C5-lmJ1132811328epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605313299;
        bh=KyL2hCGgsFaiWlEtKaeh3s+jfB7E11LNfY3tqcbJ/nc=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=nymbtww4fCKVQE9HHsvhXLb5Hhkyj+kMQSzrZvZqUFVeWF69bPkWg66OfUm7Lr1RV
         L8dTalsqaYTA42kmM2uJsWzRdQ2zI//iNWe7yz2lAPVm/wu96Nygt0NrH+lvhbWdGV
         wTYJDj2+rg71Eddv2CDs4P8iUvfkPCVw8ch8dQzg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201114002138epcas2p2bf1d93fa9f74fda66f0b23e3df292e7f~HN-B-tcU83081430814epcas2p2P;
        Sat, 14 Nov 2020 00:21:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CXwxX70FtzMqYkY; Sat, 14 Nov
        2020 00:21:36 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-6b-5faf230ed2ca
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.51.52511.E032FAF5; Sat, 14 Nov 2020 09:21:34 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 3/3] nfc: s3fwrn5: Change the error code.
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
Message-ID: <20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237@epcms2p1>
Date:   Sat, 14 Nov 2020 09:21:34 +0900
X-CMS-MailID: 20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmhS6f8vp4g2vTzCxuT5zGZnH+/AZ2
        iwvb+lgtji0Qc2Dx2LSqk82jb8sqRo/Pm+QCmKNybDJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEqE3Iy9h6awFSwhKdi5rxLzA2My7i6GDk5JARM
        JE58n8vaxcjFISSwg1FiQusbpi5GDg5eAUGJvzuEQWqEBZwkPv3aywhiCwkoSvzvOMcGEdeV
        ePH3KJjNJqAtsfZoIxOILSJQKXFg0XGwemYBU4lnp9+yQOzilZjR/hTKlpbYvnwrI4StIfFj
        WS8zhC0qcXP1W3YY+/2x+VA1IhKt985C1QhKPPi5GyouKfF23zx2kPslBNoZJc7//MEG4cxg
        lDi1+S9Uh77E4nMrwK7jFfCVmLtkB9gGFgFViW3zlrBC1LhI7F9znxXianmJ7W/nMIMCgllA
        U2L9Ln0QU0JAWeLILRaICj6JjsN/2WH+2jHvCROErSrR2/yFCebHybNbGCFaPSRWb2CBBGGg
        xM3bCxknMCrMQgT0LCRrZyGsXcDIvIpRLLWgODc9tdiowAQ5bjcxgtOdlscOxtlvP+gdYmTi
        YDzEKMHBrCTCq+ywJl6INyWxsiq1KD++qDQntfgQoynQwxOZpUST84EJN68k3tDUyMzMwNLU
        wtTMyEJJnDd0ZV+8kEB6YklqdmpqQWoRTB8TB6dUA5MKs/OJ4quHTd8F/mtlZ5Z7kKpd2WTH
        5fPRYLt8J88cZiExHa0Hd/Ye8pBfd5onZDFXfeFj7eiQ+uchK4QDsrYE1v9MPXRs4bt/ZovE
        mrYb/GGVr2DwVYgL9P2SFvjC2umzr98dZdk9Jq36VbcsHz7xWN5SGS91asoDSza23K+Sjv2N
        b472Hwx/cfumkTGz6+mjazw/OiTuZVpxmOOM1MWjIeWZ6Ws3td4LbfhSb5I8w/3getP+J7zB
        r5/v+1J6g2XWWr55Gj89XJ5+ns2i4XS68C/jbBdJfY3oaXMmT/34nvesaU++4Y+AqzLa7uVS
        kbJNb6/senOK4XtNisOnJw23D/KudJnP8qLZ5+DlK0osxRmJhlrMRcWJAPHvXEMABAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237
References: <CGME20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237@epcms2p1>
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
