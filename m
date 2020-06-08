Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259E1F2D84
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgFHXOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgFHXO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A222121527;
        Mon,  8 Jun 2020 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658066;
        bh=Ioq5oSR0MIiJstNPITP02CH7m7AaNYznuEU4MG1tsrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtWZzuCrWIxFM6F2AS0aFR9CYL08qNssv69lgoJ+YOakF+kGB2ibMeU4sp3fnGCt/
         7bQkOzh0rydVPTUNwnl0EtHxyeFKH1YDTWYNxXdyNrPRq7S4byucCajNlahU0U6H6D
         LqCfYFTUT38NEu6TVscLOTfEhlyrBG/So932TDys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Clark <richard.xnu.clark@gmail.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 112/606] aquantia: Fix the media type of AQC100 ethernet controller in the driver
Date:   Mon,  8 Jun 2020 19:03:57 -0400
Message-Id: <20200608231211.3363633-112-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Clark <richard.xnu.clark@gmail.com>

[ Upstream commit 6de556c31061e3b9c36546ffaaac5fdb679a2f14 ]

The Aquantia AQC100 controller enables a SFP+ port, so the driver should
configure the media type as '_TYPE_FIBRE' instead of '_TYPE_TP'.

Signed-off-by: Richard Clark <richard.xnu.clark@gmail.com>
Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 78b6f3248756..e0625c67eed3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -56,7 +56,7 @@ static const struct aq_board_revision_s hw_atl_boards[] = {
 	{ AQ_DEVICE_ID_D108,	AQ_HWREV_2,	&hw_atl_ops_b0, &hw_atl_b0_caps_aqc108, },
 	{ AQ_DEVICE_ID_D109,	AQ_HWREV_2,	&hw_atl_ops_b0, &hw_atl_b0_caps_aqc109, },
 
-	{ AQ_DEVICE_ID_AQC100,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc107, },
+	{ AQ_DEVICE_ID_AQC100,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc100, },
 	{ AQ_DEVICE_ID_AQC107,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc107, },
 	{ AQ_DEVICE_ID_AQC108,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc108, },
 	{ AQ_DEVICE_ID_AQC109,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc109, },
-- 
2.25.1

