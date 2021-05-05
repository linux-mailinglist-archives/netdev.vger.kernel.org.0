Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA4F37449A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhEEQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:58:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235983AbhEEQzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAA161988;
        Wed,  5 May 2021 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232726;
        bh=jfiQNzFTJKTcipJOpZRWp7iEJN2Gn0ISgW8pgMtkPio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ez+dPndECB+gNaRhFf8of67CGZAXsD2Ksclf80N4sLIayhF0hTUrbdIhRkuGolpFD
         sTMOUeO5WpJ796l/y84KbaeTEmIVTqZBxe8PsHk1ue3hGPRKxM/DB0TsP3e3fensw2
         4eY7lgOARxz6hmWZDvHhpaZ6KE154Os0p3wnWnPNFjCa649tn+o+TsVzjNev14XAh6
         7p7QNv6VLMCbWaI+paiFn4t15PNlvA0hSY72DqCF/0JHNAj4rLMwpDxz5nKXgeH7C/
         +tg6abv7q3L68Tvjpbo3IlkFUWrnqm8W5yVwX9xcTu4a0A1zhunHmNR0N0VQU95No4
         fG5BXZWd4SZhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 80/85] bnxt_en: Add PCI IDs for Hyper-V VF devices.
Date:   Wed,  5 May 2021 12:36:43 -0400
Message-Id: <20210505163648.3462507-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 7fbf359bb2c19c824cbb1954020680824f6ee5a5 ]

Support VF device IDs used by the Hyper-V hypervisor.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a59c1f1fb31e..ac714985142c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -122,7 +122,10 @@ enum board_idx {
 	NETXTREME_E_VF,
 	NETXTREME_C_VF,
 	NETXTREME_S_VF,
+	NETXTREME_C_VF_HV,
+	NETXTREME_E_VF_HV,
 	NETXTREME_E_P5_VF,
+	NETXTREME_E_P5_VF_HV,
 };
 
 /* indexed by enum above */
@@ -170,7 +173,10 @@ static const struct {
 	[NETXTREME_E_VF] = { "Broadcom NetXtreme-E Ethernet Virtual Function" },
 	[NETXTREME_C_VF] = { "Broadcom NetXtreme-C Ethernet Virtual Function" },
 	[NETXTREME_S_VF] = { "Broadcom NetXtreme-S Ethernet Virtual Function" },
+	[NETXTREME_C_VF_HV] = { "Broadcom NetXtreme-C Virtual Function for Hyper-V" },
+	[NETXTREME_E_VF_HV] = { "Broadcom NetXtreme-E Virtual Function for Hyper-V" },
 	[NETXTREME_E_P5_VF] = { "Broadcom BCM5750X NetXtreme-E Ethernet Virtual Function" },
+	[NETXTREME_E_P5_VF_HV] = { "Broadcom BCM5750X NetXtreme-E Virtual Function for Hyper-V" },
 };
 
 static const struct pci_device_id bnxt_pci_tbl[] = {
@@ -222,15 +228,25 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
 	{ PCI_VDEVICE(BROADCOM, 0x1606), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x1607), .driver_data = NETXTREME_E_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x1608), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1609), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16bd), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x16c1), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16c2), .driver_data = NETXTREME_C_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c3), .driver_data = NETXTREME_C_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c4), .driver_data = NETXTREME_E_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c5), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x16cb), .driver_data = NETXTREME_C_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16d3), .driver_data = NETXTREME_E_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16dc), .driver_data = NETXTREME_E_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e1), .driver_data = NETXTREME_C_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e5), .driver_data = NETXTREME_C_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16e6), .driver_data = NETXTREME_C_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1806), .driver_data = NETXTREME_E_P5_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x1807), .driver_data = NETXTREME_E_P5_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x1808), .driver_data = NETXTREME_E_P5_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x1809), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0xd800), .driver_data = NETXTREME_S_VF },
 #endif
 	{ 0 }
@@ -263,7 +279,8 @@ static struct workqueue_struct *bnxt_pf_wq;
 static bool bnxt_vf_pciid(enum board_idx idx)
 {
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
-		idx == NETXTREME_S_VF || idx == NETXTREME_E_P5_VF);
+		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
+		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
-- 
2.30.2

