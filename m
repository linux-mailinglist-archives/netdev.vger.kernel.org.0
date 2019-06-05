Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4B365C6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfFEUnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:43:09 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:46021 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfFEUnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:43:01 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x55KgqSJ005239
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jun 2019 14:42:57 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x55Kghj8021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Jun 2019 14:42:52 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v4 16/20] net: axienet: document device tree mdio child node
Date:   Wed,  5 Jun 2019 14:42:29 -0600
Message-Id: <1559767353-17301-17-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio child node for the MDIO bus is generally required when using
this driver but was not documented other than being shown in the
example. Document it as an optional (but usually required) parameter.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 0be335c..a8be67b 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -37,6 +37,9 @@ Optional properties:
 		  auto-detected from the CPU clock (but only on platforms where
 		  this is possible). New device trees should specify this - the
 		  auto detection is only for backward compatibility.
+ - mdio		: Child node for MDIO bus. Must be defined if PHY access is
+		  required through the core's MDIO interface (i.e. always,
+		  unless the PHY is accessed through a different bus).
 
 Example:
 	axi_ethernet_eth: ethernet@40c00000 {
-- 
1.8.3.1

