Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD8B4237A7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 07:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhJFF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 01:56:19 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52622 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJFF4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 01:56:16 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1965s5sp062140;
        Wed, 6 Oct 2021 00:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1633499645;
        bh=XVm5jaClKLtTPw0+o0SFjTc2fXGupFS/8G4P60SF21I=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mQM61Ja2DoiS+ECZEuz9+hhvYNDbKpBX6WVQkFRlSK5PooVgGAAvWgNbIbmUybZeD
         IW8FvO7H4gkTth7HBEaGBiLgP3cPaXfOYhBs5vWh0cwqAMXv4Z41yijn7xJ76E5C+X
         DKYixXdpGYm/ooYDr5aqZ2Rwsyb5fIb0oclkiIRg=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1965s5lc118691
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Oct 2021 00:54:05 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Oct 2021 00:54:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Oct 2021 00:54:05 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1965rjkE070213;
        Wed, 6 Oct 2021 00:54:00 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
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
Subject: [PATCH v4 2/6] arm64: dts: ti: am654-base-board/am65-iot2050-common: Disable mcan nodes
Date:   Wed, 6 Oct 2021 11:23:39 +0530
Message-ID: <20211006055344.22662-3-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211006055344.22662-1-a-govindraju@ti.com>
References: <20211006055344.22662-1-a-govindraju@ti.com>
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
index 65da226847f4..1e0112b90d9f 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
@@ -646,6 +646,14 @@
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

