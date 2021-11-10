Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510BE44BB6B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhKJFvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:39 -0500
Received: from inva020.nxp.com ([92.121.34.13]:38066 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhKJFvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:35 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B0FD51A0E0E;
        Wed, 10 Nov 2021 06:48:47 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 791B51A0E07;
        Wed, 10 Nov 2021 06:48:47 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 3E7E1183ACDD;
        Wed, 10 Nov 2021 13:48:46 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 3/5] ARM64: defconfig: Add config for fec-uio
Date:   Wed, 10 Nov 2021 11:18:36 +0530
Message-Id: <20211110054838.27907-4-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables fec-uio driver on imx8mm.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 545197bc0501..2303eda7f511 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -320,6 +320,7 @@ CONFIG_BNX2X=m
 CONFIG_MACB=y
 CONFIG_THUNDER_NIC_PF=y
 CONFIG_FEC=y
+CONFIG_FEC_UIO=m
 CONFIG_FSL_FMAN=y
 CONFIG_FSL_DPAA_ETH=y
 CONFIG_FSL_DPAA2_ETH=y
-- 
2.17.1

