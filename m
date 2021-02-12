Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B390C31987A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhBLDBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:01:22 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:56588 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhBLDA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:00:59 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11C2wLOc006954; Fri, 12 Feb 2021 11:58:21 +0900
X-Iguazu-Qid: 34tMK0YvjHDbcsAMEt
X-Iguazu-QSIG: v=2; s=0; t=1613098700; q=34tMK0YvjHDbcsAMEt; m=T+rajGVQEnmUhSYecvSoPc1gRrbxADF4sUR8uIr79kE=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1512) id 11C2wJUo010345;
        Fri, 12 Feb 2021 11:58:19 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11C2wJ4i009927;
        Fri, 12 Feb 2021 11:58:19 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11C2wIKk021762;
        Fri, 12 Feb 2021 11:58:18 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH v2 3/4] MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
Date:   Fri, 12 Feb 2021 11:58:05 +0900
X-TSB-HOP: ON
Message-Id: <20210212025806.556217-4-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
In-Reply-To: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add entries for Toshiba Visconti ethernet controller binding and driver.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cbf4b94f89d4..6be4bdaabf32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2641,8 +2641,10 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwamatsu/linux-visconti.git
 F:	Documentation/devicetree/bindings/arm/toshiba.yaml
+F:	Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 F:	Documentation/devicetree/bindings/pinctrl/toshiba,tmpv7700-pinctrl.yaml
 F:	arch/arm64/boot/dts/toshiba/
+F:	drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
 F:	drivers/pinctrl/visconti/
 N:	visconti
 
-- 
2.30.0.rc2

