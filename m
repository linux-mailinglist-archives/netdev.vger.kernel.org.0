Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A312B5628
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgKQBRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:17:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33738 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbgKQBRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:17:48 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201117011745epoutp018c675a712487876a02b18d92fd8e4f2f~IJr47Jy1k1693616936epoutp01F
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 01:17:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201117011745epoutp018c675a712487876a02b18d92fd8e4f2f~IJr47Jy1k1693616936epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605575865;
        bh=TfUkL+lDZElGHDBaFwcjW6Ej9dQR2j3RjB2y/gxXwDA=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=fRdz+HMw7n+A8HzH4lFSJfuKC+UaXcCuPzlBi5olUrWfmcju9Id2oq4vJkgblWlIG
         rcIjiGj7NwBgmgOynAzBG5sd/68wAEr1zSLxtrwyDbXwMmhVHc5XS/a8xdMj3zAMBF
         OgIoMrCK0c62Dsy2qA39zQ3Wr7w6SrUyJIGerLCg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201117011745epcas2p139a0e98e2883479d652d0d66c0bfbc43~IJr4qWAlA2992829928epcas2p1U;
        Tue, 17 Nov 2020 01:17:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CZp2v6KsJzMqYkg; Tue, 17 Nov
        2020 01:17:43 +0000 (GMT)
X-AuditID: b6c32a47-715ff7000000d2c4-c2-5fb324b7d76f
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.D9.53956.7B423BF5; Tue, 17 Nov 2020 10:17:43 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next v2 2/3] nfc: s3fwrn5: Fix the misspelling in a
 comment
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
Message-ID: <20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f@epcms2p1>
Date:   Tue, 17 Nov 2020 10:17:42 +0900
X-CMS-MailID: 20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmhe52lc3xBk0f5S22NE9it7g9cRqb
        xfnzG9gtLu+aw2YxZ8NmdotjC8Qc2Dw2repk8+ie/Y/Fo2/LKkaPz5vkAliicmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
        9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMo6uPM5UsJy1
        omf3BbYGxi0sXYycHBICJhL93ZsZuxi5OIQEdjBK3P++ASjBwcErICjxd4cwiCksECjxqTsI
        pFxIQFHif8c5NhBbWEBX4sXfo2A2m4C2xNqjjUwg5SICIRIf+2pBJjILrGaU6PzZyQyxildi
        RvtTqLXSEtuXb2WEsDUkfizrhaoRlbi5+i07jP3+2HyoGhGJ1ntnoWoEJR783A0Vl5R4u28e
        O8gyCYF2RonzP3+wQTgzGCVObf4L1aEvsfjcCiaIv3wlzrx3AQmzCKhK9By4wQRR4iLRuXUl
        2DPMAvIS29/OYQYpZxbQlFi/Sx/ElBBQljhyiwWigk+i4/Bfdpi3dsx7AjVFVaK3+QsTzIuT
        Z7dAnekhcfbIFzZIEAZK3F1wiGkCo8IsRDjPQrJ3FsLeBYzMqxjFUguKc9NTi40KjJGjdhMj
        OBVque9gnPH2g94hRiYOxkOMEhzMSiK8LiYb44V4UxIrq1KL8uOLSnNSiw8xmgJ9PJFZSjQ5
        H5iM80riDU2NzMwMLE0tTM2MLJTEeUNX9sULCaQnlqRmp6YWpBbB9DFxcEo1MFV0uapIn73I
        131OfxbPOaZJT237Us7UbMwtXZTmNedecZhi/bejv8JufpHxUDj69aWjyObFt097bp7+vPns
        f/XHZ/bLvTBcm+n/Z+51+f/5+Yd/bDsU8tU37m+i7fPJCw7Kbqq+yFEyy5tPqijHMjD12576
        B6dvzi1lldg4synP4tb9HlWbN7KV1n5r3G975QUvnrjti13C8onL289dst0gdCHvE/th2Q3V
        bXKP1Y8JCYtO1nkaPTuKya45ruXP9A11Jya+95pW7J8/k0+rm72l1t7IZrbihpJnO6zqWSev
        t60wPGFuo8B+OEzSvOmXQFdALS+v3cljzS99mJbFMMuf2nLwxIlzL0/uK0+L2avEUpyRaKjF
        XFScCACdZZekDgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f
References: <CGME20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f@epcms2p1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stucture should be replaced by structure.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index ec930ee2c847..4cde6dd5c019 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -266,7 +266,7 @@ static int s3fwrn5_fw_complete_update_mode(struct s3fwrn5_fw_info *fw_info)
 }
 
 /*
- * Firmware header stucture:
+ * Firmware header structure:
  *
  * 0x00 - 0x0B : Date and time string (w/o NUL termination)
  * 0x10 - 0x13 : Firmware version
-- 
2.17.1

