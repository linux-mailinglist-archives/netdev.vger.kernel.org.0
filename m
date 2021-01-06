Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231992EC53E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbhAFUkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:40:51 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:50492 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbhAFUku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:40:50 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 7776920CCC3A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net-next 2/2] ravb: update "undocumented" annotations
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <7d1107cb-f498-3401-f2c1-a0e0f3736162@omprussia.ru>
Date:   Wed, 6 Jan 2021 23:32:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "undocumented" annotations in the EtherAVB driver were done against
the R-Car gen2 manuals; most of these registers/bits were then described
in the R-Car gen3 manuals -- reflect  this fact in the annotations (note
that ECSIPR.LCHNGIP was documented in the recent R-Car gen2 manual)...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/ravb.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/ravb.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/ravb.h
+++ net-next/drivers/net/ethernet/renesas/ravb.h
@@ -165,7 +165,7 @@ enum ravb_reg {
 	GTO2	= 0x03A8,
 	GIC	= 0x03AC,
 	GIS	= 0x03B0,
-	GCPT	= 0x03B4,	/* Undocumented? */
+	GCPT	= 0x03B4,	/* Documented for R-Car Gen3 only */
 	GCT0	= 0x03B8,
 	GCT1	= 0x03BC,
 	GCT2	= 0x03C0,
@@ -225,7 +225,7 @@ enum CSR_BIT {
 	CSR_OPS_RESET	= 0x00000001,
 	CSR_OPS_CONFIG	= 0x00000002,
 	CSR_OPS_OPERATION = 0x00000004,
-	CSR_OPS_STANDBY	= 0x00000008,	/* Undocumented? */
+	CSR_OPS_STANDBY	= 0x00000008,	/* Documented for R-Car Gen3 only */
 	CSR_DTS		= 0x00000100,
 	CSR_TPO0	= 0x00010000,
 	CSR_TPO1	= 0x00020000,
@@ -529,16 +529,16 @@ enum RIS2_BIT {
 
 /* TIC */
 enum TIC_BIT {
-	TIC_FTE0	= 0x00000001,	/* Undocumented? */
-	TIC_FTE1	= 0x00000002,	/* Undocumented? */
+	TIC_FTE0	= 0x00000001,	/* Documented for R-Car Gen3 only */
+	TIC_FTE1	= 0x00000002,	/* Documented for R-Car Gen3 only */
 	TIC_TFUE	= 0x00000100,
 	TIC_TFWE	= 0x00000200,
 };
 
 /* TIS */
 enum TIS_BIT {
-	TIS_FTF0	= 0x00000001,	/* Undocumented? */
-	TIS_FTF1	= 0x00000002,	/* Undocumented? */
+	TIS_FTF0	= 0x00000001,	/* Documented for R-Car Gen3 only */
+	TIS_FTF1	= 0x00000002,	/* Documented for R-Car Gen3 only */
 	TIS_TFUF	= 0x00000100,
 	TIS_TFWF	= 0x00000200,
 	TIS_RESERVED	= (GENMASK(31, 20) | GENMASK(15, 12) | GENMASK(7, 4))
@@ -546,8 +546,8 @@ enum TIS_BIT {
 
 /* ISS */
 enum ISS_BIT {
-	ISS_FRS		= 0x00000001,	/* Undocumented? */
-	ISS_FTS		= 0x00000004,	/* Undocumented? */
+	ISS_FRS		= 0x00000001,	/* Documented for R-Car Gen3 only */
+	ISS_FTS		= 0x00000004,	/* Documented for R-Car Gen3 only */
 	ISS_ES		= 0x00000040,
 	ISS_MS		= 0x00000080,
 	ISS_TFUS	= 0x00000100,
@@ -607,13 +607,13 @@ enum GTI_BIT {
 
 /* GIC */
 enum GIC_BIT {
-	GIC_PTCE	= 0x00000001,	/* Undocumented? */
+	GIC_PTCE	= 0x00000001,	/* Documented for R-Car Gen3 only */
 	GIC_PTME	= 0x00000004,
 };
 
 /* GIS */
 enum GIS_BIT {
-	GIS_PTCF	= 0x00000001,	/* Undocumented? */
+	GIS_PTCF	= 0x00000001,	/* Documented for R-Car Gen3 only */
 	GIS_PTMF	= 0x00000004,
 	GIS_RESERVED	= GENMASK(15, 10),
 };
@@ -807,10 +807,10 @@ enum ECMR_BIT {
 	ECMR_TE		= 0x00000020,
 	ECMR_RE		= 0x00000040,
 	ECMR_MPDE	= 0x00000200,
-	ECMR_TXF	= 0x00010000,	/* Undocumented? */
+	ECMR_TXF	= 0x00010000,	/* Documented for R-Car Gen3 only */
 	ECMR_RXF	= 0x00020000,
 	ECMR_PFR	= 0x00040000,
-	ECMR_ZPF	= 0x00080000,	/* Undocumented? */
+	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 only */
 	ECMR_RZPF	= 0x00100000,
 	ECMR_DPAD	= 0x00200000,
 	ECMR_RCSC	= 0x00800000,
@@ -829,7 +829,7 @@ enum ECSR_BIT {
 enum ECSIPR_BIT {
 	ECSIPR_ICDIP	= 0x00000001,
 	ECSIPR_MPDIP	= 0x00000002,
-	ECSIPR_LCHNGIP	= 0x00000004,	/* Undocumented? */
+	ECSIPR_LCHNGIP	= 0x00000004,
 };
 
 /* PIR */
