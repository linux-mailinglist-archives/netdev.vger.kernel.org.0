Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250C713F2E
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfEELRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46167 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfEELRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id t187so884281pgb.13
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YnitByAMRX/eyDXwVy7jeAlYnzqzGMvTT5MlSLMgYtQ=;
        b=B2XMBzSBBa8kYlLR1ke15E/BqpX6A6YS+bW5cgHM8fuLyzjihSLhu8lBBKB23WGh8T
         4n8Pzu3lObRzhm7tXlTprCYrgGi4+n4Ql1HFhopXU2GfbPq6nNuPpAyZLYtQ7skCjcO5
         W7AvH4FaxzH39BbwBke+HVOx6/vx0LgKif7hU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YnitByAMRX/eyDXwVy7jeAlYnzqzGMvTT5MlSLMgYtQ=;
        b=Kd2dfubAhQj5NexB00z3o6//9M71+1HloaRhXDpW41L97Hw5hIleQvo+UeGrlpaTl7
         f6tJHdKobvFcsLyz5TrgK89xPmRGl9RMWeSRwo+6pdN72NKLPIzUmeoBTQCuInOsJMlf
         rs3i+EzORq3DnUgCbcCWDCPuPMGerLuNP28ojSzyCfo//IxBJWTQ+ruMq6LXgOmDbpEH
         41MS0n8lOg9OdpytGGFyb2CMIpSxBgggR5jykZaQsiEGAlMg++cXlkxWj+/gpHLNYUm4
         LyxsvVSKjTVI6jHJO4JOC2mzxSEwaP9No8GD4U4Na9SXq0+kje+nmrhy7amPZZi9+6VQ
         4FJg==
X-Gm-Message-State: APjAAAW5gvIAf3F1j+TGg8RVhAfGs8G5fce4de8uSAMJBG9FTKEMOnHp
        77x6xGSb6p/ePQR6UQ/je/tX1w==
X-Google-Smtp-Source: APXvYqyVWITsuFDpa24iCOhbLaSd4avC2HGwcM2SXMtEujHDZ7z3c9j5y0Vae+E5p5/ZSi/Mvvn2zQ==
X-Received: by 2002:a63:d016:: with SMTP id z22mr24534190pgf.116.1557055049971;
        Sun, 05 May 2019 04:17:29 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:29 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 11/11] bnxt_en: Add device IDs 0x1806 and 0x1752 for 57500 devices.
Date:   Sun,  5 May 2019 07:17:08 -0400
Message-Id: <1557055028-14816-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0x1806 and 0x1752 are VF variant and PF variant of the 57500 chip
family.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 143fdc9..e2c022e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -114,6 +114,7 @@ enum board_idx {
 	BCM5745x_NPAR,
 	BCM57508,
 	BCM57504,
+	BCM57502,
 	BCM58802,
 	BCM58804,
 	BCM58808,
@@ -158,6 +159,7 @@ static const struct {
 	[BCM5745x_NPAR] = { "Broadcom BCM5745x NetXtreme-E Ethernet Partition" },
 	[BCM57508] = { "Broadcom BCM57508 NetXtreme-E 10Gb/25Gb/50Gb/100Gb/200Gb Ethernet" },
 	[BCM57504] = { "Broadcom BCM57504 NetXtreme-E 10Gb/25Gb/50Gb/100Gb/200Gb Ethernet" },
+	[BCM57502] = { "Broadcom BCM57502 NetXtreme-E 10Gb/25Gb/50Gb Ethernet" },
 	[BCM58802] = { "Broadcom BCM58802 NetXtreme-S 10Gb/25Gb/40Gb/50Gb Ethernet" },
 	[BCM58804] = { "Broadcom BCM58804 NetXtreme-S 10Gb/25Gb/40Gb/50Gb/100Gb Ethernet" },
 	[BCM58808] = { "Broadcom BCM58808 NetXtreme-S 10Gb/25Gb/40Gb/50Gb/100Gb Ethernet" },
@@ -205,6 +207,7 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x16f1), .driver_data = BCM57452 },
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
+	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
@@ -216,6 +219,7 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x16dc), .driver_data = NETXTREME_E_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e1), .driver_data = NETXTREME_C_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e5), .driver_data = NETXTREME_C_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x1806), .driver_data = NETXTREME_E_P5_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x1807), .driver_data = NETXTREME_E_P5_VF },
 	{ PCI_VDEVICE(BROADCOM, 0xd800), .driver_data = NETXTREME_S_VF },
 #endif
-- 
2.5.1

