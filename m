Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404FD411868
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhITPji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:39:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60090 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbhITPjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:39:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KFblQw047379;
        Mon, 20 Sep 2021 10:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632152267;
        bh=6ogYJLh0z/u0lpQMyv6MtXQhyJZpSUWT0nZUQMmMSdw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=gm5/Eyr7xnvxu4ZnYJd07gnSJ8GaYMT9yf6wJQj7Cex5yowuquShl+SvdDvkHjaNA
         CTxUsMWN5lFPfHA+OxpPeKiDIeQ2nDScjailT/0elC9xEKoWlKFggjz9ezvG/Fn//J
         Ngx38K2SZbo/VkGc8wxga452/aY+XHwpjwBXSjlY=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KFblvX006433
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 10:37:47 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 10:37:46 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 10:37:46 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbPJk104098;
        Mon, 20 Sep 2021 10:37:41 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH v3 2/6] arm64: dts: ti: am654-base-board/am65-iot2050-common: Disable mcan nodes
Date:   Mon, 20 Sep 2021 21:07:19 +0530
Message-ID: <20210920153724.20203-3-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210920153724.20203-1-a-govindraju@ti.com>
References: <20210920153724.20203-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AM654 base board and iot platforms do not have mcan instances pinned out.
Therefore, disable all the mcan instances.

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi | 8 ++++++++
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
index 1008e9162ba2..0498b3177f9c 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
@@ -651,6 +651,14 @@
 	reset-gpios = <&wkup_gpio0 27 GPIO_ACTIVE_HIGH>;
 };
 
+&m_can0 {
+	status = "disabled";
+};
+
+&m_can1 {
+	status = "disabled";
+};
+
 &pcie1_ep {
 	status = "disabled";
 };
diff --git a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
index cfbcebfa37c1..9043f91c9bec 100644
--- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
@@ -416,6 +416,14 @@
 	status = "disabled";
 };
 
+&m_can0 {
+	status = "disabled";
+};
+
+&m_can1 {
+	status = "disabled";
+};
+
 &mailbox0_cluster0 {
 	interrupts = <436>;
 
-- 
2.17.1

