Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35930187A77
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCQH3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:29:14 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:55642 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgCQH3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:29:13 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H7T7ip063623;
        Tue, 17 Mar 2020 02:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584430147;
        bh=/Dw8KFsaIkFkfgLKZhRV5MXpefmC30Xga+RKXA8psqw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=HIhK7ksTRep1G2Xw7F45BBnD2C02mkJXp5S4CEAecZbd1sVW9RxPkz33HEYZumZPm
         HHOsUw9pJCQzt2tA/ic4X6QXfABXhiGTGpNwTfe3HDXbBDketxiXRbBLXFz/zOwXLY
         UDbqRgn6hoIKZQuWBeOTf1FImcqyFOCCIODhn0aA=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7T7vo071090;
        Tue, 17 Mar 2020 02:29:07 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 02:29:07 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 02:29:07 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H7T6Kf094089;
        Tue, 17 Mar 2020 02:29:06 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v4 11/11] arm64: defconfig: ti: k3: enable dma and networking
Date:   Tue, 17 Mar 2020 09:27:39 +0200
Message-ID: <20200317072739.23950-12-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317072739.23950-1-grygorii.strashko@ti.com>
References: <20200317072739.23950-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable TI K3 AM654x/J721E DMA and networking options.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/configs/defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 4db223dbc549..13cd865d7d4b 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -283,6 +283,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_TI_K3_AM65_CPSW_NUSS=y
 CONFIG_MDIO_BUS_MUX_MMIOREG=y
 CONFIG_MARVELL_PHY=m
 CONFIG_MARVELL_10G_PHY=m
@@ -698,6 +699,8 @@ CONFIG_QCOM_HIDMA_MGMT=y
 CONFIG_QCOM_HIDMA=y
 CONFIG_RCAR_DMAC=y
 CONFIG_RENESAS_USB_DMAC=m
+CONFIG_TI_K3_UDMA=y
+CONFIG_TI_K3_UDMA_GLUE_LAYER=y
 CONFIG_VFIO=y
 CONFIG_VFIO_PCI=y
 CONFIG_VIRTIO_PCI=y
-- 
2.17.1

