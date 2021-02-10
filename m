Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201E9316CCB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhBJRcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:32:23 -0500
Received: from mo-csw-fb1114.securemx.jp ([210.130.202.173]:60186 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhBJRcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:32:08 -0500
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 11AGYvO9019691; Thu, 11 Feb 2021 01:34:57 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 11AGUDFK028176; Thu, 11 Feb 2021 01:30:13 +0900
X-Iguazu-Qid: 2wGrHHn4MsreK3NPsG
X-Iguazu-QSIG: v=2; s=0; t=1612974613; q=2wGrHHn4MsreK3NPsG; m=fN/LI9jdkMEFZk9qrhRfPowd7tIX81bvTNdeCCXZ0+Q=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1112) id 11AGUCdi026257;
        Thu, 11 Feb 2021 01:30:12 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11AGUCAs007071;
        Thu, 11 Feb 2021 01:30:12 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11AGUBAE029453;
        Thu, 11 Feb 2021 01:30:11 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 3/4] MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
Date:   Thu, 11 Feb 2021 01:29:53 +0900
X-TSB-HOP: ON
Message-Id: <20210210162954.3955785-4-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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
2.27.0

