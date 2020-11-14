Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABCB2B29C9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgKNATZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:19:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11051 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNATZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 19:19:25 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201114001922epoutp047aef755294f7e626fca2b75837c4daf1~HN9DlT8vL0425904259epoutp04M
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:19:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201114001922epoutp047aef755294f7e626fca2b75837c4daf1~HN9DlT8vL0425904259epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605313162;
        bh=zs/00+691ryveI0MxspXLZ7OB7KyPJVjO4HgU7wBAjs=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=dJEgxxT7h2vPKa/MNCtZtf4csI9bOLBuCxNK+cZ1VDWFoKbCijXSa42ObNw4D4/p2
         sr4Y95tLYNOcxBn9vXr4SqLmqlSxaP1aQximSI++cYq0q0Mg4pdADHDeShdUKrxOpn
         cCGEK+NZrNUpRDSfa+jDOSJ9C15+iI0pBuEC8b+o=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201114001921epcas2p323fa28493da773eccc123782917792e6~HN9C8KICW2671726717epcas2p38;
        Sat, 14 Nov 2020 00:19:21 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CXwtw2sbFzMqYkY; Sat, 14 Nov
        2020 00:19:20 +0000 (GMT)
X-AuditID: b6c32a47-715ff7000000d2c4-a5-5faf2288d5cc
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.D4.53956.8822FAF5; Sat, 14 Nov 2020 09:19:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 2/3] nfc: s3fwrn5: Fix the misspelling in a comment
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
Message-ID: <20201114001920epcms2p78585234d9079f03673efdab2dc817548@epcms2p7>
Date:   Sat, 14 Nov 2020 09:19:20 +0900
X-CMS-MailID: 20201114001920epcms2p78585234d9079f03673efdab2dc817548
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmuW6H0vp4g4P7RCy2NE9it7g9cRqb
        xfnzG9gtLmzrY7U4tkDMgdVj06pONo++LasYPT5vkgtgjsqxyUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMlY/Ee94ANLxfJ/zawNjF0sXYwc
        HBICJhLXHgV2MXJxCAnsYJRYMHsnG0icV0BQ4u8O4S5GTg5hAR+JnlMPmUBsIQFFif8d59gg
        4roSL/4eBbPZBLQl1h5tBKsREaiUOLDoOCOIzSxgKvHs9FsWEFtCgFdiRvtTKFtaYvvyrYwQ
        tobEj2W9zBC2qMTN1W/ZYez3x+ZD1YhItN47C1UjKPHg526ouKTE233z2EHulxBoZ5Q4//MH
        G4Qzg1Hi1Oa/UB36EovPrQC7jlfAV2Lhn3awK1gEVCUeLrvGBFHjIrHp/zMWiKvlJba/ncMM
        CghmAU2J9bv0IWGlLHHkFlQFn0TH4b/sMH/tmPcEaoqqRG/zFyaYHyfPboG600Ni5Zp90DAM
        lPj5+BvjBEaFWYiQnoVk7yyEvQsYmVcxiqUWFOempxYbFRgjR+0mRnDa03LfwTjj7Qe9Q4xM
        HIyHGCU4mJVEeJUd1sQL8aYkVlalFuXHF5XmpBYfYjQF+ngis5Rocj4w8eaVxBuaGpmZGVia
        WpiaGVkoifOGruyLFxJITyxJzU5NLUgtgulj4uCUamBaa5Dx5FkR95VnYj8P1H7jTyvIVFVh
        WqmY8vJoh+Q574f+N2s6zVVWztqwo40x5dPy2Or9QaHGLqdP8e24KLf0QSrX27yjn7bahjFM
        TXytsKSJ7/KDrdK6L1sTDO3v/5sQXnvB1934rlHthbc3LO8cW+Zp/Inzp3Kv+4F9ihVrPX+e
        7Mu+w5ejdJxtoe5dcd50ueqXFy63erF8Y1u4vqr3H+PkNbybE21ZNrH9MJnY0d9/w/ZwwhGJ
        3j1fLtnXrLrREKJ9Zs2nd38+1hi/z94kZ9QW8a/O8f5EafnWkx//7jD+s/7+uv45yd95j7lX
        cX3YsCem9fmtyKuzygTSVR+LNr54XLkixbGvx0Cda8FVJZbijERDLeai4kQAhNFEwQQEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201114001920epcms2p78585234d9079f03673efdab2dc817548
References: <CGME20201114001920epcms2p78585234d9079f03673efdab2dc817548@epcms2p7>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


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
