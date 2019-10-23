Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104DDE1B2B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391773AbfJWMr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:47:26 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56894 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbfJWMr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 08:47:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4F7991A0716;
        Wed, 23 Oct 2019 14:47:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4306C1A0020;
        Wed, 23 Oct 2019 14:47:24 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E818E205FE;
        Wed, 23 Oct 2019 14:47:23 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/5] bus: fsl-mc: export device types present on the bus
Date:   Wed, 23 Oct 2019 15:47:05 +0300
Message-Id: <1571834829-29560-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571834829-29560-1-git-send-email-ioana.ciornei@nxp.com>
References: <1571834829-29560-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export all device types present on the fsl-mc bus in order to be able to
actually use the is_fsl_mc_bus_*() functions from drivers on the bus.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - patch added

 drivers/bus/fsl-mc/fsl-mc-bus.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 5c9bf2e06552..bb3c2fc7c5ba 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -166,42 +166,52 @@ struct bus_type fsl_mc_bus_type = {
 struct device_type fsl_mc_bus_dprc_type = {
 	.name = "fsl_mc_bus_dprc"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dprc_type);
 
 struct device_type fsl_mc_bus_dpni_type = {
 	.name = "fsl_mc_bus_dpni"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpni_type);
 
 struct device_type fsl_mc_bus_dpio_type = {
 	.name = "fsl_mc_bus_dpio"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpio_type);
 
 struct device_type fsl_mc_bus_dpsw_type = {
 	.name = "fsl_mc_bus_dpsw"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpsw_type);
 
 struct device_type fsl_mc_bus_dpbp_type = {
 	.name = "fsl_mc_bus_dpbp"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpbp_type);
 
 struct device_type fsl_mc_bus_dpcon_type = {
 	.name = "fsl_mc_bus_dpcon"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpcon_type);
 
 struct device_type fsl_mc_bus_dpmcp_type = {
 	.name = "fsl_mc_bus_dpmcp"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpmcp_type);
 
 struct device_type fsl_mc_bus_dpmac_type = {
 	.name = "fsl_mc_bus_dpmac"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpmac_type);
 
 struct device_type fsl_mc_bus_dprtc_type = {
 	.name = "fsl_mc_bus_dprtc"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dprtc_type);
 
 struct device_type fsl_mc_bus_dpseci_type = {
 	.name = "fsl_mc_bus_dpseci"
 };
+EXPORT_SYMBOL_GPL(fsl_mc_bus_dpseci_type);
 
 static struct device_type *fsl_mc_get_device_type(const char *type)
 {
-- 
1.9.1

