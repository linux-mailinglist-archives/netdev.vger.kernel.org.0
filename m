Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD72D729E
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437360AbgLKJHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:07:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:56619 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437282AbgLKJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607677645; x=1639213645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HYvqfDOJAQzsbDFrol1vkz2s/fsDFmkTjeSVK52uWyE=;
  b=qDrGXeD0bZyVWW1ys/dFbxjk6N5DeA4zyaCvzJQLEbJRzZfwZjQjqaOX
   zqJMdhzAEVjM7RRFAJ+EmqW2CEEzJuI5Yse3UlelMKWEZAOjRgEVoajd8
   dnxL5jnlxSenf4kOYOC3oaFq+TlCn6tVo+wM6IuZzDb5YzJq11GNFHLV0
   V6ldJT9zzbctzDj5i0pKaKgx2Hy127r5lr/ehaqxWQbZQ3lEMa8fHnVx9
   Colp5bS4rgsNpZU34wivDQ80uZrpM+RyJRkJ5bVne6U3l+Bj0I7i4UGqx
   gsqOvRUERIFiYPKxLkw/hjw/KOaEJLx59huD60Ez6swwknoJLi5ojVK2K
   A==;
IronPort-SDR: zExYFzteI6nza7LKzwnjn7xQqO2+xKBxXc0Y2wmz+e18mkvyh08CI6zbKhCVo5u19YgryNg//M
 yZTPblmedXCZ1Nffm0O+SWwvAM4W6iBMYXHBEJTdjRxDUP+wFxCle3PMvG3Q2dwZV7++/FF/jl
 pdYWdTGxIQ1juiQIdkW6GnuSlOrsiQXC4ke6rjJ3cVVkLc/uGNgdTOUhThTKrl7YLNBPTukF7R
 3/9Py6iMQL//kwsj9chnJz221IAert2F+O7G3wTcZI/s1ABCj1c6tTuGQKLJbQPdWL3Qousxxf
 1vI=
X-IronPort-AV: E=Sophos;i="5.78,410,1599548400"; 
   d="scan'208";a="99484087"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Dec 2020 02:06:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 02:06:04 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 11 Dec 2020 02:06:02 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Fri, 11 Dec 2020 10:05:41 +0100
Message-ID: <20201211090541.157926-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211090541.157926-1-steen.hegelund@microchip.com>
References: <20201211090541.157926-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Sparx5 serdes driver node, and enable it generally for all
reference boards.

Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 8e7724d413fb..797601a9d542 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -287,5 +287,13 @@ tmon0: tmon@610508110 {
 			#thermal-sensor-cells = <0>;
 			clocks = <&ahb_clk>;
 		};
+
+		serdes: serdes@10808000 {
+			compatible = "microchip,sparx5-serdes";
+			#phy-cells = <1>;
+			clocks = <&sys_clk>;
+			reg = <0x6 0x10808000 0x5d0000>;
+		};
+
 	};
 };
-- 
2.29.2

