Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A644102202
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfKSKWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:22:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39466 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfKSKWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:22:04 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191119102202epoutp01996065889cc69571e3d951c143eb58c7~YiTMT6ofW0612806128epoutp01O
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 10:22:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191119102202epoutp01996065889cc69571e3d951c143eb58c7~YiTMT6ofW0612806128epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574158922;
        bh=giaC8e3t68Zws4SFTQRyK+lQ99Gv3gmyFIFl7bI7GhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4ZMl20juRNpdutESt5gT44wIwV5BjoWLrgaAPmvchTscCx0nPImNGG3li7206cFU
         kNUyr0Dr68N73MuxBv2jARQZOE87Y/6/FdJVkgRpxUkGmBrUEFXJLx+GfW2ygW1+iI
         9rqcU1rxghAq8yFVN4MQRQ50Sf8tjgg4LMdeFEjE=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191119102201epcas5p26e77afa93f5e79ac27a673f94431a2e5~YiTLyUUqf1672116721epcas5p2G;
        Tue, 19 Nov 2019 10:22:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.00.04403.942C3DD5; Tue, 19 Nov 2019 19:22:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191119102201epcas5p4e215c25d5d07269a7afb1f86fac0be65~YiTLYkMH12821228212epcas5p4p;
        Tue, 19 Nov 2019 10:22:01 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191119102201epsmtrp251279e5a4f57d71f101ea270c40c4340~YiTLXrDY82129221292epsmtrp2j;
        Tue, 19 Nov 2019 10:22:01 +0000 (GMT)
X-AuditID: b6c32a4a-3cbff70000001133-0b-5dd3c2493a40
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.55.03814.942C3DD5; Tue, 19 Nov 2019 19:22:01 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191119102159epsmtip1dba7c7040027ecf90e7da6f8ef02b58f~YiTJux4Sh3094930949epsmtip1c;
        Tue, 19 Nov 2019 10:21:59 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        dmurphy@ti.com, rcsekar@samsung.com, pankaj.dubey@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: [PATCH 2/2] can: m_can_platform: remove unnecessary
 m_can_class_resume() call
Date:   Tue, 19 Nov 2019 15:50:38 +0530
Message-Id: <1574158838-4616-3-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWy7bCmuq7nocuxBt+PKFnMOd/CYtF9egur
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm6xvOs+s8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zejR/9fAo2/LKkaP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlfF40yS2ghb2is6vJxgb
        GJvYuhg5OSQETCQ2TpzJ0sXIxSEksJtRovfoYTYI5xOjxIe2G4wQzjdGiUnfprDDtExrOc4M
        kdjLKNG3aSErhNPCJNE28w8zSBWbgJ7EpfeTwZaICIRKLOudAFbELHCJUWLO+RWsIAlhgQiJ
        bT2zgIo4OFgEVCUmbwgHCfMKuEtsbz8HdaCcxM1znWAzOQU8JB7MmMkEMkdC4AibxOxbJ5hB
        eiUEXCR2zLSHqBeWeHV8C9SlUhKf3+2FmpMtsXB3PwtEeYVE2wxhiLC9xIErc8DCzAKaEut3
        6YOEmQX4JHp/P2GCqOaV6GgTgqhWk5j69B0jhC0jcefRZqjhHhIPb0+FhuJsRokXj9axTmCU
        nYUwdQEj4ypGydSC4tz01GLTAqO81HK94sTc4tK8dL3k/NxNjOAUoeW1g3HZOZ9DjAIcjEo8
        vCdULscKsSaWFVfmHmKU4GBWEuH1e3QhVog3JbGyKrUoP76oNCe1+BCjNAeLkjjvJNarMUIC
        6YklqdmpqQWpRTBZJg5OqQZGu+rco5Hrph8r26U5W1uCyfehXuSanf+9QmYssnZaGuH5Yp7K
        DC7XI+dr1eY3PXqbIifHe1JAbP0T6e8bllX9LDMVLRBm7PcP3fV4DetZk1nvs93Fn6nPWfSt
        YxPXBuWK0rsl677x3H50e8us1TkWCoq2fZV3r551fL/3ZmC5skX45zMxfCHiSizFGYmGWsxF
        xYkAUDndcg0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWy7bCSnK7nocuxBl8XcVrMOd/CYtF9egur
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm6xvOs+s8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zejR/9fAo2/LKkaP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlfF40yS2ghb2is6vJxgb
        GJvYuhg5OSQETCSmtRxn7mLk4hAS2M0osf38TMYuRg6ghIzE4s/VEDXCEiv/PWeHqGliklj8
        7AIzSIJNQE/i0vvJYINEBMIldk7oYgIpYha4wyjx4/88VpCEsECYxPIPW9hAhrIIqEpM3hAO
        EuYVcJfY3n4O6gg5iZvnOsFmcgp4SDyYMZMJxBYCqvmz+RnLBEa+BYwMqxglUwuKc9Nziw0L
        jPJSy/WKE3OLS/PS9ZLzczcxggNUS2sH44kT8YcYBTgYlXh4T6hcjhViTSwrrsw9xCjBwawk
        wuv36EKsEG9KYmVValF+fFFpTmrxIUZpDhYlcV75/GORQgLpiSWp2ampBalFMFkmDk6pBsby
        bTPZd3Ltb16cbPLgvn6ffeiMX72ne92rVOffvFe6J2H/oRNqcoJ7EiycdsQ7xS3bv3+Zb6XD
        6iBh+chLh7T4NGufb95Xox0U/V1u2oFZ/ZV8zH2xstv/P7b/aliT5vmLISz4w6vzM8oqEmbY
        LpzzOORt4MzD6v6c9gd44rUm/LDl0/mueUOJpTgj0VCLuag4EQBMiBZnTAIAAA==
X-CMS-MailID: 20191119102201epcas5p4e215c25d5d07269a7afb1f86fac0be65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191119102201epcas5p4e215c25d5d07269a7afb1f86fac0be65
References: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
        <CGME20191119102201epcas5p4e215c25d5d07269a7afb1f86fac0be65@epcas5p4.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function m_can_runtime_resume() is getting recursively called from
m_can_class_resume(). This results in a lock up.

We need not call m_can_class_resume() during m_can_runtime_resume().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
---
 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 2eaa354..38ea5e6 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -166,8 +166,6 @@ static int __maybe_unused m_can_runtime_resume(struct device *dev)
 	if (err)
 		clk_disable_unprepare(mcan_class->hclk);
 
-	m_can_class_resume(dev);
-
 	return err;
 }
 
-- 
2.7.4

