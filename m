Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50988339899
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhCLUqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:46:21 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:35216 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbhCLUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:45:51 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru F38F3209D4D0
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net-next 3/4] sh_eth: rename *enum*s still not matching
 register names
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <80b5d240-c3be-fad0-a6d4-a98b3ed3b7b9@omprussia.ru>
Date:   Fri, 12 Mar 2021 23:45:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally, rename the rest of the *enum* tags still not (exactly) matching
the abbreviated register names from the manuals...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/sh_eth.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.h
+++ net-next/drivers/net/ethernet/renesas/sh_eth.h
@@ -171,7 +171,7 @@ enum GECMR_BIT {
 };
 
 /* EDMR */
-enum DMAC_M_BIT {
+enum EDMR_BIT {
 	EDMR_NBST = 0x80,
 	EDMR_EL = 0x40, /* Litte endian */
 	EDMR_DL1 = 0x20, EDMR_DL0 = 0x10,
@@ -180,13 +180,13 @@ enum DMAC_M_BIT {
 };
 
 /* EDTRR */
-enum DMAC_T_BIT {
+enum EDTRR_BIT {
 	EDTRR_TRNS_GETHER = 0x03,
 	EDTRR_TRNS_ETHER = 0x01,
 };
 
 /* EDRRR */
-enum EDRRR_R_BIT {
+enum EDRRR_BIT {
 	EDRRR_R = 0x01,
 };
 
@@ -339,7 +339,7 @@ enum RMCR_BIT {
 };
 
 /* ECMR */
-enum FELIC_MODE_BIT {
+enum ECMR_BIT {
 	ECMR_TRCCM = 0x04000000, ECMR_RCSC = 0x00800000,
 	ECMR_DPAD = 0x00200000, ECMR_RZPF = 0x00100000,
 	ECMR_ZPF = 0x00080000, ECMR_PFR = 0x00040000, ECMR_RXF = 0x00020000,
@@ -350,7 +350,7 @@ enum FELIC_MODE_BIT {
 };
 
 /* ECSR */
-enum ECSR_STATUS_BIT {
+enum ECSR_BIT {
 	ECSR_BRCRX = 0x20, ECSR_PSRTO = 0x10,
 	ECSR_LCHNG = 0x04,
 	ECSR_MPD = 0x02, ECSR_ICD = 0x01,
@@ -360,7 +360,7 @@ enum ECSR_STATUS_BIT {
 				 ECSR_ICD | ECSIPR_MPDIP)
 
 /* ECSIPR */
-enum ECSIPR_STATUS_MASK_BIT {
+enum ECSIPR_BIT {
 	ECSIPR_BRCRXIP = 0x20, ECSIPR_PSRTOIP = 0x10,
 	ECSIPR_LCHNGIP = 0x04,
 	ECSIPR_MPDIP = 0x02, ECSIPR_ICDIP = 0x01,
