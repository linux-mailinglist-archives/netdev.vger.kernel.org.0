Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A97F600E0
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfGEGMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 02:12:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8707 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbfGEGMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 02:12:07 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 56F0F512B91DFB3938D8;
        Fri,  5 Jul 2019 14:12:03 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 14:11:52 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <dingtianhong@huawei.com>, <xiaojiangfeng@huawei.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiekunxun@huawei.com>,
        <jianping.liu@huawei.com>, <nixiaoming@huawei.com>
Subject: [PATCH 06/10] net: hisilicon: dt-bindings: Add an field of port-handle
Date:   Fri, 5 Jul 2019 14:11:46 +0800
Message-ID: <1562307106-103760-1-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, group is the same as the port, but some
boards specify a special group for better load
balancing of each processing unit.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 Documentation/devicetree/bindings/net/hisilicon-hip04-net.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/hisilicon-hip04-net.txt b/Documentation/devicetree/bindings/net/hisilicon-hip04-net.txt
index d1df8a0..464c0da 100644
--- a/Documentation/devicetree/bindings/net/hisilicon-hip04-net.txt
+++ b/Documentation/devicetree/bindings/net/hisilicon-hip04-net.txt
@@ -10,6 +10,7 @@ Required properties:
 	phandle, specifies a reference to the syscon ppe node
 	port, port number connected to the controller
 	channel, recv channel start from channel * number (RX_DESC_NUM)
+	group, field in the pkg desc, in general, it is the same as the port.
 - phy-mode: see ethernet.txt [1].
 
 Optional properties:
@@ -66,7 +67,7 @@ Example:
 		reg = <0x28b0000 0x10000>;
 		interrupts = <0 413 4>;
 		phy-mode = "mii";
-		port-handle = <&ppe 31 0>;
+		port-handle = <&ppe 31 0 31>;
 	};
 
 	ge0: ethernet@2800000 {
@@ -74,7 +75,7 @@ Example:
 		reg = <0x2800000 0x10000>;
 		interrupts = <0 402 4>;
 		phy-mode = "sgmii";
-		port-handle = <&ppe 0 1>;
+		port-handle = <&ppe 0 1 0>;
 		phy-handle = <&phy0>;
 	};
 
@@ -83,6 +84,6 @@ Example:
 		reg = <0x2880000 0x10000>;
 		interrupts = <0 410 4>;
 		phy-mode = "sgmii";
-		port-handle = <&ppe 8 2>;
+		port-handle = <&ppe 8 2 8>;
 		phy-handle = <&phy1>;
 	};
-- 
1.8.5.6

