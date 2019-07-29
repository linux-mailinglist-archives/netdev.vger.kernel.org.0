Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A978957
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfG2KLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:38 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39159 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbfG2KL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:29 -0400
Received: by mail-pl1-f170.google.com with SMTP id b7so27369708pls.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AKTCefLhi/KGcts9Q6rrs/ZyJDUF2rkevt/r+rLoOcA=;
        b=cOYUSB4BXL19qxKMNL8K6GVu3fBjTyYz0h+k5AE4czsRuetJKBJKgGgZGdDwc48l3B
         ETpN8+8D1IhZXx4wMtSHPMx2R0Sr5P/FFijDLAufgpadHfnTvqSePFAe0AOHF4nGbnmn
         8w9RbxPJZBGUZwx5CF2HLYbzgKW4QRLnkq5uw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AKTCefLhi/KGcts9Q6rrs/ZyJDUF2rkevt/r+rLoOcA=;
        b=lPl1d4k2HqLzsX48UxXIeNKXgq0V4qpeSC3LdFTa46q3+xlLuq2/BHwHpF0Q290H8q
         UOQTRondynhysnMagE1HxIj/R591PtGGy1IE4cqT93k6yQ2q4fLjllupVPwh4POPDY7V
         vbEa/wQylGBP3O6LtCMtZWpDwz6xS0jnS/ps4kjTs6SMq4u6DBkACUn8atEILaHwExh5
         SM7YZqZp2oXW2usTL+QL5G05JIITeVy0Ryi4orpi/mw1vfGeqY2/WxUdhjZJBu6dspMn
         3b1Ko1n4z1wn7nr2CzX4FBqJ+lVMtqyY7rOyBhRrEo1mwcRSQI42B9jGlXMkNN3Oznhn
         S+YA==
X-Gm-Message-State: APjAAAXEVko1tL/6wmZca43ymX9VKVhwcgMIB6EOLPrlsJdkPVbyBfZ0
        D2NYRCGrHxlUM2EcWKBBq8iYqpoQZqs=
X-Google-Smtp-Source: APXvYqyBoS+8us8b4wKkq7hixVz7mpmr3/4mdE3hKt43yoFsr4KyiY1nh4Z24eLCWgtdGb3ZjpENxQ==
X-Received: by 2002:a17:902:28:: with SMTP id 37mr101274722pla.188.1564395088357;
        Mon, 29 Jul 2019 03:11:28 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 16/16] bnxt_en: Add PCI IDs for 57500 series NPAR devices.
Date:   Mon, 29 Jul 2019 06:10:33 -0400
Message-Id: <1564395033-19511-17-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9fe81fa..7a9b92e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -116,6 +116,9 @@ enum board_idx {
 	BCM57508,
 	BCM57504,
 	BCM57502,
+	BCM57508_NPAR,
+	BCM57504_NPAR,
+	BCM57502_NPAR,
 	BCM58802,
 	BCM58804,
 	BCM58808,
@@ -161,6 +164,9 @@ static const struct {
 	[BCM57508] = { "Broadcom BCM57508 NetXtreme-E 10Gb/25Gb/50Gb/100Gb/200Gb Ethernet" },
 	[BCM57504] = { "Broadcom BCM57504 NetXtreme-E 10Gb/25Gb/50Gb/100Gb/200Gb Ethernet" },
 	[BCM57502] = { "Broadcom BCM57502 NetXtreme-E 10Gb/25Gb/50Gb Ethernet" },
+	[BCM57508_NPAR] = { "Broadcom BCM57508 NetXtreme-E Ethernet Partition" },
+	[BCM57504_NPAR] = { "Broadcom BCM57504 NetXtreme-E Ethernet Partition" },
+	[BCM57502_NPAR] = { "Broadcom BCM57502 NetXtreme-E Ethernet Partition" },
 	[BCM58802] = { "Broadcom BCM58802 NetXtreme-S 10Gb/25Gb/40Gb/50Gb Ethernet" },
 	[BCM58804] = { "Broadcom BCM58804 NetXtreme-S 10Gb/25Gb/40Gb/50Gb/100Gb Ethernet" },
 	[BCM58808] = { "Broadcom BCM58808 NetXtreme-S 10Gb/25Gb/40Gb/50Gb/100Gb Ethernet" },
@@ -209,6 +215,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
 	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
+	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
-- 
2.5.1

